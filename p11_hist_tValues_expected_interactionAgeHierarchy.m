%% create permutation for interaction effect

% we want to shuffle age in order to test our t-values form the interaction
% effect against a data set, where age should not have a systematic
% relationship with the change of time-series features across cortical
% hierarchy

filepath = pwd;

% load age
demographics = readtable([filepath '\DATA\demo_all_subjects.csv']);
age_years = table2array(demographics(:,2));

% load the parcellated map of cortical hierarchy (sydnor et al., 2021)
load([filepath '\DATA\hierarchy_parc.csv'])

load([filepath '\DATA\mat_z.mat'])
features = readtable([filepath '\DATA\features_z.csv']);


%% AC at lag 133 ms
idx_feature = find(strcmp("AC_40",table2cell(features(:,"Var2"))));
mat_feat = squeeze(mat_z(:,:,idx_feature));

% extract the statistics of the linear mixed effect model for each feature
subj=[];
parcel=[];
feat=[];
age=[];
hierarchy=[];

for k1=1:size(mat_z,1) %subjects
    subj=[subj ones(1,200)*k1];
    parcel=[parcel 1:200];
    hierarchy=[hierarchy hierarchy_parc'];
end

for ishuffle=1:10000 % loop over features
    if (mod(ishuffle,200)==0)
        disp(ishuffle);
    end
    % shuffle age for each permutation round
    idx_shuffle = randsample(350,350);

    feat=[];
    age=[];
    for k1=1:size(mat_z,1) %subjects
        feat=[feat squeeze(mat_feat(k1,:))];
        age = [age ones(1,200)*age_years(idx_shuffle(k1))];
    end

    varnames={'subj','parcel','feat','age','hierarchy'};
    tbl=table(subj',parcel',feat',age',hierarchy','VariableNames',varnames);
    model = 'feat ~ hierarchy*age + (1|subj)';
    try
        lme=fitlme(tbl,model);
        allst_AC(ishuffle,:)=lme.Coefficients.tStat;
        pval_AC(ishuffle,:)=lme.Coefficients.pValue;
    end
end

% find indices for 2.5% and 97.5% where the t-valzes should be significant
idxmin5 = 0.025*10000;
idxmin1 = 0.005*10000;
idxmax5 = 0.975*10000;
idxmax1 = 0.995*10000;

lm_sorted = sort(allst_AC(:,4),"ascend");
lm_sorted(idxmax5) % 9.15
lm_sorted(idxmax1) % 12.05
lm_sorted(idxmin5) % -9.06
lm_sorted(idxmin1) % -11.68

% save allst_AC just in case
save([filepath '\DATA\surrogate_interarction_age_hierarchy_4AC40_results.mat'] ,"allst_AC")

figure('Color','w')
h = histogram(allst_AC(:,4),'NumBins',20)
xlabel({'LMEM: t-values for AC (lag 133 ms)';'for the interaction effect of age and cortical hierarchy for shuffled age'})
ylabel('count')
h.FaceColor = [0 0.5 0.5];

hold on 
xline([lm_sorted(idxmax5) lm_sorted(idxmax1) lm_sorted(idxmin5) lm_sorted(idxmin1)],'.','LineWidth',2,'Alpha',0.7)

xline(41.06,'r--','LineWidth',2,'Alpha',0.7) % StatAvl100

box off

exportgraphics(gcf,[filepath '\PLOTS\SUPPL_hist_AC40_tValues_interactionAgeHierarchy_permAge.png'],'Resolution',500)

%% AMI40
load([filepath '\DATA\ami_1_40.mat'])
ami = squeeze(ami_out(:,:,40));
%zscore
ami_z= zscore(ami,[],2);

% extract the statistics of the linear mixed effect model for each feature
subj=[];
parcel=[];
feat=[];
age=[];
hierarchy=[];

for k1=1:size(mat_z,1) %subjects
    subj=[subj ones(1,200)*k1];
    parcel=[parcel 1:200];
    hierarchy=[hierarchy hierarchy_parc'];
end

for ishuffle=1:10000 % loop over features
    if (mod(ishuffle,200)==0)
        disp(ishuffle);
    end
    % shuffle age for each permutation round
    idx_shuffle = randsample(350,350);

    feat=[];
    age=[];
    for k1=1:size(mat_z,1) %subjects
        feat=[feat ami_z(k1,:)];
        age = [age ones(1,200)*age_years(idx_shuffle(k1))];
    end

    varnames={'subj','parcel','feat','age','hierarchy'};
    tbl=table(subj',parcel',feat',age',hierarchy','VariableNames',varnames);
    model = 'feat ~ hierarchy*age + (1|subj)';
    try
        lme=fitlme(tbl,model);
        allst_AMI(ishuffle,:)=lme.Coefficients.tStat;
        pval_AMI(ishuffle,:)=lme.Coefficients.pValue;
    end
end

% find indices for 2.5% and 97.5% where the t-valzes should be significant
idxmin5 = 0.025*10000;
idxmin1 = 0.005*10000;
idxmax5 = 0.975*10000;
idxmax1 = 0.995*10000;

lm_sorted = sort(allst_AMI(:,4),"ascend");
lm_sorted(idxmax5) % 5.20
lm_sorted(idxmax1) % 6.87
lm_sorted(idxmin5) % -5.21
lm_sorted(idxmin1) % -6.71

% save allst_AC just in case
save([filepath '\DATA\surrogate_interarction_age_hierarchy_4AMI40_results.mat'],"allst_AMI")

figure('Color','w')
h = histogram(allst_AMI(:,4),'NumBins',20)
xlabel({'LMEM: t-values for AMI (lag 133 ms)';'for the interaction effect of age and cortical hierarchy for shuffled age'})
ylabel('count')
h.FaceColor = [0 0.5 0.5];

hold on 
xline([lm_sorted(idxmax5) lm_sorted(idxmax1) lm_sorted(idxmin5) lm_sorted(idxmin1)],'.','LineWidth',2,'Alpha',0.7)

xline(21.65,'r--','LineWidth',2,'Alpha',0.7) % StatAvl100

box off

exportgraphics(gcf,[filepath '\PLOTS\SUPPL_hist_AMI40_tValues_interactionAgeHierarchy_permAge.png'],'Resolution',500)


%% ALPHA 
% loading theta
load([filepath '\DATA\03_specData_freqbands_norm'],"alpha_norm");
alpha_z = zscore(alpha_norm,[],2);

% extract the statistics of the linear mixed effect model for each feature
subj=[];
parcel=[];
feat=[];
age=[];
hierarchy=[];

for k1=1:size(mat_z,1) %subjects
    subj=[subj ones(1,200)*k1];
    parcel=[parcel 1:200];
    hierarchy=[hierarchy hierarchy_parc'];
end

for ishuffle=1:10000 % loop over features
    if (mod(ishuffle,200)==0)
        disp(ishuffle);
    end
    % shuffle age for each permutation round
    idx_shuffle = randsample(350,350);

    feat=[];
    age=[];
    for k1=1:size(mat_z,1) %subjects
        feat=[feat alpha_z(k1,:)];
        age = [age ones(1,200)*age_years(idx_shuffle(k1))];
    end

    varnames={'subj','parcel','feat','age','hierarchy'};
    tbl=table(subj',parcel',feat',age',hierarchy','VariableNames',varnames);
    model = 'feat ~ hierarchy*age + (1|subj)';
    try
        lme=fitlme(tbl,model);
        allst_alpha(ishuffle,:)=lme.Coefficients.tStat;
        pval_alpha(ishuffle,:)=lme.Coefficients.pValue;
    end
end

% find indices for 2.5% and 97.5% where the t-valzes should be significant
idxmin5 = 0.025*10000;
idxmin1 = 0.005*10000;
idxmax5 = 0.975*10000;
idxmax1 = 0.995*10000;

lm_sorted = sort(allst_alpha(:,4),"ascend");
lm_sorted(idxmax5) % 4.46
lm_sorted(idxmax1) % 5.77
lm_sorted(idxmin5) % -4.55
lm_sorted(idxmin1) % -5.91

% save allst_AC just in case
save([filepath '\DATA\surrogate_interarction_age_hierarchy_4alpha_results.mat'],"allst_alpha")

figure('Color','w')
h = histogram(allst_AC(:,4),'NumBins',20)
xlabel({'LMEM: t-values for alpha power';'for the interaction effect of age and cortical hierarchy for shuffled age'})
ylabel('count')
h.FaceColor = [0 0.5 0.5];

hold on 
xline([lm_sorted(idxmax5) lm_sorted(idxmax1) lm_sorted(idxmin5) lm_sorted(idxmin1)],'.','LineWidth',2,'Alpha',0.7)

xline(21.4,'r--','LineWidth',2,'Alpha',0.7) % StatAvl100

box off

exportgraphics(gcf,[filepath '\PLOTS\SUPPL_hist_alpha_tValues_interactionAgeHierarchy_permAge.png'],'Resolution',500)















