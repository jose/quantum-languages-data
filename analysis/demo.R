source('utils.R')

# Load external packages
library('ggplot2')

# ------------------------------------------------------------------------- Args

# args = commandArgs(trailingOnly=TRUE)
# if (length(args) != 1) {
#   stop('USAGE: Rscript demo.R <output file>')
# }
# 
# # Args
# OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------------
# Example of a table

OUTPUT_FILE <- 'demo-table.tex'

# Remove the output file if any
unlink(OUTPUT_FILE)
sink(OUTPUT_FILE, append=FALSE, split=TRUE)

# Write down the table header
cat('\\begin{tabular}{@{\\extracolsep{\\fill}} lrr} \\toprule\n', sep='')
cat('\\multicolumn{1}{c}{Column A} & \\multicolumn{1}{c}{\\# Column B} & \\multicolumn{1}{c}{\\# Column C} \\\\ \n', sep='')
cat('\\midrule \n', sep='')

# Content
cat("Configuration & 9 & 44 \\\\", "\n", sep="")

# Footer
cat('\\bottomrule\n', sep='')
cat('\\end{tabular}\n', sep='')

# Flush data
sink()

# ------------------------------------------------------------------------------
# Example of multiple pie charts in a single pdf file

OUTPUT_FILE <- 'demo-plot.pdf'

unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=10, height=9)

plot_label("Plot A\nYet another description")
slices <- c(10, 12, 4, 16, 8)
pie(slices, labels=c("US", "UK", "Australia", "Germany", "France"), main="")

plot_label("Plot B")
slices <- c(56, 1, 45, 160, 38)
pie(slices, labels=c("US", "UK", "Australia", "Germany", "France"), main="")

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)
