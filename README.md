Getting-and-Cleaning-Data
=========================


Codebook for run_analysis.R

#Loading data
Data is loading thanks to the read.table command.
One is supposed to write the full path in the read.table command.
##Train data set
###read.table(file=, header=FALSE) in order to import data (there is no header on the .txt)
for example : x_train<-read.table("E:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt",header=FALSE), for y_train and subject_train too. Header is FALSE because it comes later.
###combine y_train, subject_train and x_train by column
Combine all those data frame in one thanks to cbind command : 
train<-cbind(y_train, subject_train, x_train)

##Test data set
Data is loading thanks to the read.table command.
One is supposed to write the full path in the read.table command.
x_test, y_test, subject_test is loaded the same way as the train data set and combine with cbind as well.

##Combine test and train by row with rbind command
data<-rbind(train,test)

##Load columns names
features<-read.table("E:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/features.txt",header=FALSE,stringsAsFactors=FALSE) 
stringsAsFactors is FALSE in order to make looping easier later.

##Load activity label names
activity_label<-read.table("E:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt",header=FALSE)
colnames(activity_label)[1]<-"CodeActivity"
colnames(activity_label)[2]<-"Activity_label"

##Merge activity labels with initial data (could have been done faster without a merge)
data<-merge(activity_label, data, by.y="Activity", by.x="CodeActivity",sort=FALSE)

#Cleaning Data
##Columns names
Columns names are stored in the "features" data frame. We loop into it in order to make each label the related column name.
### Naming measurement variables
for (i in 1:561)
	colnames(data)[i+3]<-(features[i,2])
### Naming manually activity and subject variables
colnames(data)[1]<-"Activity"
colnames(data)[2]<-"Activity Label"
colnames(data)[3]<-"Subject"
	
	

##Create a logical vector in which value=TRUE where the substring "mean()" or "std()" is in column name for each column in the data. This way we exclude meanFreq() variables as well.
z1<-grepl("mean()", colnames(data),fixed=TRUE)
z2<-grepl("std()", colnames(data),fixed=TRUE)
z<-z1|z2
###Set the ID variables to TRUE
z[2:3]<-TRUE

#Create a tidy data set with only the measurements on the mean and standard deviation
data2<-data[,colnames(data)[z]]

#Create a tidy data set with the average of each variable for each activity and each subject. 
data_agg<-aggregate(data2[,(3:length(data2[1,]))], list("Activity/Subject" = paste(data2[,1],data2[,2])), mean)
