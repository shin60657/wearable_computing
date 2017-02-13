# This script is developed for the final assignment for the "Getting and Cleaning Data" course in Data Science.
# The goal is to prepare tidy data that can be used for later analysis. The original data is taken from experiments
# that have been carried out with a group of 30 volunteers who performed six activities (WALKING, WALKING_UPSTAIRS, 
# WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using 
# its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity 
# at a constant rate of 50Hz. The volunteers have split into two groups that is, between a test and training group.
#
#### SOURCE DATA
# The source data used is from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# Source files have  been downloaded locally with the following consumed:
#
#   activity_labels - description of the activities which are referenced as numbers in the actual data
#   features - The list of 561 observation variables collected in the experiments
#   features_info - Descriprion of the variables in features
#
#   Test data sets:
#     subject_test - list of the Subjects identified only by a number, who were observed
#                    for the Test experiments - they are listed corresponding to each
#                    row of observation made
#     y_test - each activity corresponding to each row of observation mae
#     X_test - every measurement recorded across all 561 observation features (columns)
#             and activities (rows)
#   Training data sets:
#     subject_train - list of the Subjects identified only by a number, who were observed
#                   for the Training experiments - they are listed corresponding to each
#                   row of observation made
#     y_train - each activity corresponding to each row of observation mae
#     X_train - every measurement recorded across all 561 observation features (columns)
#            and activities (rows)
#
# These are my steps to produce the tidy data that includes the average of each mean and standard deviation
# observation for each activity for each Subject:
# 1. Reduce and extract only the mean and standard deviation for each measurement.  To do this;
#    A. Reduce the Features list to only mean() and std().  NOTE: I am NOT getting the "meanFreq()" as they
#       are weighted averages of the frequency components USED to obtain a mean as explained in "features_info"
#    B. Read in and reduce the Test and Training observations respectively
# 2. Appropriately label the data set with descriptive variable names
# 3. Use descriptive activity names to name the activities. To do this:
# 4.  Merge the training and the test sets to create on data set.  To do this:
#    A. Merge the Subjects, Activities and Observations into the Test and Training observations respectively 
#    B. Then merge the completed Test and Training files (in Step 4.A above) together
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#    for each activity and each subject.
#
# REFERENCE THE README.MD FILE FOR MORE INFORMATION
#
run_analysis <- function(x) {
  #
  # First load in the dplyr package
  library(dplyr)
  #
  # STEP 1: Reduce and extract only the mean and standard deviation for each measurement. 
  #
  # STEP 1.A: Reduce the features list:
  #
  # Read in the features list which has all 561 variable (column) descriptions for the observed data.
  features <- read.table("D:/Coursera/03 Getting and Cleaning/wearable_computing/UCI HAR Dataset/features.txt")
  #
  # Identify and reduce the features to only those that coorespond to mean ("mean") and standard deviation ("std").
  # NOTE: I am only getting the values that are "mean()" and "std()".  I am NOT getting the "meanFreq()" as they
  # are weighted averages of the frequency components USED to obtain a mean as explained in "features_info"
  #
  meanstdcols <- grep("mean[(]|std[()]", features$V2)  # Get the column numbers as indexed
  # ... and while we're here, get the descriptive labels for each of the mean() and std() columns
  meanstdcolnames <- grep("mean[(]|std[(]", features$V2, value=TRUE)
  
  #
  # STEP 1.B: Read in and reduce the data frames to only the mean() and std() observations
  #
  # Read each of the tables with all the observation variables:
  Xtestfull <- read.table("D:/Coursera/03 Getting and Cleaning/wearable_computing/UCI HAR Dataset/test/X_test.txt")
  Xtrainfull <- read.table("D:/Coursera/03 Getting and Cleaning/wearable_computing/UCI HAR Dataset/train/X_train.txt")
  #
  # Reduce each observation data sets to mean() and std() only
  xtest <- Xtestfull[ ,meanstdcols]
  xtrain <- Xtrainfull[ ,meanstdcols]
  
  #
  # STEP 2: Appropriately label the data set with the (more) descriptive variable names.
  #
  names(xtest) <- meanstdcolnames
  names(xtrain) <- meanstdcolnames
  
  #
  # STEP 3:  Use descriptive activity names to name the activities
  #
  # Read the activity label file
  activity <- read.table("D:/Coursera/03 Getting and Cleaning/wearable_computing/UCI HAR Dataset/activity_labels.txt")
  #
   # Read the activity indexes for the test and training data
  ytest <- read.table("D:/Coursera/03 Getting and Cleaning/wearable_computing/UCI HAR Dataset/test/y_test.txt")
  ytrain <- read.table("D:/Coursera/03 Getting and Cleaning/wearable_computing/UCI HAR Dataset/train/y_train.txt")
  #
  # Translate the activity indexes to the activity description for each observation in the test and training data
  ytestact <- sapply(ytest, function(x) x = activity[ytest[ ,1],2])
  ytrainact <- sapply(ytrain, function(x) x = activity[ytrain[ ,1],2])
  colnames(ytestact) <- "Activity"
  colnames(ytrainact) <- "Activity"

  #
  # STEP 4: Merge the training and the test sets to create on data set.  To do this:
  #
  # STEP 4.A: Merge the Subjects, Activities and Observations into the Test and Training observations respectively
  #
  # First read in the subjects for Test and Training
  subjecttest <- read.table("D:/Coursera/03 Getting and Cleaning/wearable_computing/UCI HAR Dataset/test/subject_test.txt")
  subjecttrain <- read.table("D:/Coursera/03 Getting and Cleaning/wearable_computing/UCI HAR Dataset/train/subject_train.txt")
  colnames(subjecttest) <- "Subject"
  colnames(subjecttrain) <- "Subject"
  #
  # Bind the subjects and activities (and their descriptive form) to each datasets of observations.  I will keep the 
  bindedtest <- cbind(subjecttest, ytestact, xtest)
  bindedtrain <- cbind(subjecttrain, ytrainact, xtrain)

  #
  # STEP 4.B. Then merge the completed Test and Training files (in Step 4.A above) together - BIND IT ALL
  combinedall <- rbind(bindedtest, bindedtrain)
 
  #
  # STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
  #    for each activity and each subject.
  # 
  combinedall <- arrange(combinedall, Subject, Activity)
  #write.csv( combinedall, file = "./combined_test.csv", row.names = FALSE)  # For testing validation purposes
  #
  # Get the means for all measurements by Activity by Subject 
  tidydata <- combinedall %>% group_by(Subject, Activity) %>% summarise_each(funs(mean))
  #
  # Write out the tables:
  write.table( tidydata, file = "./tidy_wearable.txt", row.names = FALSE)
  write.csv( tidydata, file = "./tidy_wearable.csv", row.names = FALSE)
  
}
