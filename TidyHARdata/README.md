Aggregated Average Data from a Human Activity Recognition Dataset
========================================================

Introduction
------------------------------

This is the Course Project for the Getting and Cleaning Data Coursera course from May 2014, taught by Jeff Leek from Johns Hopkins University. 
The analysis code produces a tidy dataset containing average mean and standard deviation smartphone activity measurements for 30 subjects performing 6 different activities (walking, walking upstairs, walking downstairs, sitting, standing and laying). 
The R code for analysis can be found in *run_analysis.R* in this repo. 

Source
----------------------------
The raw dataset is taken from work by Reyes-Ortiz et al., found here:
   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
   
Some unchanged variable names and descriptions are duplicated from the raw data description there. 

It is assumed that the zipped folder from the Getting and Cleaning Data assignment page has been unzipped to a folder in the working directory called 
> /UCI HAR Dataset/ 

Because we are concerned only with the mean and standard deviation for each measurement, the "Inertial Signals" subfolders for test and training datasets, which contain a rawer form of the smartphone accelerator and gyroscope data, are not needed for this project. 

Creating the Tidy Dataset
-----------------------------------

### 1. A single Dataframe of Test and Training Data
This section explains how to create a single dataframe containing all observations for subjects in both the test and training datasets. This joint dataset is then used for further analysis. 
The example is for Test set but should be repeated for Training.

 1. Read the */test/subject_test.txt* file (a single column of the subject associated with each observation) and name the resulting vector as `subject`.
 
 2. Read the */test/Y_test.txt* file (a single column of activities coded as integers 1-6) and name the resulting vector as `activity`.
 
 3. Read the */test/X_test.txt* file (561 columns of observations) as `trainData`.
   * The columns should take `col.names` from the _/features.txt_ file - the names are in column 2 of that file. 
   
 4. Use cbind to attach `subject` and `activity` columns on the left of the `trainData` observation set, creating a single dataframe with id variables at left and measurement variables at right as per convention. 

Steps 1-4 are repeated for the training dataset. While it is possible to join the data first, the subject and activity binding was done in this order to ensure matching of subjects, activities, and the associated observations. 

Now 'rbind' can be used to create a joint dataset of the training and test data (allHAR), with 10299 rows and 563 columns. I use a check that column names are identical first to ensure no error.  

The activity and subject variables by default have the integer class, but should be factors. They are converted to factors using the `as.factor` command. 

### 2. Extract Measurements for mean and standard deviation only, for each measurement. 

The */features_info.txt* file from the original dataset contains details of the 561 observation variables recorded for each observation window of a subject performing an activity. 
There are 17 main observation types in the raw data, some of which are time (t...) and some Fast Fourier Transform frequency domain (f...) variables. From */features_info.txt* the different variable types are:

> * tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

Each of these has multiple parameters associated, each as its own column, including mean (**-mean**) and standard deviation (**-std**) as we require. There is also a mean frequency (**-meanFreq**) for some observations and this is NOT useful for our analysis but will need to be noted in identifying columns. 

Examples of the column headings required for our analysis: 

 * tBodyAccJerk-mean()-X 
 * fBodyGyro-std()-Y

There are also, we see in the */features_info.txt* file: 
> Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable.

These averages within a measurement window sample of the angle variable have been excluded from this analysis as they do not directly go towards the mean and standard deviation of the accelerator and gyroscope measurements as outlined above. These could be considered in a separate analysis (not included). They are named by convention in the form **tBodyAccMean** - Mean is capitalised - and this will enable identification and separation of relevant columns only so long as the case is not ignored. 

To find the columns to retain, we can use regular expressions in the `grep` command to find a vector of column indices of the relevant observations containing "mean" or "std". angle measurements are excluded by using lowercase, and meanFreq measurements are excluded by negation of the capital F (`mean[^F]`). The command is:
```
meanOrStd <- grep(("mean[^F]|std"), names(allHAR))
```
This vector is joined to the id variables subject and activity (columns 1:2) so that they are also retained in the subset and we can define a new dataframe from this limited subset, containing 68 columns. This is named as *cutHAR*. 


### 3. and 4. Activity Naming and Labelling

 * The first step involves labelling the subject activities with descriptive terms rather than numbers. 
We can use the */activity_labels.txt* file to identify descriptors, and the `mapvalues` function from the `plyr` package to replace the factor levels "1" to "6" with appropriate versions of the descriptors (eg in lowercase and removing underscores). 

 * For the observation mean and std data, the names should be changed to work with convention. 
   * Fixed a group of column names with "Body" duplicated which does not align with the */features_info.txt" file).
   * Brackets and hyphens which will cause problems in R (and have already been switched to periods by the program) have been removed. Note necessity for escaping out brackets and periods with double backslash (eg `"\\."`) 
* Inner capital letters are preserved for readability using "camel" convention. 
* "t" for time and "f" for frequency signifiers at start of names are preserved as is without expansion - although human-readable descriptors are encouraged, in this case the rest of the label will require reference to codebook and so it did not seem worth expanding at cost of extra length (particularly because "time" and "frequency" do not on their own clarify enough about these measurements). 
* Order within names changed to put X/Y/Z before mean/std: this fits with logic and convention, as the mean/std is an operation on a defined observation in X/Y/Z so the type of operation should come at the end rather than in the middle. 

### 5. Developing a Tidy Dataset of Averages of Means and Standard Deviations for each Subject and Activity combination. 

The `melt` and `cast` functions from the `reshape2` package can be used to generate averages for each subject/activity pair.



The `cutHAR` dataset was melted using *subject* and *activity* as id variables, leaving the rest as measurement variables. 
This yields a 4-column, "long skinny" dataframe of 679,734 observations. 

For true tidy data, the mean and standard deviation designations will be put in their own column (this could also be done with time and frequency designations but because we do not want to sort by each of those, it is unnecessary as it would go back into a joint variable name). In this dataframe I introduced a new column (placed 3rd) as a factor with two levels, "mean" and "std", to define the type of operation that had been carried out. 
`gsub` was used to then remove the mean or std information from the variable name. This means that the variable name has essentially been split across two columns, one telling what the observation is and the other showing whether it is a mean or standard deviation operation on that observation. 

The average of each set of data (mean or std), for each activity, for each subject, is then found using the `dcast` function:

```
averageHAR <- dcast(reshapeHAR, subject + activity + measureType ~ variable, mean)
```

Note that if one wanted to instead use the original variables, this is easily done by investigating subject and activity as a function of a combined variable + measureType which regains the original variable descriptions (not shown). 

The tidy dataset `averageHAR` is then reordered so that column names of variables are not in alphabetical order but in the order of the original dataset.
This tidy dataset is then exported to a tab-delimited text file using `write.table`. 

 