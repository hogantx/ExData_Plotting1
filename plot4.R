library(dplyr)

### This function downloads the data into the EDA directory.
download_data = function() {
	### Create directory
	if(!file.exists("EDA")) {
	dir.create("EDA")
	}

	setwd("./EDA")

	### Download and unzip data
	fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
	message("Downloading data")
	download.file(fileUrl, destfile = "household_power_consumption.zip")
	unzip("household_power_consumption.zip")
	
	### Note date file downloaded
	dateDownloaded = date()
}
download_data()






### This function prepares the data.
### The file is subsetted and the date and time columns are appropriately formatted.

prepare_data = function() {
  ### Column names for data, allows skipping the first row, yay!
  hpc_names <- c(
    "date", 
    "time", 
    "global_active_power", 
    "global_reactive_power", 
    "voltage", 
    "global_intensity",
    "sub_metering_1", 
    "sub_metering_2", 
    "sub_metering_3") 

  ### Read in txt, with column names, skip first row
  hpc <- read.table("household_power_consumption.txt", 
    sep = ";",
    col.names = hpc_names,
    na.strings = "?",
    skip = 1)

  ### Filter on dates
  hpc <- hpc %>%
    filter(date == "2/1/2007" | date == "2/2/2007")

  ### Munge the date format
  hpc$date <- as.character(hpc$date)
  hpc$time <- as.character(hpc$time)
  hpc$date <- as.Date(hpc$date, "%m/%d/%Y")
  hpc$dt <- strptime(paste(hpc$date, hpc$time), "%Y-%m-%d %H:%M:%S")

  ### Send it outside the function
  hpc <<- hpc
}
prepare_data()


### Plot 4
png("plot4.png", 480, 480)
par(mfrow=c(2,2))

plot(hpc$dt, 
  hpc$global_active_power, 
  type="l",
  ylab="Global Active Power (kilowatts)",
  xlab="")

plot(hpc$dt, 
  hpc$voltage, 
  type="l",
  ylab="Voltage",
  xlab="datetime")

plot(hpc$dt, hpc$sub_metering_3, type="n", ylim=c(0, 40),
  ylab = "Energy sub metering", xlab = "")
lines(hpc$dt, hpc$sub_metering_1, type="l", col="black")
lines(hpc$dt, hpc$sub_metering_2, type="l", col="red")
lines(hpc$dt, hpc$sub_metering_3, type="l", col="blue")
box()

legend("topright", 
  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
  col=c("black", "red", "blue"),
  lty = c(1, 1))

plot(hpc$dt, 
  hpc$global_reactive_power, 
  type="l",
  ylab="Global Reactive Power",
  xlab="datetime")
dev.off()
