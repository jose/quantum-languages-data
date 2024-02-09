# ------------------------------------------------------------------------------
# This script plots relation plot.
#
# Usage:
#   Rscript relation-plot.R
#     <output pdf file, e.g., relation-plot.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# Load external packages
library('tidyr')
library('ggplot2')
library('RColorBrewer')
library('ComplexUpset')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript relation-plot.R <output pdf file, e.g., relation-plot.pdf>')
}

# Args
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

# Load data
df <- load_survey_data()

# Load data
dfOpenQuestions <- load_CSV(OPEN_QUESTIONS_DATA_FILE)
# Filter out the ones that have not used any QP language, as those have not
# completed the survey
dfOpenQuestions <- dfOpenQuestions[dfOpenQuestions$'used_qpl' == 'Yes', ]

# Set output file to a PDF
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=16, height=12)
# Add a cover page to the output file
plot_label('Relations plots')

make_barplot <- function(agg, x, fill, position, legPosition, xLabel, legVertical, legNumRows=1, char_sep='\n', label_in_bar_size=6) {
  # Basic barplot
  p <- ggplot(agg, aes(x=get(x), fill=get(fill)))
  # Basic barplot
  p <- p + geom_bar(position=position)
  # Change x axis label
  # p <- p + scale_x_discrete(name=xLabel, expand=c(0,0))
  p <- p + scale_x_discrete(name='', expand=c(0,0), drop=FALSE)
  # Y axis
  if (position == 'fill') {
    # Add labels in the bars
    p <- p + stat_count(geom='text', colour='black', size=label_in_bar_size, aes(label=paste0(..count.., char_sep, '(', round(..count../tapply(..count.., ..x.., sum)[as.character(..x..)]*100, digit=1), '%)')), position=position_fill(0.5))
    # Change y axis label
    # p <- p + scale_y_continuous(name='', labels=scales::percent, expand=c(0,0))
    p <- p + scale_y_continuous(name='% participants', expand=c(0,0), labels=function(x) paste0(x*100, '%'), breaks=seq(0,1,0.1))
              # sec.axis=sec_axis(~ . * 100, name='# participants'))#, breaks=seq(0,1,0.1), labels=function(x) paste0(x, '%')))
  } else {
    # Add labels in the bars
    p <- p + stat_count(geom='text', colour='black', size=label_in_bar_size, aes(label=paste0(..count.., '\n(', round(..count../nrow(agg)*100, digit=1), '%)')), position=position_stack(0.5))
    # p <- p + stat_count(geom='text', colour='black', size=label_in_bar_size, aes(label=..count..), position=position_stack(0.5))
    # Change y axis label
    p <- p + scale_y_continuous(name='# participants', expand=c(0,0), #trans='sqrt',
              sec.axis=sec_axis(~ . / nrow(agg) * 100, name='% participants',  breaks=seq(0,100,10), labels=function(x) paste0(x, '%')))
  }
  # Change legend position and increase size of [x-y]axis labels
  # if (legVertical) {
  #   p <- p + theme(legend.position=legPosition,
  #     axis.text.x=element_text(size=16,  angle=45, hjust=1),
  #     axis.text.y=element_text(size=16,  hjust=1.0, vjust=0.0),
  #     axis.title.x=element_text(size=18, hjust=0.5, vjust=0.0),
  #     axis.title.y=element_text(size=18, hjust=0.5, vjust=0.5)
  #   )
  # } else {
    p <- p + theme(legend.position=legPosition,
      legend.text=element_text(size=17),
      axis.text.x=element_text(size=22,  hjust=0.75, vjust=0.5),
      axis.text.y=element_text(size=22,  hjust=1.0, vjust=0.0),
      axis.title.x=element_text(size=24, hjust=0.5, vjust=0.0),
      axis.title.y=element_text(size=24, hjust=0.5, vjust=0.5)
    )
  # }
  # Change legend title
  # p <- p + labs(fill='')
  p <- p + scale_fill_discrete(name='', drop=FALSE)
  # Set number of rows to the legend
  p <- p + guides(fill=guide_legend(nrow=legNumRows, byrow=TRUE))
  # Make it horizontal
  p <- p + coord_flip()
  # Number of data points in the plot
  if (position != 'fill') {
    p <- p + annotate(
      geom='text', x=Inf, y=Inf,
      label=paste('Total number of participants:', nrow(agg)),
      vjust=1, hjust=1, size=7
    )
  }
  # Plot it
  print(p)
}

make_UpSetR_plot <- function(df, fill_column, total, height_ratio=1, geom_point_size=2, intersection_y_size=18, legNumRows=1) {
  data_columns <- names(agg)
  data_columns <- data_columns[data_columns != fill_column]

  up_data <- upset_data(df, data_columns)
  breaks <- sort(unique(up_data$with_sizes$exclusive_intersection_size), decreasing=TRUE)
  print(breaks)

  p <- upset(df, data_columns,
    # specifies xlab's name
    name='',
    # Specifies how much space should be occupied by the set size panel
    width_ratio=0.225,
    # Setting height_ratio=1 will cause the intersection matrix and the intersection size to have an equal height
    height_ratio=height_ratio,
    # min_size=2,
    # Counts over bars & Total
    base_annotations=list(
      'Intersection size'=intersection_size(
        # text_colors=c(
        #   on_background='black', on_bar='white'
        # ),
        # text_mapping=aes(label=paste0(
        #   !!upset_text_percentage(),
        #   '\n(', !!get_size_mode('exclusive_intersection'), ')'
        #   )
        # ),
        # text=list(vjust=-0.50, size=4),
        mapping=aes(fill=get(fill_column)),
        counts=FALSE
      )
      # + annotate(
      #   geom='text', x=Inf, y=Inf,
      #   label=paste('Total number of participants:', nrow(df)),
      #   vjust=1, hjust=1, size=8
      # )
      + scale_y_continuous(name='# participants\n(% participants)',
          labels=function(x) paste0(x, ' (', format(round(x/total*100, digit=1), nsmall=1), '%)'),
          breaks=breaks)
          #, expand=expansion(mult=c(0, 0.2)))
      + theme(legend.position='top',
              legend.text=element_text(size=18),
              legend.margin=margin(t=0, r=0, b=0, l=0),
              legend.box.margin=margin(t=0, r=0, b=0, l=0),
              axis.text=element_text(size=intersection_y_size),
              axis.title=element_text(size=20)
        )
      # Change legend title
      + scale_fill_discrete(name='', drop=FALSE)
      # Set number of rows to the legend
      + guides(fill=guide_legend(nrow=legNumRows, byrow=TRUE))
    ),
    #
    set_sizes=(
      upset_set_size(
        geom=geom_bar(width=0.70, aes(fill=get(fill_column), x=group)),
        # filter_intersections=TRUE
        position='right'
      )
      # Change y axis
      + scale_y_continuous(name='# participants', #labels=scales::percent_format(scale=100/total),
          limits=c(0,2*max(up_data$with_sizes$inclusive_intersection_size)), expand=c(0,0))
      # Add labels over bars
      + stat_count(geom='text', colour='black', size=5, aes(label=paste0(..count.., ' (', format(round(..count../total*100, digit=1), nsmall=1), '%)')), position=position_dodge(width=0.9), hjust=-0.10)
      + theme(legend.position='none',
              axis.text=element_text(size=16),
              axis.title=element_text(size=18)
      )
    ),
    matrix=intersection_matrix(
      geom=geom_point(size=geom_point_size)
    ),
    # Theme
    stripes='white',
    themes=upset_modify_themes(
      list(
        'intersections_matrix'=theme(
          text=element_text(size=18)
        )
      )
    )
  )
  # Plot it
  print(p)
}

#
# Relation between Age and Educutaion Level of the participants
#
plot_label('Relation between Age and Education level of the participants')
agg <- aggregate(x=country ~ timestamp + age + level_education, data=df, FUN=length)
make_barplot(agg, 'age', 'level_education', 'fill', 'top', 'participant\'s age', FALSE, legNumRows=10, label_in_bar_size=5)
make_barplot(agg, 'age', 'level_education', 'stack', 'top', 'participant\'s age', FALSE, legNumRows=10, label_in_bar_size=5)
remove(agg)

#
# Relation between Primary QPL and Yes/No answer to if there are too many QPLs
#
plot_label('Relation between Primary QPL and \nYes/No answer to if there are too many QPLs')
total <- merge(df, dfOpenQuestions, by="timestamp")
agg <- aggregate(x=country ~ timestamp + primary_qpl + why_too_many_qpl_resp, data=total, FUN=length) 
agg <- agg[agg$'why_too_many_qpl_resp' != '', ]
make_barplot(agg, 'primary_qpl', 'why_too_many_qpl_resp', 'fill', 'top', 'quantum programming languages', FALSE, char_sep=' ', label_in_bar_size=7)
make_barplot(agg, 'primary_qpl', 'why_too_many_qpl_resp', 'stack', 'top', 'quantum programming languages', FALSE, char_sep=' ', label_in_bar_size=7)
remove(agg)

#
# Relation between Primary QPL and Yes/No answer to if another QPL is needed
#
plot_label('Relation between Primary QPL \nand Yes/No answer to if another QPL is needed')
total <- merge(df, dfOpenQuestions, by="timestamp")
agg <- aggregate(x=country ~ timestamp + primary_qpl + why_need_another_qpl_resp, data=total, FUN=length) 
agg <- agg[agg$'why_need_another_qpl_resp' != '', ]
make_barplot(agg, 'primary_qpl', 'why_need_another_qpl_resp', 'fill', 'top', 'quantum programming languages', FALSE, char_sep=' ', label_in_bar_size=7)
make_barplot(agg, 'primary_qpl', 'why_need_another_qpl_resp', 'stack', 'top', 'quantum programming languages', FALSE, char_sep=' ', label_in_bar_size=7)
remove(agg)

#
# Relation between Primary QPL and forum used
#
plot_label('Relation between Primary QPL and forum used')
agg <- aggregate(x=country ~ timestamp + primary_qpl + forum, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(forum, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'forum' != '', ]
# Replace open-answers with 'Other'
agg$'forum'[agg$'forum' %!in% c('Devtalk', 'Quantum Open Source Foundation', 'Slack', 'StackOverflow')] <- 'Other'
agg$'forum' <- factor(agg$'forum', levels=c(stringr::str_sort(setdiff(unique(agg$'forum'), c('Other'))), 'Other'))
make_barplot(agg, 'primary_qpl', 'forum', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=2, label_in_bar_size=5)
make_barplot(agg, 'primary_qpl', 'forum', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=2, label_in_bar_size=5)
remove(agg)
# FIXME 284 vs 208 ???

#
# Relation between primary QPL and knowledge of quantum physics
#
plot_label('Relation between primary QPL and knowledge of quantum physics')
agg <- aggregate(x=country ~ timestamp + primary_qpl + level_quantum_physics, data=df, FUN=length)
make_barplot(agg, 'primary_qpl', 'level_quantum_physics', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=1, label_in_bar_size=5)
make_barplot(agg, 'primary_qpl', 'level_quantum_physics', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=1, label_in_bar_size=5)
remove(agg)

#
# Relation between primary QPL and the education level of the participant
#
plot_label('Relation between primary QPL and the \neducation level of the participant')
agg <- aggregate(x=country ~ timestamp + primary_qpl + level_education, data=df, FUN=length)
make_barplot(agg, 'primary_qpl', 'level_education', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=10, label_in_bar_size=4)
make_barplot(agg, 'primary_qpl', 'level_education', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=10, label_in_bar_size=4)
remove(agg)

#
# Relation between primary QPL and the country of the participant
#
plot_label('Relation between primary QPL and the \ncountry of the participant')
agg <- aggregate(x=age ~ timestamp + primary_qpl + country, data=df, FUN=length)
make_barplot(agg, 'primary_qpl', 'country', 'fill', 'right', 'quantum programming languages', FALSE, legNumRows=10)
make_barplot(agg, 'primary_qpl', 'country', 'stack', 'right', 'quantum programming languages', FALSE, legNumRows=10)
remove(agg)

#
# Relation between primary QPL and the participant major
#
plot_label('Relation between primary QPL and the participant major')
agg <- aggregate(x=country ~ timestamp + primary_qpl + major, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(major, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'major' != '', ]
# Replace open-answers with 'Other'
agg$'major'[agg$'major' %!in% c('Art / Humanities', 'Computer Science', 'Economics', 'Software Engineering', 'Math', 'Other Engineering', 'Physics', 'Social Sciences')] <- 'Other'
agg$'major' <- factor(agg$'major', levels=c(stringr::str_sort(setdiff(unique(agg$'major'), c('Other'))), 'Other'))
make_barplot(agg, 'primary_qpl', 'major', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=3, label_in_bar_size=5)
make_barplot(agg, 'primary_qpl', 'major', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=3, label_in_bar_size=5)
remove(agg)
# FIXME 254 vs 208 ???

#
# Relation between primary QPL and how they learned
#
plot_label('Relation between primary QPL and how they learned')
agg <- aggregate(x=country ~ timestamp + primary_qpl + learned_qpl, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(learned_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'learned_qpl'[agg$'learned_qpl' %!in% c('Books', 'Language documentation', 'University', 'Online Course', 'Online Forums', 'Search Sites', 'Work')] <- 'Other'
agg$'learned_qpl' <- factor(agg$'learned_qpl', levels=c(stringr::str_sort(setdiff(unique(agg$'learned_qpl'), c('Other'))), 'Other'))
make_barplot(agg, 'primary_qpl', 'learned_qpl', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=2, label_in_bar_size=5)
make_barplot(agg, 'primary_qpl', 'learned_qpl', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=2, label_in_bar_size=5)
remove(agg)
# FIXME 546 vs 208 ???

#
# Relation between primary QPL and experience with QPLs
#
plot_label('Relation between primary QPL and experience with QPLs')
agg <- aggregate(x=country ~ timestamp + primary_qpl + years_coded_qpls, data=df, FUN=length)
tab <- table(agg$years_coded_qpls, agg$primary_qpl)
make_barplot(agg, 'primary_qpl', 'years_coded_qpls', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=3, label_in_bar_size=5)
make_barplot(agg, 'primary_qpl', 'years_coded_qpls', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=3, label_in_bar_size=5)
remove(agg)

#
# Relation between primary QPL and professional experience with QPLs
#
plot_label('Relation between primary QPL and professional experience with QPLs')
agg <- aggregate(x=country ~ timestamp + primary_qpl + years_coded_professionally_qpls, data=df, FUN=length)
tab <- table(agg$years_coded_professionally_qpls, agg$primary_qpl)
make_barplot(agg, 'primary_qpl', 'years_coded_professionally_qpls', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=4, label_in_bar_size=5)
make_barplot(agg, 'primary_qpl', 'years_coded_professionally_qpls', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=4, label_in_bar_size=5)
remove(agg)

#
# Relation between QPL they would like to work or try in the near future and why
#
plot_label('Relation between QPL they would like to work or \ntry in the near future and why')
agg <- aggregate(x=country ~ timestamp + qpl_future + why_like_try_qpl, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(qpl_future, sep=';'))
agg$'qpl_future' <- sapply(agg$'qpl_future', pretty_qpl)
agg$'qpl_future' <- factor(agg$'qpl_future', levels=c(stringr::str_sort(setdiff(unique(agg$'qpl_future'), c('Other'))), 'Other'))
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(why_like_try_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'why_like_try_qpl'[agg$'why_like_try_qpl' %!in% c('Heard about the language', 'Is part of a course about the language', 'Read an article about the language', 'Widely used', 'Other features')] <- 'Other'
agg$'why_like_try_qpl' <- factor(agg$'why_like_try_qpl', levels=c(stringr::str_sort(setdiff(unique(agg$'why_like_try_qpl'), c('Other'))), 'Other'))
make_barplot(agg, 'qpl_future', 'why_like_try_qpl', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=3, char_sep=' ', label_in_bar_size=5)
make_barplot(agg, 'qpl_future', 'why_like_try_qpl', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=3, char_sep=' ', label_in_bar_size=5)

# As upset plot
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'qpl_future', 'why_like_try_qpl'))]
agg <- dcast(agg, ... ~ qpl_future, value.var='qpl_future', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, 'why_like_try_qpl', total, height_ratio=1.5, geom_point_size=2, intersection_y_size=14, legNumRows=2)
# FIXME 298 vs 208 ???

remove(agg)
remove(total)

#
# Relation between primary QPL and for what they are used
#
plot_label('Relation between primary QPL and for what they are used')
agg <- aggregate(x=country ~ timestamp + primary_qpl + how_use_qpl, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(how_use_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'how_use_qpl'[agg$'how_use_qpl' %!in% c('Use it for work', 'Use it for research', 'Like to learn')] <- 'Other'
agg$'how_use_qpl' <- factor(agg$'how_use_qpl', levels=c(stringr::str_sort(setdiff(unique(agg$'how_use_qpl'), c('Other'))), 'Other'))
make_barplot(agg, 'primary_qpl', 'how_use_qpl', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=1, char_sep=' ')
make_barplot(agg, 'primary_qpl', 'how_use_qpl', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=1, char_sep=' ')
remove(agg)

#
# Relation between primary QPL and if the participants test their quantum program
#
plot_label('Relation between primary QPL and if the participants test \ntheir quantum program')
agg <- aggregate(x=country ~ timestamp + primary_qpl + do_test, data=df, FUN=length)
# Remove empty answers (not answered)
agg <- agg[agg$'do_test' != '', ]
make_barplot(agg, 'primary_qpl', 'do_test', 'fill', 'top', 'quantum programming languages', FALSE, char_sep=' ', label_in_bar_size=7)
make_barplot(agg, 'primary_qpl', 'do_test', 'stack', 'top', 'quantum programming languages', FALSE, char_sep=' ', label_in_bar_size=7)
remove(agg)

#
# Relation between primary QPL and how the participants test
#
plot_label('Relation between primary QPL and how the participants test')
agg <- aggregate(x=country ~ timestamp + primary_qpl + how_test, data=df, FUN=length)
# Remove empty answers (not answered)
agg <- agg[agg$'how_test' != '', ]
make_barplot(agg, 'primary_qpl', 'how_test', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=1, char_sep=' ', label_in_bar_size=7)
make_barplot(agg, 'primary_qpl', 'how_test', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=1, char_sep=' ', label_in_bar_size=7)
remove(agg)

#
# Relation between primary QPL and tool used for test
#
plot_label('Relation between Primary QPL and tool used for test')
agg <- aggregate(x=country ~ timestamp + primary_qpl + tools_test, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(tools_test, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'tools_test' != '', ]
# Replace open-answers with 'Other'
agg$'tools_test'[agg$'tools_test' %!in% c(
  'Cirq Simulator and Testing - cirq.testing (https://quantumai.google/cirq)',
  'Forest using pytest (https://github.com/rigetti/forest-software)',
  'MTQC - Mutation Testing for Quantum Computing (https://javpelle.github.io/MTQC/)',
  'Muskit: A Mutation Analysis Tool for Quantum Software Testing (https://ieeexplore.ieee.org/document/9678563)',
  'ProjectQ Simulator (https://arxiv.org/abs/1612.08091)',
  'QDiff - Differential Testing of Quantum Software Stacks (https://ieeexplore.ieee.org/abstract/document/9678792)',
  'QDK - xUnit (https://azure.microsoft.com/en-us/resources/development-kit/quantum-computing/)',
  'Qiskit - QASM Simulator (https://qiskit.org/)',
  'QuanFuzz - Fuzz Testing of Quantum Program (https://arxiv.org/abs/1810.10310)',
  'Quito - A Coverage-Guided Test Generator for Quantum Programs (https://ieeexplore.ieee.org/abstract/document/9678798)',
  'Straberry Fields using pytest (https://strawberryfields.ai/)')] <- 'Other'
pretty_names_remove_parentheses <- function(string) {
  return(gsub(" \\(.*\\)$", '', string))
}
agg$'tools_test'[agg$'tools_test' != 'Other'] <- sapply(agg$'tools_test'[agg$'tools_test' != 'Other'], pretty_names_remove_parentheses)
make_barplot(agg, 'primary_qpl', 'tools_test', 'fill', 'top', 'quantum programming languages', FALSE, legNumRows=10, label_in_bar_size=4)
make_barplot(agg, 'primary_qpl', 'tools_test', 'stack', 'top', 'quantum programming languages', FALSE, legNumRows=10, label_in_bar_size=4)
remove(agg)
# FIXME 215 vs 208 ???

#
# Relation between the work field of the participants and the reason they use the QPLs
#
plot_label('Relation between the work field of the participants and \nthe reason they use the QPLs')
agg <- aggregate(x=country ~ timestamp + major + how_use_qpl, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(how_use_qpl, sep=';'))
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(major, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'major' != '', ]
# Replace open-answers with 'Other'
agg$'how_use_qpl'[agg$'how_use_qpl' %!in% c('Use it for work', 'Use it for research', 'Like to learn')] <- 'Other'
agg$'how_use_qpl' <- factor(agg$'how_use_qpl', levels=c(stringr::str_sort(setdiff(unique(agg$'how_use_qpl'), c('Other'))), 'Other'))
# Replace open-answers with 'Other'
agg$'major'[agg$'major' %!in% c('Art / Humanities', 'Computer Science', 'Economics', 'Software Engineering', 'Math', 'Other Engineering', 'Physics', 'Social Sciences')] <- 'Other'
agg$'major' <- factor(agg$'major', levels=c(stringr::str_sort(setdiff(unique(agg$'major'), c('Other'))), 'Other'))
make_barplot(agg, 'major', 'how_use_qpl', 'fill', 'top', 'participant\'s major', FALSE, legNumRows=1)
make_barplot(agg, 'major', 'how_use_qpl', 'stack', 'top', 'participant\'s major', FALSE, legNumRows=1)
# FIXME 254 vs 208 ???

total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'major', 'how_use_qpl'))]
agg <- dcast(agg, ... ~ major, value.var='major', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, 'how_use_qpl', total, height_ratio=0.3, geom_point_size=2, intersection_y_size=14)

remove(agg)
remove(total)

#
# Relation between the current job of the participants and the reason they are use the QPLs
#
plot_label('Relation between the current job of the participants and \nthe reason they are use the QPLs')
agg <- aggregate(x=country ~ timestamp + job + how_use_qpl, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(how_use_qpl, sep=';'))
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(job, sep=';'))
# Replace open-answers with 'Other'
agg$'how_use_qpl'[agg$'how_use_qpl' %!in% c('Use it for work', 'Use it for research', 'Like to learn')] <- 'Other'
agg$'how_use_qpl' <- factor(agg$'how_use_qpl', levels=c(stringr::str_sort(setdiff(unique(agg$'how_use_qpl'), c('Other'))), 'Other'))
# Replace open-answers with 'Other'
agg$'job'[agg$'job' %!in% c('Academic researcher', 'Architect', 'Business Analyst', 'CIO / CEO / CTO',
  'DBA (Database Administrator)', 'Data Analyst / Data Engineer/ Data Scientist', 'Developer Advocate',
  'Developer / Programmer / Software Engineer', 'DevOps Engineer / Infrastructure Developer',
  'Instructor / Teacher / Tutor', 'Marketing Manager', 'Product Manager', 'Project Manager', 'Scientist / Researcher',
  'Student', 'Systems Analyst', 'Team Lead', 'Technical Support', 'Technical Writer', 'Tester / QA Engineer',
  'UX / UI Designer')] <- 'Other'
agg$'job' <- factor(agg$'job', levels=c(stringr::str_sort(setdiff(unique(agg$'job'), c('Other'))), 'Other'))
make_barplot(agg, 'job', 'how_use_qpl', 'fill', 'top', 'participant\'s current job', TRUE, legNumRows=1, label_in_bar_size=4)
make_barplot(agg, 'job', 'how_use_qpl', 'stack', 'top', 'participant\'s current job', TRUE, legNumRows=1, label_in_bar_size=4)
# FIXME 430 vs 208 ???

total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'job', 'how_use_qpl'))]
agg <- dcast(agg, ... ~ job, value.var='job', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, 'how_use_qpl', total, height_ratio=1, geom_point_size=2, intersection_y_size=14)

remove(agg)
remove(total)

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF
