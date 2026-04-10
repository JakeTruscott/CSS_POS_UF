################################################################################
# Class 10 - Text Models for Ideology
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated March 2026
################################################################################

################################################################################
# Packages & Libraries
# note: install.packages('PACKAGE') if not already installed
################################################################################

library(dplyr); library(ggplot2); library(stringr);  library(tm); library(quanteda); library(quanteda.textstats); library(quanteda.textstats); library(rvest); library(tibble); library(tidytext); library(word2vec); library(Rtsne); library(wordshoal)


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


default_ggplot_theme  <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 12),
    axis.title = element_text(size = 12, colour = 'black'),
    axis.text = element_text(size = 10, colour = 'black'),
    panel.background = element_rect(linewidth = 1, colour = 'black', fill = NA),
    legend.position = 'bottom',
    legend.title = element_blank(),
    legend.background = element_rect(linewidth = 1, colour = 'black', fill = NA),
  )


################################################################################
# Basic Scaling Representation Example
################################################################################

df <- data.frame(p = seq(-2, 2, 1),
                 names = c('Very\nLeft', 'Left', 'Moderate', 'Right', 'Very\nRight'))

df %>%
  mutate(names = factor(names, levels = c('Very\nLeft', 'Left', 'Moderate', 'Right', 'Very\nRight'))) %>%
  ggplot(aes(x = p, y = 0)) +
  geom_vline(xintercept = 0, linetype = 2, alpha = 1/3) +
  geom_segment(aes(x = -2, xend = 2, y = 0, yend = 0), size = 1, colour = 'black') +
  geom_text(aes(label = names, y = 0.015)) +
  geom_point(aes(x = p, y = 0, fill = factor(names)), colour = 'black', size = 3, shape = 21) +
  scale_y_continuous(expand = c(0, 0), limits = c(-0.1, 0.1)) +
  scale_fill_manual(values = c('deepskyblue', 'deepskyblue', 'white', 'coral3', 'coral3')) +
  theme_minimal() +
  theme(
    panel.background = element_rect(size = 1, colour = 'black', fill = NA),
    panel.grid = element_blank(),
    axis.text.y = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_text(size = 12, colour = 'black'),
    axis.ticks.y = element_blank(),
    legend.position = 'none'
  )

################################################################################
# Visualizing Wordscores
################################################################################

ggplot() +
  geom_vline(xintercept = 0, linetype = 2, alpha = 1/3) +
  geom_segment(aes(x = -1, xend = 1, y = 0, yend = 0),
               linewidth = 1, colour = 'black') +
  geom_point(aes(x = -0.458, y = 0),
             size = 5, shape = 21, colour = 'blue', fill = 'black') +
  geom_point(aes(x = -1, y = 0),
             size = 5, shape = 21, colour = 'black', fill = 'blue') +
  geom_point(aes(x = 1, y = 0),
             size = 5, shape = 21, colour = 'black', fill = 'red') +
  geom_text(aes(x = -0.458, y = 0.05),
            label = 'New Document\n(Moderately Left)') +
  geom_text(aes(x = -0.95, y = 0.025),
            label = 'Left Ref.') +
  geom_text(aes(x = 0.95, y = 0.025),
            label = 'Right Ref.') +
  scale_y_continuous(expand = c(0, 0), limits = c(-0.1, 0.1)) +
  theme_minimal() +
  theme(panel.background = element_rect(linewidth = 1, colour = 'black', fill = NA),
        panel.grid = element_blank(),
        axis.text.y = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_text(size = 12, colour = 'black'),
        axis.ticks.y = element_blank())

ggplot() +
  geom_vline(xintercept = 0, linetype = 2, alpha = 1/3) +
  geom_segment(aes(x = -1, xend = 1, y = 0, yend = 0),
               linewidth = 1, colour = 'black') +
  geom_point(aes(x = 0.217, y = 0),
             size = 5, shape = 21, colour = 'red', fill = 'black') +
  geom_point(aes(x = -1, y = 0),
             size = 5, shape = 21, colour = 'black', fill = 'blue') +
  geom_point(aes(x = 1, y = 0),
             size = 5, shape = 21, colour = 'black', fill = 'red') +
  geom_text(aes(x = 0.217, y = 0.05),
            label = 'New Document\n(Moderately Right)') +
  geom_text(aes(x = -0.95, y = 0.025),
            label = 'Left Ref.') +
  geom_text(aes(x = 0.95, y = 0.025),
            label = 'Right Ref.') +
  scale_y_continuous(expand = c(0, 0), limits = c(-0.1, 0.1)) +
  theme_minimal() +
  theme(panel.background = element_rect(linewidth = 1, colour = 'black', fill = NA),
        panel.grid = element_blank(),
        axis.text.y = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_text(size = 12, colour = 'black'),
        axis.ticks.y = element_blank())


################################################################################
# Wordfish -- R Manual
################################################################################

docs <- c('Doc1', 'Doc2', 'Doc3') # Documents
words <- c('welfare', 'tax', 'military') # Discriminating Words

alpha_i <- c(Doc1 = 2.4, Doc2 = 2.7, Doc3 = 1.2) # Verbosity
theta_i <- c(Doc1 = 0.5, Doc2 = 1.0, Doc3 = -0.3)  # Latent Ideology
psi_j <- c(welfare = 0.2, tax = 0.1, military = 0.3)  # Baseline Word Freq.
beta_j <- c(welfare = 0.8, tax = 0.5, military = 1.2) # Word Discrimination

lambda <- matrix(0, nrow = length(docs), ncol = length(words),
                 dimnames = list(docs, words)) # Matrix to Input Recovered Lambda_ij Values

for (d in docs) {
  for (w in words) {
    lambda[d, w] <- exp(alpha_i[d] + psi_j[w] + beta_j[w] * theta_i[d])
  }
} # Function -- For Each Doc(i)-Word(j) Pair, Recover Lambda_ij


as.data.frame(lambda) %>%
  mutate(document = rownames(lambda)) %>%
  tidyr::pivot_longer(cols = -document,
                      names_to = "word",
                      values_to = "lambda") %>%
  mutate(lambda = round(lambda, 2))


################################################################################
# Wordfish -- R Quanteda
################################################################################

dail <- quanteda::tokens(quanteda.textmodels::data_corpus_irishbudget2010, remove_punct = TRUE)
dail_dfm <- quanteda::dfm(dail) # DFM of Tokenized Dail Corpus

quanteda::docnames(dail_dfm) # Legislator Names

dail_wordfish <- quanteda.textmodels::textmodel_wordfish(dail_dfm,
                                                         dir = c(6, 5)) # Specifying Kenny on Left & Cowen on Right

quanteda.textplots::textplot_scale1d(dail_wordfish, groups = dail_dfm$party) # 1D Plot by Party

quanteda.textplots::textplot_scale1d(dail_wordfish, margin = "features",  highlighted = c("government", "global", "children", "bank", "economy", "the", "citizenship", "productivity", "deficit"))


################################################################################
# Wordshoal -- R Manual
################################################################################


docs <- data.frame(document = c('Doc1', 'Doc2', 'Doc3', 'Doc4'),
                   author   = c(1, 1, 2, 2),
                   alpha    = c(2.0, 1.8, 2.2, 2.0)) # Docs - theta_i & alpha_i

words <- data.frame(word = c('welfare', 'tax', 'military'),
                    psi  = c(0.2, 0.1, 0.3),
                    beta = c(0.8, 0.5, 1.2)) # Words -- Psi_j & beta_j

theta <- data.frame(author = c(1, 2),
                    theta  = c(-1, 1)) # Author Ideologies


wordshoal_grid <- expand.grid(document = docs$document,
                              word = words$word) %>%
  left_join(docs, by="document") %>%
  left_join(words, by="word") %>%
  left_join(theta, by="author") %>% # All Document-Word Combos
  mutate(lambda = exp(alpha + psi + beta*theta),
         lambda = round(lambda, 2)) # Calculate lambda_ij

head(tibble(wordshoal_grid))

author_word <- wordshoal_grid %>%
  group_by(author, word) %>%
  summarise(lambda_total = sum(lambda),
            beta = first(beta),
            signal = lambda_total * beta, .groups="drop") # Calculate Total Lambda x Beta (Signal)

tibble(author_word)

tibble(author_word %>%
         group_by(author) %>%
         summarise(theta_signal = sum(signal))) # Theta Signal


################################################################################
# Wordshoal -- R Quanteda
################################################################################

data_corpus_irish30 <- wordshoal::data_corpus_irish30 # Speeches from 30th Irish Dail

names(docvars(data_corpus_irish30)) # Docvars
head(tibble(docvars(data_corpus_irish30))) # Sample

wordshoal_dfm <- dfm(tokens(data_corpus_irish30))

wordshoal_fit <- wordshoal::textmodel_wordshoal(x = wordshoal_dfm,
                                     dir = c(7,1),
                                     groups = docvars(data_corpus_irish30, "debateID"), # Group = Debate
                                     authors = docvars(data_corpus_irish30, "member.name")) # Author = Legislator

# Document 7 (Left) = Debate 21, Member = Joe Castello (Irish Labour Party)
# Document 1 (righ) = Debate 21, Member = Michael Ahern (Fianna Fail Part)

combined_thetas <- merge(as.data.frame(summary(wordshoal_fit)[[2]]),
                         docvars(data_corpus_irish30),
                         by.x = "row.names", by.y = "member.name") %>%
  distinct(memberID, .keep_all = T) # Combine Thetas & Associated Meta

head(tibble(combined_thetas)) # Print Head

aggregate_party_thetas <- aggregate(theta ~ party.name, data = combined_thetas, mean) %>%
  arrange(theta) # Aggregated by Party


party_order <- aggregate_party_thetas %>%
  arrange(theta) %>%
  mutate(party_label = paste0(party.name, " (", round(theta, 3), ")")) %>%
  pull(party_label)

combined_thetas %>%
  left_join(aggregate_party_thetas %>%
              rename(party_theta = theta), by = 'party.name') %>%
  mutate(party_label = paste0(party.name, ' (', round(party_theta, 3), ')'),
         party_label = factor(party_label, levels = party_order))  %>%
  filter(grepl('Fianna', party_label, ignore.case = F)) %>%
  ggplot(aes(x = theta, y = reorder(Row.names, theta))) +
  geom_point(size = 1) +
  geom_segment(aes(x = theta - se, xend = theta + se), size = 0.5, linetype = 2) +
  geom_vline(xintercept = 0, color = "black", alpha = 1/3) +
  facet_wrap(~party_label, ncol = 1, scales = 'free_y') +
  scale_x_continuous(breaks = seq(-1.5, 1.5, 0.5)) +
  labs(x = '\nTheta',
       y = '') +
  default_ggplot_theme +
  theme(axis.text.y = element_text(size = 10, colour = 'black'),
        axis.text.x = element_text(size = 10, colour = 'black'),
        strip.text = element_text(size = 12, colour = 'black'),
        panel.grid = element_blank())



combined_thetas %>%
  left_join(aggregate_party_thetas %>%
              rename(party_theta = theta), by = 'party.name') %>%
  mutate(party_label = paste0(party.name, ' (', round(party_theta, 3), ')'),
         party_label = factor(party_label, levels = party_order))  %>%
  ggplot(aes(x = theta, y = reorder(Row.names, theta))) +
  geom_point(size = 1) +
  geom_segment(aes(x = theta - se, xend = theta + se), size = 0.5, linetype = 2) +
  geom_vline(xintercept = 0, color = "black", alpha = 1/3) +
  facet_wrap(~party_label, ncol = 1, scales = 'free_y') +
  scale_x_continuous(breaks = seq(-1.5, 1.5, 0.5)) +
  labs(x = '\nTheta',
       y = '') +
  default_ggplot_theme +
  theme(axis.text.y = element_text(size = 8, colour = 'black'),
        axis.text.x = element_text(size = 12, colour = 'black'),
        strip.text = element_text(size = 12, colour = 'black'),
        panel.grid = element_blank())

