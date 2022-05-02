source('utils.R')

# Load external packages
library('ggplot2')

# Import data file
dfSurvey <- load_CSV(append_path_data('survey.csv'))

# Set output file to a PDF
OUTPUT_FILE <- append_path_report('reportForums.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("Forum Report\nWhich forums, e.g., to ask for help, search for examples, do you use? (if any)")

#counts <- table(dfSurvey$Which.forums..e.g...to.ask.for.help..search.for.examples..do.you.use...if.any.)

tab <- matrix(c(3, 28, 53, 86, 22), ncol=5, byrow=TRUE)
colnames(tab) <- c('Devtalk','Quantum Open Source Foundation','Slack','StackOverflow','Others')
rownames(tab) <- c('#')
tab <- as.table(tab)
print(tab)

barp <- barplot(tab, ylim = c(0, 100), xlab = "Forums", ylab = "#", border = "black",  col=rainbow(5))
text(barp, tab + 1.5, labels = tab)

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)
