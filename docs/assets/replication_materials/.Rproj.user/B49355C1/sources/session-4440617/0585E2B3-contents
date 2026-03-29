################################################################################
# Class 9 - Distributed Representations of Words
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated March 2026
################################################################################

################################################################################
# Packages & Libraries
# note: install.packages('PACKAGE') if not already installed
################################################################################

library(dplyr); library(ggplot2); library(stringr);  library(tm); library(quanteda); library(quanteda.textstats); library(quanteda.textstats); library(rvest); library(tibble); library(tidytext); library(word2vec); library(Rtsne)


reduce_complexity <- function(text) {
  text <- tolower(text)
  text <- gsub("[^a-z\\s]", " ", text)
  words <- unlist(str_split(text, "\\s+"))
  words <- words[words != "" & !words %in% tm::stopwords("english")]
  words <- textstem::lemmatize_words(words)
  words <- words[str_detect(words, "^[a-z]+$")]
  text <- str_squish(paste(words, collapse = " "))
  return(text)
}


################################################################################
# word2vec
################################################################################

set.seed(1234) # Set Seed
download.file("https://raw.githubusercontent.com/JakeTruscott/CSS_POS_UF/refs/heads/main/docs/assets/replication_materials/class_7/data/imdb_train_pos.rdata", destfile = file.path('data', 'class_9', 'imdb_train_pos.rdata')) # Download IMDB Data
download.file("https://raw.githubusercontent.com/JakeTruscott/CSS_POS_UF/refs/heads/main/docs/assets/replication_materials/class_7/data/imdb_train_neg.rdata", destfile = file.path('data', 'class_9', 'imdb_train_neg.rdata')) # Download IMDB Data


imdb <- bind_rows(get(load('data/class_9/imdb_train_pos.rdata')),
                  get(load('data/class_9/imdb_train_neg.rdata'))) %>%
  dplyr::sample_n(10000) # Sample 1000


reviews = sapply(imdb, reduce_complexity) # Text from IMDB Reviews Dataset

cbow_model = word2vec(x = reviews, # IMDB Text
                      type = "cbow", # Cont. Bag of Words
                      dim = 15, # 15 Dimensions
                      iter = 20) # 20 Iterations (max)

cbow_lookslike <- predict(cbow_model, c("terrible", "incredible"), type = "nearest", top_n = 5)
print(cbow_lookslike)

cbow_embedding <- predict(cbow_model, c("terrible", "incredible"),type = "embedding")
print(cbow_embedding)

word_vectors <- as.matrix(cbow_model) # Convert Model to Matrix
similar_words <- unique(c(c("terrible", "incredible") , unlist(predict(cbow_model, c("terrible", "incredible") , type = "nearest", top_n = 10))))
word_vec_subset <- word_vectors[rownames(word_vectors) %in% similar_words, ] # Filter to Similar Words

set.seed(123) # Set Random Seed

tsne_out <- invisible(Rtsne(
  word_vec_subset, # Subset of Similar Words
  dims = 2,  # 2 Dimensions
  perplexity = 5,
  verbose = FALSE,
  max_iter = 500
))

data.frame(word = rownames(word_vec_subset),
           dim_1 = tsne_out$Y[,1],
           dim_2 = tsne_out$Y[,2]) %>%
  ggplot(aes(x = dim_1, y = dim_2, label = word)) +
  geom_point(colour = 'black', size = 3) +
  geom_text(vjust = -0.75, hjust = 0.5, size = 3.5) +
  default_ggplot_theme # Visualize
