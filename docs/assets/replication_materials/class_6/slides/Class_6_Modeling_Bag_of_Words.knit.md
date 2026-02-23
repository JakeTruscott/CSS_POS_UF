---
title: "Modeling the Bag of Words"
author: "Jake S. Truscott, Ph.D"
subtitle: |
  POS6933: Computational Social Science
institute: |
  \vspace{-5mm} University of Florida \newline
  Spring 2026 \newline \newline \newline
  \includegraphics[width=3cm]{../../../beamer_style/UF.png} \quad 
  \includegraphics[width=3.1cm]{../../../images/CSS_POLS_UF_Logo.png}
output: 
  beamer_presentation:
    slide_level: 3
    keep_tex: true
    toc: false
classoption: aspectratio=169  
header-includes:
  - \PassOptionsToClass{aspectratio=169}{beamer}
  - \usepackage{../../../beamer_style/beamer_style}
  - \setbeamersize{text margin left=3.5mm,text margin right=3.5mm}
---



# Overview

### Overview
\begin{itemize}
\item Housekeeping
\item Week 5 Problem Set Review
\item Dictionaries
\item Multinomial Language Model
\item Vector Space Model
\end{itemize}

# Housekeeping

### Housekeeping
\begin{itemize}
\item Respond to comments re: topic selection by Friday at 5:00 \par \vspace{2.5mm}
\item This week's material may require us to continue into next week -- I will make determination by end of class. 
\end{itemize}


# Week 5 Problem Set

### Week 5 Problem Set Review
\begin{itemize}
\item Everyone generally did fine \par \vspace{2.5mm}
\item Make sure to fully read prompts... \par \vspace{2.5mm}
\item I don't mind y'all coordinating together -- But more than half with same presidents, policies, and effectively the same vocabularies, it defeats a big chunk of the purpose. \par \vspace{2.5mm}
\end{itemize}

# Focus Today

### Focus Today
\begin{itemize}
\item Focus today begins preliminary application of modeling strategies re: text as data \par \vspace{2.5mm}
\item Things to Consider: 
  \begin{itemize}
  \item Embrace the learning curve 
  \item Ask questions
  \item If we need to continue this next week, we will! 
  \end{itemize}
\end{itemize}


# Dictionaries

### Dictionaries 
\begin{itemize}
\item A \textbf{dictionary} (\textit{lexicon}) is a predefined list of words associated with categories (\textit{classifications}) \par \vspace{2.5mm}
\item We can engage in basic classification or labeling tasks using these dictionaries to: 
  \begin{enumerate}
  \item Pre-processing our text to normalize/reduce complexity
  \item Counting how many dictionary words appear
  \item (Optional) Scaling document by length
  \item Assigning a category score based on the totals
  \end{enumerate} \par \vspace{2.5mm}
  \item \textbf{Classification Tasks}: Assigning each document (or sentence) to one or more predefined categories based on its content -- with dictionary methods, classification is completed by matching words. 
\end{itemize}

### Dictionaries for Classification Tasks -- Binary Classification (e.g., \textit{Positive} \textbf{or} \textit{Negative})
\[
\text{Label}_i = \arg\max_{c} \left( \text{DictionaryMatches}_{ic} \right)
\qquad \textbf{or} \qquad
\text{Score} = \frac{\text{C1 Words} - \text{C2 Words}}{\text{Total Words}}
\]
\vspace{5mm}
\begin{itemize}
\item $i$ = Sentence, $c$ = Label 
\item $\arg\max$ = Label that best fits
\item Score = Continuous Measure
\item Example: 10 Positive Words and 12 Negative Words \\ $$10_{\text{Pos}} < 12_{\text{Neg}} \Rightarrow \text{Label} = \text{Neg}
  $$ \\  $$ -0.09 = \frac{10(\text{Pos})-12(\text{Neg})}{22(\text{Total})} $$
  \end{itemize}
  
  
### Dictionaries for Classification Tasks -- Multiclass Classification (e.g., \textit{Positive}, \textit{Negative}, \textbf{or} \textit{Neutral})
\[
\text{Label}_i = \operatorname*{arg\,max}_{c \in \{\text{Pos}, \text{Neg}, \text{Neu}\}} \left( \text{DictionaryMatches}_{ic} \right)
\qquad \textbf{or} \qquad
\text{Score} = \frac{\text{C}_{c}}{\text{Total Words}}
\]
\vspace{5mm}
\begin{itemize}
\item \textit{Note}: Continuous score now recovered as weight of each category in document. 
\item Example: 10 Positive Words, 12 Negative Words, 3 Neutral words \\ $$3_{\text{Neu}} < 10_{\text{Pos}} < 12_{\text{Neg}} \Rightarrow \text{Label} = \text{Neg}$$ \\  
$$ \text{(Pos)} \frac{10}{25}= 0.4 \quad \text{(Neg)}\frac{12}{25}=0.48 \quad \text{(Neu)}\frac{3}{25}=0.12$$
\end{itemize}


### Dictionaries for Classification Tasks (Example)
\begin{itemize}
\item \textbf{Your Turn} -- Work to recover classification labels for a binary task with 15 \textbf{positive} words and 11 \textbf{negative} words. 
\item Do the same for a multiclass task that now also includes 13 \textbf{neutral} words. 
\end{itemize}

### Dictionaries for Classification Tasks (Example Cont.)
\begin{itemize}
\item Binary: $$15_{pos}>11_{neg} \quad \text{or } \frac{15-11}{26}\approx0.15$$ \par \vspace{5mm}
\item Multiclass: $$\text{(Pos)}\frac{15}{39}=0.38 \quad \text{(Neg)}\frac{11}{39}=0.28 \quad \text{(Neu)}\frac{13}{39}=0.33  $$
\end{itemize}


### Thoughts re: Dictionaries
\begin{itemize}
\item Dictionary classifiers, while rather simple and intuitive, can nevertheless provide robust classification power. \par \vspace{2.5mm} \pause
\item \textbf{However} -- much of that validity relies on the ability of researchers to construct dense lexicons (avoid small-N problems)  \par \vspace{2.5mm} \pause
\item While a dense dictionary is certainly important, paramount to such is constructing categorical classifications (e.g., positive or negative) that are both authentic and defensible.   \par \vspace{2.5mm} \pause
\item Words have associated meaning based on tense and conditional usage. Ex: \textit{happy} is certainly positive – but what if the sentence actually reads \textit{I was not happy at all} (i.e., actually very negative!). Much of these concerns (as with other areas concerning the bag of words) can be improved given more robust methods, including the incorporation of inverses (not) and n-grams.
\end{itemize}


### Creating Dictionaries
\begin{itemize}
\item Creating dictionaries is fairly intuitive -- Create vectors (classes) with terms exclusively representing words unique to that classification. \par \vspace{2.5mm}
\item Ex: 
  \begin{itemize}
  \item \textbf{Positive}: Good, Great, Excellent, Benefit, Success
  \item \textbf{Negative}: Bad, Poor, Failure, Harm, Risk
  \item \textbf{Neutral}: Okay, Average, Fine, Moderate
  \end{itemize}
\end{itemize}


### Creating Dictionary in R
\scriptsize

``` r
dictionary <- list(Positive = c("good", "great", "excellent", "benefit", "success"),
                   Negative = c("bad", "poor", "failure", "harm", "risk"),
                   Neutral  = c("okay", "average", "fine", "moderate")) # Dictionary as List

dictionary[['Positive']] # Sample
```

```
[1] "good"      "great"     "excellent" "benefit"   "success"  
```


### Applying Dictionary in R
\scriptsize

``` r
sample_text <- reduce_complexity('The project had some success but also some risk') # Reduce Complexity
print(sample_text) # Print Sample
```

```
[1] "project success also risk"
```

``` r
sapply(dictionary, function(categories) sum(strsplit(sample_text, "\\W+")[[1]] %in% categories)) # Apply 
```

```
Positive Negative  Neutral 
       1        1        0 
```
### Applying Dictionary in R
\begin{itemize}
\item \textbf{Your Turn}: Create another string and apply the same dictionary. 
\item Afterwards -- include additional values to the dictionary. 
\end{itemize}


### Existing Lexicons in R (BING)
\begin{itemize}
\item \texttt{BING} -- lexicon widely used for binary sentiment classification. \par \vspace{2.5mm}
\item Assigns words to \textit{positive} or \textit{negative} classifications -- approximately 2k positive words and 4.8k negative words
\end{itemize}

### Existing Lexicons in R (BING -- Cont.)
\scriptsize

``` r
bing_dictionary <- tidytext::get_sentiments("bing") # Grab Dictionary

bing_dictionary %>%
  group_by(sentiment) %>%
  slice_sample(n = 3) %>%
  ungroup() %>%
  arrange(sentiment) # 3 Word Sample of Each
```

```
# A tibble: 6 x 2
  word       sentiment
  <chr>      <chr>    
1 backbiting negative 
2 grainy     negative 
3 liability  negative 
4 articulate positive 
5 raptureous positive 
6 goood      positive 
```

### Existing Lexicons in R (BING -- Cont.)
\scriptsize

``` r
strings <- c("This decision is excellent, fair, and clearly the right outcome",
    "The opinion is good and persuasive, even if it is not perfect",
    "The ruling has some good points but also several serious flaws",
    "The decision is bad and poorly reasoned", "This opinion is terrible, deeply unfair, and completely wrong")

strings <- sapply(strings, function(x) reduce_complexity(x),
    USE.NAMES = FALSE)
print(strings)
```

```
[1] "decision excellent fair clearly right outcome"   "opinion good persuasive even perfect"           
[3] "rule good point also several serious flaw"       "decision bad poorly reason"                     
[5] "opinion terrible deeply unfair completely wrong"
```


### Existing Lexicons in R (BING -- Cont.)
\scriptsize

``` r
strings <- tibble(
  doc_id = seq_along(strings),
  text = strings) 

strings_tokens <- strings %>% # Convert to tibble
  tidytext::unnest_tokens(word, text) # Convert to Unnested Tokens

head(strings_tokens)
```

```
# A tibble: 6 x 2
  doc_id word     
   <int> <chr>    
1      1 decision 
2      1 excellent
3      1 fair     
4      1 clearly  
5      1 right    
6      1 outcome  
```


### Existing Lexicons in R (BING -- Cont.)
\scriptsize

``` r
strings_tokens %>%
  inner_join(tidytext::get_sentiments("bing"), by = "word") %>% # Get Sentiment
  group_by(doc_id, sentiment) %>%
  summarise(n = n(), # Total Word Matches
            words = paste(word, collapse = ", "), # Combine Word matches
            .groups = "drop") %>%
  left_join(strings, by = "doc_id") %>% # Add Back Original Text
  select(doc_id, text, sentiment, n, words) # Apply BING
```

```
# A tibble: 6 x 5
  doc_id text                                            sentiment     n words                          
   <int> <chr>                                           <chr>     <int> <chr>                          
1      1 decision excellent fair clearly right outcome   positive      4 excellent, fair, clearly, right
2      2 opinion good persuasive even perfect            positive      2 good, perfect                  
3      3 rule good point also several serious flaw       negative      1 flaw                           
4      3 rule good point also several serious flaw       positive      1 good                           
5      4 decision bad poorly reason                      negative      2 bad, poorly                    
6      5 opinion terrible deeply unfair completely wrong negative      2 terrible, wrong                
```

### Existing Lexicons in R (AFINN)
\begin{itemize}
\item \texttt{AFINN} is another lexicon widely used in \texttt{R}
\item Captures both direction \textbf{and} intensity of rhetoric
\item Generally ranges from -5 (\textbf{Very Negative}) to +5 (\textbf{Very Positive})
\end{itemize}


### Existing Lexicons in R (AFINN -- Cont.)
\scriptsize

``` r
set.seed(123)
afinn_dictionary <- tidytext::get_sentiments("afinn") # Afinn Dictionary

afinn_dictionary %>% 
  group_by(value) %>%
  slice_sample(n = 1) %>%
  ungroup() %>%
  arrange(value) %>%
  select(value, word) %>%
  { setNames(.$word, .$value) } # Sample Words (Value -5 to 5)
```

```
              -5               -4               -3               -2               -1                0                1 
"son-of-a-bitch"    "fraudulence"       "lunatics"       "lethargy"   "manipulation"      "some kind"           "cool" 
               2                3                4                5 
      "courtesy"         "cheery"         "winner"         "superb" 
```

### Existing Lexicons in R (AFINN -- Cont.)
\scriptsize

``` r
strings_tokens %>%
  inner_join(tidytext::get_sentiments(lexicon = 'afinn'), by = 'word') %>%
  group_by(doc_id, value) %>%
  summarise(n = n(), # Total Word Matches
            words = paste(word, collapse = ", "), # Combine Word matches
            .groups = "drop") %>%
  left_join(strings, by = "doc_id") %>% # Add Back Original Text
  select(doc_id, text, value, n, words)
```

```
# A tibble: 8 x 5
  doc_id text                                            value     n words        
   <int> <chr>                                           <dbl> <int> <chr>        
1      1 decision excellent fair clearly right outcome       1     1 clearly      
2      1 decision excellent fair clearly right outcome       2     1 fair         
3      1 decision excellent fair clearly right outcome       3     1 excellent    
4      2 opinion good persuasive even perfect                3     2 good, perfect
5      3 rule good point also several serious flaw           3     1 good         
6      4 decision bad poorly reason                         -3     1 bad          
7      5 opinion terrible deeply unfair completely wrong    -3     1 terrible     
8      5 opinion terrible deeply unfair completely wrong    -2     2 unfair, wrong
```


### Existing Lexicons in R (SentimentR)
\begin{itemize}
\item \texttt{sentimentR} uses a BING-style polarity lexicon (i.e., words have singular meaning) while also providing for \textbf{negators} (e.g., not, never, etc.), \textbf{amplifiers} (e.g., very or extremely), and \textbf{advesarial conjunction} (e.g., but). 
\item Result is a BING-style score combined with a valence multiplier to adjust for sentence heuristics (ex: \textit{good} = 1x, not \textit{good} = -1x, \textit{barely good} = 0.5x)
\item \textit{Note}: Negative doesn't always flip the sign from positive to negative but it will help to scale the intensity. 
\end{itemize}


### Existing Lexicons in R (SentimentR - Cont.)
\scriptsize

``` r
strings %>%
    mutate(sentiment = sentimentr::sentiment_by(text)$ave_sentiment) # Apply SentimentR
```

```
# A tibble: 5 x 3
  doc_id text                                            sentiment
   <int> <chr>                                               <dbl>
1      1 decision excellent fair clearly right outcome      1.14  
2      2 opinion good persuasive even perfect               0.671 
3      3 rule good point also several serious flaw         -0.0567
4      4 decision bad poorly reason                        -0.45  
5      5 opinion terrible deeply unfair completely wrong   -1.18  
```


### Existing Lexicons in R (Example)
\begin{itemize}
\item \textbf{Your turn}: Recover scores from \texttt{Bing, AFINN}, and \texttt{SentimentR} after reducing the complexity of the following strings: 
\footnotesize
  \begin{itemize}
  \item The recent peace agreement between the two nations is a remarkable step toward stability
  \item The summit produced some promising proposals, though implementation will take time
  \item The delegation met to discuss ongoing trade negotiations without reaching a conclusion
  \item The sanctions imposed by the council are likely to harm the civilian population disproportionately
  \item The military escalation is a disastrous and reckless move that threatens global security
  \end{itemize}
\end{itemize}



### Existing Lexicons in R (Example)
\scriptsize

``` r
print(bing %>% select(text, doc_id))
```

```
# A tibble: 4 x 2
  text                                                                       doc_id
  <chr>                                                                       <int>
1 recent peace agreement two nation remarkable step toward stability              1
2 summit produce promise proposal though implementation will take time            2
3 sanction impose council likely harm civilian population disproportionately      4
4 military escalation disastrous reckless move threaten global security           5
```

``` r
print(bing %>% select(-c(text)))
```

```
# A tibble: 4 x 4
  doc_id sentiment     n words                         
   <int> <chr>     <int> <chr>                         
1      1 positive      3 peace, remarkable, stability  
2      2 positive      1 promise                       
3      4 negative      2 impose, harm                  
4      5 negative      3 disastrous, reckless, threaten
```

### Existing Lexicons in R (Example)
\scriptsize

``` r
print(afinn %>% select(-c(text))) 
```

```
# A tibble: 8 x 4
  doc_id value     n words             
   <int> <dbl> <int> <chr>             
1      1     1     1 agreement         
2      1     2     2 peace, remarkable 
3      2     1     1 promise           
4      3     1     1 reach             
5      4    -2     1 harm              
6      4    -1     1 impose            
7      5    -3     1 disastrous        
8      5    -2     2 reckless, threaten
```

### Existing Lexicons in R (Example)
\scriptsize

``` r
print(sentimentr)
```

```
# A tibble: 5 x 3
  doc_id text                                                                       sentiment
   <int> <chr>                                                                          <dbl>
1      1 recent peace agreement two nation remarkable step toward stability             0.833
2      2 summit produce promise proposal though implementation will take time           0.25 
3      3 delegation meet discuss ongoing trade negotiation without reach conclusion     0    
4      4 sanction impose council likely harm civilian population disproportionately    -0.389
5      5 military escalation disastrous reckless move threaten global security         -0.742
```



# Multinomial Language Model

### Multinomial Language Model
\begin{itemize}
\item \textbf{Multinomial Language Model}: A probabilistic model that treats a document as a bag of words generated from a multinomial distribution over a fixed vocabulary \par \vspace{2.5mm}
\item \textbf{Formally}: For a document represented as a sequence of word counts, the likelihood of observing the document is given by the multinomial probability mass function (PMF), which combines the factorial of the total word count with the product of the probabilities of each word raised to the power of its observed count
\item Assumes that each word in a document is drawn independently from a fixed vocabulary according to a categorical distribution – i.e., in accordance with the Bag of Words approach, where each word has a certain probability of occurring.  \par \vspace{2.5mm}
\end{itemize}

### Probability Mass Function -- Categorical to Multinomial
\begin{itemize}
\item[] PMF -- Categorical Distribution: 
$$
p(\mathbf{W}_i \mid \boldsymbol{\mu})
= \prod_{j=1}^J \mu_j^{w_{ij}}
$$

\item[] We can generalize for documents that are longer than one word using the multinomial distribution:
$$
p(\mathbf{W}_i \mid \boldsymbol{\mu}) = 
\frac{M!}{\prod_{j=1}^J W_{ij}!} \prod_{j=1}^J
\mu_{j}^{\mathbf{W}_{ij}}
$$
\end{itemize}


### Multinomail PMF (Explained)
$$
p(\mathbf{W}_i \mid \boldsymbol{\mu}) = 
\frac{M!}{\prod_{j=1}^J W_{ij}!} \prod_{j=1}^J
\mu_{j}^{\mathbf{W}_{ij}}
$$
\begin{itemize}
\item $p(\mathbf{W}_i \mid \boldsymbol{\mu})$ = probability of observing the entire word-count vector for document $i$ given probabilities $\mu$
\item $\mathbf{M} = \sum_{j=1}^j\mathbf{W}_{ij}$ = Total number of word tokens in document $i$
\item $\frac{M!}{\prod_{j=1}^J W_{ij}!}$ = Number of distinct word sequences consistent with the observed counts
\item $J$ = Vocabulary size (i.e., number of unique words)
\item $\prod_{j=1}^J \mu_{j}^{\mathbf{W}_{ij}}$ = Product of word probabilities raised to the number of times each word appears in document $i$
\end{itemize}

### Multinomial Language Model -- Food Example
\begin{itemize}
\item Vocabulary = \texttt{c(hamburger, salad, taco, nuggets)} \par \vspace{2.5mm}
\item Probabilities ($\mu$): 
  \begin{itemize}
  \item $p(\text{hamburger}) = 0.3$
  \item $p(\text{salad}) = 0.25$
  \item $p(\text{taco}) = 0.15$
  \item $p(\text{nuggets}) = 0.3$
  \end{itemize} \par \vspace{2.5mm}
\item Count vector from Document $i$ for \\ \texttt{c(hamburger, salad, taco, nuggets)} =  (2, 0, 1, 1) 
\item i.e., Hamburger (2), Salad (0), Taco (1), and Nuggets (1)
\end{itemize}

### Multinomial Language Model -- Food Example (Add Our Values -- Simplify)
\begin{itemize}
\item[]$$
p(\mathbf{W}_i \mid \boldsymbol{\mu}) = 
\frac{M!}{\prod_{j=1}^J W_{ij}!} \prod_{j=1}^J
\mu_{j}^{\mathbf{W}_{ij}}
$$ 
\par \vspace{5mm} \pause
\item[] $$
p(\texttt{H,H,T,N} \mid \mu) = 
\frac{4!}{(2_{H}!)(0_{S}!)(1_{T}!)(1_{N}!)}
(0.3_H)^2 (0.25_S)^0 (0.15_T)^1 (0.3_N)^1
$$ \par \vspace{5mm} \pause
\item[] $$ = \frac{4!}{2!\cdot0!\cdot1!\cdot1!}\quad 0.09 \cdot 1 \cdot 0.15 \cdot 0.3$$ \par \vspace{5mm} \pause
\item[] $$ p(H,H,T,N \mid \mu) \approx 0.0486 $$
\end{itemize}

### Federalist Papers
\begin{itemize}
\item Collection of essays published in NY newspapers advocating ratification of US Constitution \par \vspace{2.5mm}
\item Published anonymously by James Madison, Alexander Hamilton, and Jon Jay -- all using pseudonym \textit{Publius} \par \vspace{2.5mm}
\item Virtually any course on American politics prescribes Federalist 10  (\textit{republics and factionalism}) and 51 (\textit{separation of powers to prevent tyranny})  -- I also prescribe 78 (\textit{Judiciary})
\end{itemize}


### Mosteller and Wallace (1963) -- Cont.
\begin{itemize}
\item 85 essays in total -- some where authorship was known, others not -- and some disputed. \par \vspace{2.5mm}
\item By mid-20th century, it was believed that Jay authored 5, Hamilton (at least) 43, and Madison (at least) 14 \par \vspace{2.5mm}
\item Left several with disputed authorship. \par \vspace{2.5mm}
\item Mosteller and Wallace (1963) used Bag of Words assumption to try and prescribe unknown authorship. \par \vspace{2.5mm}
\item \textbf{Basic Idea}: Variance in each potential author's word choice should emerge in disputed essay.
\end{itemize}

### Prescribing Authorship for Federalist 51
\textbf{What We Need}: \pause
\begin{itemize}
\item A vocabulary \par \vspace{2.5mm} \pause
\begin{itemize}
\item[] \texttt{by, heretofore, man, upon, whilst} \pause
\end{itemize} \par \vspace{2.5mm}
\item Variance of that vocabulary in a document of interest \textit{i} \par \vspace{2.5mm} \pause
\item The associated probabilities $\mu$
\end{itemize}

### Authorship of Federalist 51 (Cont.)

\scriptsize

``` r
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
  } 
```


### Authorship of Federalist 51 (Vocab Frequencies by Author)

```
# A tibble: 6 x 4
  word       Hamilton   Jay Madison
  <chr>         <int> <int>   <int>
1 by              861    82     477
2 heretofore       13     1       1
3 man             102     0      17
4 upon            374     1       7
5 whilst            1     0      12
6 TOTAL          1351    84     514
```


### Authorship of Federalist 51 (Recovering $\mu$)
\begin{itemize}
\item[] $$W_{Hamilton}\text{Multinomial}(1351, \mu_{H})$$ \par \vspace{2.5mm}
\item[] $$W_{Madison}\text{Multinomial}(514, \mu_{M})$$ \par \vspace{2.5mm}
\item[] $$W_{Jay}\text{Multinomial}(84, \mu_{J})$$
\end{itemize}

### Authorship of Federalist 51 (Recovering $\mu_{H,M,J}$) -- Cont.
\begin{itemize}
\item[] $$\mu_{\sigma j} = \frac{W_{\sigma j}}{N_{\sigma}} $$ \par \vspace{2.5mm}
\item[] \textbf{Hamilton}: $$\mu_{Hamilton} = (\frac{861}{861+13+102+374+1},\frac{13}{1351},\frac{102}{1351}, \frac{374}{1351}, \frac{1}{1351})$$ \par \vspace{2.5mm}
\item[] \textbf{Hamilton}: $$ \mu_{Hamilton} = (0.63,0.009,0.07,0.27,0.0007) $$ \par \vspace{2.5mm}
\end{itemize}


### Authorship of Federalist 51 (Recovering $\mu_{H,M,J}$) -- Cont.
\begin{itemize}
\item[] \textbf{Solve for Madison} \par \vspace{5mm} \pause
\item[] \textbf{Madison}: $$\mu_{Madison} = (0.92,0.001,0.033,0.013,0.023)$$ \par \vspace{2.5mm}
\item[] \textbf{Jay}: $$\mu_{Jay} = (0.97,0.01,0,0.01,0)$$
\end{itemize}


### Authorship of Federalist 51 -- Vocabulary in 51
\begin{itemize}
\item We know the following frequency of the vocabulary in Federalist 51:
  \begin{itemize}
  \item by (23)
  \item man (1)
  \item upon (0)
  \item heretofore (0)
  \item whilst (2)
  \end{itemize} \par \vspace{2.5mm}
  \item \textbf{Next Step}: Plug in our values!
\end{itemize}

### Federalist 51 -- Putting Together: Hamilton
\begin{itemize}
\item[] $$
p(\mathbf{W_{Fed51}}\mid\mu_{Hamilton}) = \frac{26!}{(23!)(1!)(0!)(0!)(2!)}(0.63)^{23}(0.009)^{1}(0.07)^{0}(0.27)^{0}(0.0007)^{2}
$$ \par \vspace{5mm} \pause

\item[] $$
p(\mathbf{W_{Fed51}}\mid\mu_{Hamilton}) = 0.0000000008346
$$
\end{itemize}

### Federalist 51 -- Putting Together: Madison
\begin{itemize}
\item \textbf{Your Turn} -- Do the same for Madison \par \vspace{2.5mm} \pause
\item[] $$p(\mathbf{W_{Fed51}}\mid\mu_{Madison}) = \frac{26!}{(23!)(1!)(0!)(0!)(2!)}(0.92)^{23}(0.001)^{1}(0.033)^{0}(0.013)^{0}(0.023)^{2}$$ 
\item[] $$
p(\mathbf{W_{Fed51}}\mid\mu_{Madison}) = 0.00055692
$$
\end{itemize}

### Federalist 51 -- Putting Together: Jay
\begin{itemize}
\item[] $$
p(\mathbf{W_{Fed51}}\mid\mu_{Jay}) = \frac{26!}{(23!)(1!)(0!)(0!)(2!)}(0.97)^{23}(0.01)^{1}(0)^{0}(0.01)^{0}(0)^{2}
$$

\item[] $$
p(\mathbf{W_{Fed51}}\mid\mu_{Jay}) = 0
$$
\end{itemize}


### Federalist 51 (Comparison)
\begin{itemize}
\item[] $$p(\mathbf{W_{Fed51}}\mid\mu_{Madison}) > p(\mathbf{W_{Fed51}}\mid\mu_{Hamilton})  > p(\mathbf{W_{Fed51}}\mid\mu_{Jay}) $$ \par \vspace{2.5mm}
\item Supports findings by Mosteller and Wallace (1963) 
\end{itemize}


### Multinomial Language Model -- Laplace Smoothing
\begin{itemize}
\item Other consideration -- no usage of \texttt{man} or \texttt{whilst} by John Jay -- produces a probability of 0. \par \vspace{2.5mm} 
\item Alternative -- \textbf{Laplace Smoothing}: Add a positive integer to all the word vector values to remove the impossibility while otherwise preserving the proportionality of word usage 
\end{itemize}

### Multinomial Language Model -- Laplace Smoothing (Cont.)
\scriptsize

\scriptsize

``` r
hamilton_likelihood <- dmultinom(x = federalist_51_vector, prob = author_vectors[['Hamilton']] + 1)

madison_likelihood <- dmultinom(x = federalist_51_vector, prob = author_vectors[['Madison']] + 1)

jay_likelihood <- dmultinom(x = federalist_51_vector, prob = author_vectors[['Jay']] + 1)


data.frame(Author = c('Hamilton', 'Madison', 'Jay'), 
           Likelihood = c(hamilton_likelihood, madison_likelihood, jay_likelihood))
```

```
    Author   Likelihood
1 Hamilton 3.845094e-08
2  Madison 2.557079e-02
3      Jay 2.222033e-03
```

``` r
madison_likelihood/jay_likelihood # Likelihood Ratio of Madison v. Jay
```

```
[1] 11.50783
```

``` r
madison_likelihood/hamilton_likelihood # Likelihood Ratio of Madison v. Hamilton 
```

```
[1] 665023.7
```

### Multinomial Language Model -- Dirichlet Distribution 
\begin{itemize}
\item Another alternative -- rather than adding a numeric constant to the word counts, add a \textbf{Dirichlet prior} over $\mu$, allowing the word probabilities themselves to be treated as random and regularized through pseudo-count parameters ($\alpha$). \par \vspace{2.5mm}
\item Basically: When calculating $\mu_{\sigma j}$, add a prior weight value ($\alpha_{j}$) that reflects our prior belief about how common that word is expected to be before observing the document.
\item For example, I am going to assign $\alpha = (2,1,1,2,1)$
\end{itemize}

### Multinomial Language Model -- Updated $\mu_{H} \sim \alpha = (2,1,1,2,1)$ 
\begin{itemize} 
\item[] \footnotesize{$$ \hat{\mu}_{Hamilton} = (\frac{861 + 2}{861+13+102+374+1 + (2 + 1 + 1 + 2 + 1)}, \frac{13+1}{1358}, \frac{102+1}{1358}, \frac{374+2}{1358}, \frac{1+1}{1358})$$}
\item[] $$p(\mathbf{W_{Fed51}\mid\hat{\mu}_{Hamilton}}) = \frac{26!}{(23!)(1!)(0!)(0!)(2!)}(0.63)^{23}(0.01)^{1}(0.07)^{0}(0.27)^{0}(0.001)^{2}$$
\item[] $$ p(\mathbf{W_{Fed51}\mid\hat{\mu}_{Hamilton}}) = 0.00000000186 $$
\end{itemize}


# Vector Space Model

### Vector Space Model
\begin{itemize}
\item While multinomial language model looks at text as a series of words and focuses on how likely each word is to appear, a vector space model treats text as a point in space. \par \vspace{2.5mm}
\item Lets us measure how similar two texts are based on distance or direction.  \par \vspace{2.5mm}
\item In essence, \textbf{MLM} is all about word probabilities –  figuring out which words are more likely in a document \par \vspace{2.5mm}
\item \textbf{VSMs} leverage linear algebra to turn text into vectors so we can compare documents based on their overall content, not just exact word counts.
\end{itemize}

### Vector Space Model -- Ex: Inner Products (Federalist 51)
\footnotesize
\begin{itemize}
\item[] $$\mathbf{W_{Madison}} \cdot \mathbf{W_{Hamilton}} = (477, 1, 17, 7, 12) \cdot (861, 13, 102, 374, 1) $$
\item[] $$= (477 \times 861) + (1 \times 13) + (17 \times 102) + (7 \times 374) + (12 \times 1) $$
\item[] $$= 410,697$$
\item[] $$\mathbf{W_{Madison}} \cdot \mathbf{W_{Jay}} = (477, 1, 17, 7, 12) \cdot (82, 1, 0, 1, 0, 84) $$
\item[] $$= (477 \times 82) + (1 \times 1) + (17 \times 0) + (7 \times 0) + (12 \times 84)$$
\item[] $$= 40,123$$
\end{itemize}


### Cosine Similarity
\begin{itemize}
\item Recall the distribution of frequencies across Hamilton, Madison, and Jay seemed to heavily favor Hamilton \par \vspace{2.5mm}
\item \textbf{Important Q}: Should it matter more that Hamilton used the four of the five words in our vocabulary more frequently than Madison, or should it matter more how the distribution of that word usage matches that in the disputed document? \par \vspace{2.5mm}
\item Ideally, no -- but high-dimensionality makes this very possible. \par \vspace{2.5mm}
\item \textbf{Cosine Similarity} allows us to normalize the inner product and the magnitude of the vectors. 
\end{itemize}


### Cosine Similarity (Cont.)
\begin{itemize}
\item[] $$
\text{cosine(u,v)} = \frac{\text{u}\cdot \text{v}}{||\text{u}||\hspace{2mm}||\text{v}||} = \frac{\sum_iu_iv_i}{\sqrt{\sum_iu_{i}^2} \sqrt{\sum_{i}v_{i}^2}}$$
\item Numerator = Inner product of the two vectors
\item Denominator = Product of the vectors' magnitudes
\end{itemize}


### Cosine Similarity -- Hamilton & Federalist 51 Example
\begin{itemize}
\item \textbf{Inner Product}: $$ \mathbf{W}_{Hamilton} \cdot \mathbf{W}_{Disputed} = (861 \times 23) + (13 \times 1) + (102 \times 0) + (374 \times 0) + (1 \times 2) \quad = 19,818 $$ \pause
\item \textbf{Magnitude of Vectors (Hamilton)}: $$||\mathbf{W}_{Hamilton}|| = \sqrt{861^2 + 13^2 + 102^2 + 374^2 + 1^2} \quad \approx 944.33$$ \pause
\item \textbf{Magnitude of Vectors} (Federalist 51): $$ ||\mathbf{W}_{Disputed}||  = \sqrt{23^2 + 1^2 + 0^2 + 0^2 + 2^2} \quad \approx 23.10$$ \pause
\item \textbf{Cosine Similarity}: $$cos(\mathbf{W}_{Hamilton}, \mathbf{W}_{Disputed}) = \frac{19,818}{944.33 \times 23.10} \quad \approx 0.9085 $$
\end{itemize}


### Cosine Similarity -- Madison
\begin{itemize}
\item \textbf{Your turn} -- Try with Madison \pause
\item[] $$cos(\mathbf{W}_{Madison}, \mathbf{W}_{Disputed}) = \frac{10,996}{477.50 \times 23.10} \quad \approx 0.996$$ \pause
\item Effectively removes all doubt re: Madison's authorship!
\end{itemize}


### TF-IDF
\begin{itemize}
\item \textbf{Term Frequency - Inverse Frequency} (TF-IDF): Strategy that rescales a DFM by its inverse document frequency, down-weighting terms that appear in many documents. \par \vspace{2.5mm}
\item In Short: Words that occur frequently in individual documents while remaining relatively uncommon in the broader corpus receive greater weight \par \vspace{2.5mm}
\item Terms that satisfy both conditions are in the \textit{Goldilocks zone} -- those that violate both are penalized.
\end{itemize}

### TF-IDF (Cont.)
\begin{itemize}
\item[] $$ W^{\text{tf-idf}}_{ij} = W_{ij} * log\frac{N}{n_j} $$
\item[] $$ N = \text{Number of Documents in Corpus} $$
\item[] $$ n_j = \text{Number of Documents Containing Word } j $$
\item[] $$ W_{ij} = \text{Word Count} $$
\item[] $$ log\frac{N}{n_j} = \text{Penalty for Frequent Words} $$
\end{itemize}


### Hamilton -- No TF-IDF

\scriptsize
\centering

``` r
wordcloud::wordcloud(words = top_hamilton$word,
                     freq = top_hamilton$n,
                     vfont=c("serif","plain")) # No TF-IDF
```



\begin{center}\includegraphics{Class_6_Modeling_Bag_of_Words_files/figure-beamer/no_tf_idf-1} \end{center}


### Hamilton -- TF-IDF
\scriptsize
\centering

``` r
wordcloud::wordcloud(words = top_hamilton$word,
                     freq = top_hamilton$tf_idf,
                     vfont=c("serif","plain")) # TF-IDF
```



\begin{center}\includegraphics{Class_6_Modeling_Bag_of_Words_files/figure-beamer/tf_idf-1} \end{center}


# Looking Forward

### Next Class
\begin{itemize}
\item Next Class: Supervised Learning Methods (Naive Bayes)
\item \textbf{Remember}: Work on final projects! 
\end{itemize}
