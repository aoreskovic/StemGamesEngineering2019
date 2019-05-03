classdef FuelPumpPosS < matlab.System & matlab.system.mixin.Propagates
    % Untitled3 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.


    properties(Nontunable)
        Q_max = 100; %Fuel pump nominal volume flow rate [l/h]
        h_max =  1000; %Fuel pump nominal head [m]
        n_min = 0.35; %Pump minimal relative speed [-]
        rho_ethanole = 789; %Ethanole density [kg/m3]
        k_pipe=2e-3; %pipe coefficient
        %pump_type (1, 1) PumpType = PumpType.type1 %Pump type
    end
    
    properties(Nontunable, Access = protected)
        g
    end
    
     properties(Access = protected)
        Q
        h0
        h
    end

    methods(Access = protected)
        function setupImpl(obj)
            obj.g=9.81;
            obj.Q = 0;
            obj.h0 = 0;
            obj.h = 0;
        end

        function validatePropertiesImpl(obj)
            % Validate related or interdependent property values
            assert(obj.Q_max>0, 'Maximal fuel pump flow rate less than 0!');
            assert(obj.Q_max<10000, 'Maximal fuel pump flow too big');
            assert(obj.h_max>0, 'Maximal fuel pump head less than 0!');
            assert(obj.h_max<1500, 'Maximal fuel pump too big!');
            assert(obj.n_min>0, 'Minimal fuel pump relative speed less than 0!');
            assert(obj.n_min<0.9, 'Minimal fuel pump relative speed more than 90%!');
            assert(obj.rho_ethanole>0, 'Fuel density less than 0!');
            assert(obj.rho_ethanole<2000, 'Fuel density more than 2000!');
            assert(obj.k_pipe>0, 'Pipe coefficient less than 0!');
            assert(obj.k_pipe<10, 'Pipe coefficient too big!');
            
        end

        function [out] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [out] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end



        function [qm_eth] = stepImpl(obj,relative_speed, pressure)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            obj.Q=obj.Q_max*relative_speed;
            
            obj.h0 = pressure/obj.g/obj.rho_ethanole;
            assert(obj.h_max>obj.h0, 'depth too big')
            obj.h=obj.h0+obj.Q*obj.Q*obj.k_pipe;
            if obj.h > obj.h_max
                obj.h = obj.h_max;
                obj.Q = sqrt((obj.h_max-obj.h0)/obj.k_pipe);
            end
            qm_eth = obj.rho_ethanole * obj.Q/3600/1000;
        end

            
            
            
        
    end
end
