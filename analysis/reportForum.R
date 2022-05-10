# ------------------------------------------------------------------------------
# This script print out a bar chart with the forums used by the participants.
#
# Usage:
#   Rscript reportForums.R
#     <output pdf file, e.g., reportForums.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript reportForums.R <output pdf file, e.g., reportForums.pdf>')
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
#OUTPUT_FILE <- append_path(report_path, 'reportForums.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("Forum Report\nWhich forums, e.g., to ask for help, search for examples, do you use? (if any)")

countDevtalk <- nrow(df[df$'Which.forums..e.g...to.ask.for.help..search.for.examples..do.you.use...if.any.' %in% 'Devtalk', ]) 
countQOSF <- nrow(df[df$'Which.forums..e.g...to.ask.for.help..search.for.examples..do.you.use...if.any.' %in% 'Quantum Open Source Foundation', ]) 
countSlack <- nrow(df[df$'Which.forums..e.g...to.ask.for.help..search.for.examples..do.you.use...if.any.' %in% 'Slack', ]) 
countStackOverflow <- nrow(df[df$'Which.forums..e.g...to.ask.for.help..search.for.examples..do.you.use...if.any.' %in%  'StackOverflow', ]) 

tab <- matrix(c(countDevtalk, countQOSF, countSlack, countStackOverflow, 10), ncol=5, byrow=TRUE)
colnames(tab) <- c('Devtalk','Quantum Open Source Foundation','Slack','StackOverflow','Others')
rownames(tab) <- c('#')
tab <- as.table(tab)
df <- as.data.frame(tab)

theme_set(theme_gray(base_size = 16))
ggplot(df, aes(x=Var2, y=Freq)) + 
  geom_bar(stat = "identity") + 
  labs(title="Which forums, e.g., to ask for help, search for examples, do you use? (if any)",
       x="", y= "Number of participants") +
  geom_text(aes(label = Freq), nudge_y= 3, color="black")

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF

