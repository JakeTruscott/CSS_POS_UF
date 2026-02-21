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
# Federalist Papers
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
