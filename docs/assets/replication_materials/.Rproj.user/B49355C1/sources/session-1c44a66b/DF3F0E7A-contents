################################################################################
# Class 6 - Modeling the Bag of Words
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated February 2026
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
# Dictionaries
################################################################################

dictionary <- list(Positive = c("good", "great", "excellent", "benefit", "success"),
                   Negative = c("bad", "poor", "failure", "harm", "risk"),
                   Neutral  = c("okay", "average", "fine", "moderate")) # Dictionary as List

dictionary[['Positive']] # Sample


sample_text <- reduce_complexity('The project had some success but also some risk') # Reduce Complexity
print(sample_text) # Print Sample

sapply(dictionary, function(categories) sum(strsplit(sample_text, "\\W+")[[1]] %in% categories)) # Apply


bing_dictionary <- tidytext::get_sentiments("bing") # Grab Dictionary

bing_dictionary %>%
  group_by(sentiment) %>%
  slice_sample(n = 3) %>%
  ungroup() %>%
  arrange(sentiment) # 3 Word Sample of Each



strings <- c('This decision is excellent, fair, and clearly the right outcome',
             'The opinion is good and persuasive, even if it is not perfect',
             'The ruling has some good points but also several serious flaws',
             'The decision is bad and poorly reasoned',
             'This opinion is terrible, deeply unfair, and completely wrong')

strings <- sapply(strings, function(x) reduce_complexity(x), USE.NAMES = FALSE)
print(strings)



strings <- tibble(
  doc_id = seq_along(strings),
  text = strings)

strings_tokens <- strings %>% # Convert to tibble
  tidytext::unnest_tokens(word, text) # Convert to Unnested Tokens

head(strings_tokens)


strings_tokens %>%
  inner_join(tidytext::get_sentiments("bing"), by = "word") %>% # Get Sentiment
  group_by(doc_id, sentiment) %>%
  summarise(n = n(), # Total Word Matches
            words = paste(word, collapse = ", "), # Combine Word matches
            .groups = "drop") %>%
  left_join(strings, by = "doc_id") %>% # Add Back Original Text
  select(doc_id, text, sentiment, n, words) # Apply BING


set.seed(123)
afinn_dictionary <- tidytext::get_sentiments("afinn") # Afinn Dictionary

afinn_dictionary %>%
  group_by(value) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  arrange(value) %>%
  select(value, word) %>%
  { setNames(.$word, .$value) } # Sample Words (Value -5 to 5)


strings_tokens %>%
  inner_join(tidytext::get_sentiments(lexicon = 'afinn'), by = 'word') %>%
  group_by(doc_id, value) %>%
  summarise(n = n(), # Total Word Matches
            words = paste(word, collapse = ", "), # Combine Word matches
            .groups = "drop") %>%
  left_join(strings, by = "doc_id") %>% # Add Back Original Text
  select(doc_id, text, value, n, words)


strings %>%
  mutate(sentiment = sentimentr::sentiment_by(text)$ave_sentiment) # Apply SentimentR


strings <- c("The recent peace agreement between the two nations is a remarkable step toward stability",
             "The summit produced some promising proposals, though implementation will take time",
             "The delegation met to discuss ongoing trade negotiations without reaching a conclusion",
             "The sanctions imposed by the council are likely to harm the civilian population disproportionately",
             "The military escalation is a disastrous and reckless move that threatens global security")

strings <- sapply(strings, function(x) reduce_complexity(x))
strings <- unname(strings)
attributes(strings) <- NULL
strings <- tibble(
  doc_id = seq_along(strings),
  text = strings)

strings_tokens <- strings %>% # Convert to tibble
  tidytext::unnest_tokens(word, text) # Convert to Unnested Tokens

bing <- strings_tokens %>%
  inner_join(tidytext::get_sentiments("bing"), by = "word") %>% # Get Sentiment
  group_by(doc_id, sentiment) %>%
  summarise(n = n(), # Total Word Matches
            words = paste(word, collapse = ", "), # Combine Word matches
            .groups = "drop") %>%
  left_join(strings, by = "doc_id") %>% # Add Back Original Text
  select(doc_id, text, sentiment, n, words) # Apply BING

afinn <- strings_tokens %>%
  inner_join(tidytext::get_sentiments(lexicon = 'afinn'), by = 'word') %>%
  group_by(doc_id, value) %>%
  summarise(n = n(), # Total Word Matches
            words = paste(word, collapse = ", "), # Combine Word matches
            .groups = "drop") %>%
  left_join(strings, by = "doc_id") %>% # Add Back Original Text
  select(doc_id, text, value, n, words)

sentimentr <- strings %>%
  mutate(sentiment = sentimentr::sentiment_by(text)$ave_sentiment) # Apply SentimentR


################################################################################
# Multinomial Language Model
# Federalist Papers -- Partition & Clean Data
################################################################################

fed_papers <- read_html('https://www.gutenberg.org/cache/epub/18/pg18-images.html')
essays <- html_elements(fed_papers, '.chapter')
text <- html_text2(essays)
text <- tibble(text)
federalist <- text %>%
  filter(stringr::str_detect(text, 'slightly different version', negate = TRUE)) %>%
  mutate(author = text %>%
           str_extract('HAMILTON AND MADISON|HAMILTON OR MADISON|HAMILTON|MADISON|JAY') %>%
           str_to_title(),
         title = str_extract(text, 'No. [A-Z].*')) # Clean & Partition

tidy_federalist <- federalist %>%
  tidytext::unnest_tokens(input = 'text',
                output = 'word') # Tokenize at Word

interesting_words <- c('by', 'man', 'upon', 'heretofore', 'whilst' ) # Vocabulary

tidy_federalist_51 <- filter(tidy_federalist,
                             word %in% interesting_words) %>%
  filter(title == 'No. LI.') # Grab Words in interesting_words from Fed 51


tidy_federalist_10 <- filter(tidy_federalist,
                             word %in% interesting_words) %>%
  filter(title == 'No. X.') # Same from 10


tidy_federalist <- filter(tidy_federalist,
                          word %in% interesting_words) %>%
  filter(author %in% c('Hamilton', 'Jay', 'Madison'))

tidy_federalist %>%
  count(author, word) %>%
  tidyr:: pivot_wider(names_from = author,values_from = n, values_fill = 0) %>%
  {
    wide <- .
    bind_rows(
      wide,
      wide %>%
        select(-word) %>%
        summarise(across(everything(), sum)) %>%
        mutate(word = "TOTAL") %>%
        select(word, everything()))
  } # Print Counts of Interesting Words


#####################################################
# Federalist 51 -- Multinom w/ Laplace Smoothing
#####################################################

federalist_51_counts <- tidy_federalist_51 %>%
  mutate(word = factor(word)) %>%
  count(word, .drop = FALSE) %>%
  setNames(c('word', 'count'))

federalist_51_vector <- rep(0, length(interesting_words))
names(federalist_51_vector) <- interesting_words

for (i in 1:nrow(federalist_51_counts)){
  temp_row <- federalist_51_counts[i,]
  federalist_51_vector[[as.character(temp_row$word)]] <- temp_row$count
}

author_vectors <- list()
author_tidy_federalist <- tidy_federalist %>%
  count(author, word) %>%
  tidyr:: pivot_wider(names_from = author,values_from = n, values_fill = 0) %>%
  {
    wide <- .
    bind_rows(
      wide,
      wide %>%
        select(-word) %>%
        summarise(across(everything(), sum)) %>%
        mutate(word = "TOTAL") %>%
        select(word, everything()))
  } # Print Counts of Interesting Words

hamilton_likelihood <- dmultinom(x = federalist_51_vector, prob = author_vectors[['Hamilton']] + 1)

madison_likelihood <- dmultinom(x = federalist_51_vector, prob = author_vectors[['Madison']] + 1)

jay_likelihood <- dmultinom(x = federalist_51_vector, prob = author_vectors[['Jay']] + 1)


data.frame(Author = c('Hamilton', 'Madison', 'Jay'),
           Likelihood = c(hamilton_likelihood, madison_likelihood, jay_likelihood))

madison_likelihood/jay_likelihood # Likelihood Ratio of Madison v. Jay
madison_likelihood/hamilton_likelihood # Likelihood Ratio of Madison v. Hamilton



#####################################################
# Robustness - Federalist 10 (Madison For Sure Author)
#####################################################

federalist_10_counts <- tidy_federalist_10 %>%
  mutate(word = factor(word)) %>%
  count(word, .drop = FALSE) %>%
  setNames(c('word', 'count'))

federalist_10_vector <- rep(0, length(interesting_words))
names(federalist_10_vector) <- interesting_words

for (i in 1:nrow(federalist_10_counts)){
  temp_row <- federalist_10_counts[i,]
  federalist_10_vector[[as.character(temp_row$word)]] <- temp_row$count
}

author_vectors <- list()
author_tidy_federalist <- tidy_federalist %>%
  count(author, word) %>%
  tidyr:: pivot_wider(names_from = author,values_from = n, values_fill = 0) %>%
  {
    wide <- .
    bind_rows(
      wide,
      wide %>%
        select(-word) %>%
        summarise(across(everything(), sum)) %>%
        mutate(word = "TOTAL") %>%
        select(word, everything()))
  } # Print Counts of Interesting Words


for (i in c('Hamilton', 'Madison', 'Jay')){

  temp_federalist_10_vector <- rep(0, length(interesting_words))
  names(temp_federalist_10_vector) <- interesting_words
  temp_values <- tidy_federalist %>%
    filter(author == i) %>%
    count(author, word) %>%
    tidyr:: pivot_wider(names_from = author,values_from = n, values_fill = 0) %>%
    setNames(c('word', 'count'))
  temp_vector <- temp_federalist_10_vector
  temp_vector[match(temp_values$word, names(temp_vector))] <- temp_values$count


  author_vectors[[as.character(i)]] <- temp_vector

}

hamilton_likelihood <- dmultinom(x = federalist_10_vector,
                                 prob = author_vectors[['Hamilton']] + 1)

madison_likelihood <- dmultinom(x = federalist_10_vector,
                                prob = author_vectors[['Madison']] + 1)

jay_likelihood <- dmultinom(x = federalist_10_vector,
                            prob = author_vectors[['Jay']] + 1)


madison_likelihood/jay_likelihood # Madison vs. Jay
madison_likelihood/hamilton_likelihood # Madison v. Hamilton


####################################################
#TF-IDF
#####################################################

text <- html_text2(essays)
text <- tibble(text)
federalist <- text %>%
  filter(stringr::str_detect(text, 'slightly different version', negate = TRUE)) %>%
  mutate(author = text %>%
           str_extract('HAMILTON AND MADISON|HAMILTON OR MADISON|HAMILTON|MADISON|JAY') %>%
           str_to_title(),
         title = str_extract(text, 'No. [A-Z].*')) # Clean & Partition

tidy_federalist <- federalist %>%
  tidytext::unnest_tokens(input = 'text',
                          output = 'word') # Tokenize at Word

tidy_federalist_clean <- tidy_federalist %>%
  filter(!word %in% interesting_words) %>%
  filter(str_detect(word, "[a-z]"))

tf_author <- tidy_federalist_clean %>%
  count(author, word, sort = TRUE)

tfidf_author <- tf_author %>%
  bind_tf_idf(term = word, document = author, n = n)

top_words <- tfidf_author %>%
  group_by(author) %>%
  slice_max(tf_idf, n = 50) %>%  # top 50 words per author
  ungroup()

top_hamilton <- top_words %>% filter(author == "Hamilton")


wordcloud::wordcloud(words = top_hamilton$word,
                     freq = top_hamilton$n,
                     vfont=c("serif","plain")) # No TF-IDF


wordcloud::wordcloud(words = top_hamilton$word,
                     freq = top_hamilton$tf_idf,
                     vfont=c("serif","plain")) # TF-IDF
