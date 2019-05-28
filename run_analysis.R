# Week 4 Assignment
# Created by Leon Paes
# Inspired by other online resources
# Assignment: 
# Merge the training and the test sets into one data set.
# Extract only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Label the data appropriately with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Set working environment, get and unzip the data files
dir.create("Week4Assignment")
setwd("Week4Assignment")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "dataFiles.zip")
unzip(zipfile = "dataFiles.zip")
file.remove("dataFiles.zip")

# Create dataframe with the activity labels, features and measurements
activityLabels <- fread("UCI HAR Dataset/activity_labels.txt"
                , col.names = c("classLabels", "activityName"))
features <- fread("UCI HAR Dataset/features.txt"\
               , col.names = c("index", "featureNames"))
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements)

# Create dataframe with the "train" datasets
train <- data.table()
train <- fread("UCI HAR Dataset/train/X_train.txt")
trainActivities <- fread("UCI HAR Dataset/train/Y_train.txt"
                       , col.names = c("Activity"))
trainSubjects <- fread("UCI HAR Dataset/train/subject_train.txt"
                       , col.names = c("SubjectNum"))
train_combined <- cbind(trainSubjects, trainActivities, train)

# Create dataframe with "test" datasets
test <- data.table()
test <- fread("UCI HAR Dataset/test/X_test.txt")
testActivities <- fread("UCI HAR Dataset/test/Y_test.txt"
                        , col.names = c("Activity"))
testSubjects <- fread("UCI HAR Dataset/test/subject_test.txt"
                      , col.names = c("SubjectNum"))
test_combined <- cbind(testSubjects, testActivities, test)

# merge the "train" and "test" datasets
combined <- rbind(train_combined, test_combined)

# Replace the numaric values in the Activity colomn with their descriptive names
combined[["Activity"]] <- factor(combined[, Activity]
                              , levels = activityLabels[["classLabels"]]
                              , labels = activityLabels[["activityName"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
combined <- melt(data = combined, id = c("SubjectNum", "Activity"))
combined <- dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

data.table::fwrite(x = combined, file = "tidyData.csv", quote = FALSE)