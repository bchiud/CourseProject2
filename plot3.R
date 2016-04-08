setwd("/Users/bradychiu/Dropbox (Uber Technologies)/R/Coursera/04_ExploratoryDataAnalysis/CourseProject2")

library(dplyr)
library(ggplot2)

if(!dir.exists("input/")) dir.create("input/")
if(!file.exists("input/exdata-data-NEI_data.zip")) download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","input/exdata-data-NEI_data.zip")
if(!file.exists("input/Source_Classification_Code.rds") | !file.exists("input/summarySCC_PM25.rds")) unzip(zipfile="input/exdata-data-NEI_data.zip",exdir="input/")

NEI <- readRDS("input/summarySCC_PM25.rds")
SCC <- readRDS("input/Source_Classification_Code.rds")

ggplot(
  NEI %>%
    filter(fips==24510) %>%
    group_by(type,year) %>%
    summarize(Emissions=sum(Emissions)) %>%
    mutate(year=factor(year))
  ,aes(x=year,y=Emissions,fill=type)
  )+
  geom_bar(stat="identity")+
  facet_grid(.~type)+
  ggtitle("PM25 Emissions by Type (Baltimore, MD)")+
  scale_fill_discrete(name="Type")+
  scale_x_discrete(name="Year")+
  theme(
    plot.title=element_text(face="bold",size=16)
    ,axis.title=element_text(face="bold",size=14)
    ,axis.text=element_text(size=12)
    ,legend.text=element_text(size=10)
    ,strip.text=element_text(size=12)
  )
ggsave("plot3.png")