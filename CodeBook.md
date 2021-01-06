# Code Book

This code book serves as a guide for the experimental design, tidying process, and output variable syntax.

# Table of Contents

1. [Experimental Design](#experimental-design)
2. [Tidying Process](#tidying-process)
3. [Variable Dictionary](#variable-dictionary)

## Experimental Design

The experimental design for the original data collection is best described from the original collectors. A snippet from the [archive](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where this data was sourced is as follows:

>"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."

In this project, we are only concerned with measurements on the mean() and std() of each data collected. Thus, the goal of the script is to successfully subset, filter, and summarize the data according to groupings on the subject and the activity.

## Tidying Process

This pipeline relies *heavily* on the 'tidyverse' suite of libraries -- see `tidyverse::tidyverse_packages()` -- so the first process that occurs is an "if-else" block which ensures that the libraries are downloaded and attached to working environment. 

Next, both the test and the training data were imported into R via `read.delim()`.

For annotation data (variables and activities), only a subset with the column containing the names is retained. Using `cbind()` and `rbind()`, the training and test measurements were merged together, as well as the training and test group data -- this was done in such a way so as to retain the same order in both sets for future merging.

To extract the columns we are interested in, a logical test was performed using `grepl()` for the phrase: "mean|std" on the variables list. Since the ordering in the variables list directly matches the ordering of the columns in our combined data set, a new data frame was created by sub-setting the large data set according to the logical vector (see below for a code snippet).

```r
cols_keep <- grepl("mean|std", features)
extracted <- data[,cols_keep]
```

Next, the activity names were cleaned up by removing underscores and converting to sentence case with a house-made sentence case function:

```r
toSentenceCase <- function(string) {
        cap <- function(string) paste(toupper(substring(string, 1, 1)),
                                 {string <- substring(string, 2); tolower(string)},
                                 sep = "", collapse = " " )
        sapply(strsplit(string, split = " "), cap, USE.NAMES = !is.null(names(string)))
}
```

This chunk was iterated over the activity names vector, and then the vector itself was repeated using the `rep()` function to obtain a string of the same dimension as the number of rows for the final tidied data (30 subjects with 6 activities = 180 rows). The result was a large vector with activity names converted like the following:

Raw | Tidied
-|-
WALKING_UPSTAIRS | WalkingUpstairs
LAYING | Laying
WALKING_DOWNSTAIRS | WalkingDownstairs

Lastly, before summarizing the data, the variables were updated to be more readable by utilizing the `sub()` base function to obtain a vector of tidied variables formatted like the following:

Raw | Tidied
-|-
tBodyAcc-mean()-X | Time-BodyAcc-mean()-X
tGravityAcc-std()-Y | Time-GravityAcc-std()-Y
fBodyGyro-std()-Z | Freq-BodyGyro-std()-Z

Lastly, the `group_by()` dplyr function was used to generate groups in the combined observation data according to the activity and the subject. Using `across()` paired with `summarize()`, it was possible to loop a `mean()` function across each variable for each subject performing each activity. The resulting data frame was then combined with the tidied activity names, subject IDs, and the tidied variables to form the final tidied data set.

Lastly, the tidied data (`result`) was exported using the following code:

```r
write.table(result, file = "tidy_data.txt", quote = FALSE, row.names = FALSE)
```

## Variable Dictionary
