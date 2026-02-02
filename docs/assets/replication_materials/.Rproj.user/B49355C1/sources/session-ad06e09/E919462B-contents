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

library(dplyr); library(ggplot2); library(ggtext); library(cowplot); library(parallel); library(doParallel)


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
# More Advanced Parallel Script
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

  clusterSetRNGStream(cl, iseed = 1234) # Sets Initial Seed Across All Cores

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
    }) # Try to Recover Results

  stopCluster(cl) # Shut Down Workers

  results_df <- do.call(rbind, lapply(results, as.data.frame)) # Combines All the Results to Single DF

  list(raw_results = results,
        results_df  = results_df)
}


out <- run_parallel_models(task_list,
                           ncores = detectCores() - 1) # Run in Parallel

head(out$results_df) # Peek Results DF
