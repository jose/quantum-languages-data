# ------------------------------------------------------------------------------
# A set of util functions for the data analysis.
# ------------------------------------------------------------------------------

# Load external packages
library('reshape2')
library('stringr')

# Environment variables
RAW_DATA_FILE <- '../data/survey.csv'
OPEN_QUESTIONS_DATA_FILE <- '../data/survey_open_questions.csv'

# --------------------------------------------------------------------- Wrappers

'%!in%' <- function(x,y)!('%in%'(x,y)) # Wrapper to 'not in'

load_CSV <- function(csv_path) {
  return(read.csv(csv_path, header=TRUE, stringsAsFactors=FALSE))
}

load_TABLE <- function(zip_path) {
  return(read.table(gzfile(zip_path), header=TRUE, stringsAsFactors=FALSE))
}

load_survey_data <- function() {
  df <- load_CSV(RAW_DATA_FILE)
  df <- pre_process_data(df)
  return(df)
}

replace_string <- function(string, find, replace) {
  gsub(find, replace, string)
}

embed_fonts_in_a_pdf <- function(pdf_path) {
  library('extrafont') # install.packages('extrafont')
  embed_fonts(pdf_path, options='-dSubsetFonts=true -dEmbedAllFonts=true -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dMaxSubsetPct=100')
}

# ------------------------------------------------------------------------- Plot

#
# Plots the provided text on a dedicated page.  This function is usually used to
# separate plots for multiple analyses in the same PDF.
#
plot_label <- function(text) {
  library('ggplot2') # install.packages('ggplot2')
  p <- ggplot() + annotate('text', label=text, x=4, y=25, size=8) + theme_void()
  print(p)
}

# ---------------------------------------------------------------- Study related

#
# Pre-process the data collected from google forms
#
pre_process_data <- function(df) {
  #
  # Rename all columns
  #
  names(df)[names(df) == 'Timestamp'] <- 'timestamp'
  names(df)[names(df) == 'Have.you.ever.used.any.Quantum.Programming.Language.'] <- 'used_qpl'
  names(df)[names(df) == 'What.is.your.age.'] <- 'age'
  names(df)[names(df) == 'Where.do.you.live...Country.'] <- 'country'
  names(df)[names(df) == 'Which.of.the.following.describe.you.'] <- 'gender'
  names(df)[names(df) == 'How.many.years.have.you.been.coding.'] <- 'years_coding'
  names(df)[names(df) == 'How.many.years.have.you.coded.professionally..as.a.part.of.your.work..'] <- 'years_coded_professionally'
  names(df)[names(df) == 'How.did.you.learn.to.code..Select.all.that.apply.'] <- 'learned_code'
  names(df)[names(df) == 'What.are.the.most.used.programming..scripting..and.markup.languages.have.you.used..Select.all.that.apply.'] <- 'used_programming_language'
  names(df)[names(df) == 'What.is.your.level.of.knowledge.in.Quantum.Physics..'] <- 'level_quantum_physics'
  names(df)[names(df) == 'Where.did.you.learn.Quantum.Physics.'] <- 'learned_quantum_physics'
  names(df)[names(df) == 'Which.of.the.following.best.describes.the.highest.level.of.education.that.you.have.completed..'] <- 'level_education'
  names(df)[names(df) == 'If.you.have.completed.a.major..what.is.the.subject.'] <- 'major'
  names(df)[names(df) == 'Which.of.the.following.describes.your.current.job..Please.select.all.that.apply.'] <- 'job'
  names(df)[names(df) == 'Where.and.how.did.you.learn.Quantum.Programming.Languages.'] <- 'learned_qpl'
  names(df)[names(df) == 'How.many.years.have.you.been.coding.using.Quantum.Programming.Languages.'] <- 'years_coded_qpls'
  names(df)[names(df) == 'How.many.years.have.you.coded.professionally.using.Quantum.Programming.Languages..as.a.part.of.your.work..'] <- 'years_coded_professionally_qpls'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Blackbird.'] <- 'used_qpls_blackbird'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Braket.SDK.'] <- 'used_qpls_braket'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Cirq.'] <- 'used_qpls_cirq'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Cove.'] <- 'used_qpls_cove'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...cQASM.'] <- 'used_qpls_cqasm'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...CQP..Communication.Quantum.Processes..'] <- 'used_qpls_cqp'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...cQPL.'] <- 'used_qpls_cqpl'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Forest.'] <- 'used_qpls_forest'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Ket.'] <- 'used_qpls_ket'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...LanQ.'] <- 'used_qpls_lanq'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...LIQUi...'] <- 'used_qpls_liqui'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...NDQFP.'] <- 'used_qpls_ndqfp'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...NDQJava.'] <- 'used_qpls_ndqjava'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Ocean.Software.'] <- 'used_qpls_ocean'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...OpenQASM.'] <- 'used_qpls_openqasm'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Orquestra.'] <- 'used_qpls_orquestra'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...ProjectQ.'] <- 'used_qpls_projectq'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Q.Language.'] <- 'used_qpls_q_language'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QASM..Quantum.Macro.Assembler..'] <- 'used_qpls_qasm'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QCL..Quantum.Computation.Language..'] <- 'used_qpls_qcl'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QDK..Quantum.Development.Kit..'] <- 'used_qpls_qdk'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QHAL.'] <- 'used_qpls_qhal'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Qiskit.'] <- 'used_qpls_qiskit'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...qGCL.'] <- 'used_qpls_qgcl'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QHaskell.'] <- 'used_qpls_qhaskell'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QML.'] <- 'used_qpls_qml'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QPAlg..Quantum.Process.Algebra..'] <- 'used_qpls_qpalg'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QPL.and.QFC.'] <- 'used_qpls_qpl_and_qfc'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QSEL.'] <- 'used_qpls_qsel'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QuaFL..DSL.for.quantum.programming..'] <- 'used_qpls_quafl'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Quil.'] <- 'used_qpls_quil'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Quipper.'] <- 'used_qpls_quipper'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Q..'] <- 'used_qpls_q'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Q.SI..'] <- 'used_qpls_qsi'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Sabry.s.Language.'] <- 'used_qpls_sabry'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Scaffold.'] <- 'used_qpls_scaffold'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Silq.'] <- 'used_qpls_silq'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Strawberry.Fields.'] <- 'used_qpls_strawberry'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Lambda.Calculi.'] <- 'used_qpls_lambda_calculi'
  names(df)[names(df) == 'What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Other.'] <- 'used_qpls_other'
  names(df)[names(df) == 'Is.there.any.other.Quantum.Programming.Language.not.listed.that.you.have.been.using.'] <- 'other_used_qpl'
  names(df)[names(df) == 'Which.of.the.following.is.your.primary.Quantum.Programming.Language...framework.'] <- 'primary_qpl'
  names(df)[names(df) == 'In.terms.of.ease...rate.your.primary.Quantum.Programming.Language...Features...functionalities.of.the.language.'] <- 'rate_primary_qpl_features'
  names(df)[names(df) == 'In.terms.of.ease...rate.your.primary.Quantum.Programming.Language...Documentation.avaliable.'] <- 'rate_primary_qpl_documentation'
  names(df)[names(df) == 'In.terms.of.ease...rate.your.primary.Quantum.Programming.Language...Code.examples.'] <- 'rate_primary_qpl_code_examples'
  names(df)[names(df) == 'In.terms.of.ease...rate.your.primary.Quantum.Programming.Language...Several.forums.'] <- 'rate_primary_qpl_forums'
  names(df)[names(df) == 'In.terms.of.ease...rate.your.primary.Quantum.Programming.Language...Support..e.g...github.issues..'] <- 'rate_primary_qpl_support'
  names(df)[names(df) == 'In.terms.of.ease...rate.your.primary.Quantum.Programming.Language...Easy.to.code.'] <- 'rate_primary_qpl_easy_to_code'
  names(df)[names(df) == 'Is.there.anything.else.you.like.the.most.in.your.primary.Quantum.Programming.Language.'] <- 'like_primary_qpl'
  names(df)[names(df) == 'Is.there.anything.else.you.do.not.like.in.your.primary.Quantum.Programming.Language.'] <- 'not_like_primary_qpl'
  names(df)[names(df) == 'Which.forums..e.g...to.ask.for.help..search.for.examples..do.you.use...if.any.'] <- 'forum'
  names(df)[names(df) == 'Which.Quantum.Programming.Languages...frameworks.would.you.like.to.work.or.try.in.the.near.future..'] <- 'qpl_future'
  names(df)[names(df) == 'Why.would.you.like.to.work.or.try.those.languages...frameworks.'] <- 'why_like_try_qpl'
  names(df)[names(df) == 'What.challenges.did.you.run.into.when.choosing.a.Quantum.Programming.Language...framework.'] <- 'challenges'
  names(df)[names(df) == 'In.your.opinion..what.makes.learning.Quantum.Programming.Languages...frameworks.important.'] <- 'learn_qpl_important'
  names(df)[names(df) == 'How.do.you.use.Quantum.Programming.Languages..'] <- 'how_use_qpl'
  names(df)[names(df) == 'What.are.the.type.of.tools.you.think.are.necessary.or.missing.to.develop.better.and.faster.Quantum.Programs...E.g...IDE.tailored.for.quantum..tools.to.debug.quantum.programs..tools.to.test..'] <- 'tools_missing_qpl'
  names(df)[names(df) == 'Do.you.test.your.Quantum.Programs.'] <- 'do_test'
  names(df)[names(df) == 'How.often.do.you.test.your.Quantum.Programs.'] <- 'how_often_test'
  names(df)[names(df) == 'How.do.you.test.your.Quantum.Programs..'] <- 'how_test'
  names(df)[names(df) == 'What.tools.do.you.use.to.test.your.Quantum.Programs.'] <- 'tools_test'
  names(df)[names(df) == 'In.your.opinion..do.you.think.there.are.too.many.or.too.few.Quantum.Programming.Languages..Why.'] <- 'why_too_many_qpl'
  names(df)[names(df) == 'In.your.opinion..do.you.think.that.quantum.developers.would.need.yet.another.Quantum.Programming.Languages.in.the.near.future..Why.'] <- 'why_need_another_qpl'

  # Filter out the ones that have not used any QP language, as those have not
  # completed the survey
  df <- df[df$'used_qpl' == 'Yes', ]

  #
  # Convert dataframe from wide to long (column level)
  #

  # rate_primary_qpl_*
  #
  all_colnames                      <- colnames(df)
  rate_primary_qpl_colnames         <- all_colnames[grep('^rate_primary_qpl_', all_colnames)]
  all_colnames_but_rate_primary_qpl <- setdiff(all_colnames, rate_primary_qpl_colnames)
  df <- melt(df, id.vars=all_colnames_but_rate_primary_qpl, measure.vars=rate_primary_qpl_colnames)

  names(df)[names(df) == 'variable'] <- 'rate_primary_qpl'
  names(df)[names(df) == 'value']    <- 'rate_primary_qpl_value'
  pretty_rate_primary_qpl <- function(rate_primary_qpl) {
    if (rate_primary_qpl == 'rate_primary_qpl_features') {
      return('features')
    } else if (rate_primary_qpl == 'rate_primary_qpl_documentation') {
      return('documentation')
    } else if (rate_primary_qpl == 'rate_primary_qpl_code_examples') {
      return('code examples')
    } else if (rate_primary_qpl == 'rate_primary_qpl_forums') {
      return('forums')
    } else if (rate_primary_qpl == 'rate_primary_qpl_support') {
      return('support')
    } else if (rate_primary_qpl == 'rate_primary_qpl_easy_to_code') {
      return('easy to code')
    }
  }
  df$'rate_primary_qpl' <- sapply(df$'rate_primary_qpl', pretty_rate_primary_qpl)
  df$'rate_primary_qpl' <- as.factor(df$'rate_primary_qpl')
  df$'rate_primary_qpl_value' <- as.factor(df$'rate_primary_qpl_value')

  df$'primary_qpl' <- sapply(df$'primary_qpl', pretty_qpl)
  df$'primary_qpl' <- factor(df$'primary_qpl', levels=c(stringr::str_sort(setdiff(unique(df$'primary_qpl'), c('Other'))), 'Other'))

  # used_qpls_*
  #
  all_colnames               <- colnames(df)
  used_qpls_colnames         <- all_colnames[grep('^used_qpls_', all_colnames)]
  all_colnames_but_used_qpls <- setdiff(all_colnames, used_qpls_colnames)
  df <- melt(df, id.vars=all_colnames_but_used_qpls, measure.vars=used_qpls_colnames)

  names(df)[names(df) == 'variable'] <- 'used_qpls'
  names(df)[names(df) == 'value']    <- 'used_qpls_value'
  pretty_used_qpl <- function(used_qpl) {
    if (used_qpl == 'used_qpls_blackbird') {
      return('Strawberry Fields (Blackbird)')
    } else if (used_qpl == 'used_qpls_braket') {
      return('Braket SDK (Python)')
    } else if (used_qpl == 'used_qpls_cirq') {
      return('Cirq (Python)')
    } else if (used_qpl == 'used_qpls_cove') {
      return('Cove (C#)')
    } else if (used_qpl == 'used_qpls_cqasm') {
      return('cQASM')
    } else if (used_qpl == 'used_qpls_cqp') {
      return('CQP') # (Communication Quantum Processes)
    } else if (used_qpl == 'used_qpls_cqpl') {
      return('cQPL')
    } else if (used_qpl == 'used_qpls_forest') {
      return('Forest (Python)')
    } else if (used_qpl == 'used_qpls_ket') {
      return('Ket')
    } else if (used_qpl == 'used_qpls_lanq') {
      return('LanQ')
    } else if (used_qpl == 'used_qpls_liqui') {
      return('LIQUi|>')
    } else if (used_qpl == 'used_qpls_ndqfp') {
      return('NDQFP')
    } else if (used_qpl == 'used_qpls_ndqjava') {
      return('NDQJava')
    } else if (used_qpl == 'used_qpls_ocean') {
      return('DWave Ocean (Python)')
    } else if (used_qpl == 'used_qpls_openqasm') {
      return('OpenQASM')
    } else if (used_qpl == 'used_qpls_orquestra') {
      return('Orquestra (Python)')
    } else if (used_qpl == 'used_qpls_projectq') {
      return('ProjectQ (Python)')
    } else if (used_qpl == 'used_qpls_q_language') {
      return('Q Language')
    } else if (used_qpl == 'used_qpls_qasm') {
      return('QASM') # (Quantum Macro Assembler)
    } else if (used_qpl == 'used_qpls_qcl') {
      return('QCL') # (Quantum Computation Language)
    } else if (used_qpl == 'used_qpls_qdk') {
      return('QDK (Python)')
    } else if (used_qpl == 'used_qpls_qhal') {
      return('QHAL')
    } else if (used_qpl == 'used_qpls_qiskit') {
      return('Qiskit (Python)')
    } else if (used_qpl == 'used_qpls_qgcl') {
      return('qGCL')
    } else if (used_qpl == 'used_qpls_qhaskell') {
      return('QHaskell')
    } else if (used_qpl == 'used_qpls_qml') {
      return('QML')
    } else if (used_qpl == 'used_qpls_qpalg') {
      return('QPAlg') # (Quantum Process Algebra)
    } else if (used_qpl == 'used_qpls_qpl_and_qfc') {
      return('QPL and QFC')
    } else if (used_qpl == 'used_qpls_qsel') {
      return('QSEL')
    } else if (used_qpl == 'used_qpls_quafl') {
      return('QuaFL') # (DSL for quantum programming)
    } else if (used_qpl == 'used_qpls_quil') {
      return('Quil')
    } else if (used_qpl == 'used_qpls_quipper') {
      return('Quipper')
    } else if (used_qpl == 'used_qpls_q') {
      return('QDK (Q#)')
    } else if (used_qpl == 'used_qpls_qsi') {
      return('Q|SI>')
    } else if (used_qpl == 'used_qpls_sabry') {
      return('Sabry Language')
    } else if (used_qpl == 'used_qpls_scaffold') {
      return('Scaffold')
    } else if (used_qpl == 'used_qpls_silq') {
      return('Silq')
    } else if (used_qpl == 'used_qpls_strawberry') {
      return('Strawberry Fields (Python)')
    } else if (used_qpl == 'used_qpls_lambda_calculi') {
      return('Lambda Calculi')
    } else if (used_qpl == 'used_qpls_other') {
      return('Other')
    }
  }
  df$'used_qpls' <- sapply(df$'used_qpls', pretty_used_qpl)
  df$'used_qpls' <- factor(df$'used_qpls', levels=c(stringr::str_sort(setdiff(unique(df$'used_qpls'), c('Other'))), 'Other'))

  # (custom) Sort gender
  df$'gender'[df$'gender' == ''] <- 'Prefer not to say'
  df$'gender' <- factor(df$'gender', levels=c(stringr::str_sort(setdiff(unique(df$'gender'), c('Prefer not to say'))), 'Prefer not to say'))
  # (custom) Sort age
  df$'age' <- factor(df$'age', levels=c(
    'Under 18 years old',
    '18-24 years old',
    '25-34 years old',
    '35-44 years old',
    '45-54 years old',
    '55-64 years old',
    '65 years or older',
    'Prefer not to say'
  ))
  # (custom) Sort learned_code
  df$'learned_code' <- factor(df$'learned_code', levels=c(stringr::str_sort(setdiff(unique(df$'learned_code'), c('Other'))), 'Other'))
  # (custom) Sort learned_quantum_physics
  df$'learned_quantum_physics' <- factor(df$'learned_quantum_physics', levels=c(stringr::str_sort(setdiff(unique(df$'learned_quantum_physics'), c('Other'))), 'Other'))
  # (custom) Sort forum
  df$'forum' <- factor(df$'forum', levels=c(stringr::str_sort(setdiff(unique(df$'forum'), c('Other'))), 'Other'))
  # (custom) Sort major
  df$'major' <- factor(df$'major', levels=c(stringr::str_sort(setdiff(unique(df$'major'), c('Other'))), 'Other'))
  # (custom) Sort job
  df$'job' <- factor(df$'job', levels=c(stringr::str_sort(setdiff(unique(df$'job'), c('Other'))), 'Other'))
  # (custom) Sort how_use_qpl
  df$'how_use_qpl' <- factor(df$'how_use_qpl', levels=c(stringr::str_sort(setdiff(unique(df$'how_use_qpl'), c('Other'))), 'Other'))
  # (custom) Sort how_often_test
  df$'how_often_test' <- factor(df$'how_often_test', levels=c(stringr::str_sort(setdiff(unique(df$'how_often_test'), c('Other'))), 'Other'))

  # (custom) Sort range of years
  years_levels <- c(
    'Less than 1 year',
    '1 to 4 years',
    '5 to 9 years',
    '10 to 14 years',
    '15 to 19 years',
    '20 to 24 years',
    '25 to 29 years',
    '30 to 34 years',
    '35 to 39 years',
    '40 to 44 years',
    '45 to 49 years',
    'More than 50 years'
  )
    years_levels_none <- c(
    'None',
    'Less than 1 year',
    '1 to 4 years',
    '5 to 9 years',
    '10 to 14 years',
    '15 to 19 years',
    '20 to 24 years',
    '25 to 29 years',
    '30 to 34 years',
    '35 to 39 years',
    '40 to 44 years',
    '45 to 49 years',
    'More than 50 years'
  )
  df$'years_coding'                    <- factor(df$'years_coding', levels=years_levels)
  df$'years_coded_professionally'      <- factor(df$'years_coded_professionally', levels=years_levels_none)
  df$'years_coded_qpls'                <- factor(df$'years_coded_qpls', levels=years_levels)
  df$'years_coded_professionally_qpls' <- factor(df$'years_coded_professionally_qpls', levels=years_levels_none)

  used_qpls_years_levels <- c(
    'Less than 1 year',
    '1 to 2 years',
    '3 to 4 years',
    '5 to 6 years',
    '7 to 8 years',
    '9 to 10 years',
    'More then 11 years'
  )
  df$'used_qpls_value' <- factor(df$'used_qpls_value', levels=used_qpls_years_levels)

  return(df)
}

#
#
#
pretty_qpl <- function(qpl) {
  if (qpl == 'Blackbird') {
    return('Strawberry Fields (Blackbird)')
  } else if (qpl == 'Braket SDK') {
    return('Braket SDK (Python)')
  } else if (qpl == 'Cirq') {
    return('Cirq (Python)')
  } else if (qpl == 'Cove') {
    return('Cove (C#)')
  } else if (qpl == 'cQASM') {
    return('cQASM')
  } else if (qpl == 'CQP (Communication Quantum Processes)') {
    return('CQP')
  } else if (qpl == 'Forest') {
    return('Forest (Python)')
  } else if (qpl == 'Ket') {
    return('Ket')
  } else if (qpl == 'LanQ') {
    return('LanQ')
  } else if (qpl == 'LIQUi|>') {
    return('LIQUi|>')
  } else if (qpl == 'NDQFP') {
    return('NDQFP')
  } else if (qpl == 'NDQJava') {
    return('NDQJava')
  } else if (qpl == 'Ocean Software') {
    return('DWave Ocean (Python)')
  } else if (qpl == 'OpenQASM') {
    return('OpenQASM')
  } else if (qpl == 'Orquestra') {
    return('Orquestra (Python)')
  } else if (qpl == 'ProjectQ') {
    return('ProjectQ (Python)')
  } else if (qpl == 'Q Language') {
    return('Q Language')
  } else if (qpl == 'QASM (Quantum Macro Assembler)') {
    return('QASM')
  } else if (qpl == 'QCL (Quantum Computation Language)') {
    return('QCL')
  } else if (qpl == 'QDK (Quantum Development Kit)') {
    return('QDK (Python)')
  } else if (qpl == 'QHAL') {
    return('QHAL')
  } else if (qpl == 'Qiskit') {
    return('Qiskit (Python)')
  } else if (qpl == 'qGCL') {
    return('qGCL')
  } else if (qpl == 'QHaskell') {
    return('QHaskell')
  } else if (qpl == 'QML') {
    return('QML')
  } else if (qpl == 'QPAlg (Quantum Process Algebra)') {
    return('QPAlg')
  } else if (qpl == 'QPL and QFC') {
    return('QPL and QFC')
  } else if (qpl == 'QSEL') {
    return('QSEL')
  } else if (qpl == 'QuaFL (DSL for quantum programming)') {
    return('QuaFL')
  } else if (qpl == 'Quil') {
    return('Quil')
  } else if (qpl == 'Quipper') {
    return('Quipper')
  } else if (qpl == 'Q#') {
    return('QDK (Q#)')
  } else if (qpl == 'Q|SI>') {
    return('Q|SI>')
  } else if (qpl == "Sabry's Language") {
    return('Sabry Language')
  } else if (qpl == 'Scaffold') {
    return('Scaffold')
  } else if (qpl == 'Silq') {
    return('Silq')
  } else if (qpl == 'Strawberry Fields') {
    return('Strawberry Fields (Python)')
  } else if (qpl == 'Lambda Calculi') {
    return('Lambda Calculi')
  } else if (qpl == 'Other (Language informed in the previous question)') {
    return('Other')
  } else if (qpl == '') {
    return('')
  } else {
    return('Other')
  }
}

# EOF
