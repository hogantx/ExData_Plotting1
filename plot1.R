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



### Plot 1
png("plot1.png", 480, 480)
hist(hpc$global_active_power, 
  main="Global Active Power", 
  xlab="Global Active Power (kilowatts)", 
  ylab="Frequency", 
  col="red",
  xlim=c(0, 6),   
  breaks=12,
  axes = FALSE)
axis(side=1, at = c(0, 2, 4, 6))
axis(side=2, at = c(0, 200, 400, 600, 800, 1000, 1200))


dev.off()


