clearvars;
close all
clc

% load u.a. fieldtrip toolbox
addpath(genpath('C:\Users\fehring\sciebo\Toolboxes\'))

% load time series data files
% data: for each participant: parcels(214) x trials(30) x samples(3000)
PATHIN = 'Z:\TBraiC\JF\HCTSA feature gradients\CamCan\raw_data\';
% only look for files which are from condition 1 (closed eyes condition)
files = dir([PATHIN,'*.mat']);
files = {files.name};

for i = 1:size(files,2)
    i
    % load the specific data file
    load([PATHIN files{i}]);

    % create fieldtrip data struct
    data=[];
    data.fsample=300;
    for k=1:214
        data.label{k}=num2str(k);
    end
    for k=1:30
        data.trial{k} = squeeze(ts(:,k,:));
        data.time{k} = 0:1/300:9.999;
    end
    data.dimord='chan_time';
    
    % setup configuration
    cfg = [];
    cfg.output = 'pow';
    cfg.method = 'mtmfft'; % multitaper frequency transformation
    cfg.taper = 'dpss';
    cfg.foi = [0:100]; % complete band
    cfg.tapsmofrq = 1;
    cfg.pad = 15;
    %cfg.keeptrials = 'yes';

    % do freq analysis
    tmp_specData = ft_freqanalysis(cfg, data);
    % average over the 6 frequencies
    specData_all(i,:,:) = tmp_specData.powspctrm;
end

% save data
save('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\01_specData_all',"specData_all");