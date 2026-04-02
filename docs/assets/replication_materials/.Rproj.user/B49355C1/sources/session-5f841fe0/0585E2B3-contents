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



################################################################################
# SBERT
################################################################################

library(reticulate) # Activate Reticulate
virtualenv_create()# Create  Virtual Environment (If Needed)

use_virtualenv(required = TRUE) # Activate Environment

required_packages <- c("torch", "transformers", "sentence-transformers")
for (pkg in required_packages) {
  if (!py_module_available(pkg)) {
    virtualenv_install(packages = pkg)
  }
} # Install torch, transformers, and sentence-transformers (if needed)

transformers <- import('transformers')
tokenizer <- transformers$AutoTokenizer$from_pretrained("bert-base-uncased") # BERT Tokenzier
model <- transformers$AutoModel$from_pretrained("bert-base-uncased") # BERT Model

words <- c('dog', 'cat', 'horse', 'pig', 'firetruck')# Same Words as Earlier

get_embedding <- function(text) {
  inputs <- tokenizer(text, return_tensors = "pt") # Convert Word to BERT-input
  outputs <- model(input_ids = inputs$input_ids, # Assign Tensor ID
                   attention_mask = inputs$attention_mask) # Tell BERT Real v. Padding Tokens
  last_hidden <- outputs$last_hidden_state # Extract Embeddings ([batch_size, sequence_length, hidden_size])
  embedding <- last_hidden$mean(dim = 1L)$squeeze() # Mean Pool Across Tokens
  return(embedding$detach()$numpy())
} # Looks Up Word Embedding, Passes Through Transformer Layers, and Applies Self-Attention

embeddings_list <- lapply(words, get_embedding) # Apply get_embedding
embeddings <- do.call(rbind, embeddings_list) # Recove Embeddings

n <- length(words)
cosine_sim_matrix <- matrix(nrow = length(words), ncol = length(words))
rownames(cosine_sim_matrix) <- colnames(cosine_sim_matrix) <- words

for (i in 1:n) {
  for (j in 1:n) {
    cosine_sim_matrix[i, j] <- cosine_similarity(embeddings[i, ], embeddings[j, ])
  }
} # Recover Cosine Sim for Each Word Pair


as.data.frame(cosine_sim_matrix) %>%
  mutate(Word1 = rownames(cosine_sim_matrix)) %>%
  tidyr::pivot_longer(cols = -Word1, names_to = "Word2", values_to = "CosineSim") %>%
  ggplot(aes(x = Word1, y = Word2, fill = CosineSim)) +
  geom_tile(colour = 'black') +
  geom_text(aes(label = round(CosineSim, 3))) +
  labs(x = '', y = '', title = 'Cosine Similarity of Words -- BERT') +
  scale_fill_gradient(low = "white", high = "steelblue") +
  default_ggplot_theme +
  theme(legend.position = 'none')


################################################################################
# SBERT (Optimized for Sentences)
################################################################################

library(reticulate) # Activate Reticulate
virtualenv_create()# Create  Virtual Environment (If Needed)

use_virtualenv(required = TRUE) # Activate Environment

required_packages <- c("torch", "transformers", "sentence-transformers", 'util')
for (pkg in required_packages) {
  if (!py_module_available(pkg)) {
    virtualenv_install(packages = pkg)
  }
} # Install torch, transformers, and sentence-transformers (if needed)

set.seed(1234) # Set Seed

imdb <- imdb %>%
  dplyr::sample_n(10000) %>%
  dplyr::sample_n(100) %>%
  mutate(row_id = row_number()) # IMDB (Reload if Necessary...)

sentences <- imdb %>%
  select(row_id, text, sentiment) # Sentences from IMDB

sentences_pairwise <- expand.grid(row_i = sentences$row_id,
              row_j = sentences$row_id) %>%
  filter(row_i != row_j) %>%  # remove self-pairs
  left_join(sentences, by = c("row_i" = "row_id")) %>%
  rename(text_i = text) %>%
  left_join(sentences, by = c("row_j" = "row_id")) %>%
  rename(text_j = text) %>%
  rename(sentiment_i = sentiment.x,
         sentiment_j = sentiment.y) # Create Pairwise DF

sentence_transformers <- import("sentence_transformers") # Import sentence-transformers
util <- import("sentence_transformers.util") # Util Package

model_name = "sentence-transformers/all-MiniLM-L6-v2" # SBERT
model <- sentence_transformers$SentenceTransformer(model_name) # Declare Model (SBERT)

embeddings <- model$encode(sentences$text) # Convert Sentences to Embeddings
cosine_sim <- data.frame() # Output DF


for (i in 1:nrow(sentences_pairwise)){

  temp_row <- sentences_pairwise[i,] # Temp Row
  i_embeddings <- embeddings[temp_row$row_i,] # i embedding
  j_embeddings <- embeddings[temp_row$row_j,] # j embedding
  temp_similarity <- util$cos_sim(i_embeddings, j_embeddings)$item() # Cosine Sim

  cosine_sim <- bind_rows(cosine_sim,
                          data.frame(temp_row, similarity = temp_similarity)) # Export

  if (i %% 500 == 0){
    message('Completed ', i, '/', nrow(sentences_pairwise))
  }

}

top_3 <- cosine_sim %>%
  arrange(desc(similarity)) %>%
  slice_head(n = 3) # 5 Most Sim

top_3$text_i[1]
top_3$text_j[1]
top_3$similarity[1]


bottom_3 <- cosine_sim %>%
  arrange(similarity) %>%
  slice_head(n = 3) %>%
  arrange(desc(similarity)) # 5 Least Sim

bottom_3$text_i[1]
bottom_3$text_j[1]
bottom_3$similarity[1]








