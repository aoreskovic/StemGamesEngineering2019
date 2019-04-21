clear all;

%% Task 1

% Data generator
Ncoords = 100;
dataset_string = '';
for ii=1:Ncoords
    dataset_string = sprintf( ...
        '%s%03d,%03d,%03d;', ...
        dataset_string, ...
        round(rand*100),round(rand*100),round(rand*100) ...
    );
end

hash_tmp2 = double(dataset_string);
hash_tmp2 = de2bi(hash_tmp2, 8);
hash_tmp2 = fliplr(hash_tmp2);
hash_tmp2 = reshape(hash_tmp2', [], 1);
dataset = hash_tmp2';

%% Frame builder

preamble_hex = {'a','5','a','5','a','5','a','5','a','5','a','5','a','5','a','5'};
preamble_tmp = hex2dec(preamble_hex)';
preamble_tmp = de2bi(preamble_tmp);
preamble_tmp = fliplr(preamble_tmp);
preamble_tmp = reshape(preamble_tmp',[],1);
preamble = preamble_tmp';

postamble_hex = {'5','a','5','a','5','a','5','a','5','a','5','a','5','a','5','a'};
postamble_tmp = hex2dec(postamble_hex)';
postamble_tmp = de2bi(postamble_tmp);
postamble_tmp = fliplr(postamble_tmp);
postamble_tmp = reshape(postamble_tmp,[],1);
postamble = postamble_tmp';

data_length_min = 64;
data_length_max = 248;

frame_size_min = 32+8+data_length_min+32;

frames = [];
noOfFrames = 0;
while 1
    % Random frame size
    data_length = round(data_length_min/8 + (data_length_max/8-data_length_min/8).*rand);
    data_length = data_length*8;

    % Zero padding
    if length(dataset) < data_length_min
        tmp = zeros(1,data_length_min);
        tmp(1,1:length(dataset)) = dataset;
        dataset = tmp;
        data_length = data_length_min;
    end

    % Header
    header = de2bi(data_length, 8);

    % CRC hash
    hash_tmp = reshape(dataset(1,1:data_length),8,[]);
    hash_tmp = fliplr(hash_tmp');
    hash_tmp = bi2de(hash_tmp);
    hash_string = CRC_16_CCITT(hash_tmp);
    hash_tmp2 = double(dataset_string);
    hash_tmp2 = de2bi(hash_tmp2, 8);
    hash_tmp2 = fliplr(hash_tmp2);
    hash_tmp2 = reshape(hash_tmp2', [], 1);
    hash = hash_tmp2';

    % Create frame
    frame = [preamble header dataset(1,1:data_length) hash postamble];
    frames = [frames frame];
    noOfFrames = noOfFrames + 1;
    
    % Cut the rest of the dataset
    if length(dataset) > data_length
        dataset = dataset(1,data_length+1:end);
    else
        clear dataset;
        break;
    end
end
fprintf('Generated %d frames.\n', noOfFrames);

% Unwrap frames
frames_reshape = reshape(frames',[],1);

%% QPSK modulator

% Integers to binary

qpskmod = comm.QPSKModulator('BitInput',true);
qpsk_modulated = step(qpskmod,frames_reshape);

%qpsk_modulated = qpsk_modulate_signal(frames_reshape');

%% Modulate to carrier

close all;

% fs is high because we are in continuous domain
fs = 192e3;
% number of samples per symbol
N = 20;
fprintf('Rs = %2.00f baud\n', fs/N);
% Time scale
t = 0:1/fs:(N - 1) * 1/fs;
% carrier frequency
fc = 12.8e3;
fprintf('fc = %2.00f Hz\n', fc);

modulated_output = [];
for ii=1:length(qpsk_modulated)
    carrier = abs(qpsk_modulated(ii)) .* cos(2 * pi * fc .* t + angle(qpsk_modulated(ii)));
    modulated_output = [modulated_output carrier];
end
return;
%% Demodulate

close all;

qpsk_demodulated = [];
qpskdmod = comm.QPSKDemodulator('BitOutput',true);

sigs = [];

% iterate over output, every N samples is 1 symbol
for i=1:N:length(modulated_output)
   sig = modulated_output(i:i + N - 1);
   % transpose to baseband
   sigbb = sig .* exp(-1j * 2 * pi * fc .* t);
   sigs = [sigs sigbb];
   % calculate spectrum
   spk = FFT(sigbb, blackman(N)', 2 * N, fs);
   % take the DC component
   spk = fftshift(spk);
   qpsk_demodulated = [qpsk_demodulated; spk(1)];
end
%frames_demod = qpsk_demodulate_signal(qpsk_demodulated);
frames_demod = step(qpskdmod, qpsk_demodulated);
spektar(sigbb, fs, 2 * N, 'Spektar u baseband-u');
spektar(sig, fs, 2 * N, 'Spektar nije u baseband-u');
plot(real(sigbb));

%% Check validity

eq_vec = frames_demod == frames_reshape;

%% Discrete sample steps (16 bit)

input_sig = int16(modulated_output * 2^15);
csvwrite('signal.txt', input_sig);
