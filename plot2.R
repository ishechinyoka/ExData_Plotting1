# Which libraries do we need?

library(readr)
library(dplyr)

# Let's do the housekeeping first. Memory is expensive, so let's just read what's necessary and store it in a file we will be working with:
# And we only need two days here. Never mind about the date format:

output <- "twodays.txt"

if(!file.exists(output)) {
  input <- "household_power_consumption.txt"
  column_names <- "Date;Time;Global_active_power;Global_reactive_power;Voltage;Global_intensity;Sub_metering_1;Sub_metering_2;Sub_metering_3\n"
  cat(column_names, file = output)

  raw_data  <- readLines(input, n = -1)

  result <- lapply(raw_data, function(x) {
    if ((substr(x,1, 8) == "1/2/2007") || (substr(x, 1, 8) == "2/2/2007")) {
      cat(x, file = output, sep = "\n", append = TRUE)
    }
  })
}

# Now let's work with the clean file, start by loading it:

hhp_data <- read_delim(file = output, delim = ";", na = "?")

##  We transform the data to the shape we like before plotting:
# Let's create an extra variable date_time in the process:

hhp_data <- hhp_data %>% mutate(Global_active_power = as.numeric(Global_active_power), date_time = as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S"))


# Make the plot: plot 2 for the assignment:

png("plot2.png", width=480, height=480)
plot(x = hhp_data$date_time, y = hhp_data$Global_active_power, type="l", xlab="Time", ylab="Global Active Power (kilowatts)")
dev.off()