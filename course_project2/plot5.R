## Wich libraries to use?
library(dplyr)
library(ggplot2)

# Do we have data files for this course project??
# Let's check and get them first:

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zip_file <- "exdata_data_NEI_data.zip"
scc_file <- "Source_Classification_Code.rds"
pm25_file <- "summarySCC_PM25.rds"

if(!file.exists(zip_file)) {
  download.file(url = url, destfile = zip_file)
} else {
  # Is the zip file extracted?
  # If not, let's do that next:
  if((!file.exists(scc_file)) || (!file.exists(pm25_file)))
    unzip(zipfile = zipfile)
}

#Read in files into data frames:
SCC <- readRDS(scc_file)
summary_pm25 <- readRDS(pm25_file)

# Get only vehicle emissions for Baltimore City, MD, during this time:
vehicles <- SCC %>% filter(grepl("vehicle", SCC.Level.Two, ignore.case = TRUE))
baltimore_vehicles_emission <- summary_pm25 %>% filter(fips=="24510", SCC %in% vehicles)

# Let's plot and save the answer:
ggplot(baltimore_vehicles_emission, aes(factor(year), Emissions)) +
  geom_bar(stat="identity", fill ="#FF9999" ,width=0.75) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

ggsave("plot5.png")