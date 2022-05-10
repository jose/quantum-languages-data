# ------------------------------------------------------------------------------
# This script print out a bar chart with why the participants wants to try these
# QPL/Framework
#
# Usage:
#   Rscript reportWhyTryeQPLFuture.R
#     <output pdf file, e.g., reportWhyTryQPLFuture.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript reportForums.R <output pdf file, e.g., reportWhyTryQPLFuture.pdf>')
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
#OUTPUT_FILE <- append_path(report_path, 'reportWhyTryQPLFuture.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("Why the participants wants to try QPLs/Framework in the near future Report\nWhy would you like to work or try those languages / frameworks?")

countHeardAbout <- nrow(df[df$'Why.would.you.like.to.work.or.try.those.languages...frameworks.' %in% 'Heard about the language', ]) 
countPartOfCourse <- nrow(df[df$'Why.would.you.like.to.work.or.try.those.languages...frameworks.' %in% 'Is part of a course about the language', ])
countReadArticle <- nrow(df[df$'Why.would.you.like.to.work.or.try.those.languages...frameworks.' %in% 'Read an article about the language', ]) 
countWidelyUsed <- nrow(df[df$'Why.would.you.like.to.work.or.try.those.languages...frameworks.' %in% 'Widely used', ]) 
countOtherFeatures <- nrow(df[df$'Why.would.you.like.to.work.or.try.those.languages...frameworks.' %in% 'Other features', ]) 

tab <- matrix(c(countHeardAbout, countPartOfCourse, countReadArticle, countWidelyUsed, countOtherFeatures, 10), ncol=6, byrow=TRUE)
colnames(tab) <- c('Heard about \nthe language','Is part of a course \nabout the language','Read an article \nabout the language','Widely used','Other features', 'Other')
rownames(tab) <- c('#')
tab <- as.table(tab)
df <- as.data.frame(tab)

theme_set(theme_gray(base_size = 16))
ggplot(df, aes(x=Var2, y=Freq)) + 
  geom_bar(stat = "identity") + 
  coord_flip() +
  labs(title="", x="", y= "Number of participants") +
  geom_text(aes(label = Freq), nudge_y= 1, color="Black")

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF

