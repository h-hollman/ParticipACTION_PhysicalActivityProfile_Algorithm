# RStudio Syntax for ParticipACTION Profile Algorithm

# First install and activate the libraries

install.packages(c("haven", "readxl", "utils", "dplyr", "ggplot2", "psych", "knitr"))
library(haven)
library(readxl)
library(utils)
library(dplyr)
library(ggplot2)
library(psych)
library(knitr)

# The algorithm requires the following four questions:

# Q1. Physical Activity Behaviour
# “In the past week, on how many days have you done a total of 30 minutes or more of PA, 
# which was enough to raise your breathing rate? 
# This may include sport, traditional games, exercise and brisk walking or cycling for recreation or 
# to get to and from places, but should not include housework or PA that may be part of your job.” 
# Responses range from 0 to 7 where 0 = 0 days and 7 = 7 days
# This single item has demonstrated surveillance-relevant concurrent validity and reliability (Bauman & Richards, 2022; Milton et al., 2011). 

# Q2. Physical Activity Intentions
# “How many days per week do you intend to engage in PA for 30 minutes or more?” 
# Responses range from 0 to 7 where 0 = 0 days to 7 = 7 days
# This question was modified from Courneya (1994) to reflect the framing of the PA behaviours question. 

# Q3. Physical Activity Habit
# “Engaging in PA for 30 minutes or more, most days of the week, is something I do without thinking” 
# Responses scored on a 5-points Likert scale (1 = strongly disagree, 2 = disagree, 3 = neither agree nor disagree, 4 = agree, 5 = strongly agree). 
# PA habit was measured with the third question from the Self-Report Behavioral Automaticity Index (Gardner et al., 2012).
# This item was selected because it consistently resulted in the lowest overall internal consistency (Cronbach alpha) when dropped, using our algorithm development and testing datasets.

# Q4. Physical Activity Identity
# “Others see me as someone who does PA regularly” 
# Responses scored on a 5-points Likert scale (1 = strongly disagree, 2 = disagree, 3 = neither agree nor disagree, 4 = agree, 5 = strongly agree). 
# This item was selected from the Exercise Identity Scale because it had the highest standardized factor loading score for PA role identity (Wilson & Muon, 2008)

# References
# Bauman, A. E., & Richards, J. A. (2022). Understanding of the Single-Item Physical Activity Question for Population Surveillance. Journal of Physical Activity and Health, 19(10), 681–686. https://doi.org/10.1123/jpah.2022-0369
# Milton, K., Bull, F. C., & Bauman, A. (2011). Reliability and validity testing of a single-item physical activity measure. British Journal of Sports Medicine, 45(3), 203–208. https://doi.org/10.1136/bjsm.2009.068395
# Courneya, K. S. (1994). Predicting repeated behavior from intention: The issue of scale correspondence. Journal of Applied Social Psychology, 24(7), 580–594. https://doi.org/10.1111/j.1559-1816.1994.tb00601.x
# Gardner, B., Abraham, C., Lally, P., & Bruijn, G.-J. de. (2012). Towards parsimony in habit measurement: Testing the convergent and predictive validity of an automaticity subscale of the Self-Report Habit Index. International Journal of Behavioral Nutrition and Physical Activity, 9(1), 1–12. https://doi.org/10.1186/1479-5868-9-102
# Wilson, P. M., & Muon, S. (2008). Psychometric properties of the exercise identity scale in a university sample. International Journal of Sport and Exercise Psychology, 6(2), 115–131. https://doi.org/10.1080/1612197X.2008.9671857

# Show an example with generated data
# Set the seed for reproducibility
set.seed(123)

# Define the response options
intentions_behaviours_options <- c("0 days", "1 day", "2 days", "3 days", "4 days", "5 days", "6 days", "7 days")
habit_identity_options <- c("Strongly Disagree", "Disagree", "Neither Agree nor Disagree", "Agree", "Strongly Agree")

# Generate the data
n <- 500  # Specify the number of observations

data <- data.frame(
  PAIntentionsraw = sample(intentions_behaviours_options, n, replace = TRUE),
  PABehavioursraw = sample(intentions_behaviours_options, n, replace = TRUE),
  PAHabitraw = sample(habit_identity_options, n, replace = TRUE),
  PAIdentityraw = sample(habit_identity_options, n, replace = TRUE)
)

# Display the first few rows of the data frame
head(data)

View(data)

# Convert variables into numbers

# Assuming you have a dataframe named 'data' containing the variables PAIntentionsraw, PABehavioursraw, Habit1raw, Habit2raw, Habit3raw, Habit4raw, Identityraw

# Recode PAIntentionsraw into PAIntentionNumbers
data$PAIntentionNumbers <- recode(data$PAIntentionsraw, '0 days' = 0, '1 day' = 1, '2 days' = 2, '3 days' = 3, '4 days' = 4, '5 days' = 5, '6 days' = 6, '7 days' = 7)

# Recode PABehavioursraw into PABehaviourNumbers
data$PABehaviourNumbers <- recode(data$PABehavioursraw, '0 days' = 0, '1 day' = 1, '2 days' = 2, '3 days' = 3, '4 days' = 4, '5 days' = 5, '6 days' = 6, '7 days' = 7)

# Recode PAHabitraw into Habit
data$Habit <- recode(data$PAHabitraw, 'Strongly Disagree' = 1, 'Disagree' = 2, 'Neither Agree nor Disagree' = 3, 'Agree' = 4, 'Strongly Agree' = 5)

# Recode Identityraw into Identity
data$Identity <- recode(data$PAIdentityraw, 'Strongly Disagree' = 1, 'Disagree' = 2, 'Neither Agree nor Disagree' = 3, 'Agree' = 4, 'Strongly Agree' = 5)


# Check outliers

# Examine variables with boxplot and stem-and-leaf plot
# Compare groups, calculate descriptive statistics, and identify extreme values
describe(data[c("PAIntentionNumbers", "PABehaviourNumbers", "Habit", "Identity")])

# Create boxplots for the specified variables
boxplot(data[c("PAIntentionNumbers", "PABehaviourNumbers", "Habit", "Identity")])

# Recode outliers if needed

# Recode PA Intentions, Behaviours, Habits, Identities to Low = 0 and High = 1

# Recode PAIntentionNumbers into PAIntentions
data$PAIntentions <- ifelse(data$PAIntentionNumbers <= 2, 0,
                            ifelse(data$PAIntentionNumbers >= 3, 1, NA))

# Recode PABehaviourNumbers into PABehaviours
data$PABehaviours <- ifelse(data$PABehaviourNumbers <= 2, 0,
                            ifelse(data$PABehaviourNumbers >= 3, 1, NA))

# Recode Habit into PAHabit
data$PAHabit <- ifelse(data$Habit >= 4, 1,
                       ifelse(data$Habit <= 3, 0, NA))

# Recode Identity into PAIdentity
data$PAIdentity <- ifelse(data$Identity >= 4, 1,
                          ifelse(data$Identity <= 3, 0, NA))

# Create the 8 profiles

# i.	Non-Intenders – both low
# ii.	Unsuccessful Adopters – both low
# iii.	Successful Adopters – both low
# iv.	Successful Maintainers – either high
# v. Non-Intenders – either high
# vi.	Unsuccessful Non-Intenders – both low
# vi.	Unsuccessful Non-Intenders – either high
# viii. Unsuccessful Adopters - either high

# Compute the specified variables only when data$PAIntentions and data$PABehaviours aren't missing (NA), and at least one of data$PAIdentity or data$PAHabit isn't missing (NA)

# i.Compute Nonintenders_BothLow only if conditions are met
data$Nonintenders_BothLow <- ifelse(
  !is.na(data$PAIntentions) & !is.na(data$PABehaviours) & 
    (!is.na(data$PAIdentity) | !is.na(data$PAHabit)),
  ifelse(data$PAIntentions == 0 & data$PABehaviours == 0 & data$PAIdentity == 0 & data$PAHabit == 0, 1, 0),
  NA
)

# ii.Compute UnsuccessfulAdopters_BothLow only if conditions are met
data$UnsuccessfulAdopters_BothLow <- ifelse(
  !is.na(data$PAIntentions) & !is.na(data$PABehaviours) & 
    (!is.na(data$PAIdentity) | !is.na(data$PAHabit)),
  ifelse(data$PAIntentions == 1 & data$PABehaviours == 0 & data$PAIdentity == 0 & data$PAHabit == 0, 1, 0),
  NA
)

# iii.Compute SuccessfulAdopters_BothLow only if conditions are met
data$SuccessfulAdopters_BothLow <- ifelse(
  !is.na(data$PAIntentions) & !is.na(data$PABehaviours) & 
    (!is.na(data$PAIdentity) | !is.na(data$PAHabit)),
  ifelse(data$PAIntentions == 1 & data$PABehaviours == 1 & data$PAIdentity == 0 & data$PAHabit == 0, 1, 0),
  NA
)

# iv.Compute SuccessfulMaintainers_EitherHigh only if conditions are met
data$SuccessfulMaintainers_EitherHigh <- ifelse(
  !is.na(data$PAIntentions) & !is.na(data$PABehaviours) & 
    (!is.na(data$PAIdentity) | !is.na(data$PAHabit)),
  ifelse(data$PAIntentions == 1 & data$PABehaviours == 1 & (data$PAIdentity == 1 | data$PAHabit == 1), 1, 0),
  NA
)

# v.Compute Nonintenders_EitherHigh only if conditions are met
data$Nonintenders_EitherHigh <- ifelse(
  !is.na(data$PAIntentions) & !is.na(data$PABehaviours) & 
    (!is.na(data$PAIdentity) | !is.na(data$PAHabit)),
  ifelse(data$PAIntentions == 0 & data$PABehaviours == 0 & (data$PAIdentity == 1 | data$PAHabit == 1), 1, 0),
  NA
)

# vi.Compute UnsuccessfulNonintenders_BothLow only if conditions are met
data$UnsuccessfulNonintenders_BothLow <- ifelse(
  !is.na(data$PAIntentions) & !is.na(data$PABehaviours) & 
    (!is.na(data$PAIdentity) | !is.na(data$PAHabit)),
  ifelse(data$PAIntentions == 0 & data$PABehaviours == 1 & data$PAIdentity == 0 & data$PAHabit == 0, 1, 0),
  NA
)

# ix.Compute UnsuccessfulNonintenders_EitherHigh only if conditions are met
data$UnsuccessfulNonintenders_EitherHigh <- ifelse(
  !is.na(data$PAIntentions) & !is.na(data$PABehaviours) & 
    (!is.na(data$PAIdentity) | !is.na(data$PAHabit)),
  ifelse(data$PAIntentions == 0 & data$PABehaviours == 1 & (data$PAIdentity == 1 | data$PAHabit == 1), 1, 0),
  NA
)

# xi.Compute UnsuccessfulAdopters_EitherHigh only if conditions are met
data$UnsuccessfulAdopters_EitherHigh <- ifelse(
  !is.na(data$PAIntentions) & !is.na(data$PABehaviours) & 
    (!is.na(data$PAIdentity) | !is.na(data$PAHabit)),
  ifelse(data$PAIntentions == 1 & data$PABehaviours == 0 & (data$PAIdentity == 1 | data$PAHabit == 1), 1, 0),
  NA
)

# Compute descriptive statistics for the specified variables
summary(data[c("Nonintenders_BothLow", "UnsuccessfulAdopters_BothLow", "SuccessfulAdopters_BothLow", 
               "SuccessfulMaintainers_EitherHigh", "Nonintenders_EitherHigh", 
               "UnsuccessfulNonintenders_BothLow", "UnsuccessfulNonintenders_EitherHigh",
               "UnsuccessfulAdopters_EitherHigh")])

# Calculate frequencies for the specified variables
frequency_table <- lapply(data[c("Nonintenders_BothLow", "UnsuccessfulAdopters_BothLow", "SuccessfulAdopters_BothLow", 
                                 "SuccessfulMaintainers_EitherHigh", "Nonintenders_EitherHigh", 
                                 "UnsuccessfulNonintenders_BothLow", "UnsuccessfulNonintenders_EitherHigh",
                                 "UnsuccessfulAdopters_EitherHigh")], table)

print(frequency_table)

# Calculate proportions
proportion_table <- lapply(frequency_table, function(x) x / sum(x))

# Print proportion tables
for (i in seq_along(proportion_table)) {
  cat("Variable:", names(proportion_table)[i], "\n")
  print(proportion_table[[i]])
}

# Convert proportions to percentages
percentage_table <- lapply(proportion_table, function(x) x * 100)

# Convert percentage table to dataframe
percentage_df <- as.data.frame(do.call(rbind, percentage_table))

# Remove the column "0" from the dataframe
percentage_df <- subset(percentage_df, select = -c(`0`))

# Rename the column "1" to Percentage
colnames(percentage_df)[colnames(percentage_df) == "1"] <- "Percentage"

# Round the data in column "Percentage" to two decimal places
percentage_df$Percentage <- round(percentage_df$Percentage, 2)

# View overall percentage table
View(percentage_df)

# Check current working directory
getwd()

# Set working directory if needed
setwd("/Users/username/Documents/")

# Save the dataframe as a CSV file
write.csv(percentage_df, "ParticipACTION_Profiles", row.names = TRUE)

# Create Overall Profile column

data$Overall_Profile <- (data$Nonintenders_BothLow*1 + data$UnsuccessfulAdopters_BothLow*2 + data$SuccessfulAdopters_BothLow*3 + 
                                data$SuccessfulMaintainers_EitherHigh*4 + data$Nonintenders_EitherHigh*5 + 
                                data$UnsuccessfulNonintenders_BothLow*6 + data$UnsuccessfulNonintenders_EitherHigh*7 +
                                data$UnsuccessfulAdopters_EitherHigh*8)


# Calculate the frequencies
frequency_table <- table(data$Overall_Profile)

# Print the frequency table
print(frequency_table)