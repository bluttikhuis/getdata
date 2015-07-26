# 1. Merge the training and the test sets to create one data set.

# !! set working directory to the location where the UCI HAR Dataset was unzipped
setwd('/Users/Berry/Desktop/Data Science/3_GETDATA/WD/UCI HAR Dataset/');

# Read in data
features     = read.table('./features.txt',header=FALSE); #imports features.txt
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt
subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       = read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
yTest       = read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

# Assign column names to the data imported above
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";

# Merge test and training data, note that they first need to be merged separately
train = cbind(yTrain,subjectTrain,xTrain)
test = cbind(yTest,subjectTest,xTest)
all = rbind(trainingData,testData)

# Create a vector for the column names from the finalData, which will be used
# to select the desired mean() & stddev() columns
columns  = colnames(all); 

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

# Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others (hint: check features.txt)
logicalVector = (grepl("activity..",columns) | grepl("subject..",columns) | grepl("-mean..",columns) & !grepl("-meanFreq..",columns) & !grepl("mean..-",columns) | grepl("-std..",columns) & !grepl("-std()..-",columns));

# Subset finalData table based on the logicalVector to keep only desired columns
all = all[logicalVector==TRUE];

# 3. Use descriptive activity names to name the activities in the data set

# Merge the 'all' dataset with the acitivityType table to include descriptive activity names

activity = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
colnames(activity)  = c('activityId','activity');
all = merge(all, activity, by='activityId',all.x=TRUE);

# Updating the colNames vector to include the new column names after merge
columns  = colnames(all); 

# 4. Appropriately label the data set with descriptive activity names. 

# Cleaning up the variable names
for (i in 1:length(columns)) 
{
  columns[i] = gsub("\\()","",columns[i])
  columns[i] = gsub("-std$","StdDev",columns[i])
  columns[i] = gsub("-mean","Mean",columns[i])
  columns[i] = gsub("^(t)","time",columns[i])
  columns[i] = gsub("^(f)","freq",columns[i])
  columns[i] = gsub("(BodyBody|Body)","Body",columns[i])
  columns[i] = gsub("AccMag","AccMagnitude",columns[i])
  columns[i] = gsub("JerkMag","JerkMagnitude",columns[i])
  columns[i] = gsub("GyroMag","GyroMagnitude",columns[i])
};

# Reassigning the new descriptive column names to the 'all' dataset
colnames(all) = columns;

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Create a new table, all2 without the activityType column
all2  = all[,names(all) != 'activity'];

# Summarizing the all2 table to include just the mean of each variable for each activity and each subject
tidy    = aggregate(all2[,names(all2) != c('activityId','subjectId')], by = list(activityId = all2$activityId, subjectId = all2$subjectId), mean);

# Merging the tidyData with activityType to include descriptive activity names
tidy    = merge(tidy, activity,by='activityId',all.x=TRUE);

# Export the tidyData set 
write.table(tidy, './tidy.txt',row.names=TRUE,sep='\t');
