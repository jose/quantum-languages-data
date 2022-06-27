# ------------------------------------------------------------------------------
# This script plots correlation plot.
#
# Usage:
#   Rscript correlation-plot.R
#     <output pdf file, e.g., correlation-plot.pdf>
# ------------------------------------------------------------------------------

source('utils.R')

# Load external packages
library('tidyr')
library('ggplot2')

# ------------------------------------------------------------------------- Args

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop('USAGE: Rscript correlation-plot.R <output pdf file, e.g., correlation-plot.pdf>')
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
plot_label('Correlation plots')

make_barplot_proptable <- function(tab, title, xlab, ylab) {
  # Barplot with prop table
  p <- barplot(prop.table(tab, 2), legend.text=TRUE, main=title, xlab=xlab, ylab=ylab)
  # Plot it
  print(p)
}

make_barplot_table <- function(tab, title, xlab, ylab, beside) {
  # Barplot with table
  p <- barplot(tab, legend.text=TRUE, beside=beside, main=title, xlab=xlab, ylab=ylab)
  # Plot it
  print(p)
}

make_correlation_plot_example <- function() {
  plot_label('Correlation Plot Example')
  my_data <- mtcars
  head(my_data)
  cor_coefs <- cor.test(my_data$mpg, my_data$wt)
  p <- ggplot(data = my_data, aes(x = mpg, y = wt)) + 
    geom_point() +
    geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
    annotate("text", x = 30, y = 4, label = paste0("R: ", round(cor_coefs$estimate, 2))) +
    annotate("text", x = 30, y = 3.5, label = paste0("p-value: ", round(cor_coefs$p.value, 10)))
  print(p)
}

print_aggregation_example <- function(agg){
  print('Aggregation')
  agg1 <- aggregate(agg$timestamp, by=list(agg$gender, agg$age), FUN=length)
  colnames(agg1) <- c('gender', 'age', 'count')
  print(agg1)
}

print_table_example <- function(agg){
  print("Table")
  tab <- table(agg$age, agg$gender)
  dfTab <- as.data.frame.matrix(tab) 
  #print(tab[,'Prefer not to say'])
  print(dfTab)
}

print_matrix_example <- function(agg){
  print("Matrix")
  genderList <- c('Man', 'Woman', 'Non-binary, genderqueer, or gender non-conforming', 'Prefer not to say')
  ageList <- c('Under 18 years old', '18-24 years old', '25-34 years old', '35-44 years old', '45-54 years old', '55-64 years old', '65 years or older', 'Prefer not to say')
  mat <- matrix(, nrow=8, ncol=4, byrow=TRUE)
  rownames(mat) <- ageList
  colnames(mat) <- genderList
  for (g in genderList){
    for (a in ageList){
      n <- nrow(agg[(agg$gender == g) & (agg$age == a), ])
      mat[a,g] <- n
    }
  }
  print(mat)
}

# Filter out the ones that have not used any QP language, as those have not
# completed the survey
df <- df[df$'used_qpl' == 'Yes', ]

#
# Relation between Age and Gender of the participants
#
plot_label('Relation between Age and Gender of the participants')
agg <- aggregate(x=country ~ timestamp + age + gender, data=df, FUN=length)
tab <- table(agg$age, agg$gender)
make_barplot_proptable(tab, "Relation between Age and Gender of the participants", "Gender", "# of participants")
make_barplot_table(tab, "Relation between Age and Gender of the participants", "Gender", "# of participants", FALSE)
make_barplot_table(tab, "Relation between Age and Gender of the participants", "Gender", "# of participants", TRUE)
remove(tab)
remove(agg)

# Close output file
dev.off()
# Embed fonts
embed_fonts_in_a_pdf(OUTPUT_FILE)

# EOF