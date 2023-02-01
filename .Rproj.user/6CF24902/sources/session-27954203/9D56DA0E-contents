#' Process the raw data, deleting the useless data.
#'
#' @param rawdata_dir ,the dir of raw data.
#'
#' @return : the processed data.
#' @export
#'
#' @examples
#' library(IdenHerb)
#' Pre_processdata(rawdata_dir = example)
filter_data <- function(unfilter_data,threshold = 10000){
  if(!"tidyverse" %in% installed.packages()) install("tidyverse")
  if(!"readxl" %in% installed.packages()) install("readxl")
  if(!"writexl" %in% installed.packages()) install("writexl")
  library(tidyverse)
  library(readxl)
  library(writexl)
  all_ion <- read.csv(unfilter_data)
  head(all_ion)
  all_ion$Area[all_ion$Area == 'N/A'] <- 0
  all_ion$Retention.Time[all_ion$Retention.Time == 'N/A'] <- 0
  all_ion <- all_ion[,-1]
  all_ion_Area_more_than1000 <- all_ion

  head(all_ion_Area_more_than1000) #查看前几行
  class(all_ion_Area_more_than1000) #查看数据类型

  sapply(all_ion_Area_more_than1000,typeof)  #查看每一列的数据类型,发现Area和time是字符型数据
  all_ion_Area_more_than1000[,3:4] <- lapply(all_ion_Area_more_than1000[,3:4],as.numeric) #把Area和time转化成数值型数据
  all_ion_Area_more_than1000 <- subset(all_ion_Area_more_than1000,Area >= threshold)
  sapply(all_ion_Area_more_than1000,typeof)  #再次查看每一列的数据类型
  processed <- all_ion_Area_more_than1000 %>%
    select(Sample.Name,Area,Retention.Time,Precursor.Mass,Retention.Time,Precursor.Mass) %>%
    mutate(mz = round(Precursor.Mass * 0.5,2),time = round(Retention.Time * 1.5),0)  #对保留时间和母离子进行处理
  processed_2 <- processed%>%
    select(Sample.Name,Area,mz,time,Retention.Time,Precursor.Mass)%>%
    mutate(mz_time = paste(mz,time,sep = "_"))  #生成新的列
  processed_3 <- processed_2 %>%
    group_by(mz_time) %>%
    mutate(n=n()) %>%
    filter(n==1)%>%
    select(-n)
  #这边是查看有没有重复的情况
  head(processed_3)
  processed_3%>%
    group_by(mz_time)%>%
    summarise(n=n())
  processed_4 <- split(processed_3,processed_3$Sample.Name)
  dir.create('./processed_rawdata')
  setwd('./processed_rawdata')
  out_fileName <- sapply(names(processed_4),function(x){
    paste(x,".csv",sep="")
  })
  for(i in 1:length(processed_4)){
    write.csv(processed_4[[i]],file=out_fileName[i],row.names = F)
  }
  processed_4
}
