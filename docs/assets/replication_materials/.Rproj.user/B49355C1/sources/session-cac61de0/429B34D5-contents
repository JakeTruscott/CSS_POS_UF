################################################################################
# Class 2 - Intermediate Coding in R
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated January 2026
################################################################################

################################################################################
# Packages & Libraries
################################################################################

library(dplyr); library(ggplot2); library(ggtext); library(cowplot)


################################################################################
# Number Generation
################################################################################

set.seed(1234) # Random Seed

uniform <- runif(1000, min = 0, max = 10) # Uniform Distribution

normal <- rnorm(1000, mean = 0, sd = 1) # Standard Normal (Mean = 0, SD = 1)

exponential <- rexp(1000, rate = 1) # Exponential Distribution (Rate = 1)

poisson <- rpois(1000, lambda = 3) # Poisson Distribution (Count)

binomial <- rbinom(1000, size = 10, prob = 0.5) # Bernoulli Distribution

geometric <- rgeom(1000, prob = 0.3) # Geometric Distribution

negative_binomial <- rnbinom(1000, size = 5, prob = 0.4) # Negative Binomial

chi_sq <- rchisq(1000, df = 4) # Chi-Square Distribution (4 Degrees of Freedom)

students_t <- rt(1000, df = 5) # Students T (5 DF)

################################################################################
# Plotting Generated Distributions
################################################################################


plot_continuous <- function(data, dist_fun, dist_args, title, bins = 30, from = min(data), to = max(data)) {
  ggplot(data.frame(x = data), aes(x)) +
    geom_histogram(aes(y = after_stat(density)), bins = bins,
                   fill = "skyblue4", color = "black", alpha = 0.4) +
    stat_function(fun = dist_fun, args = dist_args, color = "red", size = 1.2) +
    labs(title = title, x = '\n', y = 'Density\n') +
    theme_minimal() +
    theme(panel.border = element_rect(linewidth = 1 , colour = 'black', fill = NA),
          axis.title = element_text(size = 10, colour = 'black'),
          axis.text = element_text(size = 8, colour = 'black'),
          plot.title = element_text(size = 12, colour = 'black', vjust = 0.5, hjust = 0.5))
}

plot_discrete <- function(data, dist_fun, dist_args, title) {
  df <- data.frame(x = data)
  probs <- tibble::tibble(x = min(df$x):max(df$x),
                          p = dist_fun(min(df$x):max(df$x), !!!dist_args))
  ggplot(df, aes(x)) +
    geom_bar(aes(y = after_stat(prop)), fill = "skyblue4", color = "black", alpha = 0.6) +
    geom_point(data = probs, aes(x, p), color = "red", size = 1) +
    geom_line(data = probs, aes(x, p), color = "red", size = 1) +
    labs(title = title, x = '\n', y = "Probability\n", ) +
    theme_minimal() +
    theme(panel.border = element_rect(linewidth =1 , colour = 'black', fill = NA),
          axis.title = element_text(size = 10, colour = 'black'),
          axis.text = element_text(size = 8, colour = 'black'),
          plot.title = element_text(size = 12, colour = 'black', vjust = 0.5, hjust = 0.5))
}

p1 <- plot_continuous(uniform, dunif, list(min = 0, max = 10), "Uniform(0,10)")
p2 <- plot_continuous(normal, dnorm, list(mean = 0, sd = 1), "Normal(0,1)")
p3 <- plot_continuous(exponential, dexp, list(rate = 1), "Exponential(1)")
p4 <- plot_discrete(poisson, dpois, list(lambda = 3), "Poisson(3)")
p5 <- plot_discrete(binomial, dbinom, list(size = 10, prob = 0.5), "Binomial(10,0.5)")
p6 <- plot_discrete(geometric, dgeom, list(prob = 0.3), "Geometric(0.3)")
p7 <- plot_discrete(negative_binomial, dnbinom, list(size = 5, prob = 0.4), "Neg. Binomial(5,0.4)")
p8 <- plot_continuous(chi_sq, dchisq, list(df = 4), "Chi-Sq(4)")
p9 <- plot_continuous(students_t, dt, list(df = 5), "Student-t(5)")

plot_grid(p1, p2, p3, p4, p5, p6, p7, p8, p9,  ncol = 3, align = "v")


################################################################################
# Loops -- Base Syntax & Flexibility
################################################################################

for (i in 1:5){
  print(i^2)
} # Base Example


values <- seq(10, 100, by = 10) # Values 10 to 100 by 10
print(values)

values <- c(10:20) # Values 10 to 20 (Inclusive)
print(values)

values <- seq(1, 100, by = 1) # All Values 1 to 100 (Inclusive)

for (i in values){
  if (i %% 10 == 0){
    print(i)
  }
} # For Each Value in `values', if i is neatly divisible by 10, print i

values <- c('a', 'b', 'c', 'd', 'f')

for (i in 1:length(values)){
  print(values[i])
} # For Each Value in Values, Print the Value Indexed values[i]


################################################################################
# Loops -- Example
################################################################################


results <- data.frame() # Empty Dataframe to Store Output
samples <- c(10, 100, 1000, 10000) # Vector of Integers

for (i in 1:length(samples)){

  temp_sample_size <- samples[i] # Recovers the i-th value of the samples vector
  temp_run <- rnorm(temp_sample_size, mean = 50, sd = 5) # Run
  temp_run <- data.frame(sample_size = temp_sample_size,
                         value = temp_run) # Create Temporary dataframe indicating size of samples and values from rbinom()
  results <- bind_rows(results, temp_run) # Export to 'results' data.frame

}

summary(results) # Print Summary


results %>%
  mutate(sample_size = factor(sample_size)) %>%
  ggplot(aes(x = value)) +
  geom_density(aes(fill = sample_size), alpha = 1/3) +
  stat_function(fun = dnorm, args = list(mean = 50, sd = 5),
                color = "red", linewidth = 1.2) +
  labs(x = '\nValue',
       y = 'Density\n',
       fill = 'Sample Size',
       caption = 'Note: Red Line Indicates Normal Distribution (μ = 50, σ = 5)') +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 50, linetype = 2) +
  facet_wrap(~paste0(sample_size, ' Samples')) +
  scale_x_continuous(breaks = seq(35, 65, 5)) +
  theme_minimal() +
  theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
        axis.text = element_text(size = 12, colour = 'black'),
        axis.title = element_text(size = 14, colour = 'black'),
        strip.background = element_rect(linewidth = 1, colour = 'black', fill = 'grey75'),
        strip.text = element_text(size = 12, colour = 'black'),
        legend.position = 'none',
        plot.caption = element_text(hjust = 0.5))


################################################################################
# Roulette
################################################################################

set.seed(1234) # Set Initial Seed
seeds <-  sample(1:1000, size = 100, replace = FALSE) # Random Seeds
roulette_values <- c(rep("red", 18), rep("black", 18), rep("green", 2)) # Roulette Wheel
games <- c() # Empty Vector to Store Winnings (Losses...)

for (i in 1:length(seeds)){

  temp_seed <- seeds[i] # Recover Temporary Seed
  set.seed(temp_seed) # Set Temporary Seed

  available_colors <- c('red', 'black') # Available Roulette Colors
  remaining_funds <- 500 # Starting Money
  current_color <- 'red' # Starting with Red

  for (spin in 1:100){

    temp_spin <- sample(roulette_values, size = 1, replace = T) # Spin!

    if (temp_spin == current_color){
      remaining_funds <- remaining_funds + 10 # Win :D
      current_color = current_color # Keep Color
    } else {
      remaining_funds <- remaining_funds - 10 # Loss :(
      current_color = sample(available_colors[which(!available_colors == current_color)], size = 1, replace = T)
      # If Loss -- Remove $10 and Change Color to Other from Remaining Options
    }
  }
  games <- c(games, remaining_funds) # Export Remaining Funds
}

data.frame(remaining_funds = games) %>%
  ggplot(aes(x = remaining_funds)) +
  geom_histogram(aes(y = after_stat(density)),
                 fill = 'skyblue4', colour = 'black', alpha = 1/3, bins = 20) +
  geom_density(colour = 'red', linetype = 2, linewidth = 1) +
  labs(x = '\nRemaining Funds\n',
       y = ' ',
       fill = 'Sample Size',
       caption = paste0( "Dashed Black Line = Average Remaining Funds Each Day ($", round(mean(games), 0), ")\n",
                         "Dashed Red Line = Starting Funds ($500)" )) +
  geom_vline(xintercept = 500, linetype = 2, colour = 'red') +
  geom_vline(xintercept = mean(games), linetype = 2, colour = 'black') +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
        axis.text.x = element_text(size = 12, colour = 'black'),
        axis.text.y = element_blank(),
        axis.title = element_text(size = 14, colour = 'black'),
        strip.background = element_rect(linewidth = 1, colour = 'black', fill = 'grey75'),
        strip.text = element_text(size = 12, colour = 'black'),
        legend.position = 'none',
        plot.caption = element_text(hjust = 0, size = 10))



################################################################################
# Roulette -- Don't Replace Funds
################################################################################

set.seed(1234) # Set Initial Seed
seeds <-  sample(1:1000, size = 100, replace = FALSE) # Random Seeds
roulette_values <- c(rep("red", 18), rep("black", 18), rep("green", 2)) # Roulette Wheel
games <- c() # Empty Vector to Store Winnings (Losses...)

for (i in 1:length(seeds)){

  temp_seed <- seeds[i] # Recover Temporary Seed
  set.seed(temp_seed) # Set Temporary Seed

  available_colors <- c('red', 'black') # Roulette Colors
  remaining_funds <- ifelse(i == 1, 500, games[i-1])  # Starting Money (500 or Previous Start if i > 1)
  current_color <- 'red' # Starting with Red

  for (spin in 1:100){

    temp_spin <- sample(roulette_values, size = 1, replace = T) # Spin!

    if (temp_spin == current_color){
      remaining_funds <- remaining_funds + 10 # Win :D
      current_color = current_color # Keep Color
    } else {
      remaining_funds <- remaining_funds - 10 # Loss :(
      current_color = sample(available_colors[which(!available_colors == current_color)], size = 1, replace = T)
      # If Loss -- Remove $10 and Change Color to Other from Remaining Options
    }
  }
  games <- c(games, remaining_funds) # Export Remaining Funds
}

data.frame(remaining_funds = games) %>%
  ggplot(aes(x = remaining_funds)) +
  geom_histogram(aes(y = after_stat(density)),
                 fill = 'skyblue4', colour = 'black', alpha = 1/3, bins = 15) +
  geom_density(colour = 'red', linetype = 2, size = 1) +
  labs(x = '\nRemaining Funds\n',
       y = ' ',
       fill = 'Sample Size',
       caption = paste0(
         "Dashed Black Line = Average Remaining Funds After 100 Days $(", round(mean(games), 0), ")"
       )) +
  geom_vline(xintercept = 500, linetype = 2, colour = 'red') +
  geom_vline(xintercept = mean(games), linetype = 2, colour = 'black') +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
        axis.text.x = element_text(size = 12, colour = 'black'),
        axis.text.y = element_blank(),
        axis.title = element_text(size = 14, colour = 'black'),
        strip.background = element_rect(linewidth = 1, colour = 'black', fill = 'grey75'),
        strip.text = element_text(size = 12, colour = 'black'),
        legend.position = 'none',
        plot.caption = element_text(hjust = 0, size = 10))


################################################################################
# Roulette -- Bond Strategy
################################################################################


set.seed(1234) # Set Initial Seed
seeds <-  sample(1:1000, size = 100, replace = FALSE) # Random Seeds
roulette_values <- as.character(c(1:36, "0", "00")) # Roulette Wheel
bond_wins <- as.character(c(19:36, 13:18, "0", "00")) # Numbers Where James Wins
bets <- c(
  rep(14, 18),    # 19–36
  rep(5, 6),      # 13–18
  rep(0.5, 2)     # 0 and 00
) # Bets Associated with Numbers
payouts <- c(
  rep(8, 18),     # 19–36: +$8 net
  rep(10, 6),     # 13–18: +$10 net
  rep(-2, 2)      # 0 and 00: -$2 net
) # Payouts
bond_payouts <- data.frame(
  number = bond_wins, # Numbers
  bet = bets, # Bet Values
  payout = payouts,  # Associated Payouts
  stringsAsFactors = F
) # Dataframe to Return Payouts for Winning Numbers # Numbers Where James Wins


games <- c() # Empty Vector to Store Winnings (Losses...)

for (i in 1:length(seeds)){

  temp_seed <- seeds[i] # Recover Temporary Seed
  set.seed(temp_seed) # Set Temporary Seed

  remaining_funds <- ifelse(i == 1, 500, games[i-1])  # Starting Money (500 or Previous Day if i > 1)

  for (spin in 1:100){

    temp_spin <- sample(roulette_values, size = 1, replace = T) # Spin!

    if (temp_spin %in% bond_wins){

      temp_payout <- bond_payouts$payout[bond_payouts$number == temp_spin] # Return Temp Payout

      remaining_funds <- remaining_funds + temp_payout # Apply Win :D

    } else {
      remaining_funds <- remaining_funds - 20 # Apply Full $20 Loss :(
    }
  }
  games <- c(games, remaining_funds) # Export Remaining Funds
}


data.frame(remaining_funds = games) %>%
  ggplot(aes(x = remaining_funds)) +
  geom_histogram(aes(y = after_stat(density)),
                 fill = 'skyblue4', colour = 'black', alpha = 1/3, bins = 15) +
  geom_density(colour = 'red', linetype = 2, size = 1) +
  labs(x = '\nRemaining Funds\n',
       y = ' ',
       fill = 'Sample Size',
       caption = paste0(
         "Dashed Black Line = Average Remaining Funds After 100 Days $(", round(mean(games), 0), ")"
       )) +
  geom_vline(xintercept = 500, linetype = 2, colour = 'red') +
  geom_vline(xintercept = mean(games), linetype = 2, colour = 'black') +
  geom_hline(yintercept = 0) +
  theme_minimal() +
  theme(panel.border = element_rect(linewidth = 1, colour = 'black', fill = NA),
        axis.text.x = element_text(size = 12, colour = 'black'),
        axis.text.y = element_blank(),
        axis.title = element_text(size = 14, colour = 'black'),
        strip.background = element_rect(linewidth = 1, colour = 'black', fill = 'grey75'),
        strip.text = element_text(size = 12, colour = 'black'),
        legend.position = 'none',
        plot.caption = element_text(hjust = 0, size = 10))
