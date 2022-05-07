# ------------------------------------------------------------------------------
# This script print out a pie chart with the age of participants.
#
# Usage:
#   Rscript reportAge.R
#     <output pdf file, e.g., reportAge.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript reportAge.R <output pdf file, e.g., reportAge.pdf>')
}

# Args
INPUT_FILE  <- '../data/survey.csv'
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

# Load external packages
library('ggplot2')

# Import data file
df <- load_CSV(INPUT_FILE)
# Filter out the ones that have not used any QP language, as those have not
# completed the survey
df <- df[df$'Have.you.ever.used.any.Quantum.Programming.Language.' == 'Yes', ]

# Set output file to a PDF
#OUTPUT_FILE <- append_path(report_path, 'reportAge.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("Age Report\nWhat is your age?")

slices <- table(df$What.is.your.age.)
lbls <- c('less than 18 years old', '18-24 years old', '25-34 years old', '35-44 years old', '45-54 years old', '55-64 years old', '65 years or older')
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, paste("(", pct, sep="")) # add percents to labels
lbls <- paste(lbls,"%)",sep="") # ad % to labels

pie(slices,labels = lbls, col=rainbow(length(lbls)), main="")

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF