#loading data
## Please set your working directory to ~/UCI HAR Dataset"
## For exemple "E:/Coursera/Getting and Cleaning Data/UCI HAR Dataset"

##train
###read.table(file=, header=FALSE) in order to import data (there is no header on the .txt)
x_train<-read.table("train/X_train.txt",header=FALSE)
y_train<-read.table("train/Y_train.txt",header=FALSE)
subject_train<-read.table("train/subject_train.txt",header=FALSE)
###combine y_train, subject_train and x_train by column
train<-cbind(y_train, subject_train, x_train)

##test
x_test<-read.table("test/X_test.txt",header=FALSE)
y_test<-read.table("test/Y_test.txt",header=FALSE)
subject_test<-read.table("test/subject_test.txt",header=FALSE)
test<-cbind(y_test,subject_test, x_test)

#combine test and train by row
data<-rbind(train,test)

#load columns names
features<-read.table("features.txt",header=FALSE,stringsAsFactors=FALSE)
#load activity label names
activity_label<-read.table("activity_labels.txt",header=FALSE)
colnames(activity_label)[1]<-"CodeActivity"
colnames(activity_label)[2]<-"Activity_label"

#merge activity labels with initial data (could have been done faster without a merge)
colnames(data)[1]<-"CodeActivity"
data<-merge(activity_label, data,sort=FALSE)

#name colums
## naming measurement variables
for (i in 1:561)
	colnames(data)[i+3]<-(features[i,2])
## naming manually activities and subject variables
colnames(data)[1]<-"Activity"
colnames(data)[2]<-"Activity Label"
colnames(data)[3]<-"Subject"
	



#create a logical vector in which value=TRUE where the substring "mean()" or "std()" is in column namefor each column in the data
z1<-grepl("mean()", colnames(data),fixed=TRUE)
z2<-grepl("std()", colnames(data),fixed=TRUE)
z<-z1|z2
#Set the ID variables to TRUE
z[2:3]<-TRUE



#create a tidy data set with only the measurements on the mean and standard deviation
data2<-data[,colnames(data)[z]]


#create a tidy data set with the average of each variable for each activity and each subject. 
data_agg<-aggregate(data2[,(3:length(data2[1,]))], list("Activity/Subject" = paste(data2[,1],data2[,2])), mean)
