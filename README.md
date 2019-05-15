# GettingAndCleaningDataWeek4
Getting and Cleaning Data project from Coursera week 4

As a part of the task we are supposed to create a tidy data from the data captured by fitness band.

The data is available in .zip format in the following link 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data is of 2 types :- Train data,Test Data. And we are supposed to merge them in one and make a tidy data set.This new Data set should only consists of columns std and mean values.


processing Steps:-

1] Loading libraries like deplyr,stringr,curl. 

2]Process Features.txt file

				1.Load data
				
				2.Rename Features column names to feature_id,feature for understandability
				
				3.Filtering Features and their respective id which has '-mean' or '-std' in them
				
				4.Removing '()' from the feature names for better readability
				
				5.replacing items starting with t to time for better readability
				
				6.replacing items starting with f to FreqDomainSignals for better readability
				
				7.replacing  Gyro to Gyroscope for better readability
				
				8.replacing Acc to Accelerometer for better readability
				
3]load activity and rename column names to 'activity_id','activity' for better readability

4]Getting and cleaning train and test data for x which has the values of different parameters

				1.Reading train and test data for x
				
				2.merging train and test data for x
				
				3.filtering columns which has mean and std in them
				
				4.renaming column for better readability
				
5]Getting and cleaning train and test data for y,which holds the activity info

				1.Reading train and test data for y
				
				2.merging train and test data for y
				
				3.getting the respective name for the id we have from activity
				
6]loading and merging train and test subject data,holds the information of the subject

7]binding all the calculated x,y and subject data that was cleaned in the previous steps

8]giving final touches to the data by updating the column names of completedData

9]Writing the above created data set using write.table() and row.name=FALSE and name it tidy_data

The Tidy data set is ready now.

10]Aggregating values of all the columns grouped by activity and subject.

#completeData_aggregated_means<-aggregate(completeData[,3:45], list(completeData$Subject,completeData$Activity), mean)

11]Renaming columns for better readability.
12]Writing the output to a file called agreegted_tidy_data.txt


