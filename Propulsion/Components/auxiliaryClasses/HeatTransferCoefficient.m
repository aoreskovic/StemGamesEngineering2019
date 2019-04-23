classdef HeatTransferCoefficient < PhysicalProperties
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        p = 60*100000; %Pa, flue gas pressure
        R = 8314; % kJ/kmolK
        M_H20 = 18;
        M_CO2 = 44;
    end
    
    
    methods
        function [alfaT, w] = alphaTube(obj, qn_H20, qn_CO2, T_fg, A, d)
            %UNTITLED3 Construct an instance of this class
            %   Detailed explanation goes here
            qn_DP = qn_H20 + qn_CO2;
            M = qn_H20/qn_DP*obj.M_H20 + qn_CO2/qn_DP*obj.M_CO2;
            qv_FG = qn_DP * obj.R * (T_fg + 273.15) / obj.p;
            w = qv_FG/A; 
            mi = dynamicViscosity(obj, T_fg);
            ro = qn_DP*M/qv_FG;
            Re = w * ro * d / mi;
            CmpFG = qn_H20/qn_DP * molarCapacity(obj, 'H2O', T_fg) + qn_CO2/qn_DP * molarCapacity(obj, 'CO2', T_fg);
            cpFG = CmpFG/M*1000;
            lmbda = thermalConductivity(obj, T_fg);
            Pr = mi * cpFG / lmbda;
            assert(Re>2300, 'laminar!')
            Nu = 0.0398*Pr*Re^0.75/(1+1.74*Re^-0.125*(Pr-1));
            %end
            alfaT = Nu * lmbda / d;
        end
        function k = HTCoverall(obj, alfaT, alfaS, dInt, dExt, conductivity)
            R_int = dInt/2;
            R_ext = dExt/2;
            ConvInt = R_ext/(R_int*alfaT);
            Cond=R_ext/ conductivity * log(R_ext/R_int);
            ConvExt = 1/alfaS;
            R_total=(ConvInt+Cond+ConvExt);
            k=1/R_total;
        end
    end
end

