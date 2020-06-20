## Wich libraries to use?
library(dplyr)

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

summary_pm25 <- summary_pm25 %>% mutate(Emissions = as.numeric(Emissions))

total_pm25 <- summary_pm25 %>% group_by(year) %>% count(Emissions)

png("plot1.png")
barplot(total_pm25$Emissions, names = total_pm25$year, xlab = "Years", ylab = "Emissions", main = "Emissions by Year")
dev.off()