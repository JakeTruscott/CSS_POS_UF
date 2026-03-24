################################################################################
# Class 8 - Clustering and Topic Assignment
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated March 2026
################################################################################

################################################################################
# Packages & Libraries
# note: install.packages('PACKAGE') if not already installed
################################################################################

library(dplyr); library(ggplot2); library(stringr);  library(tm); library(quanteda); library(quanteda.textstats); library(quanteda.textstats); library(rvest); library(tibble); library(tidytext)


reduce_complexity <- function(text){
  text <- tolower(text) # Lower Case
  text <- tm::removePunctuation(text) # Punctuation
  text <- tm::removeNumbers(text) # Numbers
  text <- tm::removeWords(text, tm::stopwords("english")) # Stop Words
  text <- unlist(stringr::str_split(text, '\\s+')) # Tokenize
  text <- textstem::lemmatize_words(text) # Lemmatize
  text <- paste(text, collapse = ' ') # Re-Append
  text <- gsub("\\s{2,}", ' ', text) # 2 or More Spaces --> One Space
  text <- trimws(text) # White Space
  return(text)
} # Function to Process Text for Bag of Words

################################################################################
# K-Means Clustering - Numeric
################################################################################

data <- iris %>%
  rename(sepal_length = Sepal.Length,
         sepal_width = Sepal.Width,
         petal_length = Petal.Length,
         petal_width = Petal.Width) %>%
  select(sepal_length, sepal_width, petal_length, petal_width)

kmeans_example <- kmeans(data, # Iris Data
                         centers = 3, # Cluster Centers (3 Defined)
                         nstart = 25) # No. Independent Runs

kmeans_example$tot.withinss # Within-Cluster Sum of Squares (Dispersion Measure)

k_means_fig_3 <- data %>%
  mutate(cluster = factor(kmeans_example$cluster)) %>%
  ggplot(aes(x = sepal_length, y = sepal_width, color = cluster)) +
  geom_point() +
  theme_minimal() +
  labs(x = '\nSepal Width',
       y = 'Sepal Length\n',
       colour = 'Cluster Assignment',
       title = paste0('3 Cluster Centers (Within-Cluster Sum of Squares = ', round(kmeans_example$tot.withinss, 2), ')')) +
  theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
        title = element_text(size = 5, colour = 'black'),
        legend.position = 'bottom',
        legend.background = element_rect(linewidth = 1, colour = 'black', fill = NA),
        legend.title.position = 'top',
        legend.title = element_text(size = 12, hjust = 0.5),
        legend.text = element_text(size = 10))

kmeans_example_4 <- kmeans(data, # Iris Data
                           centers = 4, # Cluster Centers (4 Defined)
                           nstart = 25) # No. Independent Runs

k_means_fig_4 <- data %>%
  mutate(cluster = factor(kmeans_example_4$cluster)) %>%
  ggplot(aes(x = sepal_length, y = sepal_width, color = cluster)) +
  geom_point() +
  theme_minimal() +
  labs(x = '\nSepal Width',
       y = 'Sepal Length\n',
       colour = 'Cluster Assignment',
       title = paste0('4 Cluster Centers (Within-Cluster Sum of Squares = ', round(kmeans_example_4$tot.withinss, 2), ')')) +
  theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
        title = element_text(size = 5, colour = 'black'),
        legend.position = 'bottom',
        legend.background = element_rect(linewidth = 1, colour = 'black', fill = NA),
        legend.title.position = 'top',
        legend.title = element_text(size = 12, hjust = 0.5),
        legend.text = element_text(size = 10))


cowplot::plot_grid(k_means_fig_3, k_means_fig_4) # 3 v. 4


k_means_fig_5 <- data %>%
  mutate(cluster = factor(kmeans_example_5$cluster)) %>%
  ggplot(aes(x = sepal_length, y = sepal_width, color = cluster)) +
  geom_point() +
  theme_minimal() +
  labs(x = '\nSepal Width',
       y = 'Sepal Length\n',
       colour = 'Cluster Assignment',
       title = paste0('5 Cluster Centers (Within-Cluster Sum of Squares = ', round(kmeans_example_5$tot.withinss, 2), ')')) +
  theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
        title = element_text(size = 5, colour = 'black'),
        legend.position = 'bottom',
        legend.background = element_rect(linewidth = 1, colour = 'black', fill = NA),
        legend.title.position = 'top',
        legend.title = element_text(size = 12, hjust = 0.5),
        legend.text = element_text(size = 10))


cowplot::plot_grid(k_means_fig_4, k_means_fig_5) # 4 v. 5

################################################################################
# K-Means Clustering - Text
################################################################################

imdb_data <- imdb_data$text[1:500] # Only First 500 Rows
imdb_data <- iconv(imdb_data, from = "UTF-8", to = "UTF-8", sub = "") # Fixing Some Characters in IMDB Data
corpus <- VCorpus(VectorSource(sapply(imdb_data, reduce_complexity)))
dtm <- DocumentTermMatrix(corpus, control = list(weighting = weightTfIdf)) # TF-IDF DTM
dtm <- removeSparseTerms(dtm, 0.95)  # (Optional) Reducing Further Sparsity
dtm_matrix <- as.matrix(dtm) # Convert DTM Matrix for K-Means

kmeans_example_3_centers <- kmeans(dtm_matrix, centers = 3, nstart = 25)

kmeans_example_3_centers$tot.withinss

kmeans_example_10_centers <- kmeans(dtm_matrix, centers = 10, nstart = 25)

kmeans_example_10_centers$tot.withinss


pca <- prcomp(dtm_matrix, scale. = TRUE)
pca_data_3 <- data.frame(x = pca$x[,1], y = pca$x[,2], cluster = factor(kmeans_example_3_centers$cluster))

pca_data_10 <- data.frame(x = pca$x[,1], y = pca$x[,2], cluster = factor(kmeans_example_10_centers$cluster))


cowplot::plot_grid(

  a <- pca_data_3 %>%
    ggplot(aes(x = x, y = y, color = cluster)) +
    geom_point() +
    theme_minimal() +
    labs(x = '\nPCA Dim-1',
         y = 'PCA Dim-2\n',
         colour = 'Cluster Assignment',
         title = paste0('3 Cluster Centers (Within-Cluster Sum of Squares = ', round(kmeans_example_3_centers$tot.withinss, 2), ')')) +
    theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
          title = element_text(size = 5, colour = 'black'),
          legend.position = 'none'),

  b <- pca_data_10 %>%
    ggplot(aes(x = x, y = y, color = cluster)) +
    geom_point() +
    theme_minimal() +
    labs(x = '\nPCA Dim-1',
         y = 'PCA Dim-2\n',
         colour = 'Cluster Assignment',
         title = paste0('10 Cluster Centers (Within-Cluster Sum of Squares = ', round(kmeans_example_10_centers$tot.withinss, 2), ')')) +
    theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
          title = element_text(size = 5, colour = 'black'),
          legend.position = 'none')


)


################################################################################
# LDA
################################################################################

library(topicmodels)
data("AssociatedPress")
dtm <- AssociatedPress

lda_model <- LDA(dtm, k = 5, method = "Gibbs", control = list(seed = 1234)) # LDA w/ 5 Topics & Gibbs Sampling
topicmodels::terms(lda_model, 10)

topic_probs <- posterior(lda_model)$topics # Prob Document i Belongs to Topic K
print(round(topic_probs[c(1:10), c(1:5)], 2))

word_probs <- posterior(lda_model)$terms # Prob Word J in Topic K
head(round(word_probs[, 1:5], 5))



################################################################################
# STM
################################################################################

texts <- apply(AssociatedPress, 1, function(x) {
  paste(rep(colnames(AssociatedPress), x), collapse = " ")
})

texts_reduced <- vapply(texts, reduce_complexity, character(1))

corpus_reduced <- VCorpus(VectorSource(texts_reduced))

dtm_reduced <- DocumentTermMatrix( corpus_reduced,
                                   control = list(wordLengths = c(1, Inf))
)

dfm_ap <- as.dfm(dtm_reduced)

docs_stm <- convert(dfm_ap, to = "stm") # STM Structure

meta <- data.frame(dummy = rep(1, length(docs_stm$documents))) # Document Meta

stm_model <- stm::stm(
  documents  = docs_stm$documents,
  vocab      = docs_stm$vocab,
  K          = 5,
  prevalence = ~1,
  data       = meta,
  init.type  = "Spectral",
  seed       = 1234,
  max.em.its = 500,
  verbose    = FALSE
)

stm::labelTopics(stm_model, n = 10) # Top Words/Topic

proportions <- stm_model$theta # Document-Topic Proportions
round(proportions[1:10, ], 2)

topic_word_probs <- exp(stm_model$beta$logbeta[[1]]) #Topic Word Probabilities
head(round(topic_word_probs[,1:5], 5))

stm_model <- stm::stm(
  documents  = docs_stm$documents,
  vocab      = docs_stm$vocab,
  K          = 5,
  prevalence = ~1,
  data       = meta,
  init.type  = "Spectral",
  seed       = 1234,
  max.em.its = 500,
  verbose    = FALSE
)

stm::labelTopics(stm_model, n = 10) # Top Words/Topic

proportions <- stm_model$theta # Document-Topic Proportions
round(proportions[1:10, ], 2)

topic_word_probs <- exp(stm_model$beta$logbeta[[1]]) #Topic Word Probabilities
head(round(topic_word_probs[,1:5], 5))

topic_word_probs <- exp(stm_model$beta$logbeta[[1]]) #Topic Word Probabilities
head(round(topic_word_probs[,1:5], 5))


