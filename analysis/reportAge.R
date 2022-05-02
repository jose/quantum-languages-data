source('utils.R')

# Load external packages
library('ggplot2')

# Import data file
dfSurvey <- load_CSV(append_path_data('survey.csv'))

# Set output file to a PDF
OUTPUT_FILE <- append_path_report('reportAge.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("Age Report\nWhat is your age?")

slices <- table(dfSurvey$What.is.your.age.)
lbls <- c('less than 18 years old', '18-24 years old', '25-34 years old', '35-44 years old', '45-54 years old', '55-64 years old', '65 years or older')
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, paste("(", pct, sep="")) # add percents to labels
lbls <- paste(lbls,"%)",sep="") # ad % to labels

pie(slices,labels = lbls, col=rainbow(length(lbls)), main="A")

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)
