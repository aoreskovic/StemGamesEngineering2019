classdef CombustionChamberS < matlab.System & PhysicalProperties & matlab.system.mixin.Propagates
    % Untitled6 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.


    properties(Nontunable)
        thetaG_in = 10; %Fuel temperature [°C]
        thetaO2_in = 10; %Oxygen temperature [°C]

        
    end

    properties(Nontunable, Access = private)
        M_ethanol = 46; %kg/kmol, ethanol molar mass 
        M_CO2 = 44;  %kg/kmol, carbon dioxide molar mass 
        M_H2O = 18; %kg/kmol, water molar mass 
        heating_value = 1366940; %kJ/kmol, ethanol lower heating value at 0°C
        O2_ratio = 3; % kmol 02/ kmol G, stoichiometric ratio of axygen and ethanol
        CO2_ratio = 2; % kmol CO2 / kmol G, stoichiometric ratio of CO2 and ethanol
        H2O_ratio = 3; %kmol H20 / kmol G, stoichiometric ratio of H2O and ethanol
    end
    
    
    properties(Nontunable, Access = protected)
        Cmp_O2_ul
        Cmp_ethanol
    end
    properties(Access = protected)
        Cmp_CO2_ret
        Cmp_H2O_ret
        qnG
        qn_O2
        qn_CO2
        qn_H2O
        qn_H20_ret
        qn_CO2_ret
        ret
        theta_fg_prev
        theta_fg1
        Cmp_CO2_out
        Cmp_H2O_out
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.Cmp_O2_ul = molarCapacity(obj, 'O2', obj.thetaO2_in); %kJ/kmolK molar specific heat capacity of oxygen at inlet 
            obj.Cmp_ethanol = 2.503*obj.M_ethanol; %kJ/kmolK, ethanol specific molar heat capacity at 20°C
            obj.Cmp_CO2_ret = 0;
            obj.Cmp_H2O_ret = 0;
            obj.qnG=0;
            obj.qn_O2=0;
            obj.qn_CO2=0;
            obj.qn_H2O=0;
            obj.qn_H20_ret=0;
            obj.qn_CO2_ret=0;
            obj.ret=0;
            obj.theta_fg_prev=0;
            obj.theta_fg1=0;
            obj.Cmp_CO2_out=0;
            obj.Cmp_H2O_out=0;
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.thetaG_in > 0, 'fuel temperature below 0!')
            assert(obj.thetaG_in < 70, 'fuel temperature over 70!')
            assert(obj.thetaO2_in > 0, 'oxygen temperature below 0!')
            assert(obj.thetaO2_in < 100, 'oxygen temperature over 100!')
        end

        function [out,out2,out3] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];
            out2 = [1 1];
            out3 = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out,out2,out3] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
            out2 = "double";
            out3 = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [out,out2,out3] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
            out2 = false;
            out3 = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out,out2,out3] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
            out2 = true;
            out3 = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end

        function [thetaFGout, qnH20out, qnCO2out] = stepImpl(obj, qmG, theta_ret, qnRet)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            obj.qnG = qmG/obj.M_ethanol; %kmol/s, fuel molar flow rate
            obj.Cmp_CO2_ret = molarCapacity(obj, 'CO2', theta_ret); %kJ/kmolK molar specific heat capacity of recirculated carbon dioxide at inlet 
            obj.Cmp_H2O_ret = molarCapacity(obj, 'H2O', theta_ret); %kJ/kmolK molar specific heat capacity of recirculated water vapour dioxide at inlet 
            obj.qn_O2=obj.O2_ratio*obj.qnG; %kmol/s, oxygen molar flow rate
            obj.qn_CO2 = obj.CO2_ratio*obj.qnG; %kmol/s, generated carbon dioxide molar flow rate
            obj.qn_H2O = obj.H2O_ratio * obj.qnG; %kmol/s, generated water vapour molar flow rate
            obj.qn_H20_ret = obj.H2O_ratio/(obj.CO2_ratio+obj.H2O_ratio) * qnRet; %kmol/s,molar flow rate of returned H2O
            obj.qn_CO2_ret = obj.CO2_ratio/(obj.CO2_ratio+obj.H2O_ratio) * qnRet; %kmol/s,molar flow rate of returned CO2

            %initial guess
            obj.theta_fg_prev = theta_ret; %°C, flue gas exit temperature calculated in previous iteration
            obj.theta_fg1 = theta_ret + 600; %°C, flue gas temperature at combustion chamber exit
            iter = 0; % first iteration
            while abs(obj.theta_fg_prev- obj.theta_fg1) > 0.1 %calculate until convergence
                iter = iter +1; %new iteration
                assert(iter<1000, 'Combustion chamber - convergence not achieved')
                obj.theta_fg_prev = obj.theta_fg1; %°C, flue gas exit temperature calculated in previous iteration
                obj.Cmp_CO2_out = molarCapacity(obj, 'CO2', obj.theta_fg1); %kJ/kmolK molar specific heat capacity of  carbon dioxide at outlet 
                obj.Cmp_H2O_out = molarCapacity(obj, 'H2O', obj.theta_fg1); %kJ/kmolK molar specific heat capacity of water vapour dioxide at outlet 
                obj.theta_fg1 = (obj.qnG * (obj.heating_value + obj.Cmp_ethanol * obj.thetaG_in) + obj.qn_O2 * (obj.Cmp_O2_ul * obj.thetaO2_in ) + obj.qn_CO2_ret * obj.Cmp_CO2_ret * theta_ret + obj.qn_H20_ret * obj.Cmp_H2O_ret * theta_ret) / ((obj.qn_CO2+obj.qn_CO2_ret) * obj.Cmp_CO2_out + (obj.qn_H2O + obj.qn_H20_ret) * obj.Cmp_H2O_out); %flue gas exit temperature calculated in this iteration
            end
            
            
            qnH20out = obj.qn_H2O+obj.qn_H20_ret; %kmol/s, molar flow rate of vater vapour which exits combustion chamber
            qnCO2out = obj.qn_CO2 + obj.qn_CO2_ret; %kmol/s, molar flow rate of carbon dioxide flue gas which exits combustion chamber
            thetaFGout=obj.theta_fg1;
            
        end
    end
end
