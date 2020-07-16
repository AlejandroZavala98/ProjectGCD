if(!file.exists("./data")){dir.create("./data")}
#we download the Zip
file_Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_Url,destfile="C:/Users/Usuario/Desktop/DataScienceR/Getting_And_Cleaning_Data/Project/Dataset.zip",method="curl")
unzip(zipfile="C:/Users/Usuario/Desktop/DataScienceR/Getting_And_Cleaning_Data/Project/Dataset.zip",exdir="./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files
# I read the activity files
data_Activity_Test  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
data_Activity_Train <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
# I Read the Subject files
data_SubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
data_SubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
# I read fearures
data_FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
data_FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
# Look at the properties of the above varibles
str(data_Activity_Test)
str(data_Activity_Train)
str(data_SubjectTrain)
str(data_SubjectTest)
str(data_FeaturesTest)
str(data_FeaturesTrain)
# Concatenate by rows
data_Subject <- rbind(data_SubjectTrain, data_SubjectTest)
data_Activity<- rbind(data_Activity_Train, data_Activity_Test)
data_Features<- rbind(data_FeaturesTrain, data_FeaturesTest)
#We add names to tables
names(data_Subject)<-c("subject")
names(data_Activity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(data_Features)<- dataFeaturesNames$V2
#Merge columns
data_Combine <- cbind(data_Subject, data_Activity)
Data <- cbind(data_Features, data_Combine)
# Extracts only the measurements on the mean and standard deviation for each measurement
subdata_FeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdata_FeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)
#Uses descriptive activity names to name the activities 
basedir <- "UCI HAR Dataset"
activitylabelsfile <- paste(basedir, "activity_labels.txt", sep="/")
dir_activi <- paste("C:/Users/Usuario/Desktop/DataScienceR/Getting_And_Cleaning_Data/Project/Dataset.zip", activitylabelsfile, sep="/")
activitylabels <- read.table(dir_activi, col.names=c("activity", "activitydescription"))
library(dplyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)