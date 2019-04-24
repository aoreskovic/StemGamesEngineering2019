function [bin] = hex2bin(hex)

    bin = [];
    for ii=1:length(hex)
        tmp = hex(ii);
        tmp = hex2dec(tmp);
        tmp = dec2bin(tmp,4);
        bin = [bin tmp];
    end

    bin = bin - '0';

end