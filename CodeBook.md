# Code Book for the Getting and Cleaning Data programming assignment - train_test_average.txt

### Data Source

The raw data for this analysis came from here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

**NOTE: This data was not compiled by me. I make no guarantees about its cleanliness or accuracy.**

Information about this dataset can be found here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
### Raw Data Files

features.txt - Contains the list of column headers for the X_train.txt and X_test.txt files
* Space-delimited text file
* 2 columns
*	561 rows

activity_labels.txt - Contains the activity codes and their corresponding labels
* Space-delimited text file
* 2 columns
* 6 rows

X_train.txt - Contains the actual data for the training participants
* Space-delimited text file
* 561 columns
* 7352 rows

y_train.txt - Contains the activity code for each row of the X_train.txt file
* Space-delimited text file
* 1 column
* 7352 rows

subject_train.txt - Contains the participant identifier for each row of the X_train.txt file
* Space-delimited text file
* 1 column
* 7352 rows

X_test.txt - Contains the actual data for the test participants
* Space-delimited text file
* 561 columns
* 2947 rows

y_test.txt - Contains the activity code for each row of the X_test.txt file
* Space-delimited text file
* 1 column
* 2947 rows

subject_test.txt - Contains the participant identifier for each row of the X_test.txt file
* 1 column
* 2947 rows

### Data Transformations

1. Per the requirements, the data for both the training and test participants was subsetted to contain only the mean and standard deviation variables.

2. The column names for the training and test data were derived from the values in the features.txt file.

3. Columns containing the training participant identifiers and activity codes were added to the training data.

4. A set type column was added to the training data to specify that it was from the training dataset.

5. Columns containing the test participant indentifiers and activity codes were added to the test data.

6. A set type column was added to the test data to specify that it was from the test dataset.

7. The training and test datasets were concatenated into one dataset.

8. The dataset was grouped by set type, participant identifier, and activity code, and a second dataset was generated containg the mean calculated for each data column across these three columns.

9. The activity code column was replaced by a column that contained the activity description.

10. A column containing the date and time that the dataset was generated was added.

### Output file - train_test_average.txt

* Contains the calculated mean for each data column by set type, participant ID, and activity.
* Space-delimited text file
* 70 columns
* 181 rows

Columns:
* set_type (FACTOR) - indicates whether the data came from the training dataset or the test dataset
* subject_id (INTEGER) - participant ID
* activity (FACTOR) - activity
* avg_*(measurement)* (NUMERIC) - the mean of the specified measurement across set type, participant ID, and activity. Examples: avg_tBodyAcc_mean_X, avg_tBodyGyro_std_Z
* dataset_creation_date (CHARACTER) - the date and time that the dataset was created
