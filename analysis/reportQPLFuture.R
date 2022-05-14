# ------------------------------------------------------------------------------
# This script print out a bar chart with the QPL/Framework that the participants
# would like to use or try in the near future.
#
# Usage:
#   Rscript reportQPLFuture.R
#     <output pdf file, e.g., reportQPLFuture.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript reportForums.R <output pdf file, e.g., reportQPLFuture.pdf>')
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
#OUTPUT_FILE <- append_path(report_path, 'reportQPLFuture.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("QPL/Framework most like to be used in the future Report\nWhich Quantum Programming Languages / frameworks would you like to work or try in the near future?")

dfQplFuture <- df$'Which.Quantum.Programming.Languages...frameworks.would.you.like.to.work.or.try.in.the.near.future..'

countBlackbird <- nrow(df[grep('Blackbird', dfQplFuture), ])  
countQiskit <- nrow(df[grep('Qiskit', dfQplFuture), ]) 
countCirq <- nrow(df[grep('Cirq', dfQplFuture), ]) 
countCove <- nrow(df[grep('Cove', dfQplFuture), ]) 
countcQASM <- nrow(df[grep('cQASM', dfQplFuture), ]) 

tab <- matrix(c(countBlackbird, countQiskit, countCirq, countCove, countcQASM), ncol=5, byrow=TRUE)
colnames(tab) <- c('Blackbird','Qiskit','Cirq','Cove','cQASM')
rownames(tab) <- c('#')
tab <- as.table(tab)
df <- as.data.frame(tab)

theme_set(theme_gray(base_size = 16))
ggplot(df, aes(x=Var2, y=Freq)) + 
  geom_bar(stat = "identity") + 
  coord_flip() +
  labs(title="", x="", y= "Number of participants") +
  geom_text(aes(label = Freq), nudge_y= 0.5, color="black")

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF

