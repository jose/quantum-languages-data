# ------------------------------------------------------------------------------
# This script pre-process data from google form.
#
# Usage:
#   Rscript pre-process-data.R
#     <input data file, e.g., ../data/survey.csv>
#     <output data file, e.g., ../data/survey-post-process.csv.gz>
# ------------------------------------------------------------------------------

source('utils.R')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 2) {
  stop('USAGE: Rscript pre-process-data.R <input data file, e.g., ../data/survey.csv> <output data file, e.g., ../data/survey-post-process.csv.gz>')
}

# Args
INPUT_FILE  <- args[1]
OUTPUT_FILE <- args[2]

# ------------------------------------------------------------------------- Main

cat('Loading data... ', date(), '\n', sep='')
df <- load_CSV(INPUT_FILE)

cat('Pre-processing data... ', date(), '\n', sep='')
df <- pre_process_data(df)

cat('Data has been loaded and pre-processed. Starting compressing it... ', date(), '\n', sep='')
write.table(df, file=gzfile(OUTPUT_FILE))
stopifnot(file.exists(OUTPUT_FILE) == TRUE)

cat('Data is compressed and saved. Starting reading it back for sanity check... ', date(), '\n', sep='')
x <- read.table(gzfile(OUTPUT_FILE), header=TRUE, stringsAsFactors=FALSE)

cat('DONE! ', date(), '\n', sep='')

# EOF
