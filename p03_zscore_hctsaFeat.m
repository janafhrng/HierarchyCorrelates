clearvars;
close all
clc

%% loading all data
%addpath(genpath('C:\Users\fehring\sciebo\Toolboxes\'))

%loading matrix with the data in the form of participant x parcels x features
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\all_subj_feat_reordered_schafer200.mat');

% loading the feature file with the complete list of features 
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\features_selected.mat');
features= labels_selected;

%% Preparing for a LMM: take nans out, average, z-score

% disregard all nans
for i = 1:size(mat,3)
    n_nan(i) = sum(isnan(mat(:,:,i)),'all');
end
mat_clean = mat; features_clean = features;
mat_clean(:, :,find(n_nan > 0)) = [];
features_clean(find(n_nan > 0), :) = [];

% disregard all infinities
for i = 1:size(mat_clean,3)
    n_inf(i) = sum(isinf(mat_clean(:,:,i)),'all');
end
mat_clean(:,:,find(n_inf > 0)) = [];
features_clean(find(n_inf > 0), :) = [];

% z-score
for i = 1:size(mat_clean,3)
    tmp_mat = mat_clean(:,:,i);
    mat_z(:,:,i) = zscore(tmp_mat, 0, 2);
end

save('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\mat_z.mat',"mat_z", '-v7.3')
writetable(features, 'Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\features_z.csv','WriteRowNames',true)















