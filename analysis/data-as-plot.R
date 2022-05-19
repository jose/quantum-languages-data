# ------------------------------------------------------------------------------
# This script plots factor data as barplot and pie plot.
#
# Usage:
#   Rscript data-as-plot.R
#     <output pdf file, e.g., data-as-plot.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# Load external packages
library('tidyr')
library('ggplot2')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript data-as-barplot.R <output pdf file, e.g., data-as-barplot.pdf>')
}

# Args
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

# Load data
df <- load_survey_data()

# Set output file to a PDF
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=10, height=10)
# Add a cover page to the output file
plot_label('Data as barplots')

make_bar_plot <- function(df, x) {
  # Basic barplot
  p <- ggplot(df, aes_string(x=x)) + geom_bar(width=0.90)
  # Change x axis label
  p <- p + scale_x_discrete(name='')
  # Change y axis label
  p <- p + scale_y_continuous(name='# Number of participants')
  # Remove legend's title and increase size of [x-y]axis labels
  p <- p + theme(legend.position='none',
    axis.text.x=element_text(size=13,  hjust=0.5, vjust=0.5),
    axis.text.y=element_text(size=13,  hjust=1.0, vjust=0.0),
    axis.title.x=element_text(size=15, hjust=0.5, vjust=0.0),
    axis.title.y=element_text(size=15, hjust=0.5, vjust=0.5)
  )
  # Add labels over bars
  p <- p + stat_count(geom='text', colour='black', size=5, aes(label=..count..), position=position_dodge(width=0.9), hjust=-0.15)
  # Make it horizontal
  p <- p + coord_flip()
  # Plot it
  print(p)
}

make_pie_plot <- function(df, fill) {
  # Create a barplot to visualize the data
  p <- ggplot(df, aes_string(x=factor(1), fill=fill)) + geom_bar(width=1)
  # Create pie-chart plot
  p <- p + coord_polar('y', start=0)
  # Add text to each slice
  p <- p + stat_count(geom='text', colour='black', size=5, aes(label=..count..), position=position_stack(vjust=0.5))
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
  # Remove legend's title
  p <- p + labs(fill='')
  # Use grey scale color palette
  # p <- p + scale_fill_grey()
  # Plot it
  print(p)
}

#
# Have you ever used any Quantum Programming Language?
#

plot_label('Have you ever used any Quantum Programming Language?')
agg         <- df
agg$'count' <- 1
agg         <- aggregate(x=count ~ timestamp + used_qpl, data=agg, FUN=sum)
make_bar_plot(agg, x='used_qpl')
remove(agg)

# Filter out the ones that have not used any QP language, as those have not
# completed the survey
df <- df[df$'used_qpl' == 'Yes', ]

#
# What is your age?
#

plot_label('What is your age?')
agg <- aggregate(x=. ~ timestamp + age, data=df, FUN=length)
make_bar_plot(agg, x='age')
make_pie_plot(agg, fill='age')
remove(agg)

#
# Where do you live? (Country)
#

plot_label('Where do you live? (Country)')
agg <- aggregate(x=. ~ timestamp + country, data=df, FUN=length)
make_bar_plot(agg, x='country')
make_pie_plot(agg, fill='country')
remove(agg)

#
# Which of the following describe you?
#

plot_label('Which of the following describe you?')
agg <- aggregate(x=. ~ timestamp + gender, data=df, FUN=length)
make_bar_plot(agg, x='gender')
make_pie_plot(agg, fill='gender')
remove(agg)

#
# How many years have you been coding?
#

plot_label('How many years have you been coding?')
agg <- aggregate(x=. ~ timestamp + years_coding, data=df, FUN=length)
make_bar_plot(agg, x='years_coding')
make_pie_plot(agg, fill='years_coding')
remove(agg)

#
# How many years have you coded professionally (as a part of your work)?
#

plot_label('How many years have you coded professionally (as a part\nof your work)?')
agg <- aggregate(x=. ~ timestamp + years_coded_professionally, data=df, FUN=length)
make_bar_plot(agg, x='years_coded_professionally')
make_pie_plot(agg, fill='years_coded_professionally')
remove(agg)

#
# How did you learn to code?
#

plot_label('How did you learn to code?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(learned_code, sep=';'))
agg <- aggregate(x=. ~ timestamp + learned_code, data=agg, FUN=length)
make_bar_plot(agg, x='learned_code')
make_pie_plot(agg, fill='learned_code')
remove(agg)

#
# What are the most used programming, scripting, and markup languages have you used?
#

plot_label('What are the most used programming, scripting, and markup\n languages have you used?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(used_programming_language, sep=';'))
agg <- aggregate(x=. ~ timestamp + used_programming_language, data=agg, FUN=length)
make_bar_plot(agg, x='used_programming_language')
make_pie_plot(agg, fill='used_programming_language')
remove(agg)

#
# What is your level of knowledge in Quantum Physics?
#

plot_label('What is your level of knowledge in Quantum Physics?')
agg <- aggregate(x=. ~ timestamp + level_quantum_physics, data=df, FUN=length)
make_bar_plot(agg, x='level_quantum_physics')
make_pie_plot(agg, fill='level_quantum_physics')
remove(agg)

#
# Where did you learn Quantum Physics?
#

plot_label('Where did you learn Quantum Physics?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(learned_quantum_physics, sep=';'))
# Replace open-answers with 'Other'
agg$'learned_quantum_physics'[agg$'learned_quantum_physics' %!in% c('Books', 'Online Course', 'Search Sites', 'University', 'Work')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + learned_quantum_physics, data=agg, FUN=length)
make_bar_plot(agg, x='learned_quantum_physics')
make_pie_plot(agg, fill='learned_quantum_physics')
remove(agg)

#
# Which of the following best describes the highest level of education that you have completed?
#

plot_label('Which of the following best describes the highest level\nof education that you have completed?')
agg <- aggregate(x=. ~ timestamp + level_education, data=df, FUN=length)
make_bar_plot(agg, x='level_education')
make_pie_plot(agg, fill='level_education')
remove(agg)

#
# If you have completed a major, what is the subject?
#

plot_label('If you have completed a major, what is the subject?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(major, sep=';'))
agg <- aggregate(x=. ~ timestamp + major, data=agg, FUN=length)
make_bar_plot(agg, x='major')
make_pie_plot(agg, fill='major')
remove(agg)

#
# Which of the following describes your current job?
#

plot_label('Which of the following describes your current job?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(job, sep=';'))
agg <- aggregate(x=. ~ timestamp + job, data=agg, FUN=length)
make_bar_plot(agg, x='job')
make_pie_plot(agg, fill='job')
remove(agg)

# TODO add other

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF

