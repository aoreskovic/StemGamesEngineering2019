function symbol = qpsk_modulate(bits)

if bi2de(bits) == 0
    symbol = exp(1j * pi / 4);
elseif bi2de(bits) == 2
    symbol = exp(1j * 3 * pi / 4);
elseif bi2de(bits) == 3
    symbol = exp(1j * 5 * pi / 4);
else
    symbol = exp(1j * 7 * pi / 4);
end
        


end