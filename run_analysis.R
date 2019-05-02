library(dplyr)
#load file to console
activity_labels <- read.table("~/Data Scientist Course/Coursera/Course 3/Week 4/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
features <- read.table("~/Data Scientist Course/Coursera/Course 3/Week 4/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
subject_test <- read.table("~/Data Scientist Course/Coursera/Course 3/Week 4/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
x_test <- read.table("~/Data Scientist Course/Coursera/Course 3/Week 4/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
y_test <- read.table("~/Data Scientist Course/Coursera/Course 3/Week 4/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
subject_train <- read.table("~/Data Scientist Course/Coursera/Course 3/Week 4/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
x_train <- read.table("~/Data Scientist Course/Coursera/Course 3/Week 4/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("~/Data Scientist Course/Coursera/Course 3/Week 4/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")


#change the column names
names(x_test) <- features[,2]
names(x_train) <- features[,2]

#column bind test data set
test <- cbind(subject_test, y_test, x_test)

#column bind training data set
train <- cbind(subject_train, y_train, x_train)

#row bind data set
mydata <- rbind(test, train)

#change the name of first and second column
names(mydata)[1] <- "subject"
names(mydata)[2] <- "activity"

#extract the mean and std column
extracted <- grep("subject|activity|mean|std", features$V2)
reduced_data <- mydata[, extracted]

#rename the descriptive variable names
names(reduced_data) <- gsub("^t", "Time", names(reduced_data))
names(reduced_data) <- gsub("^f", "Frequency", names(reduced_data))
names(reduced_data) <- gsub("-mean\\(\\)", "Mean", names(reduced_data))
names(reduced_data) <- gsub("-std\\(\\)", "StdDev", names(reduced_data))
names(reduced_data) <- gsub("-", " ", names(reduced_data))
names(reduced_data) <- gsub("BodyBody", "Body", names(reduced_data))

#rename the column of activity labels
names(activity_labels) <- c("activityNumber", "activityName")

#name the activities in the data set
reduced_data$activity <- activity_labels$activityName[reduced_data$activity]

#create a tidy data set with the average for each activity and subject
tidyData <- reduced_data %>% group_by(activity, subject) %>% summarize_all((mean))

write.table(tidyData, file = "tidyData.txt", row.names = FALSE)
View(tidyData)