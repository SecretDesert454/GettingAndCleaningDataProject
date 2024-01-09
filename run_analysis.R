#############Coursera Project Getting and Cleaning Data########

#data was collected from:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

getwd()
setwd("C:/Users/Carlos Yair/OneDrive - Universidad La Salle Bajío/Personal/Cursos/R/Data Science Specialization/3 Raw and process data/Final Project")

# Downloading and unzipping dataset


if(!file.exists("./data")){dir.create("./data")}
#Link of the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/data.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/data.zip",exdir="./data")

#Step 1.Merges the training and the test sets to create one data set.

#Train
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Test
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

#activity labels:
activityLabels <- read.table('./data/UCI HAR Dataset/activity_labels.txt')


#We confirm the dimensions, so test dataset will have 2947 rows and 561 columns
#features is the name of the variables of x_test
#y_train con
dim(x_test) #data
dim(features) #colnames
dim(y_test) #activities
dim(subject_test)

# column names to the table:

colnames(x_train) <- features[,2]
colnames(y_train) <-"activity_id"
colnames(subject_train) <- "subject_id"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity_id"
colnames(subject_test) <- "subject_id"

colnames(activityLabels) <- c('activity_id','activity_type')

#Merge

train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
all <- rbind(train, test)


##mean and standard deviation for each measurement



#mean and standard deviation:
colNames <- colnames(all)
mean_and_std <- (grepl("activity_id" , colNames) | 
                     grepl("subject_id" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
)

#subset

setForMeanAndStd <- all[ , mean_and_std == TRUE]

#Step 3. Uses descriptive activity names to name the activities in the data set

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activity_id',
                              all.x=TRUE)

#Step 4. Appropriately labels the data set with descriptive variable names.


#Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setWithActivityNames <- setWithActivityNames[, -which(names(setWithActivityNames) == "activity_id")]
secTidySet <- aggregate(. ~subject_id + activity_type, setWithActivityNames, mean)


write.table(secTidySet, "summary_data.txt", row.name = FALSE)


