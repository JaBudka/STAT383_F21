###########################################################################
###### Probability, Statistics, and Data A Fresh Approach Using R    ######
###### By Darrin Speegle and Bryan Clair                             ######
###### online textbook:                                              ######
###### https://mathstat.slu.edu/~speegle/_book/preface.html          ######
###########################################################################

#############################################################
############ Chapter 7 Data Visualization with ggplot #######
#############################################################



# Data visualization is a critical aspect of statistics and data science.
# Visualization is crucial for communication because it presents the 
# essence of the underlying data in a way that is immediately understandable. 
# Visualization is also a tool for exploration that may provide insights into
# the data that lead to new discoveries.
# 
# This chapter introduces the package ggplot2 to create visualizations 
# that are more expressive and better looking than base R plots. ggplot2 has 
# a powerful yet simple syntax based on a conceptual framework called the
# grammar of graphics.

library(ggplot2)
# Creating visuals often requires transforming, reorganizing or summarizing 
# the data prior to plotting. The ggplot2 package is designed to work well 
# with dplyr, and an understanding of the dplyr tools introduced in Chapter 
# 6 will be assumed throughout this chapter.


# 7.1 ggplot fundamentals
# In this section, we discuss the grammar of graphics. We introduce the 
# scatterplot as a concrete example of how to use the grammar of graphics, 
# and discuss how the presentation of data is affected by its structure.


# 7.1.2 Basic plot creation
# The purpose of this example is to connect the terminology given in the
# previous section to a visualization. We will go into much more detail 
# on this throughout the chapter.


# Consider the built-in data set, CO2, which will be the data in this visualization.
# This data set gives the carbon dioxide uptake of six plants from Quebec 
# and six plants from Mississippi. The uptake is measured at different 
# levels of carbon dioxide concentration, and half of the plants of each
# type were chilled overnight before the experiment was conducted.
# 
# We will choose the variables conc, uptake and eventually Type as the variables 
# that we wish to map to aesthetics. We start by mapping conc to the  x-coordinate
# and uptake to the  y-coordinate. The geometry that we will add is a 
# scatterplot, given by geom_point.

# The ggplot function has set up the x-coordinates and y-coordinates for conc 
# and uptake.
ggplot(CO2, aes(x = conc, y = uptake))

# Now, we just need to tell it what we want to do with those coordinates. 
# That's where geom_point comes in.
ggplot(CO2, aes(x = conc, y = uptake)) +
  geom_point()


# To display a curve fit to the data, we can use the geometry geom_smooth()
ggplot(CO2, aes(x = conc, y = uptake)) +
  geom_smooth()
# 'loess' = locally estimated scatterplot smoothing

# Each geometry in a plot is a layer. The '+' symbol is used to add new 
# layers to a plot, and allows multiple geometries to appear on the same 
# plot. For example, we might want to see the data points and the fitted 
# curve on the same plot.
ggplot(CO2, aes(x = conc, y = uptake)) +
  geom_point() +
  geom_smooth()


# To add more information to the plot we use aesthetics to map
# additional variables to visual properties of the graph. 
# Different geometries support different aesthetics. geom_point 
# requires both x and y and supports these:
# x: x position
# y: y position
# alpha: transparency
# color: color, or outline color
# fill: fill color
# group: grouping variable for fitting lines and curves
# shape: point shape
# size: point size
# stroke: outline thickness

ggplot(CO2, aes(x = conc, y = uptake, color = Type)) +
  geom_point() +
  geom_smooth()
# That plot is very useful! We see that the Quebecois plants have a larger 
# uptake of CO2 at each concentration level than do the Mississippians.
  

# The ggplot command produces a ggplot object, which is normally displayed immediately. 
# It is also possible to store the ggplot object in a variable and then continue to modify 
# that variable until the plot is ready for display. This technique is useful for building
# complicated plots in stages.

# store the plot without displaying it
co2plot <- ggplot(CO2, aes(x = conc, y = uptake, color = Type)) +
  geom_point() +
  geom_smooth()
 
 
# Let's complete this plot by adding better labels, a scale to customize the colors assigned 
# to Type, and a theme that will change the overall look and feel of the plot. See Figure 7.1.
co2plot <- co2plot +
  labs(
    title = "Carbon Dioxide Uptake in Grass Plants",
    caption = "Data from Potvin, Lechowicz, Tardif (1990)",
    x = "Ambient CO2 concentration (mL/L)",
    y = "CO2 uptake rates (umol/m^2 sec)",
    color = "Origin"
  )
co2plot

co2plot <- co2plot +
  scale_color_manual(values = c("blue", "red")) +
  theme_minimal()
co2plot 


# 7.1.3 Structured data
# Plotting with ggplot requires you to provide clean, tidy data, with
# properly typed variables and factors in order.Many traditional plotting
# programs (such as spreadsheets) will happily generate charts from unstructured data.
# The advantage to the ggplot approach is that it forces you to reckon with the structure of
# your data, and understand how that structure is represented directly in the visualization.
# Visualizations with ggplot are reproducible, which means that new or changed data is
# easily dealt with, and chart designs can be consistently applied to different data sets.
# 
# With the spreadsheet approach, adjusting a chart after creating it requires the user to
# click through menus and dialog boxes. This method is not reproducible, and frequently
# leads to tedious repetition of effort.
# 
# The data manipulation tools from Chapter 6 are well suited to work with ggplot.
# The first argument to any ggplot command is the data, which means that
# ggplot can be placed at the end of a dplyr pipeline
# 
# For example, you may want to visualize something that isn't directly represented as a 
# variable in the data frame. We can use mutate to create the variable that we want 
# to visualize, and then use ggplot to visualize it.

# Example 7.1
# Consider the houses data set in the fosdata package. This data set gives the
# house prices and characteristics of houses sold in King County (home of Seattle) 
# from May 2014 through May 2015.
fosdata::houses
houses <- as_tibble(fosdata::houses)
houses
# Suppose we want to get a scatterplot of "price per square foot" versus 
# the "log of the lot size (sqft_lot)" for houses in zip code 98001.
names(houses)

fosdata::houses %>%
  filter(zipcode == 98001) %>%
  mutate(
    price_per_sf = price / sqft_living,
    log_lot_size = log(sqft_lot)
  ) %>%
  ggplot(aes(x = log_lot_size, y = price_per_sf)) +
  geom_point()+
  labs(title = "Home prices in zip code 98001")



# Example 7.2
# The weight_estimate data in fosdata comes from an experiment 
# where children watched actors lift objects of various weights. 
# We would like to plot the actual weight of the object on the x 
# axis and the child's estimate on the y axis. However, the "actual
# weights" are stored in the names of the four column variables 
# mean100, mean200, mean300, and mean400:
head(fosdata::weight_estimate)
# We use pivot_longer to tidy the data.
weight_tidy <- fosdata::weight_estimate %>%
  pivot_longer(
    cols = c(mean100, mean200, mean300, mean400),
    names_to = "actual_weight",
    values_to = "estimated_weight"
  )
weight_tidy
# mean should be removed from the "actual_weight" values:
weight_tidy <- fosdata::weight_estimate %>%
  pivot_longer(
    cols = c(mean100, mean200, mean300, mean400),
    names_to = "actual_weight",
    values_to = "estimated_weight",
    names_prefix = "mean"
  )
weight_tidy
# Now we can provide the actual weight as a variable for 
# plotting:
ggplot(weight_tidy,
       aes(x = actual_weight, y = estimated_weight)) +
  geom_point()
# color by age:
ggplot(weight_tidy,
       aes(x = actual_weight, y = estimated_weight, col = age)) +
  geom_point() +
  labs(title = "Child estimates of weights lifted by actors")




# Another common issue when plotting with ggplot is the 
# ordering of factor type variables. When ggplot deals 
# with a character or factor type variable, it will revert
# to alphabetic order unless the variable is a factor with 
# appropriately set levels.

# Example 7.3
# The ecars data from fosdata gives information about electric 
# cars charging at workplace charging stations.
# Let's make a barplot showing "the number of charges for each 
# day of the week, i.e, "weekday" variable.
ecars <- as_tibble(fosdata::ecars)
ecars
str(ecars$weekday)
ggplot(ecars, aes(x = weekday)) +
  geom_bar()
# Observe that the days of the week are in alphabetical order, 
# which is not helpful. To correct the chart, we need to correct 
# the data. We do this by making the weekday variable into a 
# factor with the correct order of levels.43 After that, the 
# plot shows the bars in the correct order.
levels <- c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
ecars <- ecars %>%
  mutate(weekday = factor(weekday, levels = levels))
ggplot(ecars, aes(x = weekday)) +
  geom_bar()


# 7.2 Visualizing a single variable
# In this section, we present several ways of visualizing data that 
# is contained in "a single" numeric or categorical variable. We have 
# already seen three ways of doing this in Chapter 5, namely 
# histograms, barplots and density plots. We will see how to do 
# these three types of plots using ggplot2, and we will also 
# introduce qq plots and boxplots.


# 7.2.1 Histograms
# A histogram displays the distribution of numerical data. Data is 
# divided into equal-width ranges called bins that cover the full 
# range of the variable. The histogram geometry draws rectangles 
# whose bases are the bins and whose heights represent the number 
# of data points falling into that bin. This representation assigns 
# equal area to each point in the data set.
x <- sample(1:6, 100, replace = TRUE)
hist(x, col="red")

 
# Example 7.4
# The bechdel data set in the fosdata package contains 
# information about 1794 movies, their budgets, and whether
# or not they passed the Bechdel test. This data set was
# used in the FiveThirtyEight article "The Dollar-And-Cents
# Case Against Hollywood's Exclusion of Women.
bechdel <- as_tibble(fosdata::bechdel)
# The variable binary is FAIL/PASS as to whether the movie 
# passes the Bechdel test. Let's see how many movies failed 
# the Bechdel test.
summary(bechdel$binary)
# In 991 out of the 1794 movies, there was no conversation 
# between two women about something other than a man. There 
# are several interesting things that one could do here, 
# and some of them are explored in the exercises. For now, 
# let's look at a histogram of "the budgets of all movies 
# in 2013 dollars". The geometry geom_histogram has required 
# aesthetics of x and y, but y is computed within the 
# function itself and does not need to be supplied.
names(bechdel)
ggplot(bechdel, aes(x=budget_2013))+
  geom_histogram()
# The function geom_histogram always uses 30 bins in its default
# setting and produces a message about it.
ggplot(bechdel, aes(x=budget_2013))+
  geom_histogram(bins = 10)


# 7.2.2 Barplots
# Barplots are similar to histograms in appearance, but do not
# perform any binning. A barplot simply counts the number of
# occurrences at each level (resp. value) of a categorical 
# (resp. integer) variable. It plots the count along the 
# y-axis and the levels of the variable along the  x-axis.
# It works best when the number of different levels in the 
# variable is small.
# The ggplot2 geometry for creating barplots is geom_bar, 
# which has required aesthetics x and y, but again the y 
# value is computed from the data by default so is not always 
# included in the aesthetic mapping.
y = sample(c("H", "Y"), 100, replace = TRUE)
hist(y) # Error in hist.default(y) : 'x' must be numeric
barplot(table(y))


# Example 7.5
# In the bechdel data set, the variable "clean_test" contains the
# levels 'ok', 'dubious', 'nowomen', 'notalk', 'men'. The 
# values 'ok' and 'dubious' are for movies that pass the Bechdel
# test, while the other values describe how a movie failed the 
# test. Create a barplot that displays the number of movies 
# that fall into each level of clean_test.
head(bechdel$clean_test, 12)
barplot(table(bechdel$clean_test)) # using base R

# usnig ggplot
ggplot(bechdel, aes(x=clean_test))+
  geom_bar()


# 7.2.3 Density plots
# Density plots display the distribution of a continuous random
# variable. Rather than binning, as histograms do, a density 
# plot shows a curve whose height is the mean of the pdfs of
# normal random variables centered at the data points. The
# standard deviations are controlled by the bandwidth in
# much the same way that binwidth controls width of histogram 
# bins. Density plots work best when values of the variable 
# we are plotting aren't spread out too far. It can be a good
# idea to try a few different bandwidths in order to see the 
# effect that it has on the density estimation.
# 
# In base R, we used plot(density(data)) to produce a density 
# plot of data. In ggplot2, we use the geom_density geometry. 
# As in the other geoms we have seen so far, geom_density 
# requires x and y as aesthetics, but will compute the y 
# values if they are not provided.

# base R
weight_estimate <- fosdata::weight_estimate
plot(density(weight_estimate$mean100))
# ggplot
weight_estimate %>%
  ggplot(aes(x = mean100 )) +
  geom_density()


# 7.2.4 Boxplots
# Boxplots are commonly used visualizations to get a feel 
# for the median and spread of a variable. In ggplot2 the 
# geom_boxplot geometry creates boxplots.
# 
# A boxplot displays the median of the data as a dark line. 
# The range from the 25th to the 75th percentile is called 
# the interquartile range or IQR, and is shown as a box or
# "hinges". Vertical lines called "whiskers" extend 1.5 
# times the IQR, or are truncated if the whisker reaches 
# the last data point. Points that fall outside the whiskers 
# are plotted individually. Boxplots may include notches,
# which give a rough error estimate for the median of the
# distribution (we will learn more about error estimates 
# for the mean in Chapter 8).
weight_estimate %>%
  ggplot(aes(x = mean100)) +
  geom_boxplot()

weight_estimate %>%
  ggplot(aes(y = mean100)) +
  geom_boxplot()

weight_estimate %>%
  ggplot(aes(y = mean100, x = age)) +
  geom_boxplot()


# 7.2.5 QQ plots
# Quantile-quantile plots, known as qq plots, are used to 
# compare sample data to a known distribution. In this book,
# we have often done this by plotting a known distribution 
# as a curve on top of a histogram or density estimation 
# of the data. Overplotting the curve gives a large scale
# view but won't show small differences.
# 
# Unlike histograms or density plots, qq plots provide more
# precision and do not require binwidth/bandwidth selection.
# This book will use qq plots in Section 11.4 to investigate
# assumptions in regression.
# 
# A qq plot works by plotting the values of the data variable
# on the  y-axis at positions spaced along the  x-axis 
# according to a theoretical distribution. Suppose you 
# have a random sample of size  N from an unknown distribution.
# Sort the data points from smallest to largest, and rename them  
# y(1),.,y(N). Next, compute the expected values of  N points 
# drawn from the theoretical distribution and sorted,  x(1),.,x(N). 
# For example, to compare with a uniform distribution, the  
# x(i) would be evenly spaced. To compare with a normal
# distribution, the  x(i)are widely spaced near the tails and 
# denser near the mean. The specific algorithm that R uses is
# a bit more sophisticated, but the complications only make a
# noticeable difference with small data sets.


# Example 7.9
# Simulate 50 samples from a uniform [0,1] random variable
# and draw a qq plot comparing the distribution to that of
# a uniform  [0,1].
dat <- data.frame(x = runif(50, 0, 1))
dat
ggplot(dat, aes(sample = x)) +
  geom_qq(distribution = qunif) +
  geom_qq_line(distribution = qunif)


# Example 7.10
# Consider the budget_2013 variable in the bechdel data set. 
# Create a qq plot versus a normal distribution and interpret.
bechdel %>%
  ggplot(aes(sample = budget_2013)) +
  geom_qq() +
  geom_qq_line()
# The qq plot (Figure 7.4) has a very strong U shape, and the data 
# is right skewed.
bechdel %>%
  ggplot(aes(x = budget_2013))+
  geom_density() # right skewed



# 7.3 Visualizing two or more variables
# 7.3.1 Scatterplots
# Scatterplots are a natural way to display the interaction between 
# two continuous variables, using the  x and y axes as aesthetics.
# Typically, one reads a scatterplot with the  x variable as
# explaining the  y variable, so that  y values are dependent on  
# x values. We have already seen examples of scatterplots in 
# Section 7.1: a simple example using the built-in CO2 data set
# and another example using fosdata::housing. Scatterplots can be
# the base geometry for visualizations with even more variables,
# using aesthetics such as color, size, shape, and alpha that
# control the appearance of the plotted points.


# Example 7.11
# Explore the relationship between time at the charging station 
# (chargeTimeHrs) and power usage (kwhTotal) for electric cars in 
# the fosdata::ecars data set.
ecars %>% 
  ggplot(aes(x= chargeTimeHrs, y=kwhTotal)) +
  geom_point()
# A first attempt at a scatterplot reveals that there is one 
# data point with a car that charged for 55 hours. All other 
# charge times are much shorter, so we filter out this one 
# outlier and plot:
ecars %>%
  filter(chargeTimeHrs < 30) %>%
  ggplot(aes(x = chargeTimeHrs, y = kwhTotal)) +
  geom_point()
# color by weekday
ecars %>%
  filter(chargeTimeHrs < 30) %>%
  ggplot(aes(x = chargeTimeHrs, y = kwhTotal, col = weekday)) +
  geom_point()



# Example 7.12
# Continuing with the ecars data set, let's explore the distance 
# variable. Charging stations in this data set are generally 
# workplaces, and the distance variable reports the distance 
# to the drivers home.
# Only about 1/3 of the records in ecars contain valid distance 
# data, so we filter for those. Then, we assign distance to
# the color aesthetic. The results look cluttered, so we 
# also assign distance to the alpha aesthetic, which will 
# make shorter distances partially transparent.
ecars %>%
  filter(!is.na(distance)) %>%
  ggplot(aes(
    x = chargeTimeHrs,
    y = kwhTotal,
    color = distance,
    alpha = distance
  )) +
  geom_point() +
  labs(title = "Charge time, power usage, and distance from home")


# Example 7.13
# Let's compare home sales prices between an urban and a suburban 
# area of King County, Washington. We select two zip codes from 
# the fosdata::houses data set. Zip code 98115 is a residential
# area in the city of Seattle, while 98038 is a suburb 25 miles
# southeast from Seattle's downtown.
# In this example, multiple aesthetics are used to display a
# large amount of information in a single plot.
# Sale price depends primarily on the size of the house, so we 
# choose sqft_living as our x-axis and price as our y-axis. 
# We distinguish the two zip codes by color, giving visual 
# contrast even where the data overlaps. Because the data points
# do overlap quite a bit, we set the attribute alpha to 0.8, which
# makes all points 80% transparent.
# The size of a house's property (lot) is also important to 
# price, so this is displayed by mapping sqft_lot to the size 
# aesthetic. Notice in the urban zip code there is little 
# variation in lot size, while in the suburb there is a large 
# variation in lot size and in particular larger lots sell 
# for higher prices.
# Finally, we map the waterfront variable to shape. There is
# only one waterfront property in this data set. Can you spot it?
fosdata::houses %>%
  filter(zipcode %in% c("98115", "98038")) %>%
  mutate(zipcode = factor(zipcode),
         waterfront = factor(waterfront)) %>%
  ggplot(aes(
    x = sqft_living,
    y = price
    # ,color = zipcode
    # ,size = sqft_lot
    # ,shape = waterfront
  )) +
  geom_point(alpha = 0.8) +
  labs(title = "Housing in urban and suburban Seattle")









