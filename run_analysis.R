library(plyr)
activity_labels <- read.table("/Users/Billy/Desktop/GitHub/UCI HAR Dataset/activity_labels.txt", header=FALSE)
features        <- read.table("/Users/Billy/Desktop/GitHub/UCI HAR Dataset/features.txt", header=FALSE)
x_test          <- read.table("/Users/Billy/Desktop/GitHub/UCI HAR Dataset/test/X_test.txt", header=FALSE)
y_test          <- read.table("/Users/Billy/Desktop/GitHub/UCI HAR Dataset/test/y_test.txt", header=FALSE)
subject_test    <- read.table("/Users/Billy/Desktop/GitHub/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
x_train         <- read.table("/Users/Billy/Desktop/GitHub/UCI HAR Dataset/train/X_train.txt", header=FALSE)
y_train         <- read.table("/Users/Billy/Desktop/GitHub/UCI HAR Dataset/train/y_train.txt", header=FALSE)
subject_train   <- read.table("/Users/Billy/Desktop/GitHub/UCI HAR Dataset/train/subject_train.txt", header=FALSE)

##combine like data sets

subject      <- rbind(subject_test, subject_train)
activitydata <- rbind(y_test, y_train)
featuresdata <- rbind(x_test, x_train)

##get mean and std data

getmeanstd <- grep("mean|std)//(//)", features$V2)

##correct column names using activity names and labels

featuresdata <- featuresdata[, getmeanstd]
names(featuresdata) <- features[getmeanstd, 2]
activitydata[, 1] <- activity_labels[activitydata[, 1], 2]
names(activitydata) <- "Activity"
names(subject) <- "Subject"

##combine all data

totaldata <- cbind(subject, activitydata, featuresdata)

##make data more readable

names(totaldata)<- gsub("^t", "Time", names(totaldata))
names(totaldata)<- gsub("^f", "Freq", names(totaldata))
names(totaldata)<- gsub("Acc", "Accelerometer", names(totaldata))
names(totaldata)<- gsub("Gyro", "Gyroscope", names(totaldata))
names(totaldata)<- gsub("Mag", "Magnitude", names(totaldata))
names(totaldata)<- gsub("BodyBody", "Body", names(totaldata))

##make a new tidy data frame

avgdata <- ddply(totaldata, .(Subject, Activity), function(x) colMeans(x[, 3:48]))
write.table(avgdata, "averages_data.txt", row.names=FALSE)

