rm(list = ls())
Re_build_character_ion <- function(Re_character_ion,repeat_times_set = 10){
  library(tidyverse)
  filesNEG_pro = list.files(Re_character_ion, pattern = "csv",full.names = TRUE,)  
  dir = grep('\\.csv',filesNEG_pro,value = TRUE)
  n = length(dir)
  merge.data = read.csv(dir[1])
######
######
######
  merge.data <- merge.data %>%
    group_by(mz_time) %>%
    mutate(n=n()) %>%
    filter(n==1)%>%
    select(-n)
######
  merge.data <- arrange(merge.data,-merge.data$Area)
  for (i in 2:n){
    new.data = read.csv(dir[i])
    new.data <- new.data %>%
      select(Sample.Name,Area,Retention.Time,Precursor.Mass,Retention.Time,Precursor.Mass) %>%
      mutate(mz = round(Precursor.Mass * 0.5,2),time = round(Retention.Time * 1.5),0) 
    new.data <- new.data%>%
      select(Sample.Name,Area,mz,time,Retention.Time,Precursor.Mass)%>%
      mutate(mz_time = paste(mz,time,sep = "_")) 
    new.data <- new.data %>%
      group_by(mz_time) %>%
      mutate(n=n()) %>%
      filter(n==1)%>%
      select(-n)
    new.data <- subset(new.data,Area >= 10000)
    new.data <- arrange(new.data,-new.data$Area)
    merge.data = rbind(merge.data,new.data)
  }
  repeattimes <- count(merge.data,mz_time)%>%
    filter(n>1)
  merge.data <- merge.data[!duplicated(merge.data$mz_time),]
  character_ion <- merge(merge.data,repeattimes,by = 'mz_time')
  colnames(character_ion)[8] <- "repeat_times"
  character_ion <- subset(character_ion,repeat_times >= repeat_times_set)
  character_ion <- arrange(character_ion,-character_ion$Area)
  setwd(Re_character_ion)
  write.csv(character_ion,file = './rebuild_character_Ion.csv',row.names = FALSE)
}
#example
#Re_build_character_ion(Re_character_ion = 'data_for_rebuild_character_ion/',repeat_times_set = 10)
#the value of repeat_times_set is the count of your data

