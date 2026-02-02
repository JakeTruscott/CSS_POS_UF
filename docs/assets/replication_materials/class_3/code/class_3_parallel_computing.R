################################################################################
# Class 3 - Parallel in R
# POS6933: Computational Social Science
# Jake S. Truscott
# Updated February 2026
################################################################################

################################################################################
# Packages & Libraries
# note: install.packages('PACKAGE') if not already installed
################################################################################

library(dplyr); library(ggplot2); library(parallel); library(doParallel)


################################################################################
# Check Core Allocation on Local System
################################################################################

numcores <- parallel::detectCores() # Check Cores
message('You Have ', numcores, ' Cores Available for Use!')


################################################################################
# Create Socket Cluster
################################################################################

cl <- makeCluster(numcores - 1) # Create a Socket Cluster
doParallel::registerDoParallel(cl) # Register the Parallel Environment (cl)
stopCluster(cl) # Relieves Cluster (Super Important!!!)


################################################################################
# Benchmarking a Tedious Function
################################################################################

tedious_function <- function(x) {
  y <- rnorm(10000000)
  mean(y^2)
}

cl <- makeCluster(numcores - 1)
doParallel::registerDoParallel(cl)

serial <- system.time({
  serial_run <- lapply(1:numcores, tedious_function)
}) # Serial Run (numcores times)


parallel <- system.time({
  parallel_run <- parLapply(cl, 1:10, tedious_function)
}) # Parallel Run (numcores times)

stopCluster(cl) # Shut Down Parallel

print(serial)
print(parallel)


################################################################################
# Problem Set Example 1
################################################################################
"Write a function to sample at least 100 draws 100k times from a distribution of your choice before performing a secondary task to recover the mean value. Afterwards, compare the performance of your task given a serial versus parallel approach with at least three different sizes of cores being allocated. For this comparison, construct a table using `stargazer(html)` to record the computation strategy, number of cores, completion time, mean value, and 95 percent confidence intervals. (5pts)"

recover_values_normal <- function(number_values, mean, sd){

  temp_values <- rnorm(number_values, mean = mean, sd = 5) # Recover Values
  return(mean(temp_values)) # Recover Mean

} # Recover Values

set.seed(1234) # Random Seed
seeds <- sample(1:100000, size = 100, replace = F)

serial_means <- data.frame()
serial_start <- Sys.time()
for (i in 1:100){
  set.seed(seeds[i]) # Set Random Seed
  temp_mean <- recover_values_normal(number_values = 100000, mean = 10, sd = 5) # Temp Run
  serial_means <- c(serial_means, temp_mean) # Append to Existing Vector
}
serial_end <- Sys.time()
serial_time <- round((serial_end - serial_start)[[1]], 3) # Seconds

{
  serial_mean <- mean(unlist(serial_means))
  serial_se   <- sd(unlist(serial_means)) / sqrt(length(unlist(serial_means)))
  serial_lower <- serial_mean - 1.96 * serial_se
  serial_upper <- serial_mean + 1.96 * serial_se

} # Serial Mean & CIs

parallel_means <- list() # List to Store Means by Core Allocation
cores <- c(2, 4, 6) # Different Allocation Sizes

for (i in cores) {

  recover_values_normal <- function(number_values, mean, sd){

    temp_values <- rnorm(number_values, mean = mean, sd = sd) # Recover Values
    return(mean(temp_values)) # Recover Mean

  }

  cl <- makeCluster(i)  # Create a socket cluster
  doParallel::registerDoParallel(cl) # Activate

  clusterExport(cl, c('recover_values_normal', 'seeds'))  # Allocate Global Environment Objects & Functions to Nodes

  parallel_means_vector <- c()
  parallel_start <- Sys.time() # System Start

  parallel_run <- parLapply(cl, 1:100, function(i) {
    set.seed(seeds[i])  # set a different seed for each iteration
    recover_values_normal(number_values = 100000, mean = 10, sd = 5)
  }) # Run 100 Times

  parallel_end <- Sys.time()
  parallel_time <- round((parallel_end - parallel_start)[[1]], 3)

  stopCluster(cl) # Stop Cluster

  parallel_means[[as.character(i)]] <- list(
    time = parallel_time,
    means = unlist(parallel_run)
  )


} # Run Parallel



summary_serial_parallel <- data.frame(
  method = c('Serial', rep('Parallel', 3)),
  cores_allocated = c(1, cores),
  time_completion = c(serial_time, sapply(c("2", "4", "6"), function(i) parallel_means[[i]]$time)),
  mean = c(serial_mean, sapply(c("2", "4", "6"), function(i) mean(parallel_means[[i]]$means))),
  lower_ci = c(serial_lower,  sapply(c("2", "4", "6"), function(i) {
    x <- parallel_means[[i]]$means
    m <- mean(x)
    se <- sd(x) / sqrt(length(x))
    lower <- m - 1.96 * se
    return(lower)})),
  upper_ci = c(serial_upper,
               sapply(c("2", "4", "6"), function(i) {
                 x <- parallel_means[[i]]$means
                 m <- mean(x)
                 se <- sd(x) / sqrt(length(x))
                 upper <- m + 1.96 * se
                 return(upper)}))
) %>%
  mutate(mean = round(mean, 2),
         lower_ci = round(lower_ci, 3),
         upper_ci = round(upper_ci, 3)) %>%
  rename(
    Method = method,
    `Cores Allocated` = cores_allocated,
    `Completion Time` = time_completion,
    Mean = mean,
    `Lower CI` = lower_ci,
    `Upper CI` = upper_ci
  ) %>%
  as_tibble()

stargazer::stargazer(tibble::as.tibble(summary_serial_parallel),
                     summary = F,
                     type = 'text') # Produce Table



################################################################################
# Problem Set Example 2
################################################################################

"Create an artificial dataset consisting of one dependent variable and at least five independent variables (6 total). The dataset should contain no fewer than 100,000 observations. For replication purposes, label the dependent variable as y and the independent variables as x1 through x5. You may specify the distributions and variances of these variables at your discretion, though y should be a linear combination of atleast three predictors plus random error. Afterwards, create a function that randomly samples 10,000 observations without replacement from this dataset, recovers coefficients from a linear model, and subsequently estimates predictive values (or probabilities) using `predict()` across an expanded grid (`expand.grid()`) that ranges the scope of values for x1-x5. Completing this process 1,000 times using a serial configuration before transitioning and repeating using parallel with <em>at least</em> half + 1 cores available on your personal computer. For this comparison, construct a table using `stargazer(html)` to record the computation strategy, number of cores, and completion time. (5pts)"


n = 100000
x1 <- rnorm(n, mean = 0, sd = 1)
x2 <- rnorm(n, mean = 5, sd = 2)
x3 <- runif(n, min = -1, max = 1)
x4 <- rnorm(n, mean = 10, sd = 5)
x5 <- rexp(n, rate = 1/2)
y <- 3 + 1.5*x1 - 2*x2 + 0.5*x3 + rnorm(n, mean = 0, sd = 5) # Y is Linear Combination of Predictors + Noise

sim_data <- data.frame(y, x1, x2, x3, x4, x5) # Combine to Single DF

summary(sim_data)

set.seed(1234) # Random Seeds
seeds <- sample(1:100000, size = 1000, replace = F)

###############
# Serial
###############
serial_completion <- system.time(
  for (i in 1:1000){
    set.seed(seeds[i]) # Replication
    sample_data <- sim_data %>%
      slice_sample(n = 10000) # Ranomly Grabs 10k Rows
    temp_model <- lm(y ~ x1 + x2 + x3 + x4 + x5, data = sample_data) # Sample LM Model
    newdata <- expand.grid(
      x1 = seq(min(sim_data$x1),max(sim_data$x1), sd(sim_data$x1)*2),
      x2 = seq(min(sim_data$x2),max(sim_data$x2), sd(sim_data$x2)*2),
      x3 = seq(min(sim_data$x3),max(sim_data$x3), sd(sim_data$x3)*2),
      x4 = seq(min(sim_data$x4),max(sim_data$x4), sd(sim_data$x4)*2),
      x5 = seq(min(sim_data$x5),max(sim_data$x5), sd(sim_data$x5)*2)
    ) # Builds a New Dataset Where Each Value of x1-x5 is covered within +/- 2 SDs from Between Min and Max
    predictions <- predict(temp_model, newdata)
  })[['elapsed']] # Run 100 Times, Recording Completion Time Once Complete


###############
# Parallel
###############

cores <- c(2, 4, 6)
parallel_completion_times <- c()
for (i in cores){

  cl <- makeCluster(i)
  doParallel::registerDoParallel(cl)
  clusterExport(cl, c('seeds', 'sim_data'))
  clusterEvalQ(cl, {
    library(dplyr)
  })

  parallel_completion <- system.time({
    parallel_run <- parLapply(cl, 1:1000, function(i) {
      set.seed(seeds[i])
      sample_data <- sim_data %>% slice_sample(n = 10000)
      temp_model <- lm(y ~ x1 + x2 + x3 + x4 + x5, data = sample_data)
      newdata <- expand.grid(
        x1 = seq(min(sim_data$x1), max(sim_data$x1), sd(sim_data$x1) * 2),
        x2 = seq(min(sim_data$x2), max(sim_data$x2), sd(sim_data$x2) * 2),
        x3 = seq(min(sim_data$x3), max(sim_data$x3), sd(sim_data$x3) * 2),
        x4 = seq(min(sim_data$x4), max(sim_data$x4), sd(sim_data$x4) * 2),
        x5 = seq(min(sim_data$x5), max(sim_data$x5), sd(sim_data$x5) * 2)
      )
      predict(temp_model, newdata = newdata)
    })
  })[['elapsed']]

  stopCluster(cl)

  parallel_completion_times <- c(parallel_completion_times, parallel_completion)


} # Run 100 Times, Recording Completion Time Once Complete Each Core Allocation

########################################
# Combine and Produce Table
########################################

summary_serial_parallel <- data.frame(
  `Method` = c('Serial', rep('Parallel', 3)),
  `Cores` = c(1, cores),
  `Completion Time` = round(c(serial_completion, parallel_completion_times), 3)
) %>%
  as_tibble()

stargazer::stargazer(summary_serial_parallel, summary = F, type = 'text')





################################################################################
# Another Parallel Script
# Grid of Model Specifications -- Runs Model & Recovers Results
################################################################################

model_worker <- function(data){

  n = data$n
  beta = data$beta
  noise = data$noise
  sim_id = data$sim_id

  x <- rnorm(data$n) # X = Random Values from Normal Distribution
  y <- data$beta * x + rnorm(n, sd = data$noise) # Y = X + Noise
  fit <- lm(y ~ x) # Simulate Model

  list(
    sim_id = data$sim_id,
    n = data$n,
    beta_hat = coef(fit)[2],
    se_hat = summary(fit)$coefficients[2,2],
    r2 = summary(fit)$r.squared
  )

} # Function to Run Model -- Recovers Results

data_grid <- expand.grid(
  n = c(100, 500, 1000), # 100, 500, or 1000 Runs
  beta = c(0.5, 1, 2), # Beta = 0.5, 1, or 2
  noise = c(0.5, 1), # Noise = 0.5 or 1
  sim_id = 1:20 # ID = 1:20
)

task_list <- split(data_grid, seq_len(nrow(data_grid))) # Partitions Data Grid to Individual Tasks

run_parallel_models <- function(task_list, n_cores = detectCores() - 1){

  cl <- makeCluster(n_cores) # Defaults to Total Cores - 1

  clusterSetRNGStream(cl, iseed = 1234) # Sets Seed Across All Cores

  clusterEvalQ(cl, {
    library(stats)
    NULL
  }) # Export stats Package to Each Worker

  clusterExport(cl,
                varlist = c("model_worker"),
                envir = environment()
  ) # Make Sure Every Worker Gets model_worker Function

  results <- parLapply(cl, task_list,
                       function(data_row) {
                         tryCatch(
                           model_worker(data_row),
                           error = function(e) {
                             list(sim_id = data_row$sim_id,
                                  error = TRUE,
                                  msg = e$message)
                           })
                       }) # Try to Recover Results (parLapply automatically distributes across workers!)

  stopCluster(cl) # Shut Down Workers

  results_df <- do.call(rbind, lapply(results, as.data.frame)) # Combines All the Results to Single DF

  list(raw_results = results,
       results_df  = results_df)
}


out <- run_parallel_models(task_list,
                           ncores = detectCores() - 1) # Run in Parallel

head(out$results_df) # Peek Results DF



