setwd("/Users/bradychiu/Dropbox (Uber Technologies)/R/Coursera/04_ExploratoryDataAnalysis/CourseProject2")

library(dplyr)
library(ggplot2)

if(!dir.exists("input/")) dir.create("input/")
if(!file.exists("input/exdata-data-NEI_data.zip")) download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","input/exdata-data-NEI_data.zip")
if(!file.exists("input/Source_Classification_Code.rds") | !file.exists("input/summarySCC_PM25.rds")) unzip(zipfile="input/exdata-data-NEI_data.zip",exdir="input/")

NEI <- readRDS("input/summarySCC_PM25.rds")
SCC <- readRDS("input/Source_Classification_Code.rds")

ggplot(
  merge(
    NEI %>%
      filter(fips==24510) %>%
      mutate(year=factor(year))
    ,SCC %>%
      filter(Data.Category=="Onroad")
    ,by="SCC"
  ) %>%
    group_by(year) %>%
    summarize(Emissions=sum(Emissions))
  ,aes(x=year,y=Emissions,fill=year)
  )+
  geom_bar(stat="identity")+
  ggtitle("PM25 Emissions from Motor Vehicle Sources (Baltimore, MD)")+
  scale_x_discrete(name="Year")+
  theme(
    plot.title=element_text(face="bold",size=16)
    ,axis.title=element_text(face="bold",size=14)
    ,axis.text=element_text(size=12)
    ,legend.position="none"
    ,legend.text=element_text(size=10)
    ,strip.text=element_text(size=12)
  )
ggsave("plot5.png")