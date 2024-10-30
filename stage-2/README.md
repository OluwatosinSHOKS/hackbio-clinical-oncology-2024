## Glioblastoma Gene Expression and Functional Enrichment Analysis

This project involves gene expression analysis of glioblastoma data, conducted using various R libraries and 
visualisation techniques. The goal is to identify significant genes and understand biological pathways 
related to glioblastoma progression.

### Libraries Used

1. **gplots**: for generating heatmaps and additional visualizations.
2. **ggplot2**: for creating detailed and customizable plots.
3. **RColorBrewer**: for diverse color palettes in heatmaps.
4. **dplyr**: for data manipulation tasks like filtering and summarizing data.
5. **tidyverse**: includes packages like ggplot2, dplyr, and tidyr for streamlined data handling.

**Code Installation:**  
Install packages using `install.packages("packagename")`.  
Load packages with `library(packagename)`.

### Analysis Workflow

1. **Loading Glioblastoma Data:** The dataset includes gene expression profiles, where each value represents a 
gene's expression level in a sample.  
   **R Function:** `read.csv()` loads the dataset into a dataframe.

2. **Heatmap Generation**: Created heatmaps to visualize expression patterns and highlight upregulated and 
downregulated genes. This step helps reveal gene behavior and expression trends across samples.

3. **Clustering Methods in Heatmaps**: Clustering was applied to both rows (genes) and columns (samples) to 
identify groups of co-regulated genes and sample subtypes.

   - **Gene Clustering (Rows):** Groups genes with similar expression, potentially co-regulated or involved in 
   the same processes.
   - **Sample Clustering (Columns):** Helps identify sample subtypes based on expression patterns.
   - **Dual Clustering:** Offers a comprehensive view of relationships between gene groups and sample profiles.

   **R Functions:** `heatmap.2()` for generating heatmaps.

4. **Identification of Differentially Expressed Genes:** Using the clusters, samples were divided into groups, and 
log fold change was calculated to identify significantly upregulated and downregulated genes.

   - **LogFC Formula:** `log2(groupB_mean) - log2(groupA_mean)`
   - **p-value Calculation:** t-test to compare gene counts between groups.  

5. **Functional Enrichment Analysis**: Conducted enrichment analysis to identify pathways associated with 
upregulated genes, using GO biological process databases. Results were saved in a .csv file for visualization.

6. **Pathway Visualization**: Top pathways were visualized in a dot plot, scaled by `-log10(p-value)` to 
highlight pathway significance.

   **R Function:** `ggplot()` for creating and customizing plots such as dot plot.

### Biological Insights from Upregulated Pathways
The analysis highlights key pathways indicating how tumor cells adapt and proliferate, contributing to metastasis and treatment resistance.

### Directory Structure

* **/code**: R scripts for data analysis and visualization steps.
* **/data**: Contains the gene expression dataset.
* **/figures**: Visualizations, including heatmaps and pathway plots.
* **/output**: Includes tables of significant genes and pathway enrichment results.
* **/report**: Documented reports on analysis steps and interpretations.


