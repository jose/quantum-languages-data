source('utils.R')

# Load external packages
library('ggplot2')

# Import data file
dfSurvey <- load_CSV(append_path(data_path, 'survey.csv'))

# Set output file to a PDF
OUTPUT_FILE <- append_path(report_path, 'reportForums.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("Forum Report\nWhich forums, e.g., to ask for help, search for examples, do you use? (if any)")

#counts <- table(dfSurvey$Which.forums..e.g...to.ask.for.help..search.for.examples..do.you.use...if.any.)

tab <- matrix(c(3, 28, 53, 86, 22), ncol=5, byrow=TRUE)
colnames(tab) <- c('Devtalk','Quantum Open Source Foundation','Slack','StackOverflow','Others')
rownames(tab) <- c('#')
tab <- as.table(tab)
df <- as.data.frame(tab)
#print(df)

#barp <- barplot(tab, ylim = c(0, 100), xlab = "Forums", ylab = "#", border = "black",  col=rainbow(5))
#text(barp, tab + 1.5, labels = tab)
ggplot(df, aes(x=Var2, y=Freq)) + 
  geom_bar(stat = "identity") + 
  labs(title="Which forums, e.g., to ask for help, search for examples, do you use? (if any)",
       x="", y= "") +
  geom_text(aes(label = Freq), nudge_y= 3, color="black")

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

