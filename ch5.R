###########################################################################
###### Probability, Statistics, and Data A Fresh Approach Using R    ######
###### By Darrin Speegle and Bryan Clair                             ######
###### online textbook:                                              ######
###### https://mathstat.slu.edu/~speegle/_book/preface.html          ######
###########################################################################

#############################################################
############ Chapter 5 Simulation of Random Variables #######
#############################################################


# 5.1 Estimating probabilities
# Example 5.1
# Let Z be a standard normal random variable. Estimate P(Z>1).
Z <- rnorm(10000, 0, 1)
Z
Z > 1
mean(Z > 1)        # estimation 
1 - pnorm(1, 0, 1) # exact answer



# Example 5.2
# Let  Z be a standard normal RV. Estimate P(Z^2>1).
Z <- rnorm(10000)
mean(Z^2 > 1)



# Example 5.3
# Let X be a normal random variable with mean 5 and standard deviation 2. 
# Estimate the mean and standard deviation of X. 
X = rnorm(10000, 5, 2)
mean(X)
sd(X)



# Example 5.5
# Let X and Y be independent standard normal random variables. Estimate P(XY>1).
X <- rnorm(10000)
Y <- rnorm(10000)
mean(X*Y>1)




# Example 5.6
# Suppose that two dice are rolled, and their sum is denoted as $X$. Estimate the
# pmf of $X$ via simulation. Estimate $P(X=5)$.
nsim <- 10000
X = replicate(nsim, {
  roll <- sample(1:6, 2, replace = TRUE)
  sum(roll)
})
mean(X == 5)
# It is possible to repeat this approach for each value  2, 3, ..., 12 but that
# would take a long time. Instead we use table function. 
table(X)/nsim
# PMF
plot(table(X)/nsim)
# or
plot(proportions(table(X)))


# Example 5.11
# Compare the pdf of 2Z, where  Z ~ N(0,1) to the pdf of a normal random variable
# X ~ N(0,2).

# histogram 
Z = rnorm(10000, 0, 1)
hist(2 * Z, probability = TRUE,
     main = "Density and histogram of 2Z")
x <- seq(-10, 10, .1)
curve(dnorm(x, 0, 2), add=TRUE,  col = 2, lwd=2)

# density
Z = rnorm(100, 0, 1)
plot(density(2 * Z), main = "Density and histogram of 2Z")
x <- seq(-10, 10, .1)
curve(dnorm(x, 0, 2), add=TRUE,  col = 2, lwd=2)
legend("topright",
       col = c("black", "red"),
       lwd = c(1,2),
       legend = c("estimation 2*Z", "Normal(2)"))





# Example 5.15
# Let Z be a standard normal RV. Find the pdf of  Z^2 and compare it to the
# pdf of a chi^2 RV with one df on the same plot.
Z <- rnorm(10000)
hist(Z^2,
     probability = T,
     xlab = expression(Z^2)
)
curve(dchisq(x, df = 1), add = TRUE, col = "red")



# Example 5.21
# Let X_1, ... X_30 be independent Poisson random variables with rate 2. 
# From our knowledge of the Poisson distribution, each X_i has mean mu = 2 and
# standard deviation sigma = sqrt{2}. In R, show that frac{\bar{X}-2}{\sqrt{2} / \sqrt{30}} 
# will be approximately normal with mean 0 and standard deviation 1. 

Z <- replicate(1000, {
  X <-rpois(30, 2)
  Xbar <- mean(X)
  (Xbar - 2) / (sqrt(2) / sqrt(30))
})

# plot
par(mfrow = c(1,2))
# poisson(2)
plot(x = 0:10, y = dpois(0:10, 2),
     type = "h",
     ylab = "probability",
     xlab = "X",
     main = "pmf of Pois(2)")
# CLT
plot(density(Z),
     main = "Standardized sum of 30 Poisson RVs",
     xlab = "Z",
     lwd = 2)
curve(dnorm(x), add = TRUE, col = "red")
# legend(
#   "topright",
#   col = c("black", "red"),
#   legend = c("estimation", "Normal(0,sqrt(2))"), lwd = c(2, 1))



# Example 5.30
# Let X_1, ..., X_5 be a random sample from a normal distribution with mean 1
# and variance 4. Compute bar{X} based on the random sample.
set.seed(12)

mean(rnorm(5, 1, 2)) 

mean_5 <- replicate(10000, mean(rnorm(5, 1, 2)))
mean(mean_5)



# Example 5.31
# Let X_1, ..., X_5 be a random sample from a normal distribution with mean 1 and
# variance 4. Estimate the variance sigma^2 using S^2.
sd(rnorm(5, 1, 2))^2

mean(replicate(10000, sd(rnorm(5, 1, 2))^2))




# # 5.5.1 Chi-Squared Distribution
# # Summation of 2 Chi-Squared Distributions is a Chi-Squared Distribution
# X <- rchisq(10000, 2)
# Y <- rchisq(10000, 3)
# hist(X + Y,
#      probability = TRUE,
#      main = "Sum of chi^2 random variables"
# )
# curve(dchisq(x, df = 5), add = TRUE, col = "red")
# 
# 
# # n = 4, mu = 5, sigma = 9
# # sample variance: (n - 1)/sigma^2 * S^2
# S2 <- replicate(10000, 3 / 81 * sd(rnorm(4, 5, 9))^2)
# hist(S2,
#      probability = TRUE,
#      main = "Sample variance compared to chi^2",
#      xlab = expression(S^2),
#      ylim = c(0, .25)
# )
# curve(dchisq(x, df = 3), add = TRUE, col = "red")
# 
# 
# 
# # 5.5.2 The t distribution





