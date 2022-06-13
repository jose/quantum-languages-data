# ------------------------------------------------------------------------------
# This script print out a pie chart for the Yes/No Open questions.
#
# Usage:
#   Rscript reportOpenQuestions.R
#     <output pdf file, e.g., reportOpenQuestions.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# Load external packages
library('ggplot2')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript reportOpenQuestions.R <output pdf file, e.g., reportOpenQuestions.pdf>')
}

# Args
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

# Load data
df <- load_CSV(OPEN_QUESTIONS_DATA_FILE)
# Filter out the ones that have not used any QP language, as those have not
# completed the survey
df <- df[df$'used_qpl' == 'Yes', ]
# As the dataframe df is organized in long format we first need to group data
df <- aggregate(x=. ~ timestamp + why_too_many_qpl_resp + why_need_another_qpl_resp, data=df, FUN=length)

# Set output file to a PDF
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=14, height=12)

make_pie_plot <- function(df, fill, lblPercentual) {
  # Create a barplot to visualize the data
  p <- ggplot(df, aes_string(x=factor(1), fill=fill)) + geom_bar(width=1)
  # Create pie-chart plot
  p <- p + coord_polar('y', start=0)
  # Add text to each slice
  if(lblPercentual == TRUE){
    p <- p + stat_count(geom='text', colour='black', size=6, aes(label=paste((round((..count..)/sum(..count..)*100, digit=2)), "%", sep="")), position=position_stack(vjust=0.5))
  } else {   
    p <- p + stat_count(geom='text', colour='black', size=6, aes(label=..count..), position=position_stack(vjust=0.5))
  }
  # Create a customized blank theme
  p <- p + theme(legend.position='top',
    legend.text = element_text(size=16),
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
  # Remove legend's title
  p <- p + labs(fill='')
  # Use grey scale color palette
  # p <- p + scale_fill_grey()
  # Plot it
  print(p)
}

#
# In your opinion, do you think there are too many or too few Quantum Programming Languages? Why?
#
plot_label('In your opinion, do you think there are too many or too few \nQuantum Programming Languages? Why?')
agg <- aggregate(x=. ~ timestamp + why_too_many_qpl_resp, data=df, FUN=length)
agg$'why_too_many_qpl_resp'[agg$'why_too_many_qpl_resp' %!in% c('Yes', 'No')] <- 'No Answer'
make_pie_plot(agg, fill='why_too_many_qpl_resp', TRUE)
remove(agg)

#
# In your opinion, do you think that quantum developers would need yet another Quantum Programming Languages in the near future? Why?
#
plot_label('In your opinion, do you think that quantum developers would need yet another \nQuantum Programming Languages in the near future? Why?')
agg <- aggregate(x=. ~ timestamp + why_need_another_qpl_resp, data=df, FUN=length)
agg$'why_need_another_qpl_resp'[agg$'why_need_another_qpl_resp' %!in% c('Yes', 'No')] <- 'No Answer'
make_pie_plot(agg, fill='why_need_another_qpl_resp', TRUE)
remove(agg)

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF

