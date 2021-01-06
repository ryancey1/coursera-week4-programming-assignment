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

This pipeline relies heavily on the tidyverse suite of libraries, so the first process that occurs is an if-else block which ensures that the libraries are downloaded and attached to the environment. Then, both the test and the training data were imported into Rstudio via the `read.delim()` function.

For annotation data (variables and observations), only a subset with the column containing the names is retained. Using `cbind()` and `rbind()`, the training and test measurements were merged together, as well as the training and test group data -- this was done in such a way so as to retain the same order in both sets.

To extract the columns we are interested in, a logical test was performed using `grepl()` for the phrase: "mean|std" on the variables list. Since the ordering in the variables list directly matches the ordering of the columns in our combined data set, a new data frame was created by sub-setting the large data set according to the logical vector (see below for a code snippet).

```r
cols_keep <- grepl("mean|std", features)
extracted <- data[,cols_keep]
```

## Variable Dictionary
