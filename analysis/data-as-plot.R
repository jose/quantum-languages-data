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
  stop('USAGE: Rscript data-as-plot.R <output pdf file, e.g., data-as-plot.pdf>')
}

# Args
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

make_bar_plot <- function(df, x, reorder, lblPercentual, total, stat_count_size=9, axis_text_x=22) {
  # Basic barplot
  if (reorder) {
    p <- ggplot(df, aes(x=reorder(get(x),get(x),length)))
  } else {
    p <- ggplot(df, aes(x=get(x)))
  }
  p <- p + geom_bar(width=0.90)
  # Change x axis label
  p <- p + scale_x_discrete(name='', drop=FALSE)
  if (lblPercentual == TRUE) {
    # Change y axis label
    p <- p + scale_y_continuous(name='# participants',
              # labels=function(x) paste0(round(x/total*100,0), "%"),
              # breaks=seq(0, total, total*0.1),
              limits=c(0,total),
              expand=c(0,0))
    # Add labels over bars
    p <- p + stat_count(geom='text', colour='black', size=stat_count_size, aes(label=paste0(..count.., ' (', (round((..count..)/total*100, digit=1)), '%)')), position=position_dodge(width=0.9), hjust=-0.10)
  } else {
    # Change y axis label
    p <- p + scale_y_continuous(name='# Number of participants')
    # Add labels over bars
    p <- p + stat_count(geom='text', colour='black', size=stat_count_size, aes(label=..count..), position=position_dodge(width=0.9), hjust=-0.10)
  }
  # Remove legend's title and increase size of [x-y]axis labels
  p <- p + theme(legend.position='none',
    axis.text.x=element_text(size=axis_text_x,  hjust=0.5, vjust=0.5),
    axis.text.y=element_text(size=axis_text_x,  hjust=1.0, vjust=0.0),
    axis.title.x=element_text(size=24, hjust=0.5, vjust=0.0),
    axis.title.y=element_text(size=24, hjust=0.5, vjust=0.5)
  )
  # Make it horizontal
  p <- p + coord_flip()
  # Plot it
  print(p)
}

make_pie_plot <- function(df, fill, lblPercentual, lblSize) {
  # Create a barplot to visualize the data
  p <- ggplot(df, aes_string(x=factor(1), fill=fill)) + geom_bar(width=1)
  # Create pie-chart plot
  p <- p + coord_polar('y', start=0)
  # Add text to each slice
  if (lblPercentual == TRUE) {
    p <- p + stat_count(geom='text', colour='black', size=lblSize, aes(label=paste0(..count.., '\n(', format(round(..count../sum(..count..)*100, digit=1), nsmall=1), '%)')), position=position_stack(vjust=0.5))
  } else {
    p <- p + stat_count(geom='text', colour='black', size=lblSize, aes(label=..count..), position=position_stack(vjust=0.5))
  }
  # Create a customized blank theme
  p <- p + theme(legend.position='top',
    legend.text = element_text(size=30),
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
  # p <- p + labs(fill='')
  p <- p + scale_fill_discrete(name='', drop=FALSE)
  # Set number of rows to the legend
  if (length(unique(df[[fill]])) > 3 && fill != "level_quantum_physics") {
    p <- p + guides(fill=guide_legend(nrow=2, byrow=TRUE))
  }
  # Use grey scale color palette
  # p <- p + scale_fill_grey()
  # Plot it
  print(p)
}

# Set output file to a PDF
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=14, height=12)
# Add a cover page to the output file
plot_label('Data as pieplots and barplots')

# Load data
df <- load_survey_data(only_used_qpl=FALSE)

#
# Have you ever used any Quantum Programming Language?
#
plot_label('Have you ever used any Quantum Programming Language?')
agg         <- df
agg$'count' <- 1
agg         <- aggregate(x=count ~ timestamp + used_qpl, data=agg, FUN=sum)
make_pie_plot(agg, fill='used_qpl', TRUE, 15)
remove(agg)

# Load data
df <- load_survey_data()

#
# What is your age?
#
plot_label('What is your age?')
agg <- aggregate(x=country ~ timestamp + age, data=df, FUN=length)
make_bar_plot(agg, x='age', reorder=FALSE, TRUE, length(unique(agg$timestamp)))
remove(agg)

#
# Where do you live? (Country)
#
plot_label('Where do you live? (Country)')
agg <- aggregate(x=age ~ timestamp + country, data=df, FUN=length)
make_bar_plot(agg, x='country', reorder=TRUE, TRUE, length(unique(agg$timestamp)), stat_count_size=7, axis_text_x=20)
remove(agg)

#
# Which of the following describe you?
#
plot_label('Which of the following describe you?')
agg <- aggregate(x=country ~ timestamp + gender, data=df, FUN=length)
make_pie_plot(agg, fill='gender', TRUE, 12)
remove(agg)

#
# How many years have you been coding?
#
plot_label('How many years have you been coding?')
agg <- aggregate(x=country ~ timestamp + years_coding, data=df, FUN=length)
make_bar_plot(agg, x='years_coding', reorder=FALSE, TRUE, length(unique(agg$timestamp)))
remove(agg)

#
# How many years have you coded professionally (as a part of your work)?
#
plot_label('How many years have you coded professionally (as a part\nof your work)?')
agg <- aggregate(x=country ~ timestamp + years_coded_professionally, data=df, FUN=length)
make_bar_plot(agg, x='years_coded_professionally', reorder=FALSE, TRUE, length(unique(agg$timestamp)))
remove(agg)

#
# What is your level of knowledge in Quantum Physics?
#
plot_label('What is your level of knowledge in Quantum Physics?')
agg <- aggregate(x=country ~ timestamp + level_quantum_physics, data=df, FUN=length)
make_pie_plot(agg, fill='level_quantum_physics', TRUE, 15)
remove(agg)

#
# Which of the following best describes the highest level of education that you have completed?
#
plot_label('Which of the following best describes the highest level\nof education that you have completed?')
agg <- aggregate(x=country ~ timestamp + level_education, data=df, FUN=length)
pretty_level_education_names <- function(level_education_name) {
  return(gsub("Secondary school \\(.*\\)$", 'Secondary school', level_education_name))
}
agg$'level_education' <- sapply(agg$'level_education', pretty_level_education_names)
make_bar_plot(agg, x='level_education', reorder=TRUE, TRUE, length(unique(agg$timestamp)))
remove(agg)

#
# How many years have you been coding using Quantum Programming Languages?
#
plot_label('How many years have you been coding using Quantum \nProgramming Languages?')
agg <- aggregate(x=country ~ timestamp + years_coded_qpls, data=df, FUN=length)
make_bar_plot(agg, x='years_coded_qpls', reorder=FALSE, TRUE, length(unique(agg$timestamp)))
remove(agg)

#
# How many years have you coded professionally using Quantum Programming \nLanguages (as a part of your work)?
#
plot_label('How many years have you coded professionally using Quantum \nProgramming Languages (as a part of your work)?')
agg <- aggregate(x=country ~ timestamp + years_coded_professionally_qpls, data=df, FUN=length)
make_bar_plot(agg, x='years_coded_professionally_qpls', reorder=FALSE, TRUE, length(unique(agg$timestamp)))
remove(agg)

#
# Which of the following is your primary Quantum Programming Language / framework?
#
plot_label('Which of the following is your primary Quantum Programming \nLanguage / framework?')
agg <- aggregate(x=country ~ timestamp + primary_qpl, data=df, FUN=length)
make_bar_plot(agg, x='primary_qpl', reorder=TRUE, TRUE, length(unique(agg$timestamp)))
remove(agg)

#
# How do you use Quantum Programming Languages? 
#
plot_label('How do you use Quantum Programming Languages?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(how_use_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'how_use_qpl'[agg$'how_use_qpl' %!in% c('Use it for work', 'Use it for research', 'Like to learn')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + how_use_qpl, data=agg, FUN=length)
# (custom) sort
agg$'how_use_qpl' <- factor(agg$'how_use_qpl', levels=c(stringr::str_sort(setdiff(unique(agg$'how_use_qpl'), c('Other'))), 'Other'))
make_pie_plot(agg, fill='how_use_qpl', TRUE, 15)
remove(agg)

#
# Do you test your Quantum Programs?
#
plot_label('Do you test your Quantum Programs?')
agg <- aggregate(x=country ~ timestamp + do_test, data=df, FUN=length)
make_pie_plot(agg, fill='do_test', TRUE, 16)
remove(agg)

#
# How often do you test your Quantum Programs?
#
plot_label('How often do you test your Quantum Programs?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(how_often_test, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'how_often_test' != '', ]
# Replace open-answers with 'Other'
agg$'how_often_test'[agg$'how_often_test' %!in% c('Before go to production', 'Every day', 'Every time you change the code', '')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + how_often_test, data=agg, FUN=length)
# (custom) sort
agg$'how_often_test' <- factor(agg$'how_often_test', levels=c(stringr::str_sort(setdiff(unique(agg$'how_often_test'), c('Other'))), 'Other'))
make_pie_plot(agg, fill='how_often_test', TRUE, 15)
remove(agg)

#
# How do you test your Quantum Programs? 
#
plot_label('How do you test your Quantum Programs?')
agg <- aggregate(x=country ~ timestamp + how_test, data=df[df$'how_test' != '', ], FUN=length)
make_pie_plot(agg, fill='how_test', TRUE, 16)
remove(agg)

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF
