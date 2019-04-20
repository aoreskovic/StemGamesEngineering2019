sim('testSignalGenerator');
rotValve = [valve1.time, valve1.signals.values];
transValve1 = [valve2.time, valve2.signals.values];
transValve2 = [valve3.time, valve3.signals.values];
baseVoltage = [voltage1.time, voltage1.signals.values];
pulleyVoltage = [voltage2.time, voltage2.signals.values];

rotValveRef = rotValve;
transValve1Ref = transValve1;
transValve2Ref = transValve2;
basePositionRef = baseVoltage;
pulleyPositionRef = pulleyVoltage;

