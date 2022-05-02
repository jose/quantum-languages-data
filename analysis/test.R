library(tidyverse)
library(dplyr)

#dfSurvey <- read.csv(file = "survey.csv", header = TRUE, sep = ",")
dfSurvey <- load_CSV(append_path_data('survey.csv'))

tableAge <- table(dfSurvey$Have.you.ever.used.any.Quantum.Programming.Language.)

df <- data.frame(group = c('less than 18 years old', '18-24 years old', '25-34 years old', '35-44 years old', '45-54 years old', '55-64 years old', '65 years or older'), value = t2)
glimpse(df)

ggplot(df, aes(x = "", y = value.Freq, fill = group)) +  geom_col(color = "black") + geom_text(aes(label = value.Freq), position = position_stack(vjust = 0.5)) + coord_polar(theta = "y")

