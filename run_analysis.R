#load related package
library(dplyr)
library(plyr)

# set the path
#setwd("E:/R/Getting and Cleaning Data/Course Project")

# read feature data
features<-read.table("./UCI HAR Dataset/features.txt")
names(features)<-c("id_feature","name_feature")

# read activity labels
activityLabels = read.table("./UCI HAR Dataset/activity_labels.txt")
names(activityLabels) = c("id_activity","name_activity")

# read tranning data
trainSet<-read.table("./UCI HAR Dataset/train/X_train.txt")
trainLabels<-read.table("./UCI HAR Dataset/train/y_train.txt")
trainSubject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
# Merge train data
trainData<-cbind(trainSubject,trainLabels,trainSet)

# read test data
testSet<-read.table("./UCI HAR Dataset/test/X_test.txt")
testLabels<-read.table("./UCI HAR Dataset/test/y_test.txt")
testSubject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
# Merge test data
testData<-cbind(testSubject,testLabels,testSet)

#1.Merges the training and the test sets to create one data set.
allSet<-rbind(trainSet,testSet)
#allData<-rbind(trainData,testData)

#4.Appropriately labels the data set with descriptive variable names. 
featureNames<-as.character(features[,2])
names(allSet)<-make.names(featureNames,unique=TRUE)
#names(allData)<-c("subject","activity",make.names(featureNames,unique=TRUE))

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
allSet_df<-tbl_df(allSet)
meanMeasurements<-select(allSet_df,contains("mean",ignore.case=TRUE))
stdMeasurements<-select(allSet_df,contains("std",ignore.case=TRUE))
extractMeasurement<-cbind(meanMeasurements,stdMeasurements)
names(allData)<-c("subject","activity",names(extractMeasurement))

#3.Uses descriptive activity names to name the activities in the data set
for (i in activityLabels$id_activity){
  allData$activity[allData$activity==i] = as.character(activityLabels[i,"name_activity"])
}


#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- ddply(allData,c("subject","activity"),colMeans)


write.table(tidy_data,file = "./tidy_data.txt",row.name=FALSE)
