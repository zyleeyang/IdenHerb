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
Pre_processdata <- function(rawdata_dir){
  if(!"tidyverse" %in% installed.packages()) install("tidyverse")
  if(!"readxl" %in% installed.packages()) install("readxl")
  if(!"writexl" %in% installed.packages()) install("writexl")
  library(tidyverse)
  library(readxl)
  library(writexl)
  filesNEG = list.files(rawdata_dir, pattern = "xlsx",full.names = TRUE,)  
  filesNEG
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
  write.csv(merge.data,"processed_rawdata.csv")
}
