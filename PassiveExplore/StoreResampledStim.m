close all;
clear all; %#ok<CLALL>
clc;


cd('/Users/charleswu/Google Drive/HoltLab/CueWeighting/EEG/MMN/')
stim_path = '/Users/charleswu/Google Drive/HoltLab/CueWeighting/EEG/MMN/Stim/Resampled/';

load('BPmaster_canonical.mat');

for i=1:length(BPCWmaster_can.Stimuli)
    BPCWmaster_can.Stimuli{i,1}
    fname = strcat(stim_path, BPCWmaster_can.Stimuli{i,1}, '.wav');
    BPCWmaster_can.Stimuli{i,8} = audioread(fname);
end

load('BPmaster_reverse.mat');
for i=1:length(BPCWmaster_rev.Stimuli)
    BPCWmaster_rev.Stimuli{i,1}
    fname = strcat(stim_path, BPCWmaster_rev.Stimuli{i,1}, '.wav');
    BPCWmaster_rev.Stimuli{i,8} = audioread(fname);
end

load('BPmaster_test_v1.mat');
load('BPmaster_test_v2.mat');
for i=1:2
    BPCWmaster_test.Stimuli{i,1}
    fname = strcat(stim_path, BPCWmaster_test.Stimuli{i,1}, '.wav');
    BPCWmaster_test.Stimuli{i,8} = audioread(fname);
end


load('BPmaster_baseline.mat');
for i=1:length(BPCWmaster_baseline.Stimuli)
    BPCWmaster_baseline.Stimuli{i,1}
    fname = strcat(stim_path, BPCWmaster_baseline.Stimuli{i,1}, '.wav');
    BPCWmaster_baseline.Stimuli{i,8} = audioread(fname);
end

%%%pick a few audios to plot
orig_fs = 44100;
orig_sig = BPCWmaster_test.Stimuli{1,8};
sound(orig_sig, orig_fs)

figure
f=1:length(orig_sig);
plot(f,orig_sig); 

