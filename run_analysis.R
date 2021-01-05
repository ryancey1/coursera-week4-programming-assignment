## ensures tidyverse components are installed/loaded
if(!any(.packages() == "tidyverse")) {
        if(!"tidyverse" %in% installed.packages()) {
                suppressMessages(suppressWarnings(install.packages("tidyverse")))
        } else {
                suppressMessages(suppressWarnings(library(tidyverse, verbose = FALSE)))
        }
}

## keeps script from unzipping if already in directory
if(!dir.exists("data/UCI HAR Dataset")) {
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, destfile = "dataset.zip")
        
        if (!dir.exists("data"))
                dir.create("data")
        unzip("dataset.zip", exdir = "data")
}

## load feature data
activity_labels <- read.delim("data/UCI HAR Dataset/activity_labels.txt", sep = "", check.names = FALSE, header=FALSE)
features <- read.delim("data/UCI HAR Dataset/features.txt", sep = "", check.names = FALSE, header=FALSE)

## load test data
subjects1 <- read.delim("data/UCI HAR Dataset/test/subject_test.txt", sep = "", check.names = FALSE, header=FALSE)
test.activity <- read.delim("data/UCI HAR Dataset/test/y_test.txt", sep="", check.names = FALSE, header=FALSE)
test.data <- read.delim("data/UCI HAR Dataset/test/X_test.txt", sep = "", check.names = FALSE, header = FALSE)
test.activity <- cbind(subjects1, test.activity)

# load train data
subjects2 <- read.delim("data/UCI HAR Dataset/train/subject_train.txt", sep = "", check.names = FALSE, header=FALSE)
train.activity <- read.delim("data/UCI HAR Dataset/train/y_train.txt", sep = "", check.names = FALSE, header=FALSE)
train.data <- read.delim("data/UCI HAR Dataset/train/X_train.txt", sep = "", check.names = FALSE, header = FALSE)
train.activity <- cbind(subjects2, train.activity)

# merge data frames
data <- rbind(test.data, train.data); rm(test.data, train.data)
colnames(data) <- features[,2]
activity <- rbind(test.activity, train.activity); rm(test.activity, train.activity)
colnames(activity) <- c("subjectID", "activityID")
dataset <- cbind(activity, data); rm(data, activity)

keep <- grepl("subjectID|activityID|mean|std", colnames(dataset))
filtered <- dataset[,keep]
grouped <- group_by(filtered, filtered$subjectID, filtered$activityID)

summarized <- summarize_all(grouped, mean)[,-(1:2)]
seq <- seq_along(summarized$activityID)
tmp <- c()
for(i in seq) {
        tmp <- c(tmp, activity_labels[as.numeric(summarized[i,2]),2])
}
summarized$activityID <- tmp
View(summarized)
