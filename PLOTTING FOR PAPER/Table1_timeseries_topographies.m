%% PLOT FREQBANDS TOPOGRAPHIES AVERAGED

load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\03_specData_freqbands_norm');

freq(1,:) = mean(zscore(delta_norm,[],2),1);
freq(2,:) = mean(zscore(theta_norm,[],2),1);
freq(3,:) = mean(zscore(alpha_norm,[],2),1);
freq(4,:) = mean(zscore(beta_norm,[],2),1);
freq(5,:) = mean(zscore(gamma_norm,[],2),1);

[surf_lh, surf_rh] = load_conte69();
labeling = load_parcellation('schaefer',200);

load('vik.mat')

path = 'Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\PLOTS\';

obj = plot_hemispheres(freq(1,:)', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200, 'views', 'lm');
%set(obj.handles.axes,'CLim',limits);
%set(obj.handles.colorbar,'Limits',limits, 'Ticks',limits);
set(gcf,'units','points','position',[50,-50,1200,1200])
colormap([0.7 0.7	0.7;vik])
saveas(gcf,[path, '1.png'])

obj = plot_hemispheres(freq(2,:)', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200, 'views', 'lm');
%set(obj.handles.axes,'CLim',limits);
%set(obj.handles.colorbar,'Limits',limits, 'Ticks',limits);
set(gcf,'units','points','position',[50,-50,1200,1200])
colormap([0.7 0.7	0.7;vik])
saveas(gcf,[path, '2.png'])

obj = plot_hemispheres(freq(3,:)', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200, 'views', 'lm');
%set(obj.handles.axes,'CLim',limits);
%set(obj.handles.colorbar,'Limits',limits, 'Ticks',limits);
set(gcf,'units','points','position',[50,-50,1200,1200])
colormap([0.7 0.7	0.7;vik]) 
saveas(gcf,[path, '3.png'])

obj = plot_hemispheres(freq(4,:)', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200, 'views', 'lm');
%set(obj.handles.axes,'CLim',limits);
%set(obj.handles.colorbar,'Limits',limits, 'Ticks',limits);
set(gcf,'units','points','position',[50,-50,1200,1200])
colormap([0.7 0.7	0.7;vik])
saveas(gcf,[path, '4.png'])

obj = plot_hemispheres(freq(5,:)', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200, 'views', 'lm');
%set(obj.handles.axes,'CLim',limits);
%set(obj.handles.colorbar,'Limits',limits, 'Ticks',limits);
set(gcf,'units','points','position',[50,-50,1200,1200])
colormap([0.7 0.7	0.7;vik])
saveas(gcf,[path, '5.png'])

T1 = imread([path,'1.png']);
T1 = imcrop(T1, [145, 30, 583, 240]); % only left hemisphere
T2 = imread([path,'2.png']);
T2 = imcrop(T2, [145, 30, 583, 240]);
T3 = imread([path,'3.png']);
T3 = imcrop(T3, [145, 30, 583, 240]);
T4 = imread([path,'4.png']);
T4 = imcrop(T4, [145, 30, 583, 240]);
T5 = imread([path,'5.png']);
T5 = imcrop(T5, [145, 30, 583, 240]);

Imerged = imtile({T1,T2,T3,T4,T5},  'BorderSize', 4, 'BackgroundColor', 'white','GridSize', [5 1]);
imwrite(Imerged,[path,'Tabl1_topo_freqbands.png']);

%% PLOT TOPOGRAPHIES FOOOF EXP AND COG

% plot fooof exponent
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\foof_variables.mat')
fooof_plot = mean(zscore(fooof_exp_2_60Hz,[],2),1);
% we look at the fooof exponent from 2-60 Hz, the other one is from 1-60 Hz

[surf_lh, surf_rh] = load_conte69();
labeling = load_parcellation('schaefer',200);

plot_hemispheres(fooof_plot', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200)
load('vik.mat')
colormap([0.7 0.7	0.7;vik])
set(gcf,'units','points','position',[50,-50,1200,1200])
saveas(gcf,['x.png'])
images = imcrop(imread(['x.png']), [170, 30, 1105, 270]);
imwrite(images,[path, 'Tabl1_topo_FOOOFexp.png']);

% plot peak frrequency: center of gravity
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\peak_freq_cog.mat')

peakfreq_plot = mean(zscore(peak_freq_cog,[],2),1);

[surf_lh, surf_rh] = load_conte69();
labeling = load_parcellation('schaefer',200);

plot_hemispheres(peakfreq_plot', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200)
load('vik.mat')
colormap([0.7 0.7	0.7;vik])
set(gcf,'units','points','position',[50,-50,1200,1200])
saveas(gcf,['x.png'])
images = imcrop(imread(['x.png']), [170, 30, 1105, 270]);
imwrite(images,[path, 'Tabl1_topo_peakfreq.png']);

%% PLOT StatAvl100
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\mat_z.mat')

% create average over the StatAvl100 feature #448
data2plot = squeeze(mean(mat_z(:,:,448),1));

plot_hemispheres(data2plot', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200)
load('vik.mat')
colormap([0.7 0.7	0.7;vik])
set(gcf,'units','points','position',[50,-50,1200,1200])
saveas(gcf,['x.png'])
images = imcrop(imread(['x.png']), [170, 30, 1105, 270]);
imwrite(images,[path, 'topo_StatAvl100.png']);




