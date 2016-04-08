setwd("/Users/bradychiu/Dropbox (Uber Technologies)/R/Coursera/04_ExploratoryDataAnalysis/CourseProject2")

library(dplyr)

if(!dir.exists("input/")) dir.create("input/")
if(!file.exists("input/exdata-data-NEI_data.zip")) download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","input/exdata-data-NEI_data.zip")
if(!file.exists("input/Source_Classification_Code.rds") | !file.exists("input/summarySCC_PM25.rds")) unzip(zipfile="input/exdata-data-NEI_data.zip",exdir="input/")

NEI <- readRDS("input/summarySCC_PM25.rds")
SCC <- readRDS("input/Source_Classification_Code.rds")

plot_data<-NEI %>%
  filter(year %in% c(1999,2002,2005,2008)) %>%
  group_by(year) %>%
  summarize(Emissions=sum(Emissions))

png("plot1.png")
barplot(
  height=plot_data$Emissions
  ,names.arg=plot_data$year
  ,main="US PM25 Emissions"
  ,xlab="Years"
  ,ylab="PM25 Emissions"
)
dev.off()