clear all;

dataset_string = '000,000;001,000;001,001;302,154;952,832;903,832';
dataset_tmp = double(dataset_string);

dataset_tmp = de2bi(dataset_tmp);
dataset = reshape(dataset_tmp,[],1);
dataset = dataset';

%% Frame builder

header_hex = {'a','5','a','5','a','5','a','5','a','5','a','5','a','5','a','5'};
header_tmp = hex2dec(header_hex)';
header_tmp = de2bi(header_tmp);
header = reshape(header_tmp,[],1);
header = header';

frame_size = 16;

frames = [];
while 1
    % Zero padding
    if length(dataset) < frame_size
        tmp = zeros(1,frame_size);
        tmp(1,1:length(dataset)) = dataset;
        dataset = tmp;
    end
    
    % Create frame
    frame = [header dataset(1,1:frame_size)];
    frames = [frames; frame];
    
    % Cut the rest of the dataset
    if length(dataset) > frame_size
        dataset = dataset(1,frame_size+1:end);
    else
        clear dataset;
        break;
    end
end

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
fs = 1.2e6;
% number of samples per symbol
N = 100; 
% time for symbol generating, Ts = (N - 1) * 1/fs;
t = 0:1/fs:(N - 1) * 1/fs;
% carrier frequency
fc = 32e3;

modulated_output = [];

for ii=1:length(qpsk_modulated)
    carrier = abs(qpsk_modulated(ii)) .* cos(2 * pi * fc .* t + angle(qpsk_modulated(ii)));
    modulated_output = [modulated_output carrier];
end

%% Demodulate

close all;

qpsk_demodulated = [];
qpskdmod = comm.QPSKDemodulator('BitOutput',true);


% iterate over output, every N samples is 1 symbol
for i=1:N:length(modulated_output)
   sig = modulated_output(i:i + N - 1);
   % transpose to baseband
   sigbb = sig .* exp(1j * 2 * pi * fc .* t);
   % calculate spectrum
   spk = FFT(sigbb, blackman(N)', 2 * N, fs);
   % take conjugate of DC component
   spk = fftshift(spk);
   qpsk_demodulated = [qpsk_demodulated; spk(1)'];
end
%frames_demod = qpsk_demodulate_signal(qpsk_demodulated);
frames_demod = step(qpskdmod, qpsk_demodulated);
spektar(sigbb, fs, 2 * N, 'Spektar u baseband-u');

%% Check validity

eq_vec = frames_demod == frames_reshape;

