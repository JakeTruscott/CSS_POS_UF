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
