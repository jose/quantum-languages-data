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
OUTPUT_FILE <- args[1]

# ------------------------------------------------------------------------- Main

# Import data file
df <- load_survey_data()

# Remove the output file if any
unlink(OUTPUT_FILE)
sink(OUTPUT_FILE, append=FALSE, split=TRUE)

# Write down the table header
cat('\\begin{tabular}{@{\\extracolsep{\\fill}} l', paste0(rep('r', length(levels(df$'used_qpls_value'))+1), collapse=''), '} \\toprule\n', sep='')
cat('\\multicolumn{1}{c}{Quantum Programming Language}', sep='')
for (used_qpls_value in levels(df$'used_qpls_value')) {
  cat(' & \\multicolumn{1}{c}{', used_qpls_value, '}', sep='')
}
cat(' & \\multicolumn{1}{c}{Total} \\\\ \n', sep='')
cat('\\midrule \n', sep='')

agg <- aggregate(x=country ~ timestamp + used_qpls + used_qpls_value, data=df, FUN=length)

for (used_qpls in levels(df$'used_qpls')) {
  used_qpls_mask <- agg$'used_qpls' == used_qpls
  cat(gsub('#', '\\\\#', used_qpls), sep='')

  for (used_qpls_value in levels(df$'used_qpls_value')) {
    used_qpls_value_mask <- agg$'used_qpls_value' == used_qpls_value

    num <- nrow(agg[used_qpls_mask & used_qpls_value_mask, ])
    cat(' & ', num, sep='')
  }

  num <- nrow(agg[used_qpls_mask, ])
  cat(' & ', num, sep='')
  cat(' \\\\\n', sep='')
}

# Footer
cat('\\bottomrule\n', sep='')
cat('\\end{tabular}\n', sep='')

# Flush data
sink()

# EOF
