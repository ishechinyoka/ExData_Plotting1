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


# Get Baltimore City, MD, records:
baltimore_city <- summary_pm25 %>% filter(fips == "24510")

# Doing a quick plot, and save:
qplot(factor(year), Emissions, data = baltimore_city)

ggsave("plot3.png")
