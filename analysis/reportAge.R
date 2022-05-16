# ------------------------------------------------------------------------------
# This script print out a pie chart with the age of participants.
#
# Usage:
#   Rscript reportAge.R
#     <output pdf file, e.g., reportAge.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# Load external packages
library('ggplot2')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript reportAge.R <output pdf file, e.g., reportAge.pdf>')
}

# Args
INPUT_FILE  <- '../data/survey.csv'
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

# Import data file
df <- pre_process_data(load_CSV(INPUT_FILE))
# Filter out the ones that have not used any QP language, as those have not
# completed the survey
df <- df[df$'used_qpl' == 'Yes', ]
# As the dataframe df is organized in long format we first need to group data
df         <- aggregate(x=. ~ timestamp + age, data=df, FUN=length)
# And then count number of entries per age
df$'count' <- 1
df         <- aggregate(x=count ~ age, data=df, FUN=sum)

# Set output file to a PDF
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=7, height=7)
# Add a cover page to the output file
plot_label('Age Report\nWhat is your age?')

# Create a barplot to visualize the data
p <- ggplot(df, aes(x='', y=count, fill=age)) + geom_bar(width=1, stat='identity', color='white')
# Create pie-chart plot
p <- p + coord_polar('y', start=0)
# Add text to each slice
p <- p + geom_text(aes(label=paste0(count)), position=position_stack(vjust=0.5), size=4)
# Create a customized blank theme
p <- p + theme(legend.position='top',
  legend.margin=margin(t=0, r=0, b=0, l=0),
  legend.box.margin=margin(t=0, r=0, b=-50, l=0),
  axis.line = element_blank(),
  axis.text = element_blank(),
  axis.ticks = element_blank(),
  axis.title = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.background = element_blank(),
  plot.background = element_blank()
)
# Rename legend
p <- p + labs(fill='Age')
# Use grey scale color palette
# p <- p + scale_fill_grey()

# Plot it
print(p)

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF

