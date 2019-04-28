function [rangeValid,licenseRequired,licensedB] = evaluateFreqRange(mode,f,B)
%EVALUATEFREQRANGE Summary of this function goes here
%   Detailed explanation goes here

err = linkError.instance();

rangeValid = true;
licenseRequired = false;
licensedB = 0;

switch mode
    case 'radio'
        if f-B/2 < 1e6 || f+B/2 > 11e9
            rangeValid = false;
        end
        
        freeRanges = [ ...
            144e6 430e6;
            146e6 440e6
        ];

    case 'acoustic'
        if f+B/2 > 100e3
            rangeValid = false;
        end
        
        freeRanges = [0 100e3];
        
    otherwise
        err.invokeError('trxMethod');
end

carrier = [f-B/2 f+B/2];
intersect = range_intersection(freeRanges, carrier);
if isempty(intersect)
    licenseRequired = true;
    licensedB = B;
    return;
end
if diff(intersect) == B
    return;
end
licenseRequired = true;
licensedB = B - diff(intersect);

end

