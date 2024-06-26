%% calculating the AMI for the lags 0-40 --> like for autocorrelation

% loading the data of the respective participant
% listing all participants files
Files = dir(fullfile('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\raw_data\', '*singleshell.mat'));

% adjust the data according to our schäfer 200 parcel structure
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\mapping_idx_camcan2schaefer.mat')

% finding parcels which are low, medium or high in cortical hierarchy
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\hierarchy_parc.csv')

% finding participants in different age ranges
demographics = readtable('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\demo_all_subjects.csv');
age_years = table2array(demographics(:,2));

for subj = 1:350
    tmp_name = Files(subj).name;
    load(['Z:\TBraiC\JF\HCTSA feature gradients\CamCan\raw_data\' tmp_name]);
    ts = ts(tmp_idx,:,:); % data: for each participant: parcels(214) x trials(30) x samples(3000) --> only use the schäfer 200 parcels

    for parcel = 1:200
        ts1 = squeeze(ts(parcel,:,:));
        for trial = 1:30
            ts2 = squeeze(ts1(trial,:));
            for lag = 1:40
                ami(trial,lag) = CO_RM_AMInformation(ts2,lag);
            end
        end
        ami_out(subj,parcel,:) = squeeze(mean(ami,1));
    end
end

% save ami
save('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\ami_1_40.mat','ami_out')

%% find t-values from the lme for hierarchy

for i = 1:40
    ami_out_z(:,:,i) = zscore(ami_out(:,:,i),[],2);
end

for ifeature=1:40 % loop over AMI features
    subj=[];
    parcel=[];
    feat=[];
    age=[];
    hierarchy=[];
    for k1=1:size(ami_out_z,1) %subjects
        subj=[subj ones(1,200)*k1];
        parcel=[parcel 1:200];
        age=[age ones(1,200)*age_years(k1)];
        feat=[feat squeeze(ami_out_z(k1,:,ifeature))];
        hierarchy=[hierarchy hierarchy_parc'];
    end
    varnames={'subj','parcel','feat','age','hierarchy'};
    tbl=table(subj',parcel',feat',age',hierarchy','VariableNames',varnames);
    model= 'feat ~ age*hierarchy + (1|subj)';
    try
        lme=fitlme(tbl,model);
        %plotResiduals(lme,'fitted')
        allst(ifeature,:)=lme.Coefficients.tStat;
        pval(ifeature,:)=lme.Coefficients.pValue;
    end
end

% save ami
save('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\ami_1_40_tstat.mat','allst')

%% what about cortical thickness? compute lme
% loading cortical thickness
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\thickness_smoothed_12_schaefer200_reordered.mat');
thickness(306,:) = []; % too little correlation to the mean of all subj

age_years(306) = [];

ami_out_z(306,:,:) = [];

% find t-values from the lme
for ifeature=1:40 % loop over features
    subj=[];
    parcel=[];
    feat=[];
    age=[];
    thick=[];
    for k1=1:size(ami_out_z,1) %subjects
        subj=[subj ones(1,200)*k1];
        parcel=[parcel 1:200];
        age=[age ones(1,200)*age_years(k1)];
        feat=[feat squeeze(ami_out_z(k1,:,ifeature))];
        thick=[thick thickness(k1,:)];
    end
    varnames={'subj','parcel','feat','age','thick'};
    tbl=table(subj',parcel',feat',age',thick','VariableNames',varnames);
    model= 'feat ~ age*thick+ (1|subj)';
    try
        lme=fitlme(tbl,model);
        %plotResiduals(lme,'fitted')
        allst(ifeature,:)=lme.Coefficients.tStat;
        pval(ifeature,:)=lme.Coefficients.pValue;
    end
end

