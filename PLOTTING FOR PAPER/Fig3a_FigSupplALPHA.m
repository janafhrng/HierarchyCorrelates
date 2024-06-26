%% PLOTTING ALPHA OVER DIFFERENT AGES
load('vik.mat')
load('lipari10.mat')
load('lajolla10.mat')
load("batlow10.mat")

% finding participants in different age ranges
demographics = readtable('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\demo_all_subjects.csv');
age_years = table2array(demographics(:,2));
index_age_group = [1:50;151:200;301:350];

% finding parcels which are low, medium or high in cortical hierarchy
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\hierarchy_parc.csv')
[~,hierarchy_sorted] = sort(hierarchy_parc,'ascend');
idx_h_min = hierarchy_sorted(1:10);
idx_h_med = hierarchy_sorted(96:105);
idx_h_max = hierarchy_sorted(191:200);

% loading theta
load('Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\DATA\03_specData_freqbands_norm',"alpha_norm");
data2plot = alpha_norm;

%addpath(genpath('C:\Users\fehring\sciebo\Toolboxes'))
[surf_lh, surf_rh] = load_conte69();
labeling = load_parcellation('schaefer',200);

% split according to age group 
 mat1 = mean(data2plot(table2array(demographics(:,2)) <= 28,:),1);
 mat2 = mean(data2plot(table2array(demographics(:,2)) > 48 & table2array(demographics(:,2)) <= 58,:),1);
 mat3 = mean(data2plot(table2array(demographics(:,2)) > 79,:),1);


 %% Figure 3a topo
 for i = 1:3
    data2plot2(i,:) = eval(['mat', num2str(i)]);
 end

obj = plot_hemispheres(data2plot2(1:3,:)', {surf_lh,surf_rh}, ...
    'parcellation',labeling.schaefer_200, 'views', 'lm');
set(gcf,'units','points','position',[50,-50,1200,1200])
colormap([0.7 0.7	0.7;vik])
saveas(gcf,'x.png')
I1 = imread('x.png');
T1 = imcrop(I1, [145, 30, 583, 240]); % only left hemisphere
T2 = imcrop(I1, [145, 315, 583, 240]);
T3 = imcrop(I1, [145, 600, 583, 240]);

Imerged = imtile({T1,T2,T3},  'BorderSize', 4, 'BackgroundColor', 'white','GridSize', [1,3]);
imwrite(Imerged,'Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\PLOTS\Fig3a_alpha_topo_across_age.png');




%% Figure 3a scatter
% plotting it so the interaction effect of age and cortical hierarchy are
% clear

% only take the 50 youngest and oldest participants and plot their AC40
% value over the the different parcels which have diferent hierarchy levels

colors = {repmat(batlow10(5,:),200,1),repmat(batlow10(7,:),200,1),repmat(batlow10(9,:),200,1)};

for age = [1:3]
    %our feature AC40: 123
    ts = data2plot(index_age_group(age,:),:);
    ts_mean = squeeze(mean(ts,1));
    %ts_sd = squeeze(std(ts,1));

    % plot a linear fit into the plot
    % creating a linear fit
    lm_h = fitlm(hierarchy_parc,ts_mean);

    figure
    plot(lm_h)
    xlabel('cortical hierarchy')
    ylabel('feature value')
    Lines = findobj(gca, 'Type','Line');
    CI = findobj('Type','line','DisplayName','Confidence bounds');
    CIX = CI.XData;
    CIY = CI.YData;
    lm_intercept(age) = table2array(lm_h.Coefficients(1,1));
    lm_slope(age) = table2array(lm_h.Coefficients(2,1));

    % in a nicer plot
    dist(age,:) =  lm_intercept(age)+lm_slope(age)*CIX - CIY;
    x(age,:) = [CIX CIX(end:-1:1)];
    y(age,:) = [CIY CIY(end:-1:1)+dist(age,:)*2];
end

figure('Color','w','Position',[1,1,400,500])
for age = [1:3]
    %our feature AC40: 123
    ts = data2plot(index_age_group(age,:),:);
    ts_mean = squeeze(mean(ts,1));

    % figure
    f = lm_intercept(age)+lm_slope(age)*hierarchy_parc;
    scatter(hierarchy_parc,ts_mean,90,colors{age},'filled','o','MarkerFaceAlpha',.6)
    hold on
    fill(x(age,:),y(age,:),colors{age}(1,:),'FaceAlpha',.4,'EdgeColor','none')
    h(age) = plot(hierarchy_parc,f,'LineWidth',3,'Color',colors{age}(1,:))
end

xlabel('cortical hierarchy','FontSize',16,'FontWeight','normal')
ylabel('alpha power','FontSize',16,'FontWeight','normal')
set(gca,'box','off')
set(gca,'FontSize',14)
hold off

exportgraphics(gcf,'Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\PLOTS\Fig3a_scatter_linfit_alpha_age.png','Resolution',500)


%% Supplementary boxplots ALPHA

mat_boxplot = alpha_norm;

% make grouping arrays
group_age = [repmat(1,50,1); repmat(2.5,50,1); repmat(4,50,1)];
group_hierarchy = categorical(repelem([{'1'}, {'2'}, {'3'}], [150 150 150])');

colors = [repmat(lajolla10(4,:),50,1);repmat(lajolla10(6,:),50,1);repmat(lajolla10(8,:),50,1)];

figure('color','w', 'Position',[0,0,700,1000])
h = boxchart(repmat(group_age,3,1),[mean(mat_boxplot([1:50,151:200,301:350],idx_h_min),2);mean(mat_boxplot([1:50,151:200,301:350],idx_h_med),2);mean(mat_boxplot([1:50,151:200,301:350],idx_h_max),2)],"GroupByColor",group_hierarchy)
h(1).BoxFaceColor = lajolla10(4,:);  
h(2).BoxFaceColor = lajolla10(6,:);
h(3).BoxFaceColor = lajolla10(8,:);

hold('on');

s1 = swarmchart([repmat(0.67,50,1);repmat(1,50,1);repmat(1.33,50,1)],[mean(mat_boxplot(1:50,idx_h_min),2);mean(mat_boxplot(1:50,idx_h_med),2);mean(mat_boxplot(1:50,idx_h_max),2)],[],colors,"filled",'MarkerFaceAlpha',0.6,'XJitterWidth',0.2);
s2 = swarmchart([repmat(2.17,50,1);repmat(2.5,50,1);repmat(2.83,50,1)],[mean(mat_boxplot(151:200,idx_h_min),2);mean(mat_boxplot(151:200,idx_h_med),2);mean(mat_boxplot(151:200,idx_h_max),2)],[],colors,"filled",'MarkerFaceAlpha',0.6,'XJitterWidth',0.2);
s3= swarmchart([repmat(3.67,50,1);repmat(4,50,1);repmat(4.33,50,1)],[mean(mat_boxplot(301:350,idx_h_min),2);mean(mat_boxplot(301:350,idx_h_med),2);mean(mat_boxplot(301:350,idx_h_max),2)],[],colors,"filled",'MarkerFaceAlpha',0.6,'XJitterWidth',0.2);

xticks([1,2.5,4])
set(gca,'XTickLabel',{'young','middle','old'});
set(gca,'FontSize',14)
xlabel('age group')
ylabel('alpha power')
hold off

exportgraphics(gcf,'Z:\TBraiC\JF\HCTSA feature gradients\CamCan\Code2Publish\PLOTS\SUPPL_bloxplot_alpha_age.png','Resolution',500)








