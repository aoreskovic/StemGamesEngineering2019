 turbines = xlsread('TurbineVariants.xlsx')
 save('TurbineVars', 'turbines')

 Fpumps = xlsread('FuelPumpVariants.xlsx', 'List1')
 save('FpumpsVars', 'Fpumps')

Comps = xlsread('CompressorVariants.xlsx', 'List1')
 save('CompVars', 'Comps')