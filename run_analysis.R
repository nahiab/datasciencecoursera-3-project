## Read the data sets
train_subject <- read.table("train/subject_train.txt")
train_X <- read.table ("train/X_train.txt")
train_y <- read.table ("train/y_train.txt")
test_subject <- read.table("test/subject_test.txt")
test_X <- read.table ("test/X_test.txt")
test_y <- read.table ("test/y_test.txt")

## Merge the data sets
subjects <- rbind (train_subject, test_subject)
Xs<- rbind(train_X, test_X)
ys <- rbind(train_y, test_y)

##Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table ("features.txt")
feat_mean <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
Xmean <- Xs[, feat_mean]

## Use descriptive activity names to name the activities in the data set
names(Xmean) <- features [feat_mean, 2]
names(Xmean) <- tolower (names(Xmean))
names(Xmean) <- gsub ("_", "", names(Xmean))
activities <- read.table ("activity_labels.txt")
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])
ys[, 1] = activities[ys[, 1], 2]
colnames(ys) <- 'activity'
colnames(subjects) <- 'subject'

## Appropriately label the data set with descriptive variable names
data <- cbind (subjects, Xmean, ys)
write.table(data, "step4.txt", row.names = FALSE)

## Create a second, independent, tidy data set with the average of each variable for each activity and each subject
tidy_data <- aggregate (data, by=list(activities=data$activity, subjects=data$subject), FUN=mean)
tidy_data <- tidy_data [, !(colnames(tidy_data) %in% c("subjects", "activity"))]
write.table(tidy_data, "step5.txt", row.names= FALSE)