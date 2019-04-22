classdef FlueGasMixS < matlab.System & PhysicalProperties & matlab.system.mixin.Propagates
    % Untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.


    properties(Access = protected)
        enthalpy
        qn_H20
        qn_C02
        theta
        theta_prv
        Cmp_H2O
        Cmp_CO2
        heat_capacity
    end
        


    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.enthalpy = 0;
            obj.qn_H20 = 0;
            obj.qn_C02 = 0;
            obj.theta = 0;
            obj.theta_prv = 0;
            obj.Cmp_H2O = 0;
            obj.Cmp_CO2 = 0;
            obj.heat_capacity = 0;
        end

        function out = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function out = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function out = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function out = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end

        function theta_ret = stepImpl(obj, thetaSup, qnH2Osup, qnCO2sup, thetaEv, qnH2Oev, qnCO2ev)
            obj.enthalpy =  heatCapacity(obj, qnH2Oev, qnCO2ev, thetaEv)*thetaEv + ...
    heatCapacity(obj, qnH2Osup, qnCO2sup, thetaSup)*thetaSup; % [kJ], total flue gas enthalpy
            obj.qn_H20 = qnH2Osup + qnH2Oev; % [kmol/s] total H20 mass flow rate
            obj.qn_C02 = qnCO2sup + qnCO2ev; % [kmol/s] total C02 mass flow rate
            %initial assumptions
            obj.theta = (thetaSup + thetaEv)/2;
            obj.theta_prv = obj.theta-1;
            iter = 1;
            
            while abs(obj.theta - obj.theta_prv) > 0.1
                iter = iter+1;
                assert(iter<1000, 'Flue gas mix - convergence not achieved!')
                obj.theta_prv = obj.theta;
                obj.Cmp_H2O = molarCapacity(obj, 'H2O', obj.theta); %[kJ/kmolK] water vapor molar heat capacity
                obj.Cmp_CO2 =  molarCapacity(obj, 'CO2', obj.theta); %[kJ/kmolK] carbon dioxide molar heat capacity
                obj.heat_capacity = obj.qn_H20*obj.Cmp_H2O + obj.qn_C02*obj.Cmp_CO2; %[kW/K] flue gas heat capacity
                obj.theta = obj.enthalpy/obj.heat_capacity;
            end
            theta_ret = obj.theta;
        end

    end
end
