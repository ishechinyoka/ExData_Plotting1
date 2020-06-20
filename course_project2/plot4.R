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

#Filter conditions: coal combustion 
coal_combustion <- filter(SCC, grepl("comb", SCC.Level.One, ignore.case=TRUE), grepl("coal", SCC.Level.Four, ignore.case=TRUE))
combustion_emission <- summary_pm25 %>% filter(SCC %in% coal_combustion)

# Let's plot now:

ggplot(combustion_emission, aes(x = factor(year), y = Emissions/10^5)) +
  geom_bar(stat="identity", fill ="#FF9999", width=0.75) +
  labs(x="year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

ggsave("plot4.png")
