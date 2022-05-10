# ------------------------------------------------------------------------------
# This script print out a bar chart with the place where the participants 
# learned quantum physics.
#
# Usage:
#   Rscript reportLearnQuantumPhysics.R
#     <output pdf file, e.g., reportLearnQuantumPhysics.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript reportLearnQuantumPhysics.R <output pdf file, e.g., reportLearnQuantumPhysics.pdf>')
}

# Args
INPUT_FILE  <- '../data/survey.csv'
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

# Import data file
df <- load_CSV(INPUT_FILE)
# Filter out the ones that have not used any QP language, as those have not
# completed the survey
df <- df[df$'Have.you.ever.used.any.Quantum.Programming.Language.' == 'Yes', ]

# Set output file to a PDF
#OUTPUT_FILE <- append_path(report_path, 'reportLearnQuantumPhysics.pdf')
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=12, height=9)

# Plot report 
plot_label("Forum Report\nWhere did you learn Quantum Physics?")

countBooks <- nrow(df[df$'Where.did.you.learn.Quantum.Physics.' %in% 'Books', ]) 
countOnlineCourse <- nrow(df[df$'Where.did.you.learn.Quantum.Physics.' %in% 'Online Course', ]) 
countSearchSites <- nrow(df[df$'Where.did.you.learn.Quantum.Physics.' %in% 'Search Sites', ]) 
countUniversity <- nrow(df[df$'Where.did.you.learn.Quantum.Physics.' %in%  'University', ]) 
countWork <- nrow(df[strsplit(df$'Where.did.you.learn.Quantum.Physics.', ";") %in% 'Work', ]) 

tab <- matrix(c(countBooks, countOnlineCourse, countSearchSites, countUniversity, countWork, 1), ncol=6, byrow=TRUE)
colnames(tab) <- c('Books','Online Course','Search Sites','University', 'Work','Others')
rownames(tab) <- c('#')
tab <- as.table(tab)
df <- as.data.frame(tab)

theme_set(theme_gray(base_size = 16))
ggplot(df, aes(x=Var2, y=Freq)) + 
  geom_bar(stat = "identity") + 
  coord_flip() +
  labs(title="Where did you learn Quantum Physics?",
       x="", y= "Number of participants") +
  geom_text(aes(label = Freq), nudge_y= 2, color="Black")

# Close output file
dev.off()

# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF

