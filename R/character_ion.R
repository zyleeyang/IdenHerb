#' Title
#'
#' @param processed_rawdata
#' @param rank_number
#'
#' @return
#' @export
#'
#' @examples
character_ion <- function(processed_rawdata,rank_number = 100){
  filesNEG_pro = list.files(processed_rawdata, pattern = "csv",full.names = TRUE,)  #把所有的文件都进行读取
  dir = grep('\\.csv',filesNEG_pro,value = TRUE)
  n = length(dir)
  merge.data = read.csv(dir[1])
  merge.data <- arrange(merge.data,-merge.data$Area)
  merge.data <- merge.data[1:rank_number,]
  for (i in 2:n){
    new.data = read.csv(dir[i])
    new.data <- arrange(new.data,-new.data$Area)
    new.data <- new.data[1:rank_number,]
    merge.data = rbind(merge.data,new.data)
  }
  write.csv(merge.data,file = './herb_charcter_ion.csv',row.names = FALSE)
}
