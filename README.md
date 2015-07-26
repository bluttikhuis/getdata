The script run-analysis.R:

1. Merges the training and the test sets to create one data set.
This step first merges the different files of the test and training data to a test-set and a training-set using cbind(). After this is done, both the test and training data can be merged using rbind(). 

2. Extracts only the measurements on the mean and standard deviation for each measurement. 
By creating a logical vector with the grepl() function that searches for the mean and standard deviation in the variable names, the data can be subsetted to only contain these measurements.  

3. Uses descriptive activity names to name the activities in the data set.

4. Appropriately labels the data set with descriptive variable names. 
A for-loop is used to rename the variables. 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
