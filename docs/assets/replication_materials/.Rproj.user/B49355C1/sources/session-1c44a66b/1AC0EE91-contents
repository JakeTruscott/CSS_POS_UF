################################################################################
# Class 7 - Supervised Learning
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated March 2026
################################################################################

################################################################################
# Packages & Libraries
# note: install.packages('PACKAGE') if not already installed
################################################################################

library(dplyr); library(ggplot2); library(stringr);  library(tm); library(quanteda); library(quanteda.textstats); library(quanteda.textstats); library(rvest); library(tibble); library(tidytext); library(e1071)


reduce_complexity <- function(corpus){
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  return(corpus)
} # Pre-Process (Reduce Complexity)

################################################################################
# Load IMDB Data
################################################################################

data <- c('imdb_train_pos.rdata', 'imdb_train_neg.rdata', 'imdb_test_pos.rdata', 'imdb_test_neg.rdata')

for (i in data){
  load(url(paste0('https://raw.githubusercontent.com/JakeTruscott/CSS_POS_UF/main/docs/assets/replication_materials/class_7/data/', i)))
  message('Successfully Loaded ', i)
} # Load Train & Test Data


################################################################################
# Allocate Train & Test
################################################################################

set.seed(1234) # Set Random Seed

train_data <- bind_rows(imdb_train_pos, imdb_train_neg) # Combine Train Rows
test_data  <- bind_rows(imdb_test_pos, imdb_test_neg) # combine Test Rows

train_data <- train_data[sample(nrow(train_data), size = 5000, replace = FALSE), ] # Sample Out
test_data <- test_data[sample(nrow(test_data), size = 1000, replace = FALSE), ] # Sample Out

train_corpus <- tm::VCorpus(VectorSource(train_data$text)) # Convert Train to Corpus
test_corpus  <- tm::VCorpus(VectorSource(test_data$text)) # Convert tes tto Corpus

train_corpus <- reduce_complexity(train_corpus) # Apply Complexity Reduction
test_corpus  <- reduce_complexity(test_corpus) # Apply Complexity Reduction

train_dtm <- removeSparseTerms(DocumentTermMatrix(train_corpus), 0.995) # Convert to DTM - Only Keep Terms in At least 0.5% of Docs
test_dtm  <- DocumentTermMatrix(test_corpus, control = list(dictionary = Terms(train_dtm))) # Control Ensures Same Terms in Test as Train

train_matrix <- as.data.frame(as.matrix(train_dtm)) # Convert Back to DF for NB
train_matrix$sentiment <- train_data$sentiment # Ensure Sentiment

test_matrix <- as.data.frame(as.matrix(test_dtm)) # Convert to DF
test_matrix$sentiment <- test_data$sentiment # Ensure Sentiment (for comparison)

head(train_matrix[,c(1:5)])

################################################################################
# Train Naive Bayes
################################################################################

nb_model <- e1071::naiveBayes(sentiment ~ ., data = train_matrix) # Run NB Model

head(nb_model$tables) # Likelihood of Word Being Absent [,1] or Present [,2] Given a Class (+/-)

################################################################################
# Make Predictions on Test (Unseen) Data
################################################################################

predictions <- predict(nb_model, newdata = test_matrix) # Make Predictions on Test Data

mean(predictions == test_matrix$sentiment) # Performance Accuracy

################################################################################
# Confusion Matrix
################################################################################

table(Predicted = predictions, Actual = test_matrix$sentiment) # Confusion Matrix
