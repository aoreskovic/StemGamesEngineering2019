function bits = qpsk_demodulate_signal(symbols)

bits = [];

for i=1:length(symbols)
    bits = [bits qpsk_demodulate(symbols(i))];
end

bits = bits';

