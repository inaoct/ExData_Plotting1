## Handle library pre-requisites
# Using dplyr for its more intuitive data frame processing
if(!require(dplyr)) install.packages("dplyr")
library(dplyr)
# Using lubridate for easier date manipulation
if(!require(lubridate)) install.packages("lubridate")
library(lubridate)

## Get zip file from provided location & extract the full data set
zipURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
cat("Loading data...", "\n")
download.file(zipURL,temp)
consumptionData <- read.table(unz(temp, "household_power_consumption.txt"), sep = ";", header = TRUE,
                              comment.char = "", na.strings = "?",
                              colClasses = c("character", "character", "numeric", "numeric", 
                                             "numeric", "numeric", "numeric", "numeric", "numeric"))
unlink(temp)
cat("Data load complete...", "\n")

## Prep for data processing and extract the data for the requested data range
consumptionData <- mutate(consumptionData, DateTime = parse_date_time(paste(Date, Time), "dmY hms"))
febData <- filter(consumptionData, DateTime >= mdy("02/01/2007") & DateTime < mdy("02/03/2007"))


## Plot 2
png("plot2.png", width = 480, height = 480)
par(mfrow = c(1, 1))
with(febData, plot(DateTime, Global_active_power, type = "l", 
                   ylab = "Global Active Power (kilowatts)", 
                   xlab = ""))
dev.off()
cat("Plot complete and can be found in working directory:", getwd(), "\n", "File name is plot2.png.")
