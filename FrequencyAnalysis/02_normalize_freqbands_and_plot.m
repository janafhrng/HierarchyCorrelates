clearvars;
close all
clc

filepath = pwd;

% load power spectrum
load([filepath '\DATA\01_specData_all.mat']);

% only take the 200 cortical parcels and disregard the 14 other parcels
load([filepath '\DATA\mapping_idx_camcan2schaefer.mat'])
specData_all = specData_all(:,tmp_idx,:);
save([filepath '\DATA\02_specData_all_reordered_schaefer200'], "specData_all");

% loop throught he parcipants to create their delta, theta, alpha, beta,
% gamma band power + the normalized values thereof

% mean of all freqbands
all = mean(specData_all,3,'omitnan');
delta =  mean(specData_all(:,:,2:4),3,'omitnan');
theta =  mean(specData_all(:,:,5:8),3,'omitnan');
alpha =  mean(specData_all(:,:,9:14),3,'omitnan');
beta =  mean(specData_all(:,:,15:31),3,'omitnan');
gamma =  mean(specData_all(:,:,32:101),3,'omitnan');

% normalize over all freqbands
delta_norm = delta./all; 
theta_norm = theta./all; 
alpha_norm = alpha./all; 
beta_norm = beta./all; 
gamma_norm = gamma./all; 

% take the mean of the freqbands
delta_norm_mean = mean(delta_norm,1);
theta_norm_mean = mean(theta_norm,1);
alpha_norm_mean = mean(alpha_norm,1);
beta_norm_mean = mean(beta_norm,1);
gamma_norm_mean = mean(gamma_norm,1);

freq_norm_mean = [delta_norm_mean;theta_norm_mean;alpha_norm_mean;beta_norm_mean;gamma_norm_mean];

% save the data
save([filepath '\DATA\03_specData_freqbands_norm'], "delta_norm","theta_norm","alpha_norm","beta_norm","gamma_norm");
writematrix(freq_norm_mean,[filepath '\DATA\03_specData_freqbands_norm_mean.csv'])



