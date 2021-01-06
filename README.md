# Getting and Cleaning Data - Week 4 Programming Assignment

## About the project

> "The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis."

The script in this repo (`run_analysis.R`) was developed to perform 5 essential functions after downloading and importing a specific data set.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The data set is available for download [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). 


**NOTE:** the script downloads, unzips, and imports the data itself prior to tidying for reproducibility.

## Repository contents

Here is what you'll find in this repository:


File | Description
-|-
`README.md` | This helper file
`run_analysis.R` | R script used to generate tidied data
`CodeBook.md` | A code book to explain variables
`dataset.zip` | The compressed, raw data set
`tidy_data.txt` | The tidied data output

***

### README.md

The explainer file you are currently reading.

***

### run_analysis.R

The exact recipe to get from the raw input to my tidy output. To run this script, clone this repo and set the git root as your working directory by running `setwd("/path/to/git/root")`. Then run the following command:

```r
source("run_analysis.R")
```

The console will update you on its progress with messages.

***

### CodeBook.md

A deep breakdown of all the variables and abbreviations used in the data set.

***

### dataset.zip

This file contains the compressed contents utilized in the R script. The following is a breakdown of the directory and its unzipped contents. *(Contents within each "Inertial Signals" subdirectory are omitted for brevity as they are not used.)*

```
data/
 └── UCI HAR Dataset/
      ├── README.txt
      ├── activity_labels.txt
      ├── features.txt
      ├── features_info.txt
      │
      ├── test/
      │    ├── Inertial Signals/
      │    ├── X_test.txt
      │    ├── subject_test.txt
      │    └── y_test.txt
      │
      └── train/
           ├── Inertial Signals/
           ├── X_train.txt
           ├── subject_train.txt
           └── y_train.txt
```

***

### tidy_data.txt

The space-delimited output generated from sourcing `run_analysis.R`. A tidy data set is described by Hadley Wickham [here](http://vita.had.co.nz/papers/tidy-data.pdf).

> 1. Each variable forms a column.
> 2. Each observation forms a row.
> 3. Each type of observational unit forms a table.
