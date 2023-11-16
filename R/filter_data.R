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

  head(all_ion_Area_more_than1000) 
  class(all_ion_Area_more_than1000) 

  sapply(all_ion_Area_more_than1000,typeof) 
  all_ion_Area_more_than1000[,3:4] <- lapply(all_ion_Area_more_than1000[,3:4],as.numeric) 
  all_ion_Area_more_than1000 <- subset(all_ion_Area_more_than1000,Area >= threshold)
  sapply(all_ion_Area_more_than1000,typeof) 
    select(Sample.Name,Area,Retention.Time,Precursor.Mass,Retention.Time,Precursor.Mass) %>%
  ######
  processed_2 <- processed%>%
    select(Sample.Name,Area,mz,time,Retention.Time,Precursor.Mass)%>%
    mutate(mz_time = paste(mz,time,sep = "_")) 


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
