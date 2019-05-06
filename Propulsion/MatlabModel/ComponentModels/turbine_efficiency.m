function [eta] = turbine_efficiency(qmd, qmd_max, turbine_type)
%turbine_efficiency Calculation of turbine efficiency based on steam flow
%rate
%   Inputs:
%       - qmd  [kg/s] steam mass flow
%       - qmd_max [kg/s] maximal steam mass flow through turbine
%       - turbine_type [-] type of turbine
%   Outputs:
%       - eta [-] turbine efficiency

switch turbine_type
    case 'francis'
        a = -1.2977; % quadratic efficiency coefficient
        b = 2.3734; % linear efficiency coefficient
        c = -0.18; % constant efficiency coefficient
        min_flow = 0.32; % minimal relative frol through pump
        eta_mech = 0.9; %mechanical turbine efficiency [-]
    otherwise
        error('Turbine type not recognised!')
end


rel_flw = qmd/qmd_max; % turbine relative flow rate [-]
assert(rel_flw>=min_flow, 'prenizak protok kroz turbinu')
assert(rel_flw<=1, 'previsok protok kroz turbinu')
eta_hyd = a*rel_flw^2+b*rel_flw+c; %-, hydraulic turbine efficiency
eta = eta_hyd * eta_mech; %overal turbine efficiency
eta = max(0, eta); %eta can not be less than zero!
assert(eta >= 0, 'korisnost manja od nule')
end

