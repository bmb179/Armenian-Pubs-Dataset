library(tidyverse)

data <- read.csv("C:/DIRECTORY/armenian_pubs.csv")
#source: https://www.kaggle.com/datasets/erikhambardzumyan/pubs

#Data Cleaning
unique(data$X.Occupation)
data$X.Occupation <- trimws(data$X.Occupation)
#needed whitespace trimmed

unique(data$Fav_Pub)
data$Fav_Pub <- trimws(data$Fav_Pub)
data$Fav_Pub[data$Fav_Pub == "BullDog"] <- "Bulldog"
data$Fav_Pub[data$Fav_Pub == "Do not have one"] <- NA
data$Fav_Pub[data$Fav_Pub == "I don't like pubs"] <- NA
data$Fav_Pub[data$Fav_Pub == "I have none"] <- NA
data$Fav_Pub[data$Fav_Pub == "37 pub"] <- "Pub 37"
data$Fav_Pub[data$Fav_Pub == "Tom collins"] <- "Tom Collins"
data$Fav_Pub[data$Fav_Pub == "Void"] <- NA
data$Fav_Pub[data$Fav_Pub == "VOID"] <- NA
#needed whitespace trimmed and duplicates merged

unique(data$Lifestyle)
data$Lifestyle <- trimws(data$Lifestyle)
data$Lifestyle[data$Lifestyle == "Busy(student life, work)"] <- "Student"
data$Lifestyle[data$Lifestyle == "Sport, art, traveling"] <- "Sport"
data$Lifestyle[data$Lifestyle == "Adventure/traveling/exploring"] <- "Travel"
data$Lifestyle[data$Lifestyle == "Rock, punk"] <- "Music"
data$Lifestyle[data$Lifestyle == "Business, sports, dance"] <- "Business"
#needed whitespace trimmed and responses simplified

unique(data$Occasions)
data$Occasions <- trimws(data$Occasions)
data$Occasions[data$Occasions == "Never"] <- NA
data$Occasions[data$Occasions == "Nowere"] <- NA
data$Occasions[data$Occasions == "For listening  good music"] <- "For listening to good music"
data$Occasions[data$Occasions == "Birthdays"] <- "Special events/parties"
data$Occasions[data$Occasions == "chem aycelum"] <- "I'm thirsty"
#chem aycelum (ծհեմ այծելuմ) roughly translates to "I'm thirsty" in English from Armenian
#needed whitespace trimmed and duplicates merged, 1 value needed to be translated to English

summary(data)

#ggplots
data %>% ggplot() + geom_col(aes(x = Freq, y = frequency(Freq), fill = Occasions)) +
  labs(title = "How Often Do You Go to the Pub?", 
       x = "Frequency", y = "Number of Responses")
data %>% ggplot() + geom_col(aes(x = Freq, y = frequency(Freq), fill = Lifestyle)) +
  labs(title = "How Often Do You Go to the Pub?", 
       x = "Frequency", y = "Number of Responses")
data %>% ggplot() + geom_point(aes(x = WTS, y = Age., alpha = Income.)) +
  labs(title = "How Much Do You Spend at the Pub? (in Armenian Drams)", 
       x = "Willing to Spend", y = "Age")

#Quantifying qualitative data for the regression model
data$gender_int <- NA
data$gender_int[data$Gender. == "Male"] <- 0
data$gender_int[data$Gender. == "Female"] <- 1
#purpose: detecting the influence of gender on spending

data$occupation_int <- 0
data$occupation_int[data$X.Occupation == "Student + working"] <- 1
data$occupation_int[data$X.Occupation == "Student"] <- 1 
#purpose: detecting the influence of student status on spending

data$freq_int[data$Freq == "rarely (once two week/or a month)"] <- 0
data$freq_int[data$Freq == "Several times in a month"] <- 1
data$freq_int[data$Freq == "Several times a week"] <- 1
#purpose: detecting the influence of frequency at pubs on spending

#Regression model for the effects of age, income, gender, occupation (student status), and frequency on how much an individual is willing to spend
model1 <- lm(WTS ~ Age. + Income. + gender_int + occupation_int + freq_int, data = data)
summary(model1)

