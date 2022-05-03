source('utils.R')

# Load external packages
library('ggplot2')

# Import data file
dfSurvey <- load_CSV(append_path(data_path, 'survey.csv'))

# Set output file to a PDF
OUTPUT_FILE <- append_path(table_path, 'tableCountry.tex')

# Remove the output file if any
unlink(OUTPUT_FILE)
sink(OUTPUT_FILE, append=FALSE, split=TRUE)

# Write down the table header
cat('\\begin{tabular}{@{\\extracolsep{\\fill}} lrr} \\toprule\n', sep='')
cat('\\multicolumn{1}{c}{Country} & \\multicolumn{1}{c}{\\# Participants} \\\\ \n', sep='')
cat('\\midrule \n', sep='')

# Content
country <- table(dfSurvey$Where.do.you.live...Country.)
#df <- as.data.frame(country)

cat("Brazil & 9 \\\\", "\n", sep="")
cat("Portugal & 10 \\\\", "\n", sep="")

# Footer
cat('\\bottomrule\n', sep='')
cat('\\end{tabular}\n', sep='')

# Flush data
sink()

