library(tidyverse)
rm(list = ls())
library(readxl)
setwd("C:\\Users\\Yangli\\Desktop\\.....")
QC_test_NEG <- function(QC_file_NEG){
  library(tidyverse)
  rm(list = ls())
  library(readxl)
filesNEG = list.files("NEG/", pattern = "xlsx",full.names = TRUE,)  
dir = grep('\\.xlsx',filesNEG,value = TRUE)  
n = length(dir)
merge.data = read_excel(dir[1])
merge.data
merge.data$`Library Hit` <- merge.data$`Precursor Mass`
merge.data <- select(merge.data,-8)
colnames(merge.data)[6] = 'Formula'
filesNEG
for (i in 2:n){
  new.data = (read_excel(dir[i]))
  new.data$`Library Hit` <- new.data$`Precursor Mass`
  new.data <- select(new.data,-8)
  colnames(new.data)[6] = 'Formula'
  merge.data = rbind(merge.data,new.data)
}
colnames(merge.data)[7] = 'Precursor Mass'
write.csv(merge.data,"all_ions.csv")
all_ion <- read.csv("all_ions.csv")
#Firstly NEG
QC1.1 <- subset(all_ion,all_ion$Precursor.Mass > 300.5)
QC1.2 <- subset(QC1.1,QC1.1$Precursor.Mass < 302)
QC1.3 <- subset(QC1.2,QC1.2$Retention.Time > 20)
QC1.4 <- subset(QC1.3,QC1.3$Retention.Time < 21)

QC2.1 <- subset(all_ion,all_ion$Precursor.Mass > 990)
QC2.2 <- subset(QC2.1,QC2.1$Precursor.Mass < 992)
QC2.3 <- subset(QC2.2,QC2.2$Retention.Time > 20)
QC2.4 <- subset(QC2.3,QC2.3$Retention.Time < 21)

QC3.1 <- subset(all_ion,all_ion$Precursor.Mass > 1153)
QC3.2 <- subset(QC3.1,QC3.1$Precursor.Mass < 1153.9)
QC3.3 <- subset(QC3.2,QC3.2$Retention.Time > 25)
QC3.4 <- subset(QC3.3,QC3.3$Retention.Time < 26)
QC1.4$X <- "QC1"
QC2.4$X <- "QC2"
QC3.4$X <- "QC3"
final_data_NEG <- rbind(QC1.4,QC2.4,QC3.4)
write.csv(final_data_NEG,"QC of NEG.csv")
}
rm(list=ls())
QC_tes_POS <- function(QC_file_POS){
#POS
filesPOS = list.files("POS/", pattern = "xlsx",full.names = TRUE,)  
filesPOS
dir = grep('\\.xlsx',filesPOS,value = TRUE)  
n = length(dir)
merge.data = read_excel(dir[1])
merge.data
merge.data$`Library Hit` <- merge.data$`Precursor Mass`
merge.data <- select(merge.data,-8)
colnames(merge.data)[6] = 'Formula'
filesPOS
for (i in 2:n){
  new.data = (read_excel(dir[i]))
  new.data$`Library Hit` <- new.data$`Precursor Mass`
  new.data <- select(new.data,-8)
  colnames(new.data)[6] = 'Formula'
  merge.data = rbind(merge.data,new.data)
}
colnames(merge.data)[7] = 'Precursor Mass'
write.csv(merge.data,"all_ions_POS.csv")
all_ion <- read.csv("all_ions_POS.csv")

QC1.1 <- subset(all_ion,all_ion$Precursor.Mass > 302.5)
QC1.2 <- subset(QC1.1,QC1.1$Precursor.Mass < 304)
QC1.3 <- subset(QC1.2,QC1.2$Retention.Time > 20)
QC1.4 <- subset(QC1.3,QC1.3$Retention.Time < 21)
QC1.4$X <- "QC1"
QC1.4
QC2.1 <- subset(all_ion,all_ion$Precursor.Mass > 948.4)
QC2.2 <- subset(QC2.1,QC2.1$Precursor.Mass < 948.56)
QC2.3 <- subset(QC2.2,QC2.2$Retention.Time > 20)
QC2.4 <- subset(QC2.3,QC2.3$Retention.Time < 21)
QC2.4$X <- "QC2"
QC2.4
QC3.1 <- subset(all_ion,all_ion$Precursor.Mass > 1110.5)
QC3.2 <- subset(QC3.1,QC3.1$Precursor.Mass < 1110.7)
QC3.3 <- subset(QC3.2,QC3.2$Retention.Time > 25)
QC3.4 <- subset(QC3.3,QC3.3$Retention.Time < 25.8)
QC3.4$X <- "QC3"
QC3.4
QC4.1 <- subset(all_ion,all_ion$Precursor.Mass > 299.0)
QC4.2 <- subset(QC4.1,QC4.1$Precursor.Mass < 299.2)
QC4.3 <- subset(QC4.2,QC4.2$Retention.Time > 33)
QC4.4 <- subset(QC4.3,QC4.3$Retention.Time < 34)
QC4.4$X <- "QC4"
QC4.4
QC5.1 <- subset(all_ion,all_ion$Precursor.Mass > 256.0)
QC5.2 <- subset(QC5.1,QC5.1$Precursor.Mass < 256.4)
QC5.3 <- subset(QC5.2,QC5.2$Retention.Time > 43.5)
QC5.4 <- subset(QC5.3,QC5.3$Retention.Time < 44.5)
QC5.4$X <- "QC5"
QC5.4
final_data_POS <- rbind(QC1.4,QC2.4,QC3.4,QC4.4,QC5.4)
write.csv(final_data_POS,"QC of POS.csv")
}
