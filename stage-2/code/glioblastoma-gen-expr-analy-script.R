---
  title: "Glioblastoma Gene Expression and Functional Enrichment Analysis"
  author: "Authors: Shekoni Oluwatosin"
  date: "2024-10-11"
output: html_notebook
---


# (1a) Load necessary libraries
install.packages("gplots")
install.packages("RColorBrewer")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("reshape2")

library(gplots)
library(RColorBrewer)
library(ggplot2)
library(dplyr)
library(reshape2)

# (1b) Load the dataset
glioblastoma_data_url <- "https://raw.githubusercontent.com/HackBio-Internship/public_datasets/main/Cancer2024/glioblastoma.csv"

glioblastoma_data <- read.csv(glioblastoma_data_url, row.names = 1)

head(glioblastoma_data)
View(glioblastoma_data)

# (2) Generate Heat maps

# Generate a basic heatmap
#diverging color heat map
heatmap_1_divergent <- heatmap.2(as.matrix(glioblastoma_data), col = bluered(75), scale = "row", trace = "none", 
                                 density.info = "none", margins = c(10, 10))

# Sequential color heat map
heatmap_2_sequential_colors <- colorRampPalette(brewer.pal(9, "YlGnBu"))(75)
heatmap_2_sequential <- heatmap.2(as.matrix(glioblastoma_data), col = heatmap_2_sequential_colors, scale = "row", trace = "none", 
                                  density.info = "none", margins = c(10, 10))

# Cluster Genes (Rows) Only:
heatmap_3_genes_rows <- heatmap.2(as.matrix(glioblastoma_data), col = bluered(75), Rowv = TRUE, Colv = FALSE, 
                                  scale = "row", trace = "none", density.info = "none", margins = c(10, 10), dendrogram = "row")

# Cluster Samples (Columns) Only:
heatmap_4_samples_column <- heatmap.2(as.matrix(glioblastoma_data), col = bluered(75), Rowv = FALSE, Colv = TRUE, 
                                      scale = "row", trace = "none", density.info = "none", margins = c(10, 10), dendrogram = "column")

# Cluster Both Genes and Samples:
heatmap_5_genes_n_samples <- heatmap.2(as.matrix(glioblastoma_data), col = bluered(75), Rowv = TRUE, Colv = TRUE, 
                                       scale = "row", trace = "none", density.info = "none", margins = c(10, 10))
  
  
# (3)Subset Genes Based on Fold Change and p-Value

# Separate data into two groups
glioblastoma_data_group1 <- glioblastoma_data[, 1:5]  # Columns 1-5 are Group 1
glioblastoma_data_group2 <- glioblastoma_data[, 6:10] # Columns 6-10 are Group 2

# Calculate log fold change (logFC)
glioblastoma_log_fold_change <- log2(rowMeans(glioblastoma_data_group2) + 0.5) - log2(
  rowMeans(glioblastoma_data_group1) + 0.5)

# Perform t-tests for each gene between Group 1 and Group 2
glioblastoma_p_values <- apply(glioblastoma_data, 1, function(row) {
  t.test(as.numeric(row[1:5]), as.numeric(row[6:10]))$p.value
})

# visualize the log fold change and negative log of p-values
plot(glioblastoma_log_fold_change, -log10(glioblastoma_p_values))

#Volcano plot of DEG's
# Set threshold values for fold change and p-value
logFC_threshold <- 1
pval_threshold <- 0.05

# Create a new column for significance
significance <- rep("Not Significant", nrow(glioblastoma_data))
significance[glioblastoma_log_fold_change > logFC_threshold & glioblastoma_p_values < pval_threshold] <- "Upregulated"
significance[glioblastoma_log_fold_change < -logFC_threshold & glioblastoma_p_values < pval_threshold] <- "Downregulated"

# Convert significance to a factor for better plotting
significance <- factor(significance, levels = c("Not Significant", "Upregulated", "Downregulated"))

# Volcano plot
ggplot(glioblastoma_data, aes(x = glioblastoma_log_fold_change, y = -log10(glioblastoma_p_values), color = significance)) +
  geom_point(alpha = 0.8, size = 2) + 
  scale_color_manual(values = c("gray", "red", "blue")) + 
  theme_minimal() + 
  labs(x = "Log2 Fold Change", y = "-Log10 p-value", title = "Volcano Plot of Glioblastoma DEGs") +
  geom_hline(yintercept = -log10(pval_threshold), linetype = "dashed", color = "black") + 
  geom_vline(xintercept = c(-logFC_threshold, logFC_threshold), linetype = "dashed", color = "black")


# Create a results dataframe with fold change and p-values
glioblastoma_data_2 <- data.frame(Gene = rownames(glioblastoma_data), Log_fold_Change = glioblastoma_log_fold_change, P_Value = glioblastoma_p_values)

# Subset Upregulated and Downregulated Genes: Based on fold change and p-values
# Define thresholds for upregulated and downregulated genes
glioblastoma_log_fold_change_cutoff <- 1
glioblastoma_p_value_cutoff <- 0.05

# Subset upregulated genes
glioblastoma_upregulated_genes <- glioblastoma_data_2 %>%
  filter(Log_fold_Change > glioblastoma_log_fold_change_cutoff & P_Value < glioblastoma_p_value_cutoff)

# Subset downregulated genes
glioblastoma_downregulated_genes <- glioblastoma_data_2 %>%
  filter(Log_fold_Change < glioblastoma_log_fold_change_cutoff & P_Value < glioblastoma_p_value_cutoff)

# Display counts of upregulated and downregulated genes
nrow(glioblastoma_upregulated_genes)
nrow(glioblastoma_downregulated_genes)

# Export gene lists to CSV
write.csv(glioblastoma_upregulated_genes, "upregulated_genes.csv", row.names = FALSE)
write.csv(glioblastoma_downregulated_genes, "downregulated_genes.csv", row.names = FALSE)

# (4) Functional Enrichment Analysis with ShinyGO

# Export gene names to a text file:
# 1. Go to ShinyGO and upload the gene lists.
# 2. Perform the functional enrichment analysis.


# (5) Visualize the Top 5 Pathways

# Dot plot
glioblastoma_pathways_data <- data.frame(
  Pathway = c("Ribosomal small subunit assembly", "Maturation of SSU-rRNA from tricistronic rRNA transcript (SSU-rRNA 5.", "Maturation of SSU-rRNA", "Ribosome assembly", "Ribosomal small subunit biogenesis"),
  Gene_Count = c(1, 1, 1, 1, 1),
  P_Value = c(0.0145, 0.0145, 0.0145, 0.0145, 0.0159)
)

# Calculate the negative log10 of the p-value
glioblastoma_pathways_data$LogP <- -log10(glioblastoma_pathways_data$P_Value)

# Create a dot plot using ggplot2, with color mapped to LogP values
library(ggplot2)
ggplot(glioblastoma_pathways_data, aes(y = Pathway, x = Gene_Count, size = LogP, color = LogP)) +
  geom_point() +
  scale_color_gradient(low = "blue", high = "red") +  # Color gradient from blue to red
  theme_minimal() +
  labs(title = "Top 5 Enriched Pathways: Gene Count and Significance Levels",
       y = "Pathway", x = "Gene Count",
       size = "-log10(P-Value)", color = "-log10(P-Value)") +  # Add color legend
  theme(axis.text.x = element_text(angle = 45, hjust = 1))