library(plyr)
library(reshape2)

##Extracting data for both test and training subject sets and 
##including in a single database

## Test data extracted, observations linked with subject and 
## activity and variable names applied; all joined. 
subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
activities <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names = "activity")
featureNames <- read.table("./UCI HAR Dataset/features.txt")
testData <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = featureNames[,2])
allTest <- cbind(subjects, activities, testData)

## Repeating these steps for the training dataset. 
subjects2 <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
activities2 <- read.table("./UCI HAR Dataset/train/Y_train.txt", col.names = "activity")
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = featureNames[,2])
allTrain <- cbind(subjects2, activities2, trainData)

## test for column name alignment. 
checkNames <- names(allTest) == names(allTrain)
table(checkNames)

## bind training and test datasets, make factor variables factors.
allHAR <- rbind(allTrain, allTest)
allHAR$subject <- as.factor(allHAR$subject)
allHAR$activity <- as.factor(allHAR$activity)
## Extract only the mean and standard deviation measurements for
## each observation type.
meanOrStd <- grep(("mean[^F]|std"), names(allHAR))
keepCols <- c(1:2, meanOrStd)

cutHAR <- allHAR[,keepCols]

## Naming and labelling. 

##names of activities
activityNames <- read.table("./UCI HAR Dataset/activity_labels.txt")
activityNames
##Use appropriate naming conventions for activities
actNames <- c("walking", "walkingUpstairs", "walkingDownstairs", "sitting", "standing", "laying")
cutHAR2 <- cutHAR ## reserve data, delete after. 
cutHAR$activity <- mapvalues (cutHAR$activity, from = c("1", "2", "3", "4", "5", "6"), to = actNames)

##Adapt names(cutHAR)
names(cutHAR)
names(cutHAR) <- gsub("BodyBody", "Body", names(cutHAR))
##remove multiple dots
names(cutHAR) <- gsub("\\.\\.\\.?", "", names(cutHAR))
## TO SELF keep with these columns for here but duplicate and play later
cutHAR3 <- cutHAR
##put XYZ next to rest of title. 
names(cutHAR) <- gsub(".meanZ", "Zmean", names(cutHAR))
names(cutHAR) <- gsub(".meanX", "Xmean", names(cutHAR))
names(cutHAR) <- gsub(".meanY", "Ymean", names(cutHAR))
names(cutHAR) <- gsub(".stdX", "Xstd", names(cutHAR))
names(cutHAR) <- gsub(".stdY", "Ystd", names(cutHAR))
names(cutHAR) <- gsub(".stdZ", "Zstd", names(cutHAR))
names(cutHAR) <- gsub("\\.", "", names(cutHAR))

##melt the data using id variables subject and activity

reshapeHAR <- melt(cutHAR, id = 1:2)
testMean <- grepl("mean", reshapeHAR$variable)
reshapeHAR$measureType <- ifelse(testMean == TRUE, "mean", "std")
reshapeHAR$measureType <- as.factor(reshapeHAR$measureType)
reshapeHAR <- reshapeHAR[,c(1, 2, 5, 3, 4)]
reshapeHAR$variable <- gsub("mean|std","", reshapeHAR$variable)
reshapeHAR$variable <- as.factor(reshapeHAR$variable)
reshapeHAR2 <- reshapeHAR
levels(reshapeHAR2$variable) <- ordering

##find means of each of mean and standard deviation for 
## all subject activity pairs

averageHAR <- dcast(reshapeHAR, subject + activity + measureType ~ variable, mean)
ordering <- c(c("subject", "activity", "measureType"), as.character(unique(reshapeHAR$variable)))
averageHAR <- averageHAR[, ordering]
##output table of data
write.table(averageHAR, file = "averageHARdata.txt")

## End of program. 