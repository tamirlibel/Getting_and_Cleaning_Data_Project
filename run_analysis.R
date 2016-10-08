##Merge the training and the test sets to create one data set.
#download zip file from website
if(!file.exists(".\\data")) dir.create(".\\data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = ".\\data\\projectData_getCleanData.zip")
#unzip data
listZip <- unzip(".\\data\\projectData_getCleanData.zip", exdir = ".\\data")
#load data into R
X_TraiN <- read.table(".\\data\\UCI HAR Dataset\\train\\x_train.txt")
Y_TraiN <- read.table(".\\data\\UCI HAR Dataset\\train\\y_train.txt")
SuB_TraiN <- read.table(".\\data\\UCI HAR Dataset/train\\subject_train.txt")
X_TesT <- read.table(".\\data\\UCI HAR Dataset\\test\\X_test.txt")
Y_TesT <- read.table(".\\data\\UCI HAR Dataset\\test\\y_test.txt")
SuB_TesT <- read.table(".\\data/UCI HAR Dataset\\test\\subject_test.txt")
#merge train and test data
DaT_TraiN <- cbind(SuB_TraiN, Y_TraiN, X_TraiN)
testData <- cbind(SuB_TesT, Y_TesT, X_TesT)
DaT <- rbind(DaT_TraiN, testData)

##Extract only the measurements on the mean and standard deviation for each measurement. 
#load feature name into R
FeaT_NaM <- read.table(".\\data\\UCI HAR Dataset\\features.txt", stringsAsFactors = FALSE)[,2]
#extract mean and standard deviation of each measurements
Index_Feat <- grep(("mean\\(\\)|std\\(\\)"), FeaT_NaM)
CombinedData <- DaT[, c(1, 2, Index_Feat+2)]
colnames(CombinedData) <- c("subject", "activity", FeaT_NaM[Index_Feat])

##Uses descriptive activity names to name the activities in the data set
#load activity data into R
AcT_NaM <- read.table(".\\data\\UCI HAR Dataset\\activity_labels.txt")
#replace 1 to 6 with activity names
CombinedData$activity <- factor(CombinedData$activity, levels = AcT_NaM[,1], labels = AcT_NaM[,2])

##Appropriately labels the data set with descriptive variable names.
names(CombinedData) <- gsub("\\()", "", names(CombinedData))
names(CombinedData) <- gsub("^t", "time", names(CombinedData))
names(CombinedData) <- gsub("^f", "frequence", names(CombinedData))
names(CombinedData) <- gsub("-mean", "Mean", names(CombinedData))
names(CombinedData) <- gsub("-std", "Std", names(CombinedData))

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
TidY_Dat <- CombinedData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(TidY_Dat, ".\\data\\MeanData.txt", row.names = FALSE)
