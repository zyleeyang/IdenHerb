internal_standard <- function(all_data){
  library(tidyverse)
  library(readxl)
  library(writexl)
  filesNEG = list.files(all_data, pattern = "xlsx",full.names = TRUE,)  #把所有的文件都进行读取
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

  #write.csv(merge.data,file = './merge_weiquchong.csv',row.names = FALSE)
  all_ion <- data.frame(merge.data)
  #上述操作是将所有的离子写入merge_weiquchong文件
  head(all_ion)
  all_ion$Area[all_ion$Area == 'N/A'] <- 0   #将N/A值变成0
  all_ion$Retention.Time[all_ion$Retention.Time == 'N/A'] <- 0
  Lvmeisu <- all_ion%>%
    filter_all(any_vars(grepl('321.00',.)))
  lvmeisu2 <- subset(Lvmeisu,Lvmeisu$Precursor.Mass > 320)
  lvmeisu3 <- subset(lvmeisu2,lvmeisu2$Precursor.Mass < 322)
  write.csv(lvmeisu3,"internal_standard_result_.csv")

}
