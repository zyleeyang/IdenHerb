#' Title
#'
#' @param need_match_data
#' @param character_ion
#'
#' @return
#' @export
#'
#' @examples
match_rate <- function(need_match_data,character_ion){
  filesNEG = list.files(need_match_data, pattern = "csv",full.names = TRUE,) 
  filesNEG
  dir = grep('\\.csv',filesNEG,value = TRUE)
  n = length(dir)
  n
  merge.data = read.csv(dir[1])
  setwd(need_match_data)
  dir.create("./result")
  write.csv(merge.data, file = "./result/raw_need_match_data.csv")
  head(merge.data)
  all_ion <- read.csv("./result/raw_need_match_data.csv")
  head(all_ion)
  all_ion <- select(all_ion,-X) 
  head(all_ion)

  all_ion$Area[all_ion$Area == 'N/A'] <- 0 
  all_ion$Retention.Time[all_ion$Retention.Time == 'N/A'] <- 0
  head(all_ion)
  all_ion[,3:4] <- lapply(all_ion[,3:4],as.numeric)
  all_ion <- subset(all_ion,Area >= 10000)
  #  colnames(merge.data) 
  all_ion <- all_ion %>%
    select(Sample.Name,Area,Retention.Time,Precursor.Mass,Retention.Time,Precursor.Mass) %>%

  all_ion
  getwd()

  all_ion <- all_ion %>%
    group_by(mz_time) %>%
    mutate(n=n()) %>%
    filter(n==1)%>%
    select(-n)
  write.csv(all_ion,file = './result/processed_need_match_data.csv')
  setwd("..")
  all_ion_yc = read.csv('herb_charcter_ion.csv')
  head(all_ion_yc)
  all_ion_yc$Area[all_ion_yc$Area == 'N/A'] <- 0   #将N/A值变成0
  all_ion_yc$Retention.Time[all_ion_yc$Retention.Time == 'N/A'] <- 0
  all_ion_yc[,3:4] <- lapply(all_ion_yc[,3:4],as.numeric)
  all_ion_yc <- subset(all_ion_yc,Area >= 10000)
  #  colnames(merge.data)  

  all_ion_yc <- all_ion_yc %>%
    select(Sample.Name,Area,mz,time,Retention.Time,Precursor.Mass)%>%
    mutate(mz_time = paste(mz,time,sep = "_"))  
  head(all_ion_yc)
  processed_1 <- all_ion_yc %>%
    group_by(mz_time) %>%
    mutate(n=n()) %>%
    filter(n==1)%>%
    select(-n)
  write.csv(processed_1,file = './all_charcter_ion.csv')
  processed_1 <- read.csv('./all_charcter_ion.csv')


  processed_2 <- split(processed_1,processed_1$Sample.Name)
  processed_3 <- select(processed_2[[1]],-X)
  processed_3 <- rbind(processed_3,all_ion)

  duplicate_name = processed_3 %>%
    group_by(mz_time)%>%
    summarise(freq = n()) %>%
    filter(freq > 1) %>%
    select(mz_time)
  duplicate_name
  duplicate_ion <- processed_3[processed_3$mz_time %in% duplicate_name$mz_time,]
  duplicate_ion
  out_fileName <- sapply(names(processed_2),function(x){
    paste(x,".csv",sep="")
  })
  length(processed_2)
  out_fileName  #for循环记得1:length()
  setwd(need_match_data)
  dir.create("./the result of matching individually")
  setwd('./the result of matching individually')

  for (i in 1:length(processed_2)) {
    processed_3 <- select(processed_2[[i]],-X)
    processed_3 <- rbind(processed_3,all_ion)
    duplicate_name = processed_3 %>%
      group_by(mz_time)%>%
      summarise(freq = n()) %>%
      filter(freq > 1) %>%
      select(mz_time)
    duplicate_name
    duplicate_ion <- processed_3[processed_3$mz_time %in% duplicate_name$mz_time,]
    write.csv(duplicate_ion,file = out_fileName[i],row.names = F)
  }
  filesNEG2 = list.files("./", pattern = "csv",full.names = TRUE,)  
  filesNEG2
  dir2 = grep('\\.csv',filesNEG2,value = TRUE)
  n = length(dir2)
  merge.data2 = read.csv(dir2[1])
  Sample.Name2 = unique(merge.data2[,1])
  Ion_Count_match = (nrow(merge.data2))/2
  Sample.Name2 = Sample.Name2[1]
  Matching_rate <- data.frame(Sample.Name2,Ion_Count_match)
  for (i in 2:n){
    merge.data2 = read.csv(dir2[i])
    Sample.Name2 = unique(merge.data2[,1])
    Sample.Name2 = Sample.Name2[1]
    Ion_Count_match = (nrow(merge.data2))/2
    Matching_rate2 = data.frame(Sample.Name2,Ion_Count_match)
    Matching_rate = rbind(Matching_rate,Matching_rate2)
  }
  Matching_rate4 <- Matching_rate %>%
    select(Sample.Name2,Ion_Count_match)%>%
    mutate(matching = Ion_Count_match / 100)
  setwd("..")
  write_excel_csv(Matching_rate4,"./result/sum_mathing_result.csv")
  setwd("..")
}

