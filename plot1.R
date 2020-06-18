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

hhp_data <- hhp_data %>% mutate(Global_active_power = as.numeric(Global_active_power))

# Now for our plot: 1st plot in this file:
png("plot1.png", width=480, height=480)
hist(hhp_data$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

dev.off()