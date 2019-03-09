err = linkError.instance();

% these are input parameters
mode = 'radio';
f = 2.4e9;
B = 100e6;
Nant = 2;
dant = 0.5;
lSubmarine = 10;

switch mode
    case 'radio'
        alpha = 0;
        v = 3e8;
        % alpha morske vode
        % v i lambda u morskoj vodi
        % provjera frekvencijskog pojasa
    case 'acoustic'
        alpha = 0;
        v = 0;
        % v i lambda u morskoj vodi
        % provjera frekvencijskog pojasa
            % ne zelimo ometati ekosustav!
        % sanity check antenskog niza
    otherwise
        err.invokeError('trxMethod');
end

% Sanity check antenna array
lambda = v/f;
sAnt = (Nant-1)*dant*lambda;
if sAnt > lSubmarine
    err.invokeError('arrayLength');
end

% Evaluate used frequency range
[rangeValid, licenseRequired, licensedB] = evaluateFreqRange(mode, f, B);
if ~rangeValid
    err.invokeError('freqRange');
end
if licenseRequired
    err.invokeError('freqLicense');
end
% TODO Cost penalty for licensed band

