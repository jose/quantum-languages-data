# ------------------------------------------------------------------------------
# This script plots factor data as barplot and pie plot.
#
# Usage:
#   Rscript multiple-choice-questions-as-plot.R
#     <output pdf file, e.g., multiple-choice-questions-as-plot.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# Load external packages
library('tidyr')
library('ggplot2')
library('ComplexUpset')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript multiple-choice-questions-as-plot.R <output pdf file, e.g., multiple-choice-questions-as-plot.pdf>')
}

# Args
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

make_bar_plot <- function(df, x, lblPercentual, total) {
  # Basic barplot
  p <- ggplot(df, aes(x=get(x))) + geom_bar(width=0.90)
  # Change x axis label
  p <- p + scale_x_discrete(name='', drop=FALSE)
  if (lblPercentual == TRUE) {
    # Change y axis label
    p <- p + scale_y_continuous(name='% participants', labels = function(x) paste0(round(x/total*100,0), "%"), breaks = seq(0, total, total*0.1), expand = expansion(mult = c(0, .2)))
    # Add labels over bars
    p <- p + stat_count(geom='text', colour='black', size=6, aes(label=paste0(..count.., ' (', (round((..count..)/total*100, digit=1)), '%)')), position=position_dodge(width=0.9), hjust=-0.10)
  } else {
    # Change y axis label
    p <- p + scale_y_continuous(name='# Number of participants')
    # Add labels over bars
    p <- p + stat_count(geom='text', colour='black', size=6, aes(label=..count..), position=position_dodge(width=0.9), hjust=-0.10)
  }
  # Remove legend's title and increase size of [x-y]axis labels
  p <- p + theme(legend.position='none',
    axis.text.x=element_text(size=16,  hjust=0.5, vjust=0.5),
    axis.text.y=element_text(size=16,  hjust=1.0, vjust=0.0),
    axis.title.x=element_text(size=18, hjust=0.5, vjust=0.0),
    axis.title.y=element_text(size=18, hjust=0.5, vjust=0.5)
  )
  # Make it horizontal
  p <- p + coord_flip()
  # Plot it
  print(p)
}

make_dodge_plot <- function(df, x, fill, lblSize, lblPercentual, total) {
  # Basic dodgeplot
  p <- ggplot(df, aes(x=get(x), fill=get(fill)))
  p <- p + geom_bar(width=0.90, position=position_dodge(width=1))
  # Change x axis label
  p <- p + scale_x_discrete(name='', drop=FALSE)
  if (lblPercentual == TRUE) {
    # Change y axis label
    p <- p + scale_y_continuous(name='% participants', labels = function(x) paste0(round(x/total*100,0), "%"), breaks = seq(0, total, total*0.1), expand = expansion(mult = c(0, .2)))
    # Add labels over bars
    p <- p + stat_count(geom='text', colour='black', size=lblSize, aes(label=paste0(..count.., ' (', format(round(..count../total*100, digit=1), nsmall=1), '%)')), position=position_dodge(width=1.0), hjust=-0.10)
  } else {
    # Change y axis label
    p <- p + scale_y_continuous(name='# Number of participants')
    # Add labels over bars
    p <- p + stat_count(geom='text', colour='black', size=lblSize, aes(label=..count..), position=position_dodge(width=1.0), hjust=-0.10)
  }
  # Remove legend's title and increase size of [x-y]axis labels
  p <- p + theme(legend.position='top',
    legend.text = element_text(size=20),
    axis.text.x=element_text(size=24,  hjust=0.5, vjust=0.5),
    axis.text.y=element_text(size=24,  hjust=1.0, vjust=0.0),
    axis.title.x=element_text(size=28, hjust=0.5, vjust=0.0),
    axis.title.y=element_text(size=28, hjust=0.5, vjust=0.5)
  )
  # Change legend's title
  # p <- p + labs(fill='')
  p <- p + scale_fill_discrete(name='', drop=FALSE)
  # Make it horizontal
  p <- p + coord_flip()
  # Plot it
  print(p)
}

make_stack_plot <- function(df, x, fill, lblSize, axisTextSize, lblPercentual, labelsInBars, total) {
  # par(mar=c(5.1, 4.1, 4.1, 1000.1))
  # Basic stackplot
  p <- ggplot(df, aes(x=get(x), fill=get(fill)))
  p <- p + geom_bar(position=position_stack())
  # Change x axis label
  p <- p + scale_x_discrete(name='', expand=c(0,0), drop=FALSE)
  if (lblPercentual == TRUE) {
    # Change y axis label
    p <- p + scale_y_continuous(name='# participants', expand=c(0,0),
              # labels=function(x) paste0(x, '\n(', format(round(x/total*100, digit=1), nsmall=1), '%)'),
              breaks=seq(0, total, total*0.10), sec.axis=sec_axis(~ . / total * 100, name='% participants', breaks=seq(0,100,10), labels=function(x) paste0(x, '%')))
    # Add labels in bars
    if (labelsInBars == TRUE) {
      p <- p + stat_count(geom='text', colour='black', size=lblSize, aes(label=paste0(..count.., '\n(', format(round(..count../total*100, digit=1), nsmall=1), '%)')), position=position_stack(0.5))
    }
  } else {
    # Change y axis label
    p <- p + scale_y_continuous(name='# participants')
    # Add labels in bars
    if (labelsInBars == TRUE) {
      p <- p + stat_count(geom='text', colour='black', size=lblSize, aes(label=..count..), position=position_stack(0.5))
    }
  }
  # Remove legend's title and increase size of [x-y]axis labels
  p <- p + theme(legend.position='top',
    legend.text = element_text(size=21),
    axis.text.x=element_text(size=axisTextSize,  hjust=0.5, vjust=0.5),
    axis.text.y=element_text(size=axisTextSize,  hjust=1.0, vjust=0.0),
    axis.title.x=element_text(size=24, hjust=0.5, vjust=0.0),
    axis.title.y=element_text(size=24, hjust=0.5, vjust=0.5),
    plot.margin=margin(, 1.1, 0.5, , 'cm')
  )
  # Change legend's title
  # p <- p + labs(fill='')
  p <- p + scale_fill_discrete(name='', drop=FALSE)
  # Make it horizontal
  p <- p + coord_flip()
  # and reverse it
  # p <- p + guides(fill=guide_legend(reverse=TRUE))
  # Plot it
  print(p)
}

make_UpSetR_plot <- function(df, total, height_ratio=1, geom_point_size=2, intersection_y_size=18, min_size=1) {
  up_data <- upset_data(df, colnames(df))
  breaks <- sort(unique(up_data$with_sizes$exclusive_intersection_size), decreasing=TRUE)
  print(breaks)

  p <- upset(df, colnames(df),
    # specifies xlab's name
    name='',
    # Specifies how much space should be occupied by the set size panel
    width_ratio=0.225,
    # Setting height_ratio=1 will cause the intersection matrix and the intersection size to have an equal height
    height_ratio=height_ratio,
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
      + theme(axis.text=element_text(size=intersection_y_size),
              axis.title=element_text(size=20)
        )
    ),
    #
    min_size=min_size,
    set_sizes=(
      upset_set_size(
        geom=geom_bar(width=0.70),
        # filter_intersections=TRUE,
        position='right'
      )
      # Change y axis
      + scale_y_continuous(name='# participants', #labels=scales::percent_format(scale=100/total),
          limits=c(0,2*max(up_data$with_sizes$inclusive_intersection_size)), expand=c(0,0))
      # Add labels over bars
      + stat_count(geom='text', colour='black', size=6, aes(label=paste0(..count.., ' (', format(round(..count../total*100, digit=1), nsmall=1), '%)')), position=position_dodge(width=0.9), hjust=-0.10)
      + theme(axis.text=element_text(size=16),
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
          text=element_text(size=24)
        )
      )
    )
  )
  # Plot it
  print(p)
}

# Set output file to a PDF
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=20, height=12)
# Add a cover page to the output file
plot_label('Data as barplot (stacked) and UpSet plots')

# Load data
df <- load_survey_data()

#
# How did you learn to code?
#
plot_label('How did you learn to code?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(learned_code, sep=';'))
# Replace open-answers with 'Other'
agg$'learned_code'[agg$'learned_code' %!in% c('Books / Physical media', 'Coding Bootcamp', 'Colleague', 'Friend or family member', 'Online Courses or Certification', 'Online Forum', 'Other online resources (videos, blogs, etc)', 'School')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + learned_code, data=agg, FUN=length)
# (custom) sort
agg$'learned_code' <- factor(agg$'learned_code', levels=c(stringr::str_sort(setdiff(unique(agg$'learned_code'), c('Other'))), 'Other'))
make_bar_plot(agg, x='learned_code', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'learned_code'))]
agg <- dcast(agg, ... ~ learned_code, value.var='learned_code', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=1.5, geom_point_size=2, intersection_y_size=18, min_size=2)
remove(agg)

# dev.off(); embed_fonts_in_a_pdf(OUTPUT_FILE); stopifnot(TRUE == FALSE) # FIXME remove me

#
# What are the most used programming, scripting, and markup languages have you used?
#
plot_label('What are the most used programming, scripting, and markup\n languages have you used?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(used_programming_language, sep=';'))
# Replace open-answers with 'Other'
agg$'used_programming_language'[agg$'used_programming_language' %!in% c('Assembly', 'Bash', 'C', 'Classic Visual Basic', 'COBOL', 'C++', 'C#', 'Delphi/Object Pascal', 'Fortran', 'F#', 'Go', 'Groovy', 'Haskell', 'Java', 'JavaScrpit', 'Julia', 'Lisp', 'Matlab', 'ML', 'Objective-C', 'Pascal', 'Perl', 'pGCL', 'PHP', 'PowerShell', 'Prolog', 'Python', 'Ruby', 'SQL', 'Standard ML', 'Swift', 'Visual Basic', 'Visual C++')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + used_programming_language, data=agg, FUN=length)
# (custom) sort
agg$'used_programming_language' <- factor(agg$'used_programming_language', levels=c(stringr::str_sort(setdiff(unique(agg$'used_programming_language'), c('Other'))), 'Other'))
make_bar_plot(agg, x='used_programming_language', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'used_programming_language'))]
agg <- dcast(agg, ... ~ used_programming_language, value.var='used_programming_language', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=1.0, geom_point_size=2.0, intersection_y_size=18, min_size=2)
remove(agg)

#
# Where did you learn Quantum Physics?
#
plot_label('Where did you learn Quantum Physics?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(learned_quantum_physics, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'learned_quantum_physics' != '', ]
# Replace open-answers with 'Other'
agg$'learned_quantum_physics'[agg$'learned_quantum_physics' %!in% c('Books', 'Online Course', 'Search Sites', 'University', 'Work')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + learned_quantum_physics, data=agg, FUN=length)
# (custom) sort
agg$'learned_quantum_physics' <- factor(agg$'learned_quantum_physics', levels=c(stringr::str_sort(setdiff(unique(agg$'learned_quantum_physics'), c('Other'))), 'Other'))
make_bar_plot(agg, x='learned_quantum_physics', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'learned_quantum_physics'))]
agg <- dcast(agg, ... ~ learned_quantum_physics, value.var='learned_quantum_physics', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=0.40, geom_point_size=2, intersection_y_size=18) # total in here might be lower than 208, as this questions was not mandatory
remove(agg)

#
# If you have completed a major, what is the subject?
#
plot_label('If you have completed a major, what is the subject?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(major, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'major' != '', ]
# Replace open-answers with 'Other'
agg$'major'[agg$'major' %!in% c('Art / Humanities', 'Computer Science', 'Economics', 'Software Engineering', 'Math', 'Other Engineering', 'Physics', 'Social Sciences')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + major, data=agg, FUN=length)
# (custom) sort
agg$'major' <- factor(agg$'major', levels=c(stringr::str_sort(setdiff(unique(agg$'major'), c('Other'))), 'Other'))
make_bar_plot(agg, x='major', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'major'))]
agg <- dcast(agg, ... ~ major, value.var='major', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=0.35, geom_point_size=2, intersection_y_size=14) # total in here might be lower than 208, as this questions was not mandatory
remove(agg)

#
# Which of the following describes your current job?
#
plot_label('Which of the following describes your current job?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(job, sep=';'))
# Replace open-answers with 'Other'
agg$'job'[agg$'job' %!in% c('Academic researcher', 'Architect', 'Business Analyst', 'CIO / CEO / CTO', 'DBA (Database Administrator)', 'Data Analyst / Data Engineer/ Data Scientist', 'Developer Advocate', 'Developer / Programmer / Software Engineer', 'DevOps Engineer / Infrastructure Developer', 'Instructor / Teacher / Tutor', 'Marketing Manager', 'Product Manager', 'Project Manager', 'Scientist / Researcher', 'Student', 'Systems Analyst', 'Team Lead', 'Technical Support', 'Technical Writer', 'Tester / QA Engineer', 'UX / UI Designer')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + job, data=agg, FUN=length)
# (custom) sort
agg$'job' <- factor(agg$'job', levels=c(stringr::str_sort(setdiff(unique(agg$'job'), c('Other'))), 'Other'))
make_bar_plot(agg, x='job', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'job'))]
agg <- dcast(agg, ... ~ job, value.var='job', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=0.75, geom_point_size=2.50, intersection_y_size=14, min_size=2)
remove(agg)

#
# Where and how did you learn Quantum Programming Languages?
#
plot_label('Where and how did you learn Quantum Programming Languages?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(learned_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'learned_qpl'[agg$'learned_qpl' %!in% c('Books', 'Language documentation', 'University', 'Online Course', 'Online Forums', 'Search Sites', 'Work')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + learned_qpl, data=agg, FUN=length)
# (custom) sort
agg$'learned_qpl' <- factor(agg$'learned_qpl', levels=c(stringr::str_sort(setdiff(unique(agg$'learned_qpl'), c('Other'))), 'Other'))
make_bar_plot(agg, x='learned_qpl', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'learned_qpl'))]
agg <- dcast(agg, ... ~ learned_qpl, value.var='learned_qpl', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=1.0, geom_point_size=2, intersection_y_size=18, min_size=2)
remove(agg)

#
# What Quantum Programming Languages / frameworks have you been using and for how long?
#
plot_label('What Quantum Programming Languages / frameworks have you \nbeen using and for how long?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(used_qpls, sep=';'))
agg <- aggregate(x=country ~ timestamp + used_qpls + used_qpls_value, data=agg, FUN=length)
agg <- agg[agg$'used_qpls_value' != '', ]
# # (custom) sort
agg$'used_qpls' <- factor(agg$'used_qpls', levels=c(stringr::str_sort(setdiff(unique(agg$'used_qpls'), c('Other'))), 'Other'))
# make_dodge_plot(agg, 'used_qpls', 'used_qpls_value', 2.5, TRUE, length(unique(agg$timestamp)))
make_stack_plot(agg, 'used_qpls', 'used_qpls_value', 7, 18, TRUE, FALSE, length(unique(agg$timestamp)))
remove(agg)

#
# In terms of ease, rate your primary Quantum Programming Language.
#
plot_label('In terms of ease, rate your usage of Qiskit (Python).')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(rate_primary_qpl, sep=';'))
agg <- aggregate(x=country ~ timestamp + rate_primary_qpl + rate_primary_qpl_value + primary_qpl, data=agg, FUN=length)
agg <- agg[agg$'rate_primary_qpl_value' != '', ]
agg <- agg[agg$'primary_qpl' == 'Qiskit (Python)', ]
# make_dodge_plot(agg, 'rate_primary_qpl', 'rate_primary_qpl_value', 7, TRUE, length(unique(agg$timestamp)))
make_stack_plot(agg, 'rate_primary_qpl', 'rate_primary_qpl_value', 7, 24, TRUE, TRUE, length(unique(agg$timestamp)))
remove(agg)

#
# Which forums, e.g., to ask for help, search for examples, do you use? (if any)
#
plot_label('Which forums, e.g., to ask for help, search for examples, \ndo you use? (if any)')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(forum, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'forum' != '', ]
# Replace open-answers with 'Other'
agg$'forum'[agg$'forum' %!in% c('Devtalk', 'Quantum Open Source Foundation', 'Slack', 'StackOverflow')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + forum, data=agg, FUN=length)
# (custom) sort
agg$'forum' <- factor(agg$'forum', levels=c(stringr::str_sort(setdiff(unique(agg$'forum'), c('Other'))), 'Other'))
make_bar_plot(agg, x='forum', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'forum'))]
agg <- dcast(agg, ... ~ forum, value.var='forum', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=0.20, geom_point_size=2, intersection_y_size=15)
remove(agg)

#
# Which Quantum Programming Languages / frameworks would you like to work or try in the near future?
#
plot_label('Which Quantum Programming Languages / frameworks would you \nlike to work or try in the near future?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(qpl_future, sep=';'))
agg$'qpl_future' <- sapply(agg$'qpl_future', pretty_qpl)
agg$'qpl_future' <- factor(agg$'qpl_future', levels=c(stringr::str_sort(setdiff(unique(agg$'qpl_future'), c('Other'))), 'Other'))
agg <- aggregate(x=country ~ timestamp + qpl_future, data=agg, FUN=length)
make_bar_plot(agg, x='qpl_future', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'qpl_future'))]
agg <- dcast(agg, ... ~ qpl_future, value.var='qpl_future', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=1.25, geom_point_size=2.75, intersection_y_size=14, min_size=2)
remove(agg)

#
# Why would you like to work or try those languages / frameworks?
#
plot_label('Why would you like to work or try those languages / frameworks?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(why_like_try_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'why_like_try_qpl'[agg$'why_like_try_qpl' %!in% c('Heard about the language', 'Is part of a course about the language', 'Read an article about the language', 'Widely used', 'Other features')] <- 'Other'
agg <- aggregate(x=country ~ timestamp + why_like_try_qpl, data=agg, FUN=length)
# (custom) sort
agg$'why_like_try_qpl' <- factor(agg$'why_like_try_qpl', levels=c(stringr::str_sort(setdiff(unique(agg$'why_like_try_qpl'), c('Other'))), 'Other'))
make_bar_plot(agg, x='why_like_try_qpl', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'why_like_try_qpl'))]
agg <- dcast(agg, ... ~ why_like_try_qpl, value.var='why_like_try_qpl', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=0.25, geom_point_size=2, intersection_y_size=13)
remove(agg)

#
# What tools do you use to test your Quantum Programs?
#
plot_label('What tools do you use to test your Quantum Programs?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(tools_test, sep=';'))
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
agg <- aggregate(x=country ~ timestamp + tools_test, data=agg, FUN=length)
# Attempt to pretty print tools' names
pretty_testing_tools_names <- function(testing_tool_name) {
  return(gsub(" \\(.*\\)$", '', testing_tool_name))
}
agg$'tools_test'[agg$'tools_test' != 'Other'] <- sapply(agg$'tools_test'[agg$'tools_test' != 'Other'], pretty_testing_tools_names)
# (custom) sort
agg$'tools_test' <- factor(agg$'tools_test', levels=c(stringr::str_sort(setdiff(unique(agg$'tools_test'), c('Other'))), 'Other'))
make_bar_plot(agg, x='tools_test', TRUE, length(unique(agg$timestamp))) # FIXME remove me
total <- length(unique(agg$timestamp))
agg <- agg[, (names(agg) %in% c('timestamp', 'tools_test'))]
agg <- dcast(agg, ... ~ tools_test, value.var='tools_test', fun.aggregate=length)
agg <- agg[ , which(colnames(agg) %!in% c('timestamp')) ]
make_UpSetR_plot(agg, total, height_ratio=0.40, geom_point_size=2, intersection_y_size=12)
remove(agg)

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF
