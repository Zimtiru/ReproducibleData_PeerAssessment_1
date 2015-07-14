---
title: "Reproducible Data Research Peer Assessment 1"
author: "Anteneh"
date: "July 6, 2015"
output: html_document
---

<h4> 1. Loading and preprocessing the data </h4>

```{r}
filename <- unzip("repdata_data_activity.zip")
activity <- read.csv(filename, stringsAsFactors = FALSE)
str(activity)
```
As we can see from the from the above summary, the dataset that the column containing the dates is not in a properly formatted way so we should adjust it as follow.

```{r}
activity$date <- as.Date(activity$date)
str(activity)

```
There are 2304 missing values in the column of the steps. 
```{r}
sum(is.na(activity$steps))
```

<h4> 2. What is mean total number of steps taken per day?</h4>
For the first two questions we will need a file that does not contain missing values.

For our computation we excluded 2304 missing values from our analysis.

The dataset called “activity_new” is created for this reason.

```{r, echo=FALSE}
activity_new<-activity[which(!is.na(activity$steps)),]
```
The number of steps taken is measured in timeslots, 5-minute intervals, so in order to compute the total number of steps taken for each day we will aggregate the data by day.

```{r, echo=FALSE}
perday<-tapply(activity_new$steps, activity_new$date, sum)
```
So, now the per day dataset contains the total number of steps taken for each day of October and November (total 53 days)
Let's make a histogram of the total number of steps taken each day.

```{r, echo=FALSE}
hist(perday,10, main = "Total number of steps taken per day", xlab = "",ylab="Frequency")
```
The average total number of steps for  a whole day is 10766, while the median of the total steps is 10765.
```{r}
mean(perday)
median(perday)
```
<h4> 3. What is the average daily activity pattern?</h4>
Inorder to study our data during the day, it is necessary to aggregate the dataset by intervals.  Therefore this will create a per interval array  and a time series.

Please keep in mind that the x-axis point labels are the names of the intervals in the dataset. The coding of the interval names is such, so that e.g. 500 should be conidered as 5:00 and 1000 as 10:00, ans so on. So, one can consider th x-axis as a fuull 24-hour-day starting from midnight and ending at the next midnight hour.
```{r, echo=FALSE}
dailyactivity<-tapply(activity_new$steps, activity_new$interval, mean)
plot(y = dailyactivity, x = names(dailyactivity), type = "l",xlab ="5-Minute-Interval", main = "Pattern of Daily Activity", ylab = "Mean number of steps")
```
Finally, we find out that the interval with the maximum average number of steps throughout the days is 835 with 206.1698 steps.
```{r}
dailyactivity[dailyactivity==max(dailyactivity)]
```
<h4> 4. Inputing missing values </h4>
That there are a number of days/intervals where there are missing values (labelled as NA). The presence of missing days may introduce bias into the calculations or summaries of the data. Therefore we need to check these missing values in th whole dataset before we go to our analysis.
```{r}
sum(is.na(activity$steps))
sum(is.na(activity))
```
As we have seen in  the above statement, the total number of missing values for the column of steps equals to the total number missing from the whole dataset. These missing values(2304/17568= 13.11475%) will bring biase.

Hence, 2304 missing values is a percentage of 13.11% on the total observations, so obviously there will be some bias.

In order to exclude the bias we have to come up with a method for filling in all of the missing values in the dataset. Some quick ways are to use the mean/median for that day, or the mean for that 5-minute interval, etc.

