## Set working directory and load library  
setwd("/Users/Wei-Ting/Desktop/R course/course 3")
library(reshape2)

## Download the data if file does not already exists and load data
if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
  download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    destfile = "getdata_projectfiles_UCI HAR Dataset.zip")
}
date.download <- date()

if (!file.exists("UCI HAR Dataset")) {
  unzip("getdata_projectfiles_UCI HAR Dataset.zip") 
}
 
## Merges the training and the test sets to create one data set.
# Look at type of files in the data folder
folder <- file.path("/Users/Wei-Ting/Desktop/R course/course 3", "UCI HAR Dataset")
files <- list.files(folder, recursive=TRUE)
# Read the Activity files
data.Activity.Test  <- read.table(file.path(folder, "test" , "Y_test.txt" ), header = FALSE)
data.Activity.Train <- read.table(file.path(folder, "train", "Y_train.txt"), header = FALSE)
# Read the Subject files
data.Subject.Train <- read.table(file.path(folder, "train", "subject_train.txt"), header = FALSE)
data.Subject.Test  <- read.table(file.path(folder, "test" , "subject_test.txt"), header = FALSE)
# Read Fearures files
data.Features.Test  <- read.table(file.path(folder, "test" , "X_test.txt" ), header = FALSE)
data.Features.Train <- read.table(file.path(folder, "train", "X_train.txt"), header = FALSE)
# Concatenate training and testing datasets
data.Subject <- rbind(data.Subject.Train, data.Subject.Test)
data.Activity<- rbind(data.Activity.Train, data.Activity.Test)
data.Features<- rbind(data.Features.Train, data.Features.Test)
# Assign names to variables
names(data.Subject)<-c("subject")
names(data.Activity)<- c("activity")
Features.Names <- read.table(file.path(folder, "features.txt"), header = FALSE)
names(data.Features)<- Features.Names$V2
# Merge columns to get the data frame Data for all data
data <- cbind(data.Subject, data.Activity, data.Features)

## Extracts only the measurements on the mean and standard deviation
columnsToKeep <- grepl("subject|activity|mean|std", colnames(data))
subset.data <- data[, columnsToKeep]

## Uses descriptive activity names to name the activities in the data set
activity.names <- read.table(file.path(folder, "activity_labels.txt"), header = FALSE)
subset.data$activity <- factor(subset.data$activity, levels = activity.names[,1], labels = activity.names[,2])

## Appropriately labels the data set with descriptive variable names
# remove special characters and set descriptive variable names
colnames(subset.data) <- gsub("[\\(\\)-]", "", colnames(subset.data))
colnames(subset.data) <- gsub("^t", "time", colnames(subset.data))
colnames(subset.data) <- gsub("^f", "frequency", colnames(subset.data))
colnames(subset.data) <- gsub("Acc", "Accelerometer", colnames(subset.data))
colnames(subset.data) <- gsub("Gyro", "Gyroscope", colnames(subset.data))
colnames(subset.data) <- gsub("Mag", "Magnitude", colnames(subset.data))
colnames(subset.data) <- gsub("BodyBody", "Body", colnames(subset.data))

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
mean.data <- aggregate(. ~subject + activity, data = subset.data, mean)
write.table(mean.data, file = "tidydata.txt",row.name=FALSE)

