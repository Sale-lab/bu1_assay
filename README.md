# bu1_assay

This R script is used to automate the analysis of the data exported from FlowJo to a spreadsheet to provide scatter plots, median and statistics. This analysis can also be performed using other graphing and analysis tools such as Prism. 
Preparation of files and running the script. 
In this example, the flow cytometry analyses were performed with and data exported from FlowJo® (Becton Dickinson) as an Excel (.xlsx) file. However, only the layout of the data matters in running the script, thus any flow cytometry software can be used for analysis. 
The script retrieves the percentage of the gated Bu-1 positive cells by searching any line in the cytometry output file containing the name of this gate (“Bu1_Pos”), and extracting the next column value (in this example 98.5%). 

WT_NT_Tube_001.fcs	NA	20879

WT_NT_Tube_001.fcs/Single_cells	50.4	10519

WT_NT_Tube_001.fcs/Single_cells /Bu1_Pos	98.5	10363

If the name of the gate (“Bu1_Pos”) has been changed, this must also be amended within the script in the custom parameters section 
For the script to run, four replacements on the original .xlsx must first be performed: 
1. All empty cells should be filled with ‘NA”.
2. All spaces between words should be replaced by an underscore.¬
3. Column names should be removed. 
4. The file should be saved as a .csv file (or tabulated .txt, in which case this must be recorded within the script in the custom parameters section). 
The R script should be placed in a folder also containing Input and an Output subfolders. 
Input folder: CSV files with data for all conditions to be compared should be put within the same folder inside the ./Input folder. Note: each folder within ./Input is processed independently. 
Fisher exact test: The user should define the bin size (in the custom parameters section) for the Fisher exact test. The bin is set to contain 90% of the control sample. Based on our previous experience, well looked after and well stained wild type DT40 do not exhibit more than a maximum of 20% apparent loss variants, most often < 10%. 
Output: For each subfolder in ./Input, a subfolder of same name is generated within ./Output. After the script has run, each folder should contain two files: 
1. an SVG file containing scatter plots of the percentage of Bu-1 loss variants in each sample together with lower and upper quartile (black lines) and median (red line). 
2. TXT file containing the P value from the Fisher exact test between conditions. 

