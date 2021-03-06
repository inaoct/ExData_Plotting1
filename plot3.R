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


#Plot 3
png("plot3.png", width = 480, height = 480)
par(mfrow = c(1, 1))
with(febData, plot(DateTime, Sub_metering_1, type = "n", 
                   ylab = "Energy sub metering", xlab = ""))
lines(febData$DateTime, febData$Sub_metering_1, col = "black")
lines(febData$DateTime, febData$Sub_metering_2, col = "red")
lines(febData$DateTime, febData$Sub_metering_3, col = "blue")
legend("topright", lty = c(1, 1, 1), col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# Note: used y.intersp = 0.4 when plotting to screen as the legend was taking too large space of the topright of the graph.
# However, when I save this plot to png, the legend appeared to small and I had to remove this parameter.
dev.off()
cat("Plot complete and can be found in working directory:", getwd(), "\n", "File name is plot3.png.")

