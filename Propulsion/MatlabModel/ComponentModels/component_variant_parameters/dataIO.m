 turbines = xlsread('Table1.xlsx')
 save('TurbineVars', 'turbines')

 Fpumps = xlsread('FuelPumpVariants.xlsx', 'List1')
 save('FpumpsVars', 'Fpumps')

Comps = xlsread('CompressorVariants.xlsx', 'List1')
 save('CompVars', 'Comps')
 
 Pipes = xlsread('PipeVariants.xlsx', 'List1')
  save('PipeVars', 'Pipes')

  
  load('TurbineVars')