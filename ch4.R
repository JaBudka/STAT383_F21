###########################################################################
###### Probability, Statistics, and Data A Fresh Approach Using R    ######
###### By Darrin Speegle and Bryan Clair                             ######
###### online textbook:                                              ######
###### https://mathstat.slu.edu/~speegle/_book/preface.html          ######
###########################################################################

#############################################################
############ Chapter 4 Continuous Random Variables ############
#############################################################


# Figure 4.6
# Normal distributions with mu=0
# and various values of sigma. 
par(mfrow = c(1, 4))
plot(density(rnorm(99999, 0, 0.5)), xlim = c(-10, 10), col = "red", xlab="x", main = "sd=0.5", ylim = c(0, 0.8))
plot(density(rnorm(99999, 0, 1)), xlim = c(-10, 10), col = "red", xlab="x", main = "sd=1", ylim = c(0, 0.8))
plot(density(rnorm(99999, 0, 2)), xlim = c(-10, 10), col = "red", xlab="x", main = "sd=2", ylim = c(0, 0.8))
plot(density(rnorm(99999, 0, 4)), xlim = c(-10, 10), col = "red", xlab="x", main = "sd=4", ylim = c(0, 0.8))





# Example 4.20
# Let X be Normal(mu=3,sigma=2)
# Find P(X =< 4).
pnorm(4, mean = 3, sd = 2)
# P(0 =< X =<5).
pnorm(5, 3, 2) - pnorm(0, 3, 2)


# Example 4.24
# Suppose you are picking seven women at random from a university 
# to form a starting line-up in an ultimate frisbee game. Assume 
# that women's heights at this university are normally distributed 
# with mean 64.5 inches (5 foot, 4.5 inches) and standard deviation 
# 2.25 inches. What is the probability that 3 or more of the women
# are 68 inches (5 foot, 8 inches) or taller?
pnorm(68, 65, 2.25, lower.tail = FALSE)
sum(dbinom(3:7, 7, 0.09121122))



# Example
# Suppose that the yearly rainfall in Seattle is approximately normally 
# distributed with a mean of 38 inches and standard deviation of 8 inches. 
# 1. What is the probability that it will rain more than 40 inches next year in Seattle?
1 - pnorm(40, 38, 8)
# 2. Find the probability that it will rain between 30 and 50 inches next year in Seattle.
pnorm(50, 38, 8) - pnorm(30, 38, 8)
# 3. What is the 80th percentile of rainfall in Seattle?
qnorm(0.8, 38, 8)
# 4. Between what two values does approximately 95% of Seattle's 
# yearly rainfall fall between?
c(38 - 2 * 8, 38 + 2 * 8)



# 4.4.2 Normal approximation to the binomial
# Theorem 4.6
x <- rbinom(10000, size = 100, prob = 0.5)
hist(x)
plot(density(x))
# theoretical E[X]=np
100*0.5
# estimated E[X]
mean(x)
# theoretical Var[X]=np(1-p)
100*0.5*(1-0.5)
# estimated Var[X]
var(x)


# Example 4.26
# Let X be RV with a binomial distribution with n=300 and p=0.46.
# Compute P(X>150).

# 1. Computing P(X>150) using a binomial distribution RV
1 - pbinom(150, size = 300, prob = 0.46)
# 2. Computing P(X>150) using a normal distribution RV
1-pnorm(150, mean = 300*0.46, sd = sqrt(300*0.46*(1-0.46)))
# we see that  0.07398045 and 0.08224985 are approximately equal. 

