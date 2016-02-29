# needs the package dplyr
library(dplyr)
# LOAD DATA
#read features and make them the colNames
features<-read.delim('UCI HAR Dataset/features.txt', header = FALSE, sep = " ", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
colNames<-features[,2]
# load the train data
sbj_train<-read.delim('UCI HAR Dataset/train/subject_train.txt', header = FALSE, sep = "\n", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
# read X Train
X_train<-read.table('UCI HAR Dataset/train/X_train.txt')
# read y_train
y_train<-read.delim('UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = "\n", quote = "\"", dec = ".", fill = TRUE, comment.char = "")

# read test data
sbj_test<-read.delim('UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = "\n", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
# read X test
X_test<-read.table('UCI HAR Dataset/test/X_test.txt')
# read y test
y_test<-read.delim('UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = "\n", quote = "\"", dec = ".", fill = TRUE, comment.char = "")

# combine the two sets of data in one 
sbj_data<-rbind(sbj_train,sbj_test)
X_data<-rbind(X_train,X_test)
y_data<-rbind(y_train,y_test)
# set the features as column names for X data set
names(X_data)<-colNames
# Extracts only the measurements on the mean and standard deviation for each measurement
keep_features<-grep("(-mean\\(\\))|(-std\\(\\))",colNames, value = TRUE)
# keep only the required variables
keepX_data<-X_data[,keep_features]
# replace the activity code by activity label

# add the subject ID and the Activity variables
Big_data<-cbind(sbj_data,y_data,keepX_data)
# clean the names of the features of non important characters
better_names<-lapply(keep_features,gsub,pattern = '\\(\\)-|-|\\(\\)', replacement = '')
names(Big_data)<-c("sbjID", "Activity",better_names)
# group data by Subject ID and Activity variables
GRP_data<-group_by(Big_data, sbjID, Activity)
# calculate the averages for each variable except subject ID and Activity
AVE_data<-as.data.frame(summarize_each(GRP_data,funs(mean)))
# writes to file the tidy data
write.table(AVE_data,"tidy_data.txt", row.names = FALSE)
