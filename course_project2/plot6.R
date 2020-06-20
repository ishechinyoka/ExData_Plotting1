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
vehicles <- SCC %>% filter(grepl("vehicle", SCC.Level.Two, ignore.case = TRUE))
vehicles_emission <- summary_pm25 %>% filter(SCC %in% vehicles)

# We filter by city, and add a new column to each dataframe:
baltimore_md <- vehicles_emission %>% filter(fips == "24510") %>% 
mutate(city = "Baltimore City")

los_angeles_ca <- vehicles_emission %>% filter(fips == "06037") %>%mutate(city = "Los Angeles")

# And we combine into a single tibble for plotting purposes:
two_cities <- rbind(baltimore_md, los_angeles_ca)

# Then plot and save to file:
ggplot(two_cities, aes(x = factor(year), y = Emissions, fill = city)) +
   geom_bar(aes(fill=year),stat="identity") +
   facet_grid(scales="free", space="free", .~city) +
   labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
   labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in # Baltimore & LA, 1999-2008"))

ggsave("plot6.png")