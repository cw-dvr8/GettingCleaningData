#----------------------------------------------------------------------------#
# Program Name: run_analysis.R                                               #
# Author: Cindy Molitor                                                      #
# Creation Date: 05Apr2017                                                   #
# Purpose: Assemble a dataset consisting of the means and standard           #
#          deviations of activity measurements of testing and training data  #
#          derived from accelerometers using a Samsung Galaxy 5 smartphone.  #
#          From this data, create a dataset of the averages of the means and #
#          standard deviation columns across participant/activity.           #
# Project: Coursera Data Science program                                     #
#          Getting and Cleaning Data class - programming assignment          #
#                                                                            #
# Inputs: features.txt - description of the statistics in the data           #
#         X_train.txt - the actual data statistics for the training          #
#                       participants                                         #
#         subject_train.txt - participant identifiers for the training data  #
#         y_train.txt - activity codes for the training data                 #
#         X_test.txt - the actual data statistics for the test participants  #
#         subject_test.txt - participant identifiers for the test data       #
#         y_test.txt - activity codes for the test data                      #
#         activity_labels.txt - decodes of the activity codes                #
#                                                                            #
# Output: train_test_average.csv - contains the averages of the mean and     #
#                                  standard deviation columns across         #
#                                  participant/activity                      #
#----------------------------------------------------------------------------#

library(dplyr)

#--------------------------------------------------------------------------#
# Get the column statistic definitions for the test and train datasets and #
# convert them into a vector. The second column is the column statistic.   #
#--------------------------------------------------------------------------#
column_defs <- read.table("features.txt")
column_stats <- as.vector(column_defs[, 2])

#--------------------------------------------------------------------------#
# Change the dashes and commas to underscores, and remove the parentheses. #
#--------------------------------------------------------------------------#
column_stats <- gsub("-", "_", column_stats)
column_stats <- gsub(",", "_", column_stats)
column_stats <- gsub("\\(", "", column_stats)
column_stats <- gsub("\\)", "", column_stats)

#------------------------------------------------------------------------#
# Determine which columns hold mean and standard deviation data for the  #
# measurements. The \\b around the term "mean()" is a word boundary that #
# keeps grep from also grabbing the meanFreq() statistics.               #
#------------------------------------------------------------------------#
mean_std_cols <- sort(c(grep("\\bmean()\\b|std()", column_defs$V2)))

#---------------------------------------------------------------------------#
# Read in the training measures and use the column statistics as the column #
# names. Pull out the mean and standard deviation columns.                  #
#---------------------------------------------------------------------------#
train_stats <- read.table("X_train.txt", col.names=column_stats)
train_mean_std <- train_stats[, mean_std_cols]

#------------------------------------#
# Read in the training subject data. #
#------------------------------------#
train_subjects <- read.table("subject_train.txt", col.names="subject_id")

#------------------------------------------#
# Read in the training activity code data. #
#------------------------------------------#
train_activity <- read.table("y_train.txt", col.names="activity_code")

#-----------------------------------------------------------------------#
# Combine the subject data, activity code data, and measures. Add a set #
# type field to the data frame.                                         #
#-----------------------------------------------------------------------#
train_data <- cbind(train_subjects, train_activity, train_mean_std)
train_data$set_type <- factor("TRAINING")

#-----------------------------------------------------------------------#
# Read in the test measures and use the column statistics as the column #
# names. Pull out the mean and standard deviation columns.              #
#-----------------------------------------------------------------------#
test_stats <- read.table("X_test.txt", col.names=column_stats)
test_mean_std <- test_stats[, mean_std_cols]

#--------------------------------#
# Read in the test subject data. #
#--------------------------------#
test_subjects <- read.table("subject_test.txt", col.names="subject_id")

#--------------------------------------#
# Read in the test activity code data. #
#--------------------------------------#
test_activity <- read.table("y_test.txt", col.names="activity_code")

#------------------------------------------------------------------------#
# Combine the test subject data, activity code data, and measures. Add a #
# set type field to the data frame.                                      #
#------------------------------------------------------------------------#
test_data <- cbind(test_subjects, test_activity, test_mean_std)
test_data$set_type <- factor("TEST")

#-----------------------------------------------#
# Combine the training data with the test data. #
#-----------------------------------------------#
train_test_raw <- rbind(train_data, test_data)

#-------------------------------------------------------------------------#
# Get the activities and merge them with the training/test data. Drop the #
# the activity code column.                                               #
#-------------------------------------------------------------------------#
activity_labels <- read.table("activity_labels.txt",
                              col.names=c("activity_code","activity"))

train_test_final <- merge(train_test_raw, activity_labels)
train_test_final <- subset(train_test_final, select= -activity_code)


#---------------------------------------------------------------------------#
# Create a vector containing the columns to be averaged, and then use it to #
# calculate the average of each variable for each subject/activity. I'm     #
# including the set type in the grouping because it will not be in the      #
# data frame if I don't.                                                    #
#---------------------------------------------------------------------------#
avg_columns <- sort(c(grep("mean|std", names(train_test_final))))
train_test_avg <- train_test_final %>%
                      group_by(set_type, subject_id, activity) %>%                                     
                      summarise_each(funs(mean), avg_columns)

#--------------------------------------------------------------------------#
# Rename the columns, add a creation date column, and write the data frame #
# out to a csv file.                                                       #
#--------------------------------------------------------------------------#
avg_names <- names(train_test_avg)
group_vars <- c("set_type","subject_id","activity")
new_colnames <- unlist(lapply(avg_names, function(x) {
                         if (x %in% group_vars) x else paste0("avg_", x)}))
colnames(train_test_avg) <- new_colnames

train_test_avg <- arrange(train_test_avg, subject_id, activity)
train_test_avg$dataset_creation_date <- date()

write.table(train_test_avg, file="train_test_average.txt", row.names=FALSE)

#----- End of Program -----#
