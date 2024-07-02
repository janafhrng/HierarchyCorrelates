%% PLOT CORTICAL HIERARCHY AND CORTICAL THICKNESS
filepath = pwd;

load('vik.mat')

%addpath(genpath('C:\Users\fehring\sciebo\Toolboxes'))
[surf_lh, surf_rh] = load_conte69();
labeling = load_parcellation('schaefer',200);


%% plotting hierarchy
load([filepath '\DATA\hierarchy_parc.csv'])

obj = plot_hemispheres(hierarchy_parc, {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200, 'views', 'lm');
set(gcf,'units','points','position',[50,-50,1200,1200])
colormap([0.7 0.7	0.7;vik])
saveas(gcf,'x.png')
I1 = imread('x.png');
T1 = imcrop(I1, [175, 30, 1100, 240]); % only left hemisphere
Imerged = imtile({T1},  'BorderSize', 4, 'BackgroundColor', 'white','GridSize', [1,1]);
imwrite(Imerged,[filepath '\PLOTS\topo_cortical_hierarchy.png']);


%% plotting cortical thickness

% loading cortical thickness
load([filepath '\DATA\thickness_smoothed_12_schaefer200_reordered.mat']);
thickness(306,:) = [];

thick_mean = mean(thickness,1);

obj = plot_hemispheres(thick_mean', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200, 'views', 'lm');
set(gcf,'units','points','position',[50,-50,1200,1200])
colormap([0.7 0.7	0.7;vik])
saveas(gcf,'x.png')
I1 = imread('x.png');
T1 = imcrop(I1, [175, 30, 1100, 240]); % only left hemisphere
Imerged = imtile({T1},  'BorderSize', 4, 'BackgroundColor', 'white','GridSize', [1,1]);
imwrite(Imerged,[filepath '\PLOTS\topo_cortical_thickness.png']);
