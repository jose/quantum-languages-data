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

# Filter out the ones that have not used any QP language, as those have not
# completed the survey
df <- df[df$'used_qpl' == 'Yes', ]

# Load data
dfOpenQuestions <- load_CSV(OPEN_QUESTIONS_DATA_FILE)
# Filter out the ones that have not used any QP language, as those have not
# completed the survey
dfOpenQuestions <- dfOpenQuestions[dfOpenQuestions$'used_qpl' == 'Yes', ]

# Set output file to a PDF
unlink(OUTPUT_FILE)
pdf(file=OUTPUT_FILE, family='Helvetica', width=14, height=12)
# Add a cover page to the output file
plot_label('Relations plots')

make_barplot <- function(agg, x, fill, position, legPosition, xLabel, legend) {
  # Basic barplot
  p <- ggplot(agg, aes(x=get(x), fill=get(fill)))
  # Basic barplot
  p <- p + geom_bar(position=position) 
  if(position=='fill'){
    # Add labels in the bars
    p <- p + stat_count(geom='text', colour='black', size=4, aes(label=paste((round((..count..)/tapply(..count.., ..x.., sum)[as.character(..x..)]*100, digit=2)), "%", sep="")), position=position_fill(.5))
    # Change y axis label
    p <- p + scale_y_continuous(name='', labels = scales::percent)
  } else {
    # Add labels in the bars
    p <- p + stat_count(geom='text', colour='black', size=4, aes(label=..count..), position=position_stack(.5))
    # Change y axis label
    p <- p + scale_y_continuous(name='# of participants')
  }
  # Change legend position
  p <- p + theme(legend.position=legPosition) 
  # Change legend title
  p <- p + labs(fill=legend)
  # Change x axis label
  p <- p + scale_x_discrete(name=xLabel)
  # Plot it
  print(p)
}

make_barplot_proptable <- function(tab, xlab) {
  # Barplot with prop table
  p <- barplot(prop.table(tab, 2), legend.text=TRUE, main='', xlab=xlab, ylab='', col=brewer.pal(12, "Paired"))
  # Plot it
  print(p)
}

make_barplot_table <- function(tab, xlab, beside) {
  # Barplot with table
  p <- barplot(tab, legend.text=TRUE, beside=beside, main='', xlab=xlab, ylab='# of participants', las=2)
  # Plot it
  print(p)
}

#
# Relation between Age and Educutaion Level of the participants
#
plot_label('Relation between Age and Education level of the participants')
agg <- aggregate(x=country ~ timestamp + age + level_education, data=df, FUN=length)
tab <- table(agg$level_education, agg$age)
make_barplot_proptable(tab, "Age")
make_barplot(agg, 'age', 'level_education', 'fill', 'right', 'Age', 'Level of education')
make_barplot(agg, 'age', 'level_education', 'stack', 'right', 'Age', 'Level of education')
make_barplot_table(tab, "Age", FALSE)
#make_barplot_table(tab, "Age", TRUE)
remove(tab)
remove(agg)

#
# Relation between Age and Gender of the participants
#
plot_label('Relation between Age and Gender of the participants')
agg <- aggregate(x=country ~ timestamp + age + gender, data=df, FUN=length)
tab <- table(agg$age, agg$gender)
make_barplot_proptable(tab, "Gender")
make_barplot_table(tab, "Gender", FALSE)
make_barplot_table(tab, "Gender", TRUE)
remove(tab)
remove(agg)

#
# Relation between Top 3 Primary QPL/framework and Yes/No answer to if there are too many QPLs
#
plot_label('Relation between Top 3 Primary QPL/framework and \nYes/No answer to if there are too many QPLs')
total <- merge(df, dfOpenQuestions, by="timestamp")
agg <- aggregate(x=country ~ timestamp + primary_qpl + why_too_many_qpl_resp, data=total, FUN=length) 
agg <- agg[agg$'why_too_many_qpl_resp' != '', ]
agg <- agg[agg$'primary_qpl' == 'Qiskit' | agg$'primary_qpl' == 'Cirq' | agg$'primary_qpl' == 'Q#', ]
tab <- table(agg$why_too_many_qpl_resp, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between Top 3 Primary QPL/framework and Yes/No answer to if another QPL is needed
#
plot_label('Relation between Top 3 Primary QPL/framework \nand Yes/No answer to if another QPL is needed')
total <- merge(df, dfOpenQuestions, by="timestamp")
agg <- aggregate(x=country ~ timestamp + primary_qpl + why_need_another_qpl_resp, data=total, FUN=length) 
agg <- agg[agg$'why_need_another_qpl_resp' != '', ]
agg <- agg[agg$'primary_qpl' == 'Qiskit' | agg$'primary_qpl' == 'Cirq' | agg$'primary_qpl' == 'Q#', ]
tab <- table(agg$why_need_another_qpl_resp, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)
remove(total)

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
tab <- table(agg$forum, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and knowledge of quantum physics
#
plot_label('Relation between primary QPL/framework and knowledge of quantum physics')
agg <- aggregate(x=country ~ timestamp + primary_qpl + level_quantum_physics, data=df, FUN=length)
tab <- table(agg$level_quantum_physics, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between where the participants learned quantum physics and theie knowledge in quantum physics
#
plot_label('Relation between where the participants learned quantum physics \nand their knowledge in quantum physics')
agg <- aggregate(x=country ~ timestamp + learned_quantum_physics + level_quantum_physics, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(learned_quantum_physics, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'learned_quantum_physics' != '', ]
# Replace open-answers with 'Other'
agg$'learned_quantum_physics'[agg$'learned_quantum_physics' %!in% c('Books', 'Online Course', 'Search Sites', 'University', 'Work')] <- 'Other'
tab <- table(agg$level_quantum_physics, agg$learned_quantum_physics)
make_barplot_proptable(tab, "where learned quantum physics")
make_barplot_table(tab, "where learned quantum physics", FALSE)
make_barplot_table(tab, "where learned quantum physics", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and the education level of the participant
#
plot_label('Relation between primary QPL/framework and the \neducation level of the participant')
agg <- aggregate(x=country ~ timestamp + primary_qpl + level_education, data=df, FUN=length)
pretty_level_education_names <- function(level_education_name) {
  return(gsub("Secondary school \\(.*\\)$", 'Secondary school', level_education_name))
}
agg$'level_education' <- sapply(agg$'level_education', pretty_level_education_names)
tab <- table(agg$level_education, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and the participant major
#
plot_label('Relation between primary QPL/framework and the participant major')
agg <- aggregate(x=country ~ timestamp + primary_qpl + major, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(major, sep=';'))
# Remove empty answers (not answered)
agg <- agg[agg$'major' != '', ]
# Replace open-answers with 'Other'
agg$'major'[agg$'major' %!in% c('Art / Humanities', 'Computer Science', 'Economics', 'Software Engineering', 'Math', 'Other Engineering', 'Physics', 'Social Sciences')] <- 'Other'
tab <- table(agg$major, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and how they learned
#
plot_label('Relation between primary QPL/framework and how they learned')
agg <- aggregate(x=country ~ timestamp + primary_qpl + learned_qpl, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(learned_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'learned_qpl'[agg$'learned_qpl' %!in% c('Books', 'Language documentation', 'University', 'Online Course', 'Online Forums', 'Search Sites', 'Work')] <- 'Other'
tab <- table(agg$learned_qpl, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and experience with QPLs
#
plot_label('Relation between primary QPL/framework and experience with QPLs')
agg <- aggregate(x=country ~ timestamp + primary_qpl + years_coded_qpls, data=df, FUN=length)
tab <- table(agg$years_coded_qpls, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and professional experience with QPLs
#
plot_label('Relation between primary QPL/framework and professional experience with QPLs')
agg <- aggregate(x=country ~ timestamp + primary_qpl + years_coded_professionally_qpls, data=df, FUN=length)
tab <- table(agg$years_coded_professionally_qpls, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between QPL\nframework they would like to work or try in the near future and why
#
plot_label('Relation between QPL/framework they would like to work or \ntry in the near future and why')
agg <- aggregate(x=country ~ timestamp + qpl_future + why_like_try_qpl, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(qpl_future, sep=';'))
# Replace open-answers with 'Other'
agg$'qpl_future'[agg$'qpl_future' %!in% c('Blackbird', 'Braket SDK', 'Cirq', 'Cove', 'cQASM', 'CQP (Communication Quantum Processes)', 'cQPL', 'Forest', 'Ket', 'LanQ', 'LIQUi|>', 'NDQFP', 'NDQJava', 'Ocean Software', 'OpenQASM', 'Orquestra', 'ProjectQ', 'Q Language', 'QASM (Quantum Macro Assembler)', 'QCL (Quantum Computation Language)', 'QDK (Quantum Development Kit)', 'QHAL', 'Qiskit', 'qGCL', 'QHaskell', 'QML', 'QPAlg (Quantum Process Algebra)', 'QPL and QFC', 'QSEL', 'QuaFL (DSL for quantum programming)', 'Quil', 'Quipper', 'Q#', 'Q|SI>', 'Sabry\'s Language', 'Scaffold', 'Silq', 'Strawberry Fields', 'Lambda Calculi')] <- 'Other'
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(why_like_try_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'why_like_try_qpl'[agg$'why_like_try_qpl' %!in% c('Heard about the language', 'Is part of a course about the language', 'Read an article about the language', 'Widely used', 'Other features')] <- 'Other'
tab <- table(agg$why_like_try_qpl, agg$qpl_future)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and for what they are used
#
plot_label('Relation between primary QPL/framework and for what they are used')
agg <- aggregate(x=country ~ timestamp + primary_qpl + how_use_qpl, data=df, FUN=length)
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(agg %>% separate_rows(how_use_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'how_use_qpl'[agg$'how_use_qpl' %!in% c('Use it for work', 'Use it for research', 'Like to learn')] <- 'Other'
tab <- table(agg$how_use_qpl, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and if the participants test their quantum program
#
plot_label('Relation between primary QPL/framework and if the participants test \ntheir quantum program')
agg <- aggregate(x=country ~ timestamp + primary_qpl + do_test, data=df, FUN=length)
# Remove empty answers (not answered)
agg <- agg[agg$'do_test' != '', ]
tab <- table(agg$do_test, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and how the participants test
#
plot_label('Relation between primary QPL/framework and how the participants test')
agg <- aggregate(x=country ~ timestamp + primary_qpl + how_test, data=df, FUN=length)
# Remove empty answers (not answered)
agg <- agg[agg$'how_test' != '', ]
tab <- table(agg$how_test, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

#
# Relation between primary QPL/framework and tool used for test
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
# Attempt to pretty print tools' names
pretty_testing_tools_names <- function(testing_tool_name) {
  return(gsub(" \\(.*\\)$", '', testing_tool_name))
}
agg$'tools_test'[agg$'tools_test' != 'Other'] <- sapply(agg$'tools_test'[agg$'tools_test' != 'Other'], pretty_testing_tools_names)
tab <- table(agg$tools_test, agg$primary_qpl)
make_barplot_proptable(tab, "QPL/framework")
make_barplot_table(tab, "QPL/framework", FALSE)
make_barplot_table(tab, "QPL/framework", TRUE)
remove(tab)
remove(agg)

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF