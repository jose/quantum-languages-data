# ------------------------------------------------------------------------------
# This script print out a latex table with the number of participants using a
# quantum programming language and how long.
#
# Usage:
#   Rscript tableQPLUsedHowLong.R
#     <output tex file, e.g., tableQPLUsedHowLong.tex>
# ------------------------------------------------------------------------------

source('utils.R')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript tableQPLUsedHowLong.R <output tex file, e.g., 
 tableQPLUsedHowLong.tex>')
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

# Remove the output file if any
#OUTPUT_FILE <- append_path(table_path, 'tableQPLUsedHowLong.tex')
unlink(OUTPUT_FILE)
sink(OUTPUT_FILE, append=FALSE, split=TRUE)

# Write down the table header
cat('\\begin{tabular}{@{\\extracolsep{\\fill}} p{2.5cm}rrrrrrrr} \\toprule\n', sep='')
cat('\\multicolumn{1}{c}{QPLs} & \\multicolumn{1}{c}{Less than 1 year} & \\multicolumn{1}{c}{1 to 2 years} & \\multicolumn{1}{c}{3 to 4 years} & \\multicolumn{1}{c}{5 to 6 years} & \\multicolumn{1}{c}{7 to 8 years} & \\multicolumn{1}{c}{9 to 10 years} & \\multicolumn{1}{c}{More than 11 years} & \\multicolumn{1}{c}{Total} \\\\ \n', sep='')
cat('\\midrule \n', sep='')

# Content
listDf <- list()
listDf[[1]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Blackbird.
names(listDf[[1]])[1] <- 'Blackbird'
listDf[[2]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Braket.SDK.
names(listDf[[2]])[1] <- 'Braket SDK'
listDf[[3]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Cirq.
names(listDf[[3]])[1] <- 'Cirq'
listDf[[4]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Cove.
names(listDf[[4]])[1] <- 'Cove'
listDf[[5]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...cQASM.
names(listDf[[5]])[1] <- 'cQAMS'
listDf[[6]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...CQP..Communication.Quantum.Processes..
names(listDf[[6]])[1] <- 'CQP'
listDf[[7]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...cQPL.
names(listDf[[7]])[1] <- 'cQPL'
listDf[[8]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Forest.
names(listDf[[8]])[1] <- 'Forest'
listDf[[9]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Ket.
names(listDf[[9]])[1] <- 'Ket'
listDf[[10]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...LanQ.
names(listDf[[10]])[1] <- 'LanQ'
listDf[[11]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...LIQUi...
names(listDf[[11]])[1] <- '$LIQUi|\\rangle$'
listDf[[12]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...NDQFP.
names(listDf[[12]])[1] <- 'NDQFP'
listDf[[13]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...NDQJava.
names(listDf[[13]])[1] <- 'NDQJava'
listDf[[14]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Ocean.Software.
names(listDf[[14]])[1] <- 'Ocean Software'
listDf[[15]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...OpenQASM.
names(listDf[[15]])[1] <- 'OpenQASM'
listDf[[16]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Orquestra.
names(listDf[[16]])[1] <- 'Orquestra'
listDf[[17]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...ProjectQ.
names(listDf[[17]])[1] <- 'ProjectQ'
listDf[[18]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Q.Language.
names(listDf[[18]])[1] <- 'Q Language'
listDf[[19]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QASM..Quantum.Macro.Assembler..
names(listDf[[19]])[1] <- 'QASM'
listDf[[20]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QCL..Quantum.Computation.Language..
names(listDf[[20]])[1] <- 'QCL'
listDf[[21]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QDK..Quantum.Development.Kit..
names(listDf[[21]])[1] <- 'QDK'
listDf[[22]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QHAL.
names(listDf[[22]])[1] <- 'QHAL'
listDf[[23]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Qiskit.
names(listDf[[23]])[1] <- 'Qiskit'
listDf[[24]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...qGCL.
names(listDf[[24]])[1] <- 'qGCL'
listDf[[25]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QHaskell.
names(listDf[[25]])[1] <- 'QHaskell'
listDf[[26]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QML.
names(listDf[[26]])[1] <- 'QML'
listDf[[27]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QPAlg..Quantum.Process.Algebra..
names(listDf[[27]])[1] <- 'QPAlg'
listDf[[28]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QPL.and.QFC.
names(listDf[[28]])[1] <- 'QPL and QFC'
listDf[[29]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QSEL.
names(listDf[[29]])[1] <- 'QSEL'
listDf[[30]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...QuaFL..DSL.for.quantum.programming..
names(listDf[[30]])[1] <- 'QuaFL'
listDf[[31]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Quil.
names(listDf[[31]])[1] <- 'Quil'
listDf[[32]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Quipper.
names(listDf[[32]])[1] <- 'Quipper'
listDf[[33]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Q..
names(listDf[[33]])[1] <- 'Q\\#'
listDf[[34]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Q.SI..
names(listDf[[34]])[1] <- '$Q|SI\\rangle$'
listDf[[35]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Sabry.s.Language.
names(listDf[[35]])[1] <- 'Sabry\'s Language'
listDf[[36]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Scaffold.
names(listDf[[36]])[1] <- 'Scaffold'
listDf[[37]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Silq.
names(listDf[[37]])[1] <- 'Silq'
listDf[[38]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Strawberry.Fields.
names(listDf[[38]])[1] <- 'Strawberry Field'
listDf[[39]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Lambda.Calculi.
names(listDf[[39]])[1] <- '$\\lambda_{q}$'
listDf[[40]] <- df$What.Quantum.Programming.Languages...frameworks.have.you.been.using.and.for.how.long...Other.
names(listDf[[40]])[1] <- 'Other'

for (newDf in listDf){
  countLess1 <- 0
  count1to2 <- 0
  count3to4 <- 0
  count5to6 <- 0
  count7to8 <- 0
  count9to10 <- 0
  countMore11 <- 0
  for (response in sort(unique(newDf))) {
    countLess1 <- nrow(df[newDf == 'Less than 1 year', ])
    count1to2 <- nrow(df[newDf == '1 to 2 years', ])
    count3to4 <- nrow(df[newDf == '3 to 4 years', ])
    count5to6 <- nrow(df[newDf == '5 to 6 years', ])
    count7to8 <- nrow(df[newDf == '7 to 8 years', ])
    count9to10 <- nrow(df[newDf == '9 to 10 years', ])
    countMore11 <- nrow(df[newDf == 'More then 11 years', ])
  }
  total <- countLess1 + count1to2 + count3to4 + count5to6 + count7to8 + count9to10 + countMore11
  cat(names(newDf)[1], ' & ', countLess1, ' & ', count1to2, ' & ', count3to4, ' & ', count5to6, ' & ', count7to8, ' & ', count9to10, ' & ', countMore11, ' & ', total, ' \\\\\n', sep='')
}

# Footer
cat('\\bottomrule\n', sep='')
cat('\\end{tabular}\n', sep='')

# Flush data
sink()

# EOF

