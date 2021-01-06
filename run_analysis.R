#### 0. Runs housekeeping functions & import data ####
# ensures tidyverse components are installed/loaded
if(!any(.packages() == "tidyverse")) {
        if(!"tidyverse" %in% installed.packages()) {
                message("Installing required package: \'tidyverse\'...")
                suppressMessages(suppressWarnings(install.packages("tidyverse")))
                suppressMessages(suppressWarnings(library(tidyverse, verbose = FALSE)))
        } else {
                message("Loading required packages from \'tidyverse\' library")
                suppressMessages(suppressWarnings(library(tidyverse, verbose = FALSE)))
        }
}
message("Ready to run script: \'run_analysis.R\'")

# keeps script from unzipping if already in directory
if(!dir.exists("data/UCI HAR Dataset")) {
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, destfile = "dataset.zip")
        message("Extracting dataset from compressed file...")
        unzip("dataset.zip", exdir = "data")
}

message("Loading required elements into environment...")
# load feature data, keep only relevant cols
activity_labels <- read.delim("data/UCI HAR Dataset/activity_labels.txt", sep = "", check.names = FALSE, header=FALSE)[,2]
features <- read.delim("data/UCI HAR Dataset/features.txt", sep = "", check.names = FALSE, header=FALSE)[,2]

# load test data
subjects1 <- read.delim("data/UCI HAR Dataset/test/subject_test.txt", sep = "", check.names = FALSE, header=FALSE)
test.activity <- read.delim("data/UCI HAR Dataset/test/y_test.txt", sep="", check.names = FALSE, header=FALSE)
test.data <- read.delim("data/UCI HAR Dataset/test/X_test.txt", sep = "", check.names = FALSE, header = FALSE)
test.activity <- cbind(subjects1, test.activity)

# load train data
subjects2 <- read.delim("data/UCI HAR Dataset/train/subject_train.txt", sep = "", check.names = FALSE, header=FALSE)
train.activity <- read.delim("data/UCI HAR Dataset/train/y_train.txt", sep = "", check.names = FALSE, header=FALSE)
train.data <- read.delim("data/UCI HAR Dataset/train/X_train.txt", sep = "", check.names = FALSE, header = FALSE)
train.activity <- cbind(subjects2, train.activity)

# clean up environment
rm(subjects1, subjects2)

#### 1. Merges the training and the test sets to create one data set. ####
message("Merging training and test data...")
data <- rbind(test.data, train.data)
groups <- rbind(test.activity, train.activity); colnames(groups) <- c("subject", "activity")

# clean up environment
rm(test.data, train.data, test.activity, train.activity)

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement. ####
message("Extracting desired variables...")
cols_keep <- grepl("mean|std", features)
extracted <- data[,cols_keep]

# clean up environment
rm(data)

#### 3. Uses descriptive activity names to name the activities in the data set ####
message("Tidying up activity labels...")
# remove underscores while preserving order, create vector repeating over as many participants (30)
tidy_activities <- sub("_", " ", activity_labels)
# generic function from ?toupper help page
toSentenceCase <- function(string) {
        cap <- function(string) paste(toupper(substring(string, 1, 1)),
                                      {string <- substring(string, 2); tolower(string)},
                                      sep = "", collapse = " " )
        sapply(strsplit(string, split = " "), cap, USE.NAMES = !is.null(names(string)))
}
for(i in seq_along(tidy_activities)) {
        tmp <- toSentenceCase(tidy_activities[i])
        tidy_activities[i] <- tmp
}
tidy_activities <- sub(" ", "", tidy_activities)
tidy_activities <- rep(tidy_activities, times = 30)

# clean up environment
rm(activity_labels, i, tmp, toSentenceCase)

#### 4. Appropriately labels the data set with descriptive variable names. ####
message("Tidying up feature labels...")
tidy_variables <- features[cols_keep]
tidy_variables <- sub("^t", "Time-", tidy_variables)
tidy_variables <- sub("^f", "Freq-", tidy_variables)
tidy_variables <- c("Subject", "Activity", tidy_variables)

# clean up environment
rm(cols_keep, features)

#### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ####
message("Generating tidy data set...")
extracted <- group_by(extracted, groups$subject, groups$activity)
result <- summarize(extracted, across(.fns = mean), .groups = "keep")

# update variable names and activity observation names with "tidy" replacements
colnames(result) <- tidy_variables
result$Activity <- tidy_activities
result <- arrange(result, result$Activity)

# clean up environment
rm(extracted, groups, tidy_activities, tidy_variables)

#### 6. Exports space-delimited, tidy data set from step 5 ####
message("Exporting results...")
write.table(result, file = "tidy_data.txt", quote = FALSE, row.names = FALSE)
message("DONE - Tidy data exported to file: \'tidy_data.txt\'")
