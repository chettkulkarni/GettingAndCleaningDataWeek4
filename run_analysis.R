#run_analysis.R

#downloading required files
#library(curl)
#library(dplyr)
#library(stringr)


download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Week4Zip.zip",method="libcurl")
unzip("./Week4Zip.zip")

#deciding the column names for the files and loading them into r

# Steps Carried out for features,
# 1.Load data
# 2.Rename Features column names to feature_id,feature for understandability
# 3.Filtering Features and their respective id which has '-mean' or '-std' in them
# 4.Removing '()' from the feature names for better readability
# 5.replacing items starting with t to time for better readability
# 6.replacing items starting with f to FreqDomainSignals for better readability
# 7.replacing  Gyro to Gyroscope for better readability
# 8.replacing Acc to Accelerometer for better readability
# 9.replacing BodyBody to Body for better readability

#1
features<-read.table("./UCI HAR Dataset/features.txt")

#2
colnames(features)=c("feature_id","feature")
features[,2]=as.character(features[,2])

#3 to #8
features_filtered<-filter(features,str_detect(feature, pattern=c("mean","std")))
features_filtered$feature<-gsub('[()]','',features_filtered$feature)
features_filtered$feature<-gsub('-mean',' Mean ',features_filtered$feature)
features_filtered$feature<-gsub('-std',' StandardDeviation',features_filtered$feature)
features_filtered$feature<-gsub("^t","time ",features_filtered$feature)
features_filtered$feature<-gsub("^f","FreqDomainSignals ",features_filtered$feature)
features_filtered$feature<-gsub("*Gyro*"," Gyroscope ",features_filtered$feature)
features_filtered$feature<-gsub("*Acc*"," Accelerometer  ",features_filtered$feature)
features_filtered$feature<-gsub("*BodyBody*"," Body  ",features_filtered$feature)


#load activity and rename column names for better readability
activity<-read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity)=c("activity_id","activity")
activity[,2]=as.character(activity[,2])

#Getting and cleaning train and test data for x
# 1.Reading train and test data for x
# 2.merging train and test data for x
# 3.filtering columns which has mean and std in them
# 4.renaming column for better readability


train_x<-read.table("./UCI HAR Dataset/train/X_train.txt")
test_x<-read.table("./UCI HAR Dataset/test/X_test.txt")
mergedData_x<-rbind(train_x,test_x)
filtered_mergedData_x<-mergedData_x[,features_filtered$feature_id]
colnames(filtered_mergedData_x)<-features_filtered$feature





#Getting and cleaning train and test data for y
# 1.Reading train and test data for y
# 2.merging train and test data for y
# 3.getting the respective name for the id we have from activity


train_y<-read.table("./UCI HAR Dataset/train/Y_train.txt")
test_y<-read.table("./UCI HAR Dataset/test/Y_test.txt")
mergedData_y<-rbind(train_y,test_y)
mergedData_y_description<-activity[mergedData_y[ , 1], 2]


##loading and merging train and test subject data
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
mergedData_subject<-rbind(train_subject,test_subject)


#binding all the calculated x,y and subject data that was cleaned in the previous steps
completeData<-cbind(mergedData_subject,filtered_mergedData_x,mergedData_y_description)

#giving final touches to the data by updating the column names of completedData
colnames(completeData)[colnames(completeData)=="mergedData_y_description"]<-"Activity"
colnames(completeData)[colnames(completeData)=="V1"]<-"Subject"


#writing the created completeData to file named tidy_data.txt
write.table(completeData,file='tidy_data.txt',row.name=FALSE)

completeData_aggregated_means<-aggregate(completeData[,3:45], list(completeData$Subject,completeData$Activity), mean)

colnames(completeData_aggregated_means)[colnames(completeData_aggregated_means)=="Group.1"]="Subject"
colnames(completeData_aggregated_means)[colnames(completeData_aggregated_means)=="Group.2"]="Activity"


write.table(completeData_aggregated_means,file='agreegted_tidy_data.txt',row.name=FALSE)
