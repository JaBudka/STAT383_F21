###########################################################################
###### Probability, Statistics, and Data A Fresh Approach Using R    ######
###### By Darrin Speegle and Bryan Clair                             ######
###### online textbook:                                              ######
###### https://mathstat.slu.edu/~speegle/_book/preface.html          ######
###########################################################################

#############################################################
############ Chapter 3 Discrete Random Variables ############
#############################################################



# Example 3.5
# Let X denote the number of Heads observed when a coin is tossed 
# three times. Estimate the pdf. 
nsim = 10000
X <- replicate(nsim, {
  coin_toss <- sample(c("H", "T"), 3, replace = TRUE)
  sum(coin_toss == "H")
})

table(X) / nsim
# Here we sample 30 values of  X without "flipping" any "coins":
sample(0:3, 30, replace = TRUE, prob = c(0.125, 0.375, 0.375, 0.125))



# Example 3.9
# Using simulation, we determine the expected value of a die roll. 
# Here are 30 observations and their average:
rolls <- sample(1:6, 30, replace = TRUE)
rolls
mean(rolls)
# The mean appears to be somewhere between 3 and 4. 
# Using more trials gives more accuracy:  
rolls <- sample(1:6, 10000, replace = TRUE)
mean(rolls)



# Example 3.12
# Let X denote the number of heads observed when 3 coins are tossed.
# Estimate E[X].  
X <- replicate(10000, {
  coin_toss <- sample(c("H", "T"), 3, replace = TRUE)
  sum(coin_toss == "H")
})
mean(X)


# Figure 3.2: Binomial distributions with p=0.5 and various values of n.
par(mfrow = c(2,2))
# flip 10 coins 10,000 times
hist(rbinom(10000, 10, 0.5), xlim = c(0,80))
# flip 20 coins 10,000 times
hist(rbinom(10000, 20, 0.5), xlim = c(0,80))
# flip 50 coins 10,000 times
hist(rbinom(10000, 50, 0.5), xlim = c(0,80))
# flip 100 coins 10,000 times
hist(rbinom(10000, 100, 0.5), xlim = c(0,80))



# Figure 3.3: Binomial distributions with  n=100 and various values of p.
par(mfrow = c(2,2))
hist(rbinom(10000, 100, 0.2), xlim = c(0,100))
hist(rbinom(10000, 100, 0.5), xlim = c(0,100))
hist(rbinom(10000, 100, 0.7), xlim = c(0,100))
hist(rbinom(10000, 100, 0.95), xlim = c(0,100))
  
  
# Example
# It is known that any toy produced by a certain 
# machine will be defective with probability 0.02, 
# independently of any other toy. Suppose we sample 
# 50 toys produced from this machine.

# part 2.  Use R command to compute the probability that 
# there are five defective toys in the sample.
dbinom(x = 5, size = 50, prob = 0.02)
# part 3.Find the probability that at most three will be defective. 
dbinom(x = 0:3, size = 50, prob = 0.02)
sum ( dbinom(x = 0:3, size = 50, prob = 0.02)  )
# part 4. Find the probability that at least three will be defective. 
1- sum ( dbinom(x = 0:2, size = 50, prob = 0.02)  )  
# part 5. Calculate P(2 =< X =< 6).
sum ( dbinom(x = 2:6, size = 50, prob = 0.02)  ) 



# Example 3.24
# Roll a die until a 4 is tossed. What is the expected number of rolls? 
event <- replicate(10000, {
  roll <- sample(1:6, 100, replace = TRUE)
  which(roll == 4)[1]
})
mean(event)



# Example 3.32
# Variance of a die roll is
X <- sample(1:6, 100000, replace = TRUE)
var(X)
# standard deviation of a die roll is
sd(X)



# Figure 3.6: Poisson pmfs with various means
par(mfrow = c(2, 2))
hist(rpois(99999, 5), xlim = c(0, 40), col = "red", xlab="x", main = "lambda=5")
hist(rpois(99999, 10), xlim = c(0, 40), col = "red", xlab="x", main = "lambda=10")
hist(rpois(99999, 15), xlim = c(0, 40), col = "red", xlab="x", main = "lambda=15")
hist(rpois(99999, 20), xlim = c(0, 40), col = "red", xlab="x", main = "lambda=20")

 
# Example 3.38
# Suppose a typist makes typos at a rate of 3 typos per 10 pages. 
# 1. What is the probability that they will make 
# exactly 2 typos on a 10 page document? 
dpois(2, 3)
# 2. What is the probability that they will make 
# at most 1 typo on a five page document?
ppois(1, 1.5)

  
  