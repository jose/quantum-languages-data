source('utils.R')

# Load external packages
library('ggplot2')

# Import data file
dfSurvey <- load_CSV(append_path(data_path, 'survey.csv'))

# Set output file to a PDF
OUTPUT_FILE <- append_path(report_path, 'reportLearnQuantumPhysics.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("Forum Report\nWhere did you learn Quantum Physics?")

#counts <- table(dfSurvey$Where.did.you.learn.Quantum.Physics.)
#print(counts)

tab <- matrix(c(99, 61, 37, 90, 40, 9), ncol=6, byrow=TRUE)
colnames(tab) <- c('Books','Online Course','Search Sites','University', 'Work','Others')
rownames(tab) <- c('#')
tab <- as.table(tab)
df <- as.data.frame(tab)

#barp <- barplot(tab, ylim = c(0, 10), xlim = c(0, 100), xlab = "", ylab = "", border = "black",  col=rainbow(6), horiz=TRUE, )
#text(barp, tab + 1.5, labels = tab)

ggplot(df, aes(x=Var2, y=Freq)) + 
  geom_bar(stat = "identity") + 
  coord_flip() +
  labs(title="Where did you learn Quantum Physics?",
       x="", y= "") +
  geom_text(aes(label = Freq), nudge_y= -3, color="white")

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

