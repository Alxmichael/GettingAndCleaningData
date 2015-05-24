# Merges the training and the test sets to create one data set.
xTrainData <- read.table('~/datasciencecoursera/GettingAndCleaningData/UCI HAR Dataset/train/X_train.txt')
xTestData <- read.table('~/datasciencecoursera/GettingAndCleaningData/UCI HAR Dataset/test/X_test.txt')
x <- rbind(xTrainData, xTestData)

subjectTrain <- read.table('~/datasciencecoursera/GettingAndCleaningData/UCI HAR Dataset/train/subject_train.txt')
subjectTest <- read.table('~/datasciencecoursera/GettingAndCleaningData/UCI HAR Dataset/test/subject_test.txt')
subj <- rbind(subjectTrain, subjectTest)

yTrainData <- read.table('~/datasciencecoursera/GettingAndCleaningData/UCI HAR Dataset/train/y_train.txt')
yTestData <- read.table('~/datasciencecoursera/GettingAndCleaningData/UCI HAR Dataset/test/y_test.txt')
y <- rbind(yTrainData, yTestData)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
featuresData <- read.table('~/datasciencecoursera/GettingAndCleaningData/UCI HAR Dataset/features.txt')
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", featuresData[, 2])
x.mean.sd <- x[, mean.sd]

# Uses descriptive activity names to name the activities in the data set
names(x.mean.sd) <- featuresData[mean.sd, 2]
names(x.mean.sd) <- tolower(names(x.mean.sd)) 
names(x.mean.sd) <- gsub("\\(|\\)", "", names(x.mean.sd))

activities <- read.table('~/datasciencecoursera/GettingAndCleaningData/UCI HAR Dataset/activity_labels.txt')
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])

y[, 1] = activities[y[, 1], 2]
colnames(y) <- 'activity'
colnames(subj) <- 'subject'

# Appropriately labels the data set with descriptive activity names.
data <- cbind(subj, x.mean.sd, y)
str(data)
write.table(data, '~/datasciencecoursera/GettingAndCleaningData/merged.txt', row.names = F)

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
average.df <- average.df[, !(colnames(average.df) %in% c("subj", "activity"))]
str(average.df)
write.table(average.df, '~/datasciencecoursera/GettingAndCleaningData/tidyData.txt', row.names = F)