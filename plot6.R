setwd("/Users/bradychiu/Dropbox (Uber Technologies)/R/Coursera/04_ExploratoryDataAnalysis/CourseProject2")

library(dplyr)
library(ggplot2)
library(tidyr)

if(!dir.exists("input/")) dir.create("input/")
if(!file.exists("input/exdata-data-NEI_data.zip")) download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","input/exdata-data-NEI_data.zip")
if(!file.exists("input/Source_Classification_Code.rds") | !file.exists("input/summarySCC_PM25.rds")) unzip(zipfile="input/exdata-data-NEI_data.zip",exdir="input/")

NEI <- readRDS("input/summarySCC_PM25.rds")
SCC <- readRDS("input/Source_Classification_Code.rds")

ggplot(
  merge(
    NEI %>%
      filter(fips %in% c("06037","24510")) %>%
      mutate(
        year=factor(year)
        ,city_name=ifelse(fips=="06037","Los Angeles",
                   ifelse(fips=="24510","Baltimore",
                   "Error"))
        )
    ,SCC %>%
      filter(Data.Category=="Onroad")
    ,by="SCC"
    ) %>%
    group_by(city_name,year) %>%
    summarize(Emissions=sum(Emissions)) %>%
    spread(year,Emissions) %>%
    mutate(change=`2008`-`1999`)
  ,aes(x=city_name,y=change,fill=city_name)
  )+
  geom_bar(stat="identity")+
  ggtitle("Change in PM25 Emissions from 1999 to 2008")+
  geom_label(aes(label=round(change,2)))+
  scale_x_discrete(name="City")+
  scale_y_continuous(name="Change in PM25 Emissions")+
  theme(
    plot.title=element_text(face="bold",size=16)
    ,axis.title=element_text(face="bold",size=14)
    ,axis.text=element_text(size=12)
    ,legend.position="none"
    ,strip.text=element_text(size=12)
  )
ggsave("plot6.png")