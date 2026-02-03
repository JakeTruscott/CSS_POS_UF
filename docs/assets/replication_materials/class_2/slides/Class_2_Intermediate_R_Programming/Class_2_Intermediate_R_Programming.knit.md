---
title: "Intermediate \\texttt{R} Programming"
author: "Jake S. Truscott, Ph.D"
subtitle: |
  POS6933: Computational Social Science
institute: |
  \vspace{-5mm} University of Florida \newline
  Spring 2026 \newline \newline \newline
  \includegraphics[width=3cm]{../../beamer_style/UF.png} \quad 
  \includegraphics[width=3.1cm]{../../images/CSS_POLS_UF_Logo.png}
output: 
  beamer_presentation:
    slide_level: 3
    keep_tex: true
    toc: false
classoption: aspectratio=169  
header-includes:
  - \PassOptionsToClass{aspectratio=169}{beamer}
  - \usepackage{../../beamer_style/beamer_style}
  - \setbeamersize{text margin left=3.5mm,text margin right=3.5mm}
---



# Overview

### Overview

-   \textbf{Today's Goal}: Improve Effectiveness w/ \texttt{R} Programming

    \par \vspace{2.5mm}

-   Random Number Generation in \texttt{R}

    \par  \vspace{2.5mm}

-   Loops and Iteration \vspace{2.5mm}

    \par

-   Visualizing Data and Relationships Using \texttt{ggplot::()} \& \texttt{Stargazer}

### Getting Started

- Navigate to main directory folder w/ \texttt{R} environment \& 3 folders (data, code, practice_set) \par \vspace{2.5mm}
- Open the \texttt{R} environment, then \texttt{File} $\rightarrow$ \text{New File + R Script} \par \vspace{2.5mm}
- Run the code emailed earlier today -- this will download code from GitHub walkthroughs

# Random Number Generation

### Coin Flips

\centering

\textbf{What is the probability that any independent coin flip will land on heads?} \pause

\par \vspace{5mm}

\textbf{Does this change if I flip 50 times?} \pause

\par \vspace{5mm}

\textbf{What about 100 times?}\pause

\par \vspace{5mm}

\textbf{What about 1000 times?}\pause

\par \vspace{5mm}

\textbf{What about 10000 times?}

### Coin Flips (Cont.)

\small


\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/coin_10-1} \end{center}

### Coin Flips (Cont.)

\small


\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/coin_100-1} \end{center}

### Coin Flips (Cont.)

\small


\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/coin_1k-1} \end{center}

### Coin Flips (Cont.)

\small


\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/coin_10k-1} \end{center}

### Coin Flips (Cont.)

-   We can use \texttt{sample()} to randomly select elements from a vector
-   In this case, a coin flip where $p(heads) = p(tails) = 0.5$ \small


``` r
sides <- c("Heads", "Tails")  # Flip Options
single_flip <- sample(sides, size = 1)  # Single Draw
print(single_flip)
```

```
[1] "Tails"
```

### 6-Sided Die

-   We can use the same approach to "roll" a six-sided die. \small


``` r
sides <- c(1:6)  # 1, 2, 3, 4, 5, 6
single_roll <- sample(sides, size = 1)  # Single Roll
message("Result of Single Roll: ", single_roll)
```

```
Result of Single Roll: 2
```

\small

### Poker Hands {.fragile}

-   We can even use it to do more complex operations like simulate a random draw from 5-card Poker \tiny


``` r
cards <- as.character(c(2:10, "J", "Q", "K", "A"))
# All Card Values
suits <- c("Hearts", "Diamonds", "Spades", "Clubs")
# Suits

deck <- expand.grid(value = cards, suit = suits) %>%
    mutate(card = paste(value, "of", suit)) %>%
    pull(card)  # Create a Full Deck

random_draw <- sample(deck, size = 5, replace = F)
# Random 5-Card Draw w/out Replacement
```

### Poker Hands (Cont.) {.fragile}


```
Hand: 
3 of Diamonds
5 of Hearts
10 of Diamonds
2 of Diamonds
Q of Diamonds
```

### Generating Distributions

-   What if we wanted to move beyond random selection where each draw or iteration exists with equal probability or within a uniform distribution?

    \par \vspace{5mm}

-   \texttt{R} is very flexible and capable of illustrating sampling distributions against expected outcomes

### Generating Distributions (Standard Normal)

-   Let's start with 1000 samples from a standard normal distribution where $\mu$ = 50 and $\sigma$ = 10


``` r
normal <- rnorm(1000, mean = 50, sd = 10)
```


\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/normal_distribution_figure-1} \end{center}

### Generating Distributions (Standard Normal)

-   \textbf{Your Turn}: Generate 1000 draws from a standard normal distribution where $\mu$ = 25 and $\sigma$ = 10.

### Generating Distributions (Standard Normal -- Ex)


``` r
normal <- rnorm(1000, mean = 25, sd = 10)
```


\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/normal_distribution_ex_figure-1} \end{center}

### Generating Distributions (Exponential -- Ex)

-   \textbf{Your Turn}: Generate 1000 draws from an exponential distribution where \texttt{rate} = 2

### Generating Distributions (Exponential -- Ex)


``` r
exp <- rexp(1000, rate = 2)
```


\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/rexp_ex_figure-1} \end{center}

# Functions

### Functions (Basics)

-   Functions are reusable blocks of code that perform a specific task when called, helping avoid repetition.

    \par \vspace{2.5mm}

-   They can take arguments (inputs) and return values (outputs), making them flexible and generalizable.

    \par \vspace{2.5mm}

-   They can also be combined, nested, and used within other functions to build complex workflows in a clear, organized way.

### Functions (Basic Syntax)

\small


``` r
function_name <- function(input_1, input_2) {

    # Code to Assume Input_1 and Input_2

    # return(Return Output Value or Object)

}
```

### Functions (Example)

\small


``` r
add_numbers <- function(x, y) {
    result <- x + y
    return(result)
}

add_numbers(5, 3)
```

### Functions (Basics, Cont.)

-   Take some time to try your own!
-   Try:
    -   Random Number Generation
    -   Easy Task Completion (e.g., addition, subtraction, etc.)

# Loops

### Loops (Basics)

-   In \texttt{R}, a for loop is a control structure used to repeat a block of code a fixed number of times, iterating over a sequence of values. The basic syntax is:


``` r
for (variable in sequence) {
    # Repeating Code Routine return(Result Value
    # or Object)
}
```

### Loops (Basics, Cont.)

-   For example, we can complete basics rolls of six-sided dice:

\footnotesize


``` r
rolls <- c()

for (i in 1:10) {

    temp_roll <- sample(1:6, 1, replace = TRUE, prob = rep(1/6,
        6))

    rolls <- c(rolls, temp_roll)
}

rolls  # Print
```

```
 [1] 4 6 3 1 2 2 3 2 5 5
```

### Loops (Basics, Cont.)

-   We can also conditionally iterate through different values from the \texttt{functions} example

\footnotesize


``` r
add_numbers <- function(x, y) {
    result <- x + y
    return(result)
}

available_values <- c(1:10)
sums <- c()

for (pair in seq(1:10)) {
    temp_pair <- sample(available_values, 2)
    sums <- c(sums, add_numbers(temp_pair[1], temp_pair[2]))
}

sums
```

```
 [1]  9  7  9  9 12 15 19 15  8 13
```

### Loops (Basics, Cont.)

-   I can also deal 5 hands from a standard 52-card deck for a game of Texas Hold 'Em

    \par \vspace{2.5mm}

-   Here's the setup -- What's Next?

\footnotesize


``` r
set.seed(1234)  # Seed
cards <- as.character(c(2:10, "J", "Q", "K", "A"))
suits <- c("Hearts", "Diamonds", "Spades", "Clubs")
deck <- expand.grid(value = cards, suit = suits) |>
    mutate(card = paste(value, "of", suit)) |>
    pull(card)  # Create a Full Deck

hands <- lapply(1:5, function(x) x)
```

### Loops (Basics, Cont.)

\footnotesize


``` r
for (card in 1:2) {
    for (player in 1:5) {
        temp_player_card <- sample(deck, 1, replace = F)
        deck <- deck[!deck %in% temp_player_card]
        hands[[player]][card] <- temp_player_card
    }  # For All 5 Players
}  # For Both Cards

do.call(cbind, hands)
```

```
     [,1]          [,2]            [,3]           
[1,] "3 of Spades" "4 of Diamonds" "J of Diamonds"
[2,] "A of Clubs"  "10 of Hearts"  "6 of Hearts"  
     [,4]         [,5]           
[1,] "2 of Clubs" "10 of Clubs"  
[2,] "6 of Clubs" "7 of Diamonds"
```

### Games of Chance: Blackjack

\centering

\textbf{What are the basic rules of Blackjack?}

\par \vspace{5mm}

\includegraphics[width=9cm]{../../images/blackjack.png}

### Rules of Blackjack:

-   Objective: Beat the dealer by getting closer to 21 without going over
-   Card values:
    -   Number Cards = Face Value
    -   Face Cards = 10 (Aces = 1 *or* 11)
-   Dealer Rules: Dealer reveals cards after players act and must hit until *at least* 17
-   Gameplay:
    -   Go Over 21 = **BUST** (Loss)

    -   Tie w/ Dealer = Push (No Win/Loss)

    -   Standard Win = **1:1** (Win Bet x2)

    -   Blackjack (Ace + 10-Value Card = **3:2**

### Blackjack Exercise

```{=tex}
\begin{center}
\textbf{Write an \texttt{R} routine to play a round of Blackjack. I will do the same.}
\end{center} \par \vspace{5mm}
```
-   *Hint*: Sample from all 52 cards without replacement...

### Blackjack Exercise (Cont.)

1.  What if we play with a four-deck shoe? \pause

    \par \vspace{2.5mm}

2.  What if I wanted to repeat this process 1,000 times?

    \par \vspace{2.5mm}

*Hint*: Use a loop!

### Blackjack Exercise (Cont.)

1.  Assume I begin with \$1000 every day and bet \$100 each game (though I'll only play 10 hands...). Over 100 days, approximately how much money am I left with? *Note*: If I run out of money on a given day, I'm done -- also, each day restarts with \$1000 but previous day's leftover sum is added to aggregate winnings.

    \par \vspace{2.5mm}

2.  What if I start with \$1000 but don't replace the money every day... How much will I have after 10 days? 50 days?

    \par \vspace{2.5mm}

3.  Take some time then play around with blackjack_simulation.R

### Roulette Exercise

-   Head over to Course GitHub (Intermediate Programming in \texttt{R})
-   Bottom of \texttt{Number Generation \& Loops}

# Data Visualization

-   \texttt{ggplot()} is an incredibly flexible visualization tool

    \par \vspace{2.5mm}

-   There's a balance between professional & \textit{noisy} visualizations

    \par \vspace{2.5mm}

-   Some journals & reviewers are more critical than others

    \par \vspace{2.5mm}

-   \textbf{Goal}: \textit{Publication-ready} visualizations capable of relaying inferential value on its own

### My Default ggplot() Aesthetics

\scriptsize


``` r
default_ggplot_theme  <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 12),
    
    axis.title = element_text(size = 12, colour = 'black'),
    
    axis.text = element_text(size = 10, colour = 'black'),
    
    panel.background = element_rect(linewidth = 1, colour = 'black', fill = NA), 
    
    legend.position = 'bottom', 
    
    legend.background = element_rect(linewidth = 1, colour = 'black', fill = NA), 
  )
```

### My Default ggplot() Aesthetics

\scriptsize


``` r
set.seed(1234)

sample_data <- tibble(x = c(1:100), y = rnorm(100,
    mean = 0.75, sd = 0.33))

summary(sample_data)
```

```
       x                y           
 Min.   :  1.00   Min.   :-0.02408  
 1st Qu.: 25.75   1st Qu.: 0.45454  
 Median : 50.50   Median : 0.62307  
 Mean   : 50.50   Mean   : 0.69827  
 3rd Qu.: 75.25   3rd Qu.: 0.90550  
 Max.   :100.00   Max.   : 1.59117  
```

### My Default ggplot() Aesthetics

\scriptsize


``` r
sample_data %>%
    ggplot(aes(x = x, y = y)) + geom_point() + geom_smooth(method = "lm",
    formula = "y~x")
```



\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/default_ggplot_application_2-1} \end{center}

### Adding Default Aes

\scriptsize


\begin{center}\includegraphics{Class_2_Intermediate_R_Programming_files/figure-beamer/default_ggplot_application_3-1} \end{center}

# Stargazer

### Stargazer

\scriptsize


``` r
library(stargazer)
temp_lm <- lm(Sepal.Length ~ Sepal.Width + Petal.Length +
    Petal.Width, data = iris)

stargazer::stargazer(temp_lm, type = "text", omit.stat = c("ser",
    "f", "adj.rsq"), dep.var.caption = "")
```

### Stargazer -- Text Example

\scriptsize


```

========================================
                    Sepal.Length        
----------------------------------------
Sepal.Width           0.651***          
                       (0.067)          
                                        
Petal.Length          0.709***          
                       (0.057)          
                                        
Petal.Width           -0.556***         
                       (0.128)          
                                        
Constant              1.856***          
                       (0.251)          
                                        
----------------------------------------
Observations             150            
R2                      0.859           
========================================
Note:        *p<0.1; **p<0.05; ***p<0.01
```

### Stargazer -- Latex Example (type = 'latex')

\tiny

```

% Table created by stargazer v.5.2.3 by Marek Hlavac, Social Policy Institute. E-mail: marek.hlavac at gmail.com
% Date and time: Tue, Jan 27, 2026 - 7:59:23 AM
\begin{table}[!htbp] \centering 
  \caption{} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
\\[-1.8ex] & Sepal.Length \\ 
\hline \\[-1.8ex] 
 Sepal.Width & 0.651$^{***}$ \\ 
  & (0.067) \\ 
  & \\ 
 Petal.Length & 0.709$^{***}$ \\ 
  & (0.057) \\ 
  & \\ 
 Petal.Width & $-$0.556$^{***}$ \\ 
  & (0.128) \\ 
  & \\ 
 Constant & 1.856$^{***}$ \\ 
  & (0.251) \\ 
  & \\ 
\hline \\[-1.8ex] 
Observations & 150 \\ 
R$^{2}$ & 0.859 \\ 
\hline 
\hline \\[-1.8ex] 
\textit{Note:}  & \multicolumn{1}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
\end{tabular} 
\end{table} 
```

### Stargazer -- Latex Example Rendered

```{=tex}
\tiny
\begin{table}[!htbp] \centering 
  \caption{Rendered \texttt{stargazer} Table} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
\\[-1.8ex] & Sepal.Length \\ 
\hline \\[-1.8ex] 
 Sepal.Width & 0.651$^{***}$ \\ 
  & (0.067) \\ 
  & \\ 
 Petal.Length & 0.709$^{***}$ \\ 
  & (0.057) \\ 
  & \\ 
 Petal.Width & $-$0.556$^{***}$ \\ 
  & (0.128) \\ 
  & \\ 
 Constant & 1.856$^{***}$ \\ 
  & (0.251) \\ 
  & \\ 
\hline \\[-1.8ex] 
Observations & 150 \\ 
R$^{2}$ & 0.859 \\ 
\hline 
\hline \\[-1.8ex] 
\textit{Note:}  & \multicolumn{1}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
\end{tabular} 
\end{table}
```
### Stargazer -- Multiple Models



```{=tex}
\tiny
\begin{table}[!htbp] \centering 
  \caption{Rendered \texttt{stargazer} Table with 2 Models} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lcc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
\\[-1.8ex] & \multicolumn{2}{c}{Sepal.Length} \\ 
\\[-1.8ex] & (1) & (2)\\ 
\hline \\[-1.8ex] 
 Sepal.Width & 0.651$^{***}$ &  \\ 
  & (0.067) &  \\ 
  & & \\ 
 Petal.Length & 0.709$^{***}$ &  \\ 
  & (0.057) &  \\ 
  & & \\ 
 Petal.Width & $-$0.556$^{***}$ & $-$0.311$^{***}$ \\ 
  & (0.128) & (0.114) \\ 
  & & \\ 
 Sepal.Width:Petal.Length &  & 0.185$^{***}$ \\ 
  &  & (0.017) \\ 
  & & \\ 
 Constant & 1.856$^{***}$ & 4.150$^{***}$ \\ 
  & (0.251) & (0.078) \\ 
  & & \\ 
\hline \\[-1.8ex] 
Observations & 150 & 150 \\ 
R$^{2}$ & 0.859 & 0.821 \\ 
\hline 
\hline \\[-1.8ex] 
\textit{Note:}  & \multicolumn{2}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
\end{tabular} 
\end{table}
```
### Stargazer -- Summary Data

\footnotesize


``` r
stargazer(iris, type = "text", summary = TRUE, title = "Summary of Iris Dataset")
```

```

Summary of Iris Dataset
===========================================
Statistic     N  Mean  St. Dev.  Min   Max 
-------------------------------------------
Sepal.Length 150 5.843  0.828   4.300 7.900
Sepal.Width  150 3.057  0.436   2.000 4.400
Petal.Length 150 3.758  1.765   1.000 6.900
Petal.Width  150 1.199  0.762   0.100 2.500
-------------------------------------------
```

### Visualization Example

-   Using the \texttt{mtcars} dataset – \texttt{library(mtcars)} – complete the following: \par \vspace{2.5mm}
    1.   Using \texttt{mpg} as the dependent variable, compile two models using \texttt{cyl}, \texttt{disp}, \texttt{hp}, and \texttt{wt} – the second should have an interaction between \texttt{disp} and \texttt{wt}. \par \vspace{1.5mm}
    2.  Produce a table using \texttt{stargazer} of the resulting models. \par \vspace{1.5mm}
    3.  Use \texttt{ggplot} to illustrate the distribution of each of the variables listed in (1).
    
    
# Looking Forward

### Looking Forward

- Homework: Problem Set (Class 2) \par \vspace{2.5mm}
- Next Class: Parallel Computing 
