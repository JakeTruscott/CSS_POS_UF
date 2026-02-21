################################################################################
# Class 5 - The Bag of Words
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated February 2026
################################################################################

################################################################################
# Packages & Libraries
# note: install.packages('PACKAGE') if not already installed
################################################################################

library(dplyr); library(ggplot2); library(stringr);  library(tm); library(quanteda); (quanteda.textstats); library(quanteda.textstats)


################################################################################
# Example -- SOTU Addresses
################################################################################

library(sotu) # Load SOTU Dataset

sotu_info <-  sotu::sotu_meta %>%
  filter(president %in% c('Dwight D. Eisenhower', 'George Bush')) # Get Info for Eisenhower and H.W.

head(sotu_info) # Print Head

indices <- c(sotu_info$X) # Indices to Partition sotu_text

sotu_eisenhower_bush <- setNames(
  lapply(seq_len(nrow(sotu_info)), function(i) {
    cbind(sotu_info[i, ], text = sotu::sotu_text[[indices[i]]])
  }),
  paste0(sotu_info$president, " (", sotu_info$year, ")")
) # Nest Each Speech in List

names(sotu_eisenhower_bush) # Print Names


military_words_regex <- paste0('(', paste(c('military', 'army', 'navy', 'marines', 'air force'),
                                          collapse = '|'), ')') # "Military" Words Regex


for (speech in 1:length(sotu_eisenhower_bush)){
  temp_speech <- sotu_eisenhower_bush[[speech]]
  temp_speech <- data.frame(stringr::str_split(temp_speech$text, pattern = '\\n')) %>%
    setNames('text') %>%
    filter(!text == '') # Grab Speech -- Partition to Sentences

  sotu_eisenhower_bush[[speech]]$text <- list(temp_speech) # Append Back to Original


  military_sentences <- temp_speech %>%
    filter(grepl(military_words_regex, text, ignore.case = T)) # All Sentences w/ "Military" Words

  sotu_eisenhower_bush[[speech]]$military_text <- list(military_sentences) # Append

} # Process Speeches & Isolate "Military" Sentences

for (speech in 1:length(sotu_eisenhower_bush)){
  temp_speech_name <- names(sotu_eisenhower_bush[speech])
  military_sentences <- length(unlist(sotu_eisenhower_bush[[speech]]$military_text))
  cat(temp_speech_name, ' -- ', military_sentences, ' Sentences \n')
} # Prints # of "Military" Sentences Per Speech

unlist(sotu_eisenhower_bush[[14]]$military_text) # Bush 1992 -- Print Example

military_speeches <- data.frame()

for (i in 1:length(sotu_eisenhower_bush)){
  temp_military <- unlist(sotu_eisenhower_bush[[i]]$military_text)
  if (length(temp_military) == 0){
    next
  }
  temp_speech <- names(sotu_eisenhower_bush[i])
  temp_df <- data.frame(speech = temp_speech,
                        military_text = temp_military)
  military_speeches <- bind_rows(military_speeches, temp_df)
} # Combine to Single DF


military_speeches$president <- ifelse(grepl("Eisenhower", military_speeches$speech),
                                      "Eisenhower", "Bush") # Add President ID

head(military_speeches)


################################################################################
# Complexity Reduction
################################################################################


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


military_speeches$military_text[1] # Print Regular Text

reduce_complexity(military_speeches$military_text[1]) # Processed Text Example


################################################################################
# Document Frequency Matrix
################################################################################

military_speeches <- military_speeches %>%
  mutate(military_text_clean = sapply(military_text, reduce_complexity)) # Apply Complexity Reduction

sotu_corpus <- quanteda::corpus(military_speeches, text_field = "military_text_clean") # Convert to Corpus Object

sotu_tokens <- quanteda::tokens(sotu_corpus) # Recover Tokens from Corpus Object

sotu_dfm <- dfm(sotu_tokens) %>%
  dfm_trim(min_termfreq = 2)  # Convert to DFM -- Remove Words w/ Less Than 2 Appearances

topfeatures(sotu_dfm, 20) # 20-top Features (Words)

################################################################################
# Visualizing the DFM
################################################################################

###################################
# Heatmap
###################################

sotu_dfm_reduced <- sotu_dfm[, names(topfeatures(sotu_dfm, 10))] # Filter to Top-20 Terms
speech_labels <- docvars(sotu_dfm_reduced, "speech")

sotu_dfm_reduced %>%
  quanteda::convert(to = "data.frame") %>% # Convert DFM to DF
  mutate(speech = speech_labels) %>% # Append Speech Labels
  tidyr::pivot_longer(cols = -c(doc_id, speech), names_to = "term", values_to = "frequency") %>%
  ggplot(aes(x = term, y = speech, fill = frequency)) +
  geom_tile(colour = 'grey') +
  geom_label(aes(label = frequency)) +
  scale_fill_gradient(low = "white", high = "deepskyblue4") +
  theme_minimal() +
  labs(x = "\nTerm", y = "Speech\n") +
  default_ggplot_theme +
  theme(axis.text.x = element_text(angle = 45))


###################################
# Top Terms Bar Chart
###################################

top_terms <- topfeatures(sotu_dfm, 20)

sotu_bar_df <- data.frame(term = names(top_terms),
                     frequency = as.numeric(top_terms))

sotu_bar_df %>%
  ggplot(aes(x = frequency, y = reorder(term, frequency))) +
  geom_col(fill = 'grey', colour = 'black') +
  labs(x = '\nFrequency', y = 'Term\n') +
  geom_vline(xintercept =  0) +
  scale_x_continuous(breaks = seq(25, 150, 25)) +
  default_ggplot_theme


###################################
# Terms Bar Chart by President
###################################

sotu_term_freq <- textstat_frequency(sotu_dfm, group = president)

sotu_term_freq %>%
  group_by(group) %>%
  slice_max(frequency, n = 10) %>% # Take top-10 Terms
  ggplot(aes(y = reorder(feature, frequency), x = frequency)) +
  geom_col(aes(fill = group), colour = 'black', position = position_dodge()) +
  scale_x_continuous(breaks = seq(25, 125, 25)) +
  geom_vline(xintercept = 0) +
  default_ggplot_theme


###################################
# Wordcloud
###################################

quanteda.textplots::textplot_wordcloud(dfm_group(sotu_dfm, groups = military_speeches$president) , comparison = TRUE, max_words = 100,
                                       color = c("blue", "red"), labelsize = 0.75, fixed_aspect = TRUE,
labeloffset = F)
