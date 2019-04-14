function symbols = qpsk_modulate_signal(bits)

symbols = [];

for i=1:2:length(bits)
    symbols = [symbols; qpsk_modulate(bits(i:i+1))];
end

