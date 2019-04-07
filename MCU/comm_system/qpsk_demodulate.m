function bits = qpsk_demodulate(symbol)

if real(symbol) > 0 && imag(symbol) > 0
    bits = [0 0];
elseif real(symbol) < 0 && imag(symbol) > 0
    bits = [0 1];
elseif real(symbol) < 0 && imag(symbol) < 0
    bits = [1 1];
else
    bits = [1 0];
end

end