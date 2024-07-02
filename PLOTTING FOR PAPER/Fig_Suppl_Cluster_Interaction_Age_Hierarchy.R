##### LME INTERACTION EFFECT CORTICAL HIERARCHY AND AGE #####
filepath = getwd()

nfeat = 50

# Load lme t values
tval <- read.csv(paste(filepath,'/DATA/lme_out_age_effect_hierarchy.csv' ,sep=""), header = F)
tval_h <- tval$V4
tval_sort = sort(abs(tval_h),decreasing = T)[1:50]
index = order(abs(tval_h),decreasing = T)

# load features and numeric feature matrix and sort them according to this index
mat_z <- read_mat(paste(filepath,'/DATA/mat_z.mat' ,sep=""))
df <- mat_z[[1]]
mat_z_sort = df[,,index]
mat_z_sort <- mat_z_sort[,,1:50]

table <- read.csv(paste(filepath,'/DATA/features_z.csv' ,sep=""), header = F)
table_sort = table[index,]
features_sort = table_sort[1:50,]

# reshape mat into a long matrix where participants*parcels x features
dim(mat_z_sort) <- c(200 * 350 , nfeat)
mat_z_corr <- abs(cor(mat_z_sort,method = "spearman"))

# clustered heatmap
cols= str_c(features_sort[,2],", t = ", round(tval_sort,2))
rownames(mat_z_corr) <- cols
colnames(mat_z_corr) <- cols

annotation_col = data.frame(gsub(",.*", "", features_sort[,4]))
rownames(annotation_col)=rownames(mat_z_corr)
names(annotation_col) <- "Hctsa_group"

col_dist = rev(hcl.colors(100, "inferno"))
col_label = list(Hctsa_group = c(correlation="#E78AC3",entropy="#FF7F00",forecasting="#66C2A5",information="lightsteelblue2",
                                 model="mediumorchid",nonlinear="#1F78B4",scaling="#BEAED4",stationarity="#B3E2CD",symbolic="#FB9A99",
                                 trend="darkmagenta"))


windowsFonts(A = windowsFont("Calibri"))

Cairo::Cairo(
  45, #length
  25, #width
  file = paste(filepath, "/PLOTS/SUPPL_cluster_interaction_hierarchy_age", ".png", sep = "")
  type = "png", #tiff
  bg = "transparent", #white or transparent depending on your requirement 
  dpi = 500,
  units = "cm" #you can change to pixels etc 
)

x <- pheatmap(mat_z_corr,show_colnames=FALSE,
              scale = "none",clustering_method="ward.D2",
              clustering_distance_cols="euclidean", clustering_distance_rows="euclidean",
              cutree_rows = 4,cutree_cols = 4,
              annotation_col = annotation_col, annotation_row = annotation_col, annotation_names_row = FALSE,
              legend = TRUE, legend_labels = "absulute correlation",
              cellwidth = 12, cellheight = 12,border_color = NA, color = col_dist[1:80], annotation_colors = col_label) +
  theme(text = element_text(family = "A")) 

dev.off()