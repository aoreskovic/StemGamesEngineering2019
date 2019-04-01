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

%% Modulate to carrier

fs = 96e3;
Ts = 1/9.6e3; % kbaud

f = 30e3;

modulated_output = [];

for ii=1:length(qpsk_modulated)
    carrier = abs(qpsk_modulated(ii)).*sin(f/fs .* [1:Ts*fs] + angle(qpsk_modulated(ii)));
    modulated_output = [modulated_output carrier];
end