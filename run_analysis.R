#loading data
## path where your files are
path="E:/Coursera/Getting and Cleaning Data/UCI HAR Dataset"

##train
###read.table(file=, header=FALSE) in order to import data (there is no header on the .txt)
x_train<-read.table(file=paste(path,"/train/X_train.txt", sep = ""),header=FALSE)
y_train<-read.table(file=paste(path,"/train/Y_train.txt", sep = ""),header=FALSE)
subject_train<-read.table(file=paste(path,"/train/subject_train.txt", sep = ""),header=FALSE)
###combine y_train, subject_train and x_train by column
train<-cbind(y_train, subject_train, x_train)

##test
x_test<-read.table(file=paste(path,"/test/X_test.txt", sep = ""),header=FALSE)
y_test<-read.table(file=paste(path,"/test/Y_test.txt", sep = ""),header=FALSE)
subject_test<-read.table(file=paste(path,"/test/subject_test.txt", sep = ""),header=FALSE)
test<-cbind(y_test,subject_test, x_test)

#combine test and train by row
data<-rbind(train,test)

#load columns names
features<-read.table(file=paste(path,"/features.txt", sep = ""),header=FALSE,stringsAsFactors=FALSE)
#load activity label names
activity_label<-read.table(file=paste(path,"/activity_labels.txt", sep = ""),header=FALSE)
colnames(activity_label)[1]<-"CodeActivity"
colnames(activity_label)[2]<-"Activity_label"
#merge activity labels with initial data (could have been done faster without a merge)
data<-merge(activity_label, data, by.y="Activity", by.x="CodeActivity",sort=FALSE)
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
