#處理海表鹽度(SSS)資料
#下載自HYCOM衛星系統，資料以每日為單位，依據不同月份合併在1-2個檔案中，後續會依據不同年份進行資料整理。
#來源: https://www.hycom.org/dataserver/gofs-3pt0/analysis
#以下以4月份為例，###!!記號代表需依據不同月份更改code

library(ncdf4)
library(raster)
filename_SSS_a = paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\nc\\2014_0101_0404.nc",sep="")  ###!!
filename_SSS_b = paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\nc\\2014_0405_1231.nc",sep="")  ###!!

###讀取nc檔資料-----
data_a = brick(filename_SSS_a) #brick to get time series of data
data_nc_a = nc_open(filename_SSS_a)
data_b = brick(filename_SSS_b) #brick to get time series of data
data_nc_b = nc_open(filename_SSS_b)

###設定經緯度範圍、網格化-----
raw_Latitude = ncvar_get(data_nc_a, "Latitude")
raw_Longitude = ncvar_get(data_nc_a, "Longitude")
extent(data_a)=c(min(raw_Longitude[,1]),max(raw_Longitude[,1]),min(raw_Latitude[1,]),max(raw_Latitude[1,]))
extent(data_b)=c(min(raw_Longitude[,1]),max(raw_Longitude[,1]),min(raw_Latitude[1,]),max(raw_Latitude[1,]))
e = extent(119.1, 134.5, 20.1, 26.9) 
e = raster(e,nrows=1,ncols=1)
res(e) = 0.2  #0.2度網格
values(e) = 0

###資料整理-----
##2014年4月的鹽度資料紀錄在兩個nc檔中(以A和B表示)
tableA=NULL
for (i in 91:94){  ###!!!! 
  agg_SSS = resample(data_a[[i]],e,methode="bilinear") ###!!!!
  co_SSS = as.matrix(coordinates(agg_SSS))
  df_SSS = cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS) = c("Lon","Lat","SSS")
  tableA = rbind(df_SSS,tableA)
}
tableB=NULL
for (j in 1:26){  ###!!!!
  agg_SSS = resample(data_b[[j]],e,methode="bilinear") ###!!!!
  co_SSS = as.matrix(coordinates(agg_SSS))
  df_SSS = cbind(Lon=co_SSS[,1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS) = c("Lon","Lat","SSS")
  tableB = rbind(df_SSS,tableB)
}
tableC = rbind(tableA,tableB)
tableD = NULL
fin_data = aggregate(SSS~Lon+Lat,tableC,FUN=mean,na.action = na.pass)
tableD = cbind(rep(4,nrow(fin_data)),fin_data)    ###!!!!!
colnames(tableD) = c("month","Lon","Lat","SSS")

##2014年除了4月外，其他月份都記錄在同一個nc檔中
#2014/1
table1=NULL
for (i in 1:31){  ###!!!!
  agg_SSS=resample(data_a[[i]],e,methode="bilinear") ###!!!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table1=rbind(df_SSS,table1)
}
fin_data=aggregate(SSS~Lon+Lat,table1,FUN=mean,na.action = na.pass)
table1=cbind(rep(1,nrow(fin_data)),fin_data) ###!!
colnames(table1)=c("month","Lon","Lat","SSS")

#2014/2
table2=NULL
for (i in 32:59){  ###!!
  agg_SSS=resample(data_a[[i]],e,methode="bilinear") ###!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table2=rbind(df_SSS,table2)
}
fin_data=aggregate(SSS~Lon+Lat,table2,FUN=mean,na.action = na.pass)
table2=cbind(rep(2,nrow(fin_data)),fin_data) ###!!
colnames(table2)=c("month","Lon","Lat","SSS")

#2014/3
table3=NULL
for (i in 60:90){ ###!!
  agg_SSS=resample(data_a[[i]],e,methode="bilinear") ###!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table3=rbind(df_SSS,table3)
}
fin_data=aggregate(SSS~Lon+Lat,table3,FUN=mean,na.action = na.pass)
table3=cbind(rep(3,nrow(fin_data)),fin_data) ###!!
colnames(table3)=c("month","Lon","Lat","SSS")

#2014/5
table5=NULL
for (i in 27:57){  ###!!
  agg_SSS=resample(data_b[[i]],e,methode="bilinear") ###!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table5=rbind(df_SSS,table5)
}
fin_data=aggregate(SSS~Lon+Lat,table5,FUN=mean,na.action = na.pass)
table5=cbind(rep(5,nrow(fin_data)),fin_data) 
colnames(table5)=c("month","Lon","Lat","SSS")

#2014/6
table6=NULL
for (i in 58:87){  ###!!
  agg_SSS=resample(data_b[[i]],e,methode="bilinear") ###!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table6=rbind(df_SSS,table6)
}
fin_data=aggregate(SSS~Lon+Lat,table6,FUN=mean,na.action = na.pass)
table6=cbind(rep(6,nrow(fin_data)),fin_data) 
colnames(table6)=c("month","Lon","Lat","SSS")

#2014/7
table7=NULL
for (i in 88:118){ ###!!
  agg_SSS=resample(data_b[[i]],e,methode="bilinear") ###!! 
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[,1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table7=rbind(df_SSS,table7)
}
fin_data=aggregate(SSS~Lon+Lat,table7,FUN=mean,na.action = na.pass)
table7=cbind(rep(7,nrow(fin_data)),fin_data) ###!!
colnames(table7)=c("month","Lon","Lat","SSS")

#2014/8
table8=NULL
for (i in 119:149){ ###!!
  agg_SSS=resample(data_b[[i]],e,methode="bilinear") ###!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table8=rbind(df_SSS,table8)
}
fin_data=aggregate(SSS~Lon+Lat,table8,FUN=mean,na.action = na.pass)
table8=cbind(rep(8,nrow(fin_data)),fin_data) ###!!
colnames(table8)=c("month","Lon","Lat","SSS")

#2014/9
table9=NULL
for (i in 150:179){ ###!!
  agg_SSS=resample(data_b[[i]],e,methode="bilinear") ###!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table9=rbind(df_SSS,table9)
}
fin_data=aggregate(SSS~Lon+Lat,table9,FUN=mean,na.action = na.pass)
table9=cbind(rep(9,nrow(fin_data)),fin_data) ###!!
colnames(table9)=c("month","Lon","Lat","SSS")

#2014/10
table10=NULL
for (i in 180:210){ ###!!
  agg_SSS=resample(data_b[[i]],e,methode="bilinear") ###!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table10=rbind(df_SSS,table10)
}
fin_data=aggregate(SSS~Lon+Lat,table10,FUN=mean,na.action = na.pass)
table10=cbind(rep(10,nrow(fin_data)),fin_data) ###!!
colnames(table10)=c("month","Lon","Lat","SSS")

#2014/11
table11=NULL
for (i in 211:240){  ###!!
  agg_SSS=resample(data_b[[i]],e,methode="bilinear") ###!! 
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table11=rbind(df_SSS,table11)
}
fin_data=aggregate(SSS~Lon+Lat,table11,FUN=mean,na.action = na.pass)
table11=cbind(rep(11,nrow(fin_data)),fin_data) ###!!
colnames(table11)=c("month","Lon","Lat","SSS")

#2014/12
table12=NULL
for (i in 241:271){  ###!!
  agg_SSS=resample(data_b[[i]],e,methode="bilinear") ###!!
  co_SSS <- as.matrix(coordinates(agg_SSS))
  df_SSS <- cbind(Lon=co_SSS[, 1], Lat=co_SSS[,2],SSS=as.data.frame(agg_SSS))
  colnames(df_SSS)=c("Lon","Lat","SSS")
  table12=rbind(df_SSS,table12)
}
fin_data=aggregate(SSS~Lon+Lat,table12,FUN=mean,na.action = na.pass)
table12=cbind(rep(12,nrow(fin_data)),fin_data) ###!!
colnames(table12)=c("month","Lon","Lat","SSS")

###結合所有table、輸出-----
table_2014=rbind(table1,table2,table3,tableD,table5,table6,table7,table8,table9,table10,table11,table12) ###!!
table_2014=cbind(rep(2014,nrow(table_2014)),table_2014) ###!!
colnames(table_2014)=c("year","month","lon","lat","SSS")
#輸出2014年12個月份的海表鹽度資料
write.csv(table_2014,file=paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\pro_data\\SSS_2014.csv",sep=""),row.names=FALSE) ###!!


