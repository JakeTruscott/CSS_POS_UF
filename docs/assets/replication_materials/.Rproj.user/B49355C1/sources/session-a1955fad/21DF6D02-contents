################################################################################
# Class 4 - Intro to Text Analysis
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated February 2026
################################################################################

################################################################################
# Packages & Libraries
# note: install.packages('PACKAGE') if not already installed
################################################################################

library(dplyr); library(ggplot2); library(gutenbergr); library(stringr)


################################################################################
# Regular Expressions
################################################################################

sample_text <- 'This is Sample Text'
print(sample_text)

sample_vector <- c('Sample 1', 'Sample 2', 'Sample 3')
print(sample_vector)


text <- 'This is a sample string with a date 2026-02-06, a time 14:30, an email test.user@example.com, and the number 42.'

unlist(stringr::str_extract_all(text, "\\b[a-zA-Z]+\\b")) # All Text

unlist(stringr::str_extract_all(text, "\\b\\d+\\b")) # All Numbers

unlist(stringr::str_extract(text, "\\b\\d{4}-\\d{2}-\\d{2}\\b")) # Grab Date

unlist(stringr::str_extract(text, "\\b\\d{2}:\\d{2}\\b")) # Grab Time HH:MM

unlist(stringr::str_extract(text,"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}")) # Email Address

unlist(stringr::str_extract(text, "^[^,]+")) # All Before 1st Comma

unlist(stringr::str_replace_all(text, "[[:punct:]]", "")) # Remove Punctuation


#####################################
# Partitioning and Searching Text
#####################################


set.seed(1234)

string <- 'The quick brown fox jumps over the lazy dog'

gsub('quick', 'wild', string) # Replace Quick

grepl('quick brown', string, ignore.case = F) # Check String


lorem_ipsum <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas scelerisque eros nec libero luctus, a gravida augue dictum. Integer sem est, malesuada nec mi ut, venenatis pellentesque massa. Mauris ac ex odio. Integer eget est lacus. Ut varius, sapien nec efficitur malesuada, sem lectus aliquet lacus, ac efficitur ipsum mauris vitae augue. Aliquam ornare faucibus nibh, a varius mauris mattis id. Nullam eu nibh aliquam, vestibulum neque sed, sagittis mi. Etiam blandit facilisis sagittis. Duis ut dolor sed nibh egestas porta. Aenean quis lorem nec augue semper convallis lacinia eget orci. Nam eget dolor tortor."

stringr::str_split(lorem_ipsum, pattern = '\\.')





################################################################################
# Grab Lies, Damn Lies, and Statistics Transcript
################################################################################

west_wing_script_location <- "https://raw.githubusercontent.com/JakeTruscott/CSS_POS_UF/main/docs/assets/replication_materials/class_4/supplemental_materials/West_Wing_S1_E21.txt" # Location of txt File on Github Repo
west_wing <- readLines(west_wing_script_location, warn = FALSE) # Read Txt from GitHub Repo
head(west_wing) # Print Head

#####################################
#Grab Transcript (txt)
#####################################

west_wing <- data.frame(unlist(west_wing)) %>%
  setNames('text') # Unlist Script as Text

characters <- c('Josh', 'Toby', 'C.J.', 'Donna', 'Sam', 'Leo', 'Bartlet')  # Characters of Interests

character_regex <- paste0("^(", paste0(toupper(characters), collapse = "|"), ")$") #

#####################################
# Grab Speaker Variance in Episode
#####################################

damn_lies <-  west_wing %>%
  mutate(character_line = ifelse(stringr::str_detect(text, character_regex), 1, 0), # If Character Found in Text
         empty_row = ifelse(text == '', 1, 0), # If Row is Empty
         first_entry = ifelse(character_line == 1, 1, NA)) %>% #
  tidyr::fill(first_entry, .direction = 'down') %>% # Fill Down
  filter(!is.na(first_entry)) %>% # Remove Empty Rows
  select(-c(first_entry)) %>%
  mutate(group = cumsum(character_line == 1)) %>%
  group_by(group) %>%
  mutate(to_keep = row_number() < which(empty_row == 1)[1] | is.na(which(empty_row == 1)[1])) %>%
  ungroup() %>%
  filter(to_keep) %>% # Removes Empty Lines
  select(text, character_line) %>%
  mutate(group = cumsum(character_line == 1)) %>%
  group_by(group) %>%
  summarise(
    character = text[character_line == 1][1],
    dialogue  = paste(text[-1], collapse = " "),
    .groups = "drop") %>%
  rename(id = group) %>%
  select(character, dialogue, id) %>%
  rowwise() %>%
  mutate(word_count = stringr::str_count(dialogue, "\\S+")) %>% # Count Words
  ungroup() %>%
  filter(!word_count == 0) # Final Check


head(damn_lies, 10) # Print Sample of Rows

damn_lies %>%
  group_by(character) %>% # By Each Character
  summarise(total_words = sum(word_count), # Total Words
            average_words = round(mean(word_count)), # Average Per Utterance
            total_lines = n()) %>% # Total Utterances
  arrange(desc(total_words)) %>% # Organize Most to Least
  rename(Character = character,
         `Total Words` = total_words,
         `Average Words` = average_words,
         `Total Lines` = total_lines)


################################################################################
# Gutenbegr -- Oliver Twist by Charles Dickens
################################################################################

gutenberg_metadata %>%
  filter(title == "Oliver Twist")

oliver_twist <- gutenberg_download(730) # Download Oliver Twist
chapter_ids <-  paste0('(', paste(paste0('CHAPTER ', as.character(as.roman(1:26)), '.' ), collapse = '|'), ')') # Roman Number Chapter IDs

oliver_twist <- oliver_twist %>%
  mutate(chapter_start = ifelse(grepl(chapter_ids, text), 1, 0),  # Identify Chapter Starts
         chapter_name = ifelse(chapter_start == 1, paste(text, lead(text)), NA),
         chapter_name = ifelse(chapter_start == 1 & !lead(text, 2) == '', paste0(chapter_name, ' ', lead(text, 2)), chapter_name),
         chapter_name = trimws(chapter_name)) %>% # Name Chapters
  filter(!lag(chapter_start) == 1) %>% # Remove Title Rows
  tidyr::fill(chapter_name, .direction = 'down') %>% # Assign Chapter Down
  filter(!is.na(chapter_name), !text %in% c('', ' '), !chapter_start == 1) %>% # Remove Header, Empty Rows, Chapter Start Row
  rowwise() %>%
  filter(!grepl(text, chapter_name, fixed = TRUE)) %>%
  select(-c(chapter_start, gutenberg_id))

paste(oliver_twist$text[1:8], collapse = ' ')


oliver_twist <- tibble::as_tibble(
  oliver_twist %>%
    mutate(chapter_name = trimws(chapter_name),
           chapter_name = ifelse(stringr::str_count(chapter_name, "\\S+") > 10,
                                 paste0(stringr::str_c(stringr::str_split(chapter_name, "\\s+", simplify = TRUE)[, 1:10],
                                                       collapse = " "), "..."), chapter_name)) %>%
    group_by(chapter_name) %>%
    summarize(text = paste(text, collapse = " "), .groups = "drop") %>%
    tidytext::unnest_tokens(word, text) %>%
    group_by(chapter_name) %>%
    summarize(
      `Word Count` = n(),
      `Unique Words` = n_distinct(word),
      .groups = "drop"
    ) %>%
    rename(`Chapter Name` = chapter_name)
)  # As Tibble

stargazer::stargazer(oliver_twist, type = 'text', summary = F)


################################################################################
# SCOTUS Oral Arguments
################################################################################


################################################################################
# Gutenbegr -- War and Peace by Leo Tolstoy
################################################################################

gutenberg_metadata %>%
  filter(title == "War and Peace")

war_and_peace <- gutenberg_download(2600) # Download War & Peace
chapter_ids <-  paste0('(', paste(paste0('^CHAPTER ', as.character(as.roman(1:26))), collapse = '|'), ')') # Roman Number Chapter IDs

war_and_peace <- war_and_peace %>%
  mutate(chapter_start = ifelse(grepl(chapter_ids, text), 1, 0),  # Identify Chapter Starts
         chapter_name = ifelse(chapter_start == 1, paste(text), NA)) %>% # Name Chapters
  filter(!lag(chapter_start) == 1) %>% # Remove Title Rows
  tidyr::fill(chapter_name, .direction = 'down') %>% # Assign Chapter Down
  filter(!is.na(chapter_name), !text %in% c('', ' '), !chapter_start == 1) %>% # Remove Header, Empty Rows, Chapter Start Row
  rowwise() %>%
  filter(!grepl(text, chapter_name, fixed = TRUE)) %>%
  select(-c(chapter_start, gutenberg_id))


paste(war_and_peace$text[1:8], collapse = ' ')


war_and_peace <- tibble::as_tibble(
  war_and_peace %>%
    mutate(chapter_name = trimws(chapter_name),
           chapter_name = ifelse(stringr::str_count(chapter_name, "\\S+") > 10,
                                 paste0(stringr::str_c(stringr::str_split(chapter_name, "\\s+", simplify = TRUE)[, 1:10],
                                                       collapse = " "), "..."), chapter_name)) %>%
    group_by(chapter_name) %>%
    summarize(text = paste(text, collapse = " "), .groups = "drop") %>%
    tidytext::unnest_tokens(word, text) %>%
    group_by(chapter_name) %>%
    summarize(
      `Word Count` = n(),
      `Unique Words` = n_distinct(word),
      .groups = "drop"
    ) %>%
    rename(`Chapter Name` = chapter_name)
)  # As Tibble

stargazer::stargazer(war_and_peace, type = 'text', summary = F)



################################################################################
# Corpus Creation And Manipulation w/ tm
################################################################################

library(tm) # Load tm

texts <- c(
  "The quick brown fox jumps over the lazy dog.",
  "Data science is revolutionizing the way we analyze information.",
  "Text analysis in R is fun and informative!"
) # Sample Texts (as vector)

tm_corpus <- tm::VCorpus(VectorSource(texts)) # Create Corpus from texts

tm::inspect(tm_corpus) # Inspect

tm_corpus_clean <- tm::tm_map(tm_corpus, content_transformer(tolower)) # Convert All to Lowercase
tm_corpus_clean <- tm::tm_map(tm_corpus_clean, removePunctuation) # Remove Punctuation
tm_corpus_clean <- tm::tm_map(tm_corpus_clean, removeNumbers) # Remove Numbers
tm_corpus_clean <- tm::tm_map(tm_corpus_clean, removeWords, stopwords("english")) # Remove English Stopwords

tm::inspect(tm_corpus_clean) # Notice How A Ton of Characters Are Now Gone?


################################################################################
# Corpus Creation & Manipulation w/ quanteda
################################################################################

library(quanteda) # Load Quanteda

texts <- c(
  "The quick brown fox jumps over the lazy dog.",
  "Data science is revolutionizing the way we analyze information.",
  "Text analysis in R is fun and informative!"
) # Sample Texts (as vector)

texts_with_meta <- tibble(
  doc_id = c("sentence_1", "sentence_2", "sentence_3"),
  text = texts,
  author = c('Josh', 'Leo', 'Toby'),
  date = as.Date(c("2025-01-01", "2025-01-02", "2025-01-03"))
) # Create Metadata for Texts (Same as tm example!)

quanteda_corpus <- corpus(texts_with_meta, text_field = "text")

summary(quanteda_corpus) # Inspect the Corpus

######################################
# Lies, Damn Lies, and Statistics
######################################

damn_lies_corpus <- quanteda::corpus(damn_lies, text_field = "dialogue") # Create Corpus (Text = 'dialogue')

summary(damn_lies_corpus[1:10]) # Inspect (Just First Couple of Rows)

damn_lies_corpus[1]
quanteda::docvars(damn_lies_corpus[1])
