###########################################################################
###### Probability, Statistics, and Data A Fresh Approach Using R    ######
###### By Darrin Speegle and Bryan Clair                             ######
###### online textbook:                                              ######
###### https://mathstat.slu.edu/~speegle/_book/preface.html          ######
###########################################################################

#############################################################
############ Chapter 6 Data Manipulation ####################
#############################################################

# In this chapter we introduce the tidyverse. The tidyverse consists
# of a collection of R packages designed to work together, organized 
# around common principles. The central organizing principle is that 
# data should be tidy: Data should be rectangular, each row should 
# correspond to one observation, and each column should correspond 
# to one observed variable. Data should not be stored in the names 
# of variables.

# install.packages("tidyverse") # install it only one time
library(tidyverse) # load the package tidyverse

#6.1 Data frames and tibbles
# Data in R is usually stored in data frames, with one row per observation
# and one column per variable. The tidyverse tools work naturally with 
# data frames, but prefer a new data format called a tibble. 
library(ggplot2)

# mtcars data frame
mtcars

# convert a data.frame to tibble
as_tibble(mtcars)


# As usual, this does not change mtcars into a tibble unless we store
# the result back into the variable via mtcars <- as_tibble(mtcars).
# Most of the time, you don't need to worry about the difference between 
# a data frame and a tibble

# 1. 
mtcars[1:5, c("am", "gear", "carb")] # data frame
mtcars[1:5, "carb"] # vector

# install.packages("remotes") # if you don't already have this package
# remotes::install_github(repo = "speegled/fosdata")

# 2. 
fosdata::movies
as_tibble(fosdata::movies)


# load "movies" data set from "fosdata" package
movies <- fosdata::movies

# Let's convert it to a tibble so that when we print things out to 
# the screen, we aren't overwhelmed with information.
movies <- as_tibble(movies)
movies


### 6.2 dplyr verbs
# The dplyr package is organized around commands called verbs. 
# Each verb takes a tibble (or data frame) as its first argument, 
# and possibly additional arguments.

# The first verb we will meet is filter,27 which forms a new 
# data frame consisting of rows that satisfy certain filtering 
# conditions:
# Here we create a new data frame with all 218 reviews of 
# the 1999 film Fight Club:
filter(movies, title == "Fight Club (1999)")
# using base R:
movies[movies$title == "Fight Club (1999)",]

# Find all user Ratings of 1 or less:
filter(movies, rating <= 1)

# All rating  of 1 or less for Fight Club:
filter(movies, title == "Fight Club (1999)", rating <= 1)
# It turns out there are only three users in this data set who 
# really disliked Fight Club!


# Now that we have some basic idea of how verbs work, let's 
# look at an overview of some of the ones that we will use in 
# this chapter. We will use the following verbs regularly when
# working with data:

# Select the columns rating and movieId (in that order).
select(movies, rating, movieId)

# Arrange the ratings in order of rating.
arrange(movies, rating)

# Arrange the ratings in descending order of rating.
arrange(movies, desc(rating))


### 6.3 dplyr pipelines
# Verb commands are simple, but are designed to be used 
# together to perform more complicated operations. The 
# pipe operator is the dplyr method for combining verbs. 
# Pipe is the three-character symbol %>%, which you can 
# also type using the three key combination ctrl-shift-m. 
# Pipe works by taking the value produced on its left and 
# feeding it as the first argument of the function on its right.
movies %>%
  filter(title == "Batman (1989)") %>%
  arrange(rating)
# With pipelines, we imagine the data (movies) flowing into 
# the pipe then passing through the verbs in sequence, first 
# being filtered and then being arranged. Pipelines also make
# it natural to break up long commands into multiple lines 
# after each pipe operator, although this is not required.


# Example 6.2
# Find all movies which some user rated 5.
movies %>%
  filter(rating == 5) %>%
  select(title) %>%
  distinct() %>%
  head(n = 5)


### 6.3.1 Group by and summarize
# The tool to do this is the dplyr verb "group_by", which groups 
# data to perform tasks by groups.

# Example 6.3
# In order to find the mean rating of each movie, we will use 
# the group_by() function.
movies = as_tibble(movies)
movies %>%
  group_by(title) %>% 
  summarize(mean(rating))
# We could give that variable an easier name to type by assigning
# it as part of the summarize operation: 
movies %>%
  group_by(title) %>% 
  summarize(rating = mean(rating))

# Example
# In order to find the mean rating of each genres, we will use 
# the group_by() function.
movies %>%
  group_by(genres) %>% 
  summarize(rating = mean(rating))


# Example 6.4
# The built-in chickwts records the weight of chickens fed on different 
# diets. Calculate the number of chickens in each feed group, and the mean 
# weight of chickens in that group.
chickwts %>% 
  group_by(feed) %>% 
  summarize(weight = mean(weight))


### 6.4 The power of dplyr
# With a small collection of verbs and the pipe operator, you are well 
# equipped to perform complicated data analysis. This section shows 
# some of the techniques you can use to learn answers from data.


# Example 6.6
# Create a data frame consisting of the observations associated with movies 
# that have an average rating of 5 stars. That is, each rating of the movie 
# was 5 stars.
# In order to do this, we will use the group_by() function to find the mean 
# rating of each movie, as above.
movies %>% 
  group_by(title) %>% 
  summarize(rating = mean(rating)) %>% 
  filter(rating == 5)


# Example 6.7
# Which movie that received only 5 star ratings has the most ratings?
movies %>% 
  group_by(title) %>% 
  summarize(rating = mean(rating), n.rating = n()) %>% 
  filter(rating == 5) %>% 
  filter(n.rating == max(n.rating))
  

# Example 6.8
# Out of movies with a lot of ratings (say more than 100), 
# which has the highest rating? 
# Well, we need to decide what a lot of ratings means. Let's see 
# how many ratings some of the movies had.
movies %>% 
  group_by(title) %>% 
  summarize(m.rating = mean(rating), n.rating = n()) %>% 
  arrange(desc(n.rating)) %>% 
  filter(n.rating >= 100) %>% 
  slice_max(m.rating, n=5)


# Example 6.9
# Find the "worst opinions" in the MovieLens data set. We are 
# interested in finding the movie that received the most ratings 
# while also receiving exactly one five star rating, and in 
# finding the user who had that bad take.

movies %>% 
  group_by(title) %>% 
  mutate(num5 = sum(rating==5), numRating = n() ) %>% 
  ungroup() %>% 
  filter(num5 == 1, rating ==5) %>%
  select(userId, title, numRating) %>%
  slice_max(numRating, n = 5)

  


### 6.5 Working with character strings
# This section introduces the stringr package for basic string
# manipulation. As far as R is concerned, strings are variables
# of type character, or chr. For example:
our_class <- c("STAT 383", "Prob and Stat")
str(our_class)
# One might very reasonably be interested in the number of spaces 
# (a proxy for the number of words), the capital letters (a person's 
# initials), or in sorting a vector of characters containing names 
# by the last name of the people. All of these tasks (and more)
# are made easier using the stringr package.
library(stringr)
# Most functions from stringr begin with the prefix str_. The function 
# str_length accepts one argument, a string, which can either be a single
# string or a vector of strings. It returns the length(s) of the string(s). 
# For example,
str_length(our_class)
# To count the number of spaces, we will pass a single character to the pattern, 
# namely the space character.
str_count(our_class, " ")
str_count(our_class, "[ST]")
str_count(our_class, "[St]")
str_count(our_class, "[A-Z]") # upper case
str_count(our_class, "[a-z]") # lower case
str_count(our_class, "[0-9]") # numbers

# Suppose we want to extract the initials of "our_class"
str_extract(our_class, "[A-Z]")
# Note that this only extracts the first occurrence of the pattern in each
# string. To get all of them, we use str_extract_all
str_extract_all(our_class, "[A-Z]")

str_remove_all(our_class, "[A-Z]")
str_remove_all(our_class, "[^A-Z]")

# we could look for the pattern an in our_class
str_detect(our_class, "an")
# The function str_split takes two arguments, a string and a pattern on
# which to split the string. Every time the function sees the pattern,
# it splits off a piece of the string. For example,
str_split(our_class, " ")
# If we know that we only want to split into at most 2 groups, say, then 
# we can use str_split_fixed
str_split_fixed(our_class, " ", n = 2)
str_split_fixed(our_class, " ", n = 3)


# Example 6.10
# Let's apply string manipulation to understand the Genres variable of the 
# fosdata::movies data set. What are the best comedies? We look for the highest
# rated movies that have been rated at least 50 times and include "Comedy" in 
# the genre list.
movies %>%
  filter(str_detect(genres, "Comedy")) %>%
  group_by(title) %>%
  summarize(rating = mean(rating), count = n()) %>%
  filter(count >= 50) %>%
  slice_max(rating, n = 10)



# Example 6.12
# Consider the accelerometer data in the fosdata package. This data set 
# will be described in more detail in Chapter 11. Here we list the names
# of all the variables in this data set:
accelerometer <- fosdata::accelerometer
names(accelerometer)
# Let's suppose you wanted to create a new data frame that had all of 
# the time measurements in it. Those are the variables whose names end 
# with ms
accelerometer %>% 
  select(matches("ms$")) %>%
  print(n = 5)
# To build a data frame that includes both variables that start with 
# smartphone or end with ms, use the regular expression | character for 
# "or."
accelerometer %>% 
  select(matches("smartphone|ms$")) %>%
  print(n = 5)


### 6.6 The structure of data
### 6.6.1 Tidy data: pivoting
# 1
WorldPhones1 <- as_tibble(WorldPhones)
WorldPhones1$years = c(1951, 1956, 1957, 1958, 1959, 1960, 1961)
WorldPhones1 %>% 
  pivot_longer(names(WorldPhones1)[-8], 
               names_to = "country",
               values_to = "telephones")
# 2
# The WorldPhones data is stored as a matrix with row names, so we convert
# it to a tibble called phones and preserve the row names in a new variable
# called Year. We also clean up the names into a standard format using 
# janitor::clean_names
phones <- as_tibble(WorldPhones) 
phones$year <- c(1951, 1956, 1957, 1958, 1959, 1960, 1961.)
phones %>% 
  janitor::clean_names()
phones

phones %>%
  pivot_longer(cols = !year, names_to = "region", values_to = "telephones")




# Example 6.13
# As a more complex example, let's look at the billboard data set provided 
# with the tidyr package. This contains the weekly Billboard rankings for 
# each song that entered the top 100 during the year 2000. Observe that 
# each row is a song (track) and the track's place on the charts is stored 
# in up to 76 columns named wk1 through wk76. There are many NA in the data
# since none of these tracks were ranked for 76 consecutive weeks.
billboard %>% 
  pivot_longer(cols = !c("artist","track", "date.entered"),
               names_to = "week", values_to = "value")
# or
long.bill <- billboard %>%
  pivot_longer(
    cols = wk1:wk76,
    names_to = "week", values_to = "rank",
    values_drop_na = TRUE
  )
long.bill

# Now we can group by track and count the number of times it was ranked:
long.bill %>%
  group_by(track) %>%
  summarize(weeks_on_chart = n())

# Example 6.14
# Consider the babynames data set in the babynames package. This consists 
# of all names of babies born in the USA from 1880 through 2017, together 
# with the sex assigned to the baby, the number of babies of that sex 
# given that name in that year, and the proportion of babies with that 
# sex in that year that were given the name. Only names that were given
# to five or more babies are included.
babynames::babynames %>%
  filter(year == 2000) %>% 
  pivot_wider(id_cols = name, names_from = sex, values_from = n, values_fill = 0)



# 6.6.2 Using join to merge data frames










