# ------------------------------------------------------------------------------
# A set of util functions for the data analysis.
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------- Wrappers


# ------------------------------------------------------------------------------
# Path to the repository
# ------------------------------------------------------------------------------
data_path <- "D:/OneDrive/GitHub/quantum-languages-data/data/"
report_path <- "D:/OneDrive/GitHub/quantum-languages-thesis/thesis/figures/"
table_path <- "D:/OneDrive/GitHub/quantum-languages-thesis/thesis/tables/"
# ------------------------------------------------------------------------------

append_path <- function(directory_path, file_path) {
  return(paste(directory_path, file_path, sep=""))
}

'%!in%' <- function(x,y)!('%in%'(x,y)) # Wrapper to 'not in'

load_CSV <- function(csv_path) {
  return(read.csv(csv_path, header=TRUE, stringsAsFactors=FALSE))
}

load_TABLE <- function(zip_path) {
  return(read.table(gzfile(zip_path), header=TRUE, stringsAsFactors=FALSE))
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

# TODO

# EOF