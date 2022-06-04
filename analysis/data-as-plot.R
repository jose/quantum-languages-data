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
pdf(file=OUTPUT_FILE, family='Helvetica', width=14, height=12)
# Add a cover page to the output file
plot_label('Data as pieplots and barplots')

make_bar_plot <- function(df, x) {
  # Basic barplot
  p <- ggplot(df, aes_string(x=x)) + geom_bar(width=0.90)
  # Change x axis label
  p <- p + scale_x_discrete(name='')
  # Change y axis label
  p <- p + scale_y_continuous(name='', labels = scales::percent_format(scale = 1))
  # Remove legend's title and increase size of [x-y]axis labels
  p <- p + theme(legend.position='none',
    axis.text.x=element_text(size=16,  hjust=0.5, vjust=0.5),
    axis.text.y=element_text(size=16,  hjust=1.0, vjust=0.0),
    axis.title.x=element_text(size=16, hjust=0.5, vjust=0.0),
    axis.title.y=element_text(size=16, hjust=0.5, vjust=0.5)
  )
  # Add labels over bars
  p <- p + stat_count(geom='text', colour='black', size=6, aes(label=paste((round((..count..)/sum(..count..)*100, digit=2)), "%", sep="")), position=position_dodge(width=0.9), hjust=-0.15)
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
  lbl <- 
  p <- p + stat_count(geom='text', colour='black', size=6, aes(label=paste((round((..count..)/sum(..count..)*100, digit=2)), "%", sep="")), position=position_stack(vjust=0.5))
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

make_dodge_plot <- function(df, x, v, legendsTitle) {
  # FIXME x-axis scale
  # Basic dodgeplot
  p <- ggplot(df, aes(x=x, fill=v))
  p <- p + geom_bar(width=0.90, position=position_dodge(width=1))
  # Change x axis label
  p <- p + scale_x_discrete(name='')
  # Change y axis label
  p <- p + scale_y_continuous(name='', labels=scales::percent_format(scale=1))
  # Remove legend's title and increase size of [x-y]axis labels
  p <- p + theme(legend.position='top',
    axis.text.x=element_text(size=14,  hjust=0.5, vjust=0.5),
    axis.text.y=element_text(size=14,  hjust=1.0, vjust=0.0),
    axis.title.x=element_text(size=14, hjust=0.5, vjust=0.0),
    axis.title.y=element_text(size=14, hjust=0.5, vjust=0.5)
  )
  # Change legend's title
  p <- p + labs(fill=legendsTitle)
  # Add labels over bars
  p <- p + stat_count(geom='text', colour='black', size=2.5, aes(label=paste((round((..count..)/sum(..count..)*100, digit=2)), '%', sep='')), position=position_dodge(width=0.9), hjust=-0.15)
  # Make it horizontal
  p <- p + coord_flip()
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
#make_bar_plot(agg, x='used_qpl')
make_pie_plot(agg, fill='used_qpl')
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
#make_pie_plot(agg, fill='age')
remove(agg)

#
# Where do you live? (Country)
#
plot_label('Where do you live? (Country)')
agg <- aggregate(x=. ~ timestamp + country, data=df, FUN=length)
make_bar_plot(agg, x='country')
#make_pie_plot(agg, fill='country')
remove(agg)

#
# Which of the following describe you?
#
plot_label('Which of the following describe you?')
agg <- aggregate(x=. ~ timestamp + gender, data=df, FUN=length)
#make_bar_plot(agg, x='gender')
make_pie_plot(agg, fill='gender')
remove(agg)

#
# How many years have you been coding?
#
plot_label('How many years have you been coding?')
agg <- aggregate(x=. ~ timestamp + years_coding, data=df, FUN=length)
make_bar_plot(agg, x='years_coding')
#make_pie_plot(agg, fill='years_coding')
remove(agg)

#
# How many years have you coded professionally (as a part of your work)?
#
plot_label('How many years have you coded professionally (as a part\nof your work)?')
agg <- aggregate(x=. ~ timestamp + years_coded_professionally, data=df, FUN=length)
make_bar_plot(agg, x='years_coded_professionally')
#make_pie_plot(agg, fill='years_coded_professionally')
remove(agg)

#
# How did you learn to code?
#
plot_label('How did you learn to code?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(learned_code, sep=';'))
# Replace open-answers with 'Other'
agg$'learned_code'[agg$'learned_code' %!in% c('Books / Physical media', 'Coding Bootcamp', 'Colleague', 'Friend or family member', 'Online Courses or Certification', 'Online Forum', 'Other online resources (videos, blogs, etc)', 'School')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + learned_code, data=agg, FUN=length)
make_bar_plot(agg, x='learned_code')
#make_pie_plot(agg, fill='learned_code')
remove(agg)

#
# What are the most used programming, scripting, and markup languages have you used?
#
plot_label('What are the most used programming, scripting, and markup\n languages have you used?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(used_programming_language, sep=';'))
# Replace open-answers with 'Other'
agg$'used_programming_language'[agg$'used_programming_language' %!in% c('Assembly', 'Bash', 'C', 'Classic Visual Basic', 'COBOL', 'C++', 'C#', 'Delphi/Object Pascal', 'Fortran', 'F#', 'Go', 'Groovy', 'Haskell', 'Java', 'JavaScrpit', 'Julia', 'Lisp', 'Matlab', 'ML', 'Objective-C', 'Pascal', 'Perl', 'pGCL', 'PHP', 'PowerShell', 'Prolog', 'Python', 'Ruby', 'SQL', 'Standard ML', 'Swift', 'Visual Basic', 'Visual C++')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + used_programming_language, data=agg, FUN=length)
make_bar_plot(agg, x='used_programming_language')
#make_pie_plot(agg, fill='used_programming_language')
remove(agg)

#
# What is your level of knowledge in Quantum Physics?
#
plot_label('What is your level of knowledge in Quantum Physics?')
agg <- aggregate(x=. ~ timestamp + level_quantum_physics, data=df, FUN=length)
#make_bar_plot(agg, x='level_quantum_physics')
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
#make_bar_plot(agg, x='learned_quantum_physics')
make_pie_plot(agg, fill='learned_quantum_physics')
remove(agg)

#
# Which of the following best describes the highest level of education that you have completed?
#
plot_label('Which of the following best describes the highest level\nof education that you have completed?')
agg <- aggregate(x=. ~ timestamp + level_education, data=df, FUN=length)
make_bar_plot(agg, x='level_education')
#make_pie_plot(agg, fill='level_education')
remove(agg)

#
# If you have completed a major, what is the subject?
#
plot_label('If you have completed a major, what is the subject?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(major, sep=';'))
# Replace open-answers with 'Other'
agg$'major'[agg$'major' %!in% c('Art / Humanities', 'Computer Science', 'Economics', 'Software Engineering', 'Math', 'Other Engineering', 'Physics', 'Social Sciences')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + major, data=agg, FUN=length)
make_bar_plot(agg, x='major')
#make_pie_plot(agg, fill='major')
remove(agg)

#
# Which of the following describes your current job?
#
plot_label('Which of the following describes your current job?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(job, sep=';'))
# Replace open-answers with 'Other'
agg$'job'[agg$'job' %!in% c('Academic researcher', 'Architect', 'Business Analyst', 'CIO / CEO / CTO', 'DBA (Database Administrator)', 'Data Analyst / Data Engineer/ Data Scientist', 'Developer Advocate', 'Developer / Programmer / Software Engineer', 'DevOps Engineer / Infrastructure Developer', 'Instructor / Teacher / Tutor', 'Marketing Manager', 'Product Manager', 'Project Manager', 'Scientist / Researcher', 'Student', 'Systems Analyst', 'Team Lead', 'Technical Support', 'Technical Writer', 'Tester / QA Engineer', 'UX / UI Designer')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + job, data=agg, FUN=length)
make_bar_plot(agg, x='job')
#make_pie_plot(agg, fill='job')
remove(agg)

#
# Where and how did you learn Quantum Programming Languages?
#
plot_label('Where and how did you learn Quantum Programming Languages?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(learned_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'learned_qpl'[agg$'learned_qpl' %!in% c('Books', 'Language documentation', 'University', 'Online Course', 'Online Forums', 'Search Sites', 'Work')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + learned_qpl, data=agg, FUN=length)
#make_bar_plot(agg, x='learned_qpl')
make_pie_plot(agg, fill='learned_qpl')
remove(agg)

#
# How many years have you been coding using Quantum Programming Languages?
#
plot_label('How many years have you been coding using Quantum \nProgramming Languages?')
agg <- aggregate(x=. ~ timestamp + years_coded_qpls, data=df, FUN=length)
#make_bar_plot(agg, x='years_coded_qpls')
make_pie_plot(agg, fill='years_coded_qpls')
remove(agg)

#
# How many years have you coded professionally using Quantum Programming \nLanguages (as a part of your work)?
#
plot_label('How many years have you coded professionally using Quantum \nProgramming Languages (as a part of your work)?')
agg <- aggregate(x=. ~ timestamp + years_coded_professionally_qpls, data=df, FUN=length)
#make_bar_plot(agg, x='years_coded_professionally_qpls')
make_pie_plot(agg, fill='years_coded_professionally_qpls')
remove(agg)

#
# What Quantum Programming Languages / frameworks have you been using and for how long?
#
plot_label('What Quantum Programming Languages / frameworks have you \nbeen using and for how long?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(used_qpls, sep=';'))
agg <- aggregate(x=. ~ timestamp + used_qpls + used_qpls_value, data=agg, FUN=length)
agg <- agg[agg$'used_qpls_value' != '', ]

#make_dodge_plot(agg, x='used_qpls', v='used_qpls_value', legendsTitle='How long')

# FIXME x-axis scale
# Basic dodgeplot
p <- ggplot(df, aes(x=used_qpls, fill=used_qpls_value))
p <- p + geom_bar(width=0.90, position=position_dodge(width=1))
# Change x axis label
p <- p + scale_x_discrete(name='')
# Change y axis label
p <- p + scale_y_continuous(name='', labels=scales::percent_format(scale=1))
# Remove legend's title and increase size of [x-y]axis labels
p <- p + theme(legend.position='top',
  axis.text.x=element_text(size=14,  hjust=0.5, vjust=0.5),
  axis.text.y=element_text(size=14,  hjust=1.0, vjust=0.0),
  axis.title.x=element_text(size=14, hjust=0.5, vjust=0.0),
  axis.title.y=element_text(size=14, hjust=0.5, vjust=0.5)
)
# Change legend's title
p <- p + labs(fill='How long')
# Add labels over bars
p <- p + stat_count(geom='text', colour='black', size=2.5, aes(label=paste((round((..count..)/sum(..count..)*100, digit=2)), '%', sep='')), position=position_dodge(width=0.9), hjust=-0.15)
# Make it horizontal
p <- p + coord_flip()
# Plot it
print(p)

remove(agg)

#
# Which of the following is your primary Quantum Programming Language / framework?
#
plot_label('Which of the following is your primary Quantum Programming \nLanguage / framework?')
agg <- aggregate(x=. ~ timestamp + primary_qpl, data=df, FUN=length)
make_bar_plot(agg, x='primary_qpl')
#make_pie_plot(agg, fill='primary_qpl')
remove(agg)

#
# In terms of ease, rate your primary Quantum Programming Language.
#

# TODO CREATE Stacked barplot
plot_label('In terms of ease, rate your primary Quantum Programming Language.')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(rate_primary_qpl_name, sep=';'))
agg <- aggregate(x=. ~ timestamp + rate_primary_qpl_name + rate_primary_qpl_value, data=agg, FUN=length)
make_bar_plot(agg, x='rate_primary_qpl_name')
#make_pie_plot(agg, fill='rate_primary_qpl_name')
remove(agg)

#
# Which forums, e.g., to ask for help, search for examples, do you use? (if any)
#
plot_label('Which forums, e.g., to ask for help, search for examples, \ndo you use? (if any)')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(forum, sep=';'))
# Replace open-answers with 'Other'
agg$'forum'[agg$'forum' %!in% c('Devtalk', 'Quantum Open Source Foundation', 'Slack', 'StackOverflow')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + forum, data=agg, FUN=length)
#make_bar_plot(agg, x='forum')
make_pie_plot(agg, fill='forum')
remove(agg)

#
# Which Quantum Programming Languages / frameworks would you like to work or try in the near future?
#
plot_label('Which Quantum Programming Languages / frameworks would you \nlike to work or try in the near future?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(qpl_future, sep=';'))
# Replace open-answers with 'Other'
agg$'qpl_future'[agg$'qpl_future' %!in% c('Blackbird', 'Braket SDK', 'Cirq', 'Cove', 'cQASM', 'CQP (Communication Quantum Processes)', 'cQPL', 'Forest', 'Ket', 'LanQ', '𝐿𝐼𝑄𝑈𝑖|⟩', 'NDQFP', 'NDQJava', 'Ocean Software', 'OpenQASM', 'Orquestra', 'ProjectQ', 'Q Language', 'QASM (Quantum Macro Assembler)', 'QCL (Quantum Computation Language)', 'QDK (Quantum Development Kit)', 'QHAL', 'Qiskit', 'qGCL', 'QHaskell', 'QML', 'QPAlg (Quantum Process Algebra)', 'QPL and QFC', 'QSEL', 'QuaFL (DSL for quantum programming)', 'Quil', 'Quipper', 'Q#', '𝑄|𝑆𝐼⟩', 'Sabry\'s Language', 'Scaffold', 'Silq', 'Strawberry Fields', '𝜆𝑞 (Lambda Calculi)')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + qpl_future, data=agg, FUN=length)
make_bar_plot(agg, x='qpl_future')
#make_pie_plot(agg, fill='qpl_future')
remove(agg)

#
# Why would you like to work or try those languages / frameworks?
#
plot_label('Why would you like to work or try those languages / frameworks?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(why_like_try_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'why_like_try_qpl'[agg$'why_like_try_qpl' %!in% c('Heard about the language', 'Is part of a course about the language', 'Read an article about the language', 'Widely used', 'Other features')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + why_like_try_qpl, data=agg, FUN=length)
#make_bar_plot(agg, x='why_like_try_qpl')
make_pie_plot(agg, fill='why_like_try_qpl')
remove(agg)

#
# How do you use Quantum Programming Languages? 
#
plot_label('How do you use Quantum Programming Languages?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(how_use_qpl, sep=';'))
# Replace open-answers with 'Other'
agg$'how_use_qpl'[agg$'how_use_qpl' %!in% c('Use it for work', 'Use it for research', 'Like to learn')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + how_use_qpl, data=agg, FUN=length)
#make_bar_plot(agg, x='how_use_qpl')
make_pie_plot(agg, fill='how_use_qpl')
remove(agg)

#
# Do you test your Quantum Programs?
#
plot_label('Do you test your Quantum Programs?')
agg <- aggregate(x=. ~ timestamp + do_test, data=df, FUN=length)
#make_bar_plot(agg, x='do_test')
make_pie_plot(agg, fill='do_test')
remove(agg)

#
# How often do you test your Quantum Programs?
#
plot_label('How often do you test your Quantum Programs?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(how_often_test, sep=';'))
# Replace open-answers with 'Other'
agg$'how_often_test'[agg$'how_often_test' %!in% c('Before go to production', 'Every day', 'Every time you change the code')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + how_often_test, data=agg, FUN=length)
#make_bar_plot(agg, x='how_often_test')
make_pie_plot(agg, fill='how_often_test')
remove(agg)

#
# How do you test your Quantum Programs? 
#
plot_label('How do you test your Quantum Programs?')
agg <- aggregate(x=. ~ timestamp + how_test, data=df[df$'how_test' != '', ], FUN=length)
#make_bar_plot(agg, x='how_test')
make_pie_plot(agg, fill='how_test')
remove(agg)

#
# What tools do you use to test your Quantum Programs?
#
plot_label('What tools do you use to test your Quantum Programs?')
# Convert dataframe from wide to long (row level), i.e., collapse a column with multiple values into multiple rows
agg <- as.data.frame(df %>% separate_rows(tools_test, sep=';'))
# Replace open-answers with 'Other'
agg$'tools_test'[agg$'tools_test' %!in% c('Cirq Simulator and Testing - cirq.testing (https://quantumai.google/cirq)', 'Forest using pytest (https://github.com/rigetti/forest-software)', 'MTQC - Mutation Testing for Quantum Computing (https://javpelle.github.io/MTQC/)', 'Muskit: A Mutation Analysis Tool for Quantum Software Testing (https://ieeexplore.ieee.org/document/9678563)', 'ProjectQ Simulator (https://arxiv.org/abs/1612.08091)', 'QDiff - Differential Testing of Quantum Software Stacks (https://ieeexplore.ieee.org/abstract/document/9678792)', 'QDK - xUnit (https://azure.microsoft.com/en-us/resources/development-kit/quantum-computing/)', 'Qiskit - QASM Simulator (https://qiskit.org/)', 'QuanFuzz - Fuzz Testing of Quantum Program (https://arxiv.org/abs/1810.10310)', 'Quito - A Coverage-Guided Test Generator for Quantum Programs (https://ieeexplore.ieee.org/abstract/document/9678798)', 'Straberry Fields using pytest (https://strawberryfields.ai/)')] <- 'Other'
agg <- aggregate(x=. ~ timestamp + tools_test, data=agg, FUN=length)
make_bar_plot(agg, x='tools_test')
#make_pie_plot(agg, fill='tools_test')
remove(agg)

#
# In your opinion, do you think there are too many or too few Quantum Programming Languages? Why?
#
plot_label('In your opinion, do you think there are too many or too few \nQuantum Programming Languages? Why?')
agg <- aggregate(x=. ~ timestamp + why_too_many_qpl_resp, data=df, FUN=length)
#make_bar_plot(agg, x='why_too_many_qpl_resp')
make_pie_plot(agg, fill='why_too_many_qpl_resp')
remove(agg)

#
# In your opinion, do you think that quantum developers would need yet another Quantum Programming Languages in the near future? Why?
#
plot_label('In your opinion, do you think that quantum developers would need yet another \nQuantum Programming Languages in the near future? Why?')
agg <- aggregate(x=. ~ timestamp + why_need_another_qpl_resp, data=df, FUN=length)
#make_bar_plot(agg, x='why_need_another_qpl_resp')
make_pie_plot(agg, fill='why_need_another_qpl_resp')
remove(agg)

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF

