#loading data
##train
###read.table(file=, header=FALSE) in order to import data (there is no header on the .txt)
x_train<-read.table("D:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt",header=FALSE)
y_train<-read.table("D:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/Y_train.txt",header=FALSE)
subject_train<-read.table("D:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt",header=FALSE)
###combine y_train, subject_train and x_train by column
train<-cbind(y_train, subject_train, x_train)

##test
x_test<-read.table("D:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt",header=FALSE)
y_test<-read.table("D:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/Y_test.txt",header=FALSE)
subject_test<-read.table("D:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt",header=FALSE)
test<-cbind(y_test,subject_test, x_test)

#combine test and train by row
data<-rbind(train,test)

#load columns names
features<-read.table("D:/Coursera/Getting and Cleaning Data/UCI HAR Dataset/features.txt",header=FALSE,stringsAsFactors=FALSE)

#name colums
## naming measurement variables
for (i in 1:561)
	colnames(data)[i+2]<-(features[i,2])
## naming manually activity and subject variables
colnames(data)[1]<-"Activity"
colnames(data)[2]<-"Subject"
	


#create a logical vector in which value=TRUE where the substring "mean()" or "std()" is in column namefor each column in the data
z1<-grepl("mean()", colnames(data),fixed=TRUE)
z2<-grepl("std()", colnames(data),fixed=TRUE)
z<-z1|z2
#Set the ID variables to TRUE
z[1:2]<-TRUE

#don't work	I wanted to exclUde meanFreq()and run grepl in one line
#target<-c("mean()-","std()")
#z0<-grepl(paste(target, collapse='|'), colnames(data))

#create a tidy data set with only the measurements on the mean and standard deviation
data2<-data[,colnames(data)[z]]

#create a tidy data set with the average of each variable for each activity and each subject. 
data_agg<-aggregate(data2, list("Activity/Subject" = paste(data2[,1],data2[,2])), mean)
