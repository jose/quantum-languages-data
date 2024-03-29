# ------------------------------------------------------------------------------
# This script print out a latex table with the number of participants per country.
#
# Usage:
#   Rscript tableCountry.R
#     <output tex file, e.g., tableCountry.tex>
# ------------------------------------------------------------------------------

source('utils.R')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript tableCountry.R <output tex file, e.g., tableCountry.tex>')
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
cat('\\begin{tabular}{@{\\extracolsep{\\fill}} lrr} \\toprule\n', sep='')
cat('\\multicolumn{1}{c}{Country} & \\multicolumn{1}{c}{\\# Participants} \\\\ \n', sep='')
cat('\\midrule \n', sep='')

# Content
for (country in sort(unique(df$'country'))) {
  count <- length(unique(df$'timestamp'[df$'country' == country]))
  cat(country, ' & ', count, ' \\\\\n', sep='')
}

# Footer
cat('\\bottomrule\n', sep='')
cat('\\end{tabular}\n', sep='')

# Flush data
sink()

# EOF
