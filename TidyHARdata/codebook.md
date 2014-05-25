Codebook for HAR Data Tidy Subset
========================================================

Explanation of variables (columns) in the dataset *averageHAR.txt*.
The data are a tidied subset of the dataset "Human Activity Recognition Using Smartphones Dataset" found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

There are 36 columns in the final dataset, of which the first three columns are id-type non-numeric variables. 

### ID (non-numeric) variables associated with averageHAR tidy dataset

|variableName  |column  |variableDescription      |values                                                                                        |
|:-------------|:-------|:------------------------|:---------------------------------------------------------------------------------------------|
|subject       |1       |Human subject monitored  |Subject ID between 1 and 30 inclusive. Subjects were volunteers 19-48 years                   |
|activity      |2       |Activity performed       |One of 6 activities: walking, walkingUpstairs, walkingDownstairs, sitting, standing, laying.  |
|measureType   |3       |Type of data             |Either mean or 'std' standard deviation                                                       |

The remaining 33 variables are numerical means. 

### Numeric Variables: mean values of HAR mean and standard deviation data

|numericVariables  |
|:-----------------|
|tBodyAccX         |
|tBodyAccY         |
|tBodyAccZ         |
|tGravityAccX      |
|tGravityAccY      |
|tGravityAccZ      |
|tBodyAccJerkX     |
|tBodyAccJerkY     |
|tBodyAccJerkZ     |
|tBodyGyroX        |
|tBodyGyroY        |
|tBodyGyroZ        |
|tBodyGyroJerkX    |
|tBodyGyroJerkY    |
|tBodyGyroJerkZ    |
|tBodyAccMag       |
|tGravityAccMag    |
|tBodyAccJerkMag   |
|tBodyGyroMag      |
|tBodyGyroJerkMag  |
|fBodyAccX         |
|fBodyAccY         |
|fBodyAccZ         |
|fBodyAccJerkX     |
|fBodyAccJerkY     |
|fBodyAccJerkZ     |
|fBodyGyroX        |
|fBodyGyroY        |
|fBodyGyroZ        |
|fBodyAccMag       |
|fBodyAccJerkMag   |
|fBodyGyroMag      |
|fBodyGyroJerkMag  |

Each of these columns contains the mean for the specified measurement type, activity and subject of aggregated smartphone data. The smartphone data was based on accelerometer and gyroscope measurements and has had some processing in the original dataset. In general, names are multipart: 
 * __"t"__ for a time-averaged data or __"f"__ for Fast Fourier Transform processed frequency data.
 * either __"Body"__ or __"Gravity"__ contributions to:
 * Acceleration (__"Acc"__) or gyroscopic movement (__"Gyro"__; no gravity component).
 * Other characteristics including 
   * __X__, __Y__ or __Z__ axis
   * total values (unspecified) or a __"Jerk"__ definition of movement
   * magnitude (__"Mag"__) using the Euclidean norm. 
   
Data are numeric and normalized to between -1 and +1. 
Means were taken from multiple observations on the order of 10-100 per subject-activity pair. 

The original dataset contains more information on the origin of the data and the processing that had already taken place. 