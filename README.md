---
title: "ReadMe"
author: "Shin Saito"
date: "February 10, 2017"
output: html_document
---
Coursera "Getting and Cleaning Data" course -final assignment
Author: Shin Saito
Contact: ssaito@prioricorp.com
Submitted: February 10, 2017

Modified data from the "Human Activity Recognition Using Smartphones"
Dataset Version 1.0 - sourced from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Files submitted for the assignment are located:
https://github.com/shin60657/wearable_computing

Files submitted:
* run_analysis.r - R script performing the analysis
* tidy_wearable.txt - Tidy data set
* tidy_werable.csv - csv version of the tidy data
* CodeBook.md - Code book describing the tidy data
* README.md - This file that describes run_analysis.r
 
======================================================================================

# Introduction - Wearable Computing

This project is developed for the final assignment for the "Getting and Cleaning Data" 
for the Coursera Data Science course. The purpose of this project is to demonstrate 
the ability to collect, work with, and clean a data set. The goal is to prepare tidy 
data that can be used for later analysis. The original data is taken from experiments
that have been carried out with a group of 30 volunteers who performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a 
smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and 
gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a 
constant rate of 50Hz. The volunteers have split into two groups that is, between a 
test and training group.

A full description of the experiment is available at the site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Source data
The source data used is from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

They've been downloaded and extracted locally and consist of:

## Activity and features files from the source
* activity_labels - description of the activities which are referenced as numbers in the actual data
* features - The list of 561 observation variables collected in the experiments
* features_info - Descriprion of the variables in features

## Observation variable data
* Test data sets:
**   subject_test - list of the Subjects identified only by a number, who were observed for the Test experiments - they are listed corresponding to each row of observation made
**   y_test - each activity corresponding to each row of observation mae
**   X_test - every measurement recorded across all 561 observation features (columns)and activities (rows)
* Training data sets:
**   subject_train - list of the Subjects identified only by a number, who were observed for the Training experiments - they are listed corresponding to each row of observation made
**   y_train - each activity corresponding to each row of observation mae
**   X_train - every measurement recorded across all 561 observation features (columns) and activities (rows)

NOTE: The Internal Signal data were NOT included.  They are the raw data and the assignment only involves the processed data (means and standard deviations) found in the X_test and X_train respectively.

# Assignment STEPS
The assignment direct us to do the following. 
 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement 
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names. 
 5. From the data set in step 4, creates a second, independent tidy data set with the average 
    of each variable for each activity and each subject.

HOWEVER, run_analysis.r has modified and implemented the steps as follows to achieve
the same goal as the assignment Step #5.  The reason for modifying the steps is the 
reduce the size of the files being worked on and also, in the opinion of this author, 
simplifies some of the work needed to the results.  Here are the run_analysis.r steps:
 1. Reduce and extract only the mean and standard deviation for each measurement. To do this:
    +1.A.  Reduce the 561 variables in the features list to only mean() and std().  
          NOTE: The experiments has data called "meanFreq()" This data has been excluded
          from the tidy data since they are NOT actual means but, used in the steps to 
          obtain the means.  The file "features_info' that accompanies the experiment data 
          describes "meanFreq()" as the "Weighted average of the frequency components to 
          obtain a mean frequency". So, these variables are NOT the actual means.
    +1.B.  Read in and reduce the Test and Training observations respectively
 2. Appropriately label the data set with descriptive variable names
 3. Use descriptive activity names to name the activities. To do this:
 4.  Merge the training and the test sets to create on data set.  To do this:
    +4.A.  Merge the Subjects, Activities and Observations into the Test and Training 
          observations respectively 
    +4.B.  Then merge the completed Test and Training files (in Step 4.A above) together
 5. From the data set in step 4, creates a second, independent tidy data set with the 
    average of each variable 

# Reading the data
Two formats have been provided to view the data. One is in text format similar to the source
file and the other is in csv format that might for some, be easier to read locally.  Use the 
following to read the data in R:

To read:
(PUT my_data.frame name here) <- read.table("https://raw.githubusercontent.com/shin60657/wearable_computing/master/tidy_wearable.txt", header=TRUE, stringsAsFactors=FALSE)

If you want to download the files locally - first set your working directory then:

TEXT FILE: 
download.file("https://raw.githubusercontent.com/shin60657/wearable_computing/master/tidy_wearable.txt", "./tidy_wearable.txt")

CSV FILE: 
download.file("https://raw.githubusercontent.com/shin60657/wearable_computing/master/tidy_wearable.csv", "./tidy_wearable.csv")

# Why this is tidy data:
This script extracts the data from the full experiments and provides the results in a Tidy data format.  It is Tidy because each variable is in a column, each observation is in a row and this dataset contains one observational unit. Please note that the Tidy format is in the long form as mentioned in the rubic as either long or wide is acceptable.  

This dataset is Tidy because each row provides all the measurements pertaining to a single activity for each Subject being tested.  There are two fixed variables, one being the Subject identified and the other the activity itself.  All other columns are the measurements associated with the activity.  

The dataset has further reduced to only the mean and standard deviations of the measurements in keeping with the parameters of this exercise.