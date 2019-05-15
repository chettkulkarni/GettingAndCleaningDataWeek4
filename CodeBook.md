#CodeBook.md

Variables:-

        1.features:- has features.txt as a table
        2.features_filtered:- filtered features with mean and std calculations
        3.activity:-has activity_labels.txt as a table
        4.train_x:-has X_train.txt as a table
        5.test_x:-has X_test.txt as a table
        6.mergedData_x:-Union of train_x and test_X
        7.filtered_mergedData_x:-filtered_mergedData_x features with mean and std calculations
        8.train_y:-has Y_train.txt as a table
        9.test_y:-has Y_test.txt as a table
        10.mergedData_y:-Union of train_y and test_y
        11.mergedData_y_description:-Has activity names 
        12.train_subject:-has subject_train.txt as a table
        13.test_subject:-has subject_test.txt as a table
        14.mergedData_subject:-Union of train_subject and test_subject
        15.completeData:- A column binded data of mergedData_subject,filtered_mergedData_x,mergedData_y_description .This is the final tidy_set on which we can work upon
        16.completeData_aggregated_means:-mean of all the std and mean values are stored in this table
        
Transformations:-


1.Downloading and unzipping the required data set as follows
    
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Week4Zip.zip",method="libcurl")
     unzip("./Week4Zip.zip")

2.Reading and transforming features.txt and updating all the cluttered column names into more readable format as follows

				
				
				#reading  features file
				features<-read.table("./UCI HAR Dataset/features.txt")
				
				#updating column names
				colnames(features)=c("feature_id","feature")
				
				#converting the factor type datatype of second column to string as it has a feature names
				features[,2]=as.character(features[,2])
				
				#filtering column which works on std and mean
				features_filtered<-filter(features,str_detect(feature, pattern=c("mean","std")))
				
				#removning ()
				features_filtered$feature<-gsub('[()]','',features_filtered$feature)
				
				#changing -mean to Mean
				features_filtered$feature<-gsub('-mean',' Mean ',features_filtered$feature)
				
				#changing -std to StandardDeviation
				features_filtered$feature<-gsub('-std',' StandardDeviation',features_filtered$feature)
				
				#changing all the column names starting with t to time as explained in the readme file
				features_filtered$feature<-gsub("^t","time ",features_filtered$feature)
				
				#changing all the column names starting with f to FreqDomainSignals as explained in the readme file
				features_filtered$feature<-gsub("^f","FreqDomainSignals ",features_filtered$feature)
				
				#changing all the column names  with Gyro to Gyroscope as explained in the readme file
				features_filtered$feature<-gsub("*Gyro*"," Gyroscope ",features_filtered$feature)
				
				#changing all the column names  with Acc to Accelerometer
				features_filtered$feature<-gsub("*Acc*"," Accelerometer  ",features_filtered$feature)
				
				#changing all the column names  with BodyBody to Body as its a typo in the data and is specified in the readme file
				features_filtered$feature<-gsub("*BodyBody*"," Body  ",features_filtered$feature)
        
        
3.load activity.txt and rename column names for better readability and also change the data type of 2nd column to string as it has names in it.

        activity<-read.table("./UCI HAR Dataset/activity_labels.txt")
				colnames(activity)=c("activity_id","activity")
				activity[,2]=as.character(activity[,2])
				
        
 4.Handling train and test data:-
 
a)Getting and cleaning train and test data for x and y

b)Reading train and test data for x and y 

c)merging train and test data for x and y

d)filtering columns which has mean and std in them

e)renaming column for better readability 



            all from a to e is done using the following code
            train_x<-read.table("./UCI HAR Dataset/train/X_train.txt")
            test_x<-read.table("./UCI HAR Dataset/test/X_test.txt")
            mergedData_x<-rbind(train_x,test_x)
            filtered_mergedData_x<-mergedData_x[,features_filtered$feature_id]
            colnames(filtered_mergedData_x)<-features_filtered$feature
            
            #y
            train_y<-read.table("./UCI HAR Dataset/train/Y_train.txt")
            test_y<-read.table("./UCI HAR Dataset/test/Y_test.txt")
            mergedData_y<-rbind(train_y,test_y)
            mergedData_y_description<-activity[mergedData_y[ , 1], 2]
            
            #subject
            train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
            test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
            mergedData_subject<-rbind(train_subject,test_subject)
            
            
5.binding all the calculated x,y and subject data that was cleaned in the previous steps.And Renaming column names for better readability

           completeData<-cbind(mergedData_subject,filtered_mergedData_x,mergedData_y_description)
           colnames(completeData)[colnames(completeData)=="mergedData_y_description"]<-"Activity"
           colnames(completeData)[colnames(completeData)=="V1"]<-"Subject"

6.Writing the tidy data set onto a file named tidy_data
          
          write.table(completeData,file='tidy_data.txt',row.name=FALSE)

7.Aggregating all the column values on a group of subject and activity
  
  
           completeData_aggregated_means<-aggregate(completeData[,3:45], list(completeData$Subject,completeData$Activity), mean)
           colnames(completeData_aggregated_means)[colnames(completeData_aggregated_means)=="Group.1"]="Subject"
           colnames(completeData_aggregated_means)[colnames(completeData_aggregated_means)=="Group.2"]="Activity"

8.Writing completeData_aggregated_means onto a file named agreegted_tidy_data

            write.table(completeData_aggregated_means,file='agreegted_tidy_data.txt',row.name=FALSE)



