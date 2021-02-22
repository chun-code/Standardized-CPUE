#處理環境資料
#本分析需下載2009-2018年，每年每月的海表溫度(SST),海表鹽度(SSS),葉綠素a濃度(chla)資料。
#SST和chla下載自noaa的MODIS-Aqua衛星系統，由於網站僅提供每日資料，需利用網頁爬蟲下載大筆資料，接著作數據整理。
#資料來源https://oceandata.sci.gsfc.nasa.gov/MODIS-Aqua/L3SMI/
#SSS資料另外呈現在"海表鹽度(SSS)"資料夾中。

####(1)從網站下載SST和chla資料----------
#檔案路徑的規則請參考"Download data from MODIS.docx"檔案
#下載的原始檔案為nc檔
##v1: 2009-2018 (except 2012, 2016)
year_v1 = c(2009,2010,2011,2013,2014,2015,2017,2018)
for (i in year_v1) {
  for(j in 1:12) {
    month_code_v1 = c("001","032","060","091","121","152","182","213","244","274","305","335")
    file_code_v1 = c("031","059","090","120","151","181","212","243","273","304","334","365")
    file_month_Nam = c(1:12)
    
    #SST
    urls_SST = paste("https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/A",i,month_code_v1[j],i,file_code_v1[j],".L3m_MO_SST_sst_9km.nc",sep="") 
    filename_SST = paste("F:/test/nc/SST/",i,"_",file_month_Nam[j],".nc",sep="")
    download.file(urls_SST,filename_SST,mod="wb")
    
    #chl-a
    urls_chla = paste("https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/A",i,month_code_v1[j],i,file_code_v1[j],".L3m_MO_CHL_chlor_a_9km.nc",sep="") 
    filename_chla = paste("F:/test/nc/chla/",i,"_",file_month_Nam[j],".nc",sep="")
    download.file(urls_chla,filename_chla,mod="wb")
  }
}
##v2: 2012,2016 
year_v2 = c(2012,2016)
for (i in year_v2) {
  for(j in 1:12) {
    month_code_v2 = c("001","032","061","092","122","153","183","214","245","275","306","336")
    file_code_v2 = c("031","060","091","121","152","182","213","244","274","305","335","366")
    file_month_Nam = c(1:12)
    
    #SST
    urls_SST = paste("https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/A",i,month_code_v2[j],i,file_code_v2[j],".L3m_MO_SST_sst_9km.nc",sep="") 
    filename_SST = paste("F:/test/nc/SST/",i,"_",file_month_Nam[j],".nc",sep="")
    download.file(urls_SST,filename_SST,mod="wb")
    #chl-a
    urls_chla = paste("https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/A",i,month_code_v2[j],i,file_code_v2[j],".L3m_MO_CHL_chlor_a_9km.nc",sep="") 
    filename_chla = paste("F:/test/nc/chla/",i,"_",file_month_Nam[j],".nc",sep="")
    download.file(urls_chla,filename_chla,mod="wb")
  }
}

##(2)讀取、整理溫度和葉綠素資料----------
library(raster)
library(ncdf4)
for (i in 2009:2018) {
  year = as.character(2009:2018)
  year_data = NULL
  month_data = NULL
  
  for(j in 1:12){
    month = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
    ##read NetCDF file
    filename_SST = paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\nc\\SST\\",i,"_",j,".nc",sep="")
    filename_chla = paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\nc\\chla\\",i,"_",j,".nc",sep="")
    data_SST = raster(filename_SST) #res(data_SST)
    data_chla = raster(filename_chla) #res(data_chla)
    
    ##set up an initial "sampling raster"
    e = extent(119.1, 134.5, 20.1, 26.9) 
    e = raster(e,nrows=1,ncols=1,crs=data_SST@crs)
    res(e) = 0.2  #set resolution which we want
    values(e) = 0
    ##resample raw rasterdata in initial data
    agg_SST = resample(data_SST,e,methode="bilinear")
    agg_chla = resample(data_chla,e,methode="bilinear")
    
    ##combine lat,lon and variable 
    #SST
    co_SST = as.matrix(coordinates(agg_SST))
    df_SST = data.frame(Lon=co_SST[,1], Lat=co_SST[,2], SST=as.data.frame(agg_SST))
    colnames(df_SST) = c("Lon","Lat","SST")
    #chla
    co_chla = as.matrix(coordinates(agg_chla))
    df_chla = data.frame(Lon=co_chla[,1], Lat=co_chla[,2], chla=as.data.frame(agg_chla))
    colnames(df_chla) = c("Lon","Lat","chla")
    
    ##combine month data(SST&chla)
    tem_month_data = cbind(rep(j,length(df_SST$Lat)),df_SST$Lat,df_SST$Lon,df_SST$SST,df_chla$chla)
    month_data = rbind(month_data, tem_month_data)
  }
  tem_year_data = cbind(rep(i, nrow(month_data)),month_data)
  year_data = rbind(year_data,tem_year_data)
  colnames(year_data) = c("year","month","lat","lon","SST","chla")
  write.csv(year_data,file=paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\SST&chla_",i,".csv",sep=""),row.names=FALSE)
}
####(3)結合不同來源環境資料----------
#鹽度資料下載自HYCOM: "https://www.hycom.org/dataserver/gofs-3pt0/analysis"
#鹽度資料下載方式請參考"海表鹽度(SSS)"資料夾
for(i in 2009:2018) {
  filename_SST = paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\pro_data\\SST&chla_",i,".csv",sep="")
  filename_SSS = paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\pro_data\\SSS_",i,".csv",sep="")
  SST = read.csv(filename_SST)
  SSS = read.csv(filename_SSS)
  DATA = merge(x=SST,y=SSS,by=c("year","month","lat","lon"),all=TRUE)
  write.csv(DATA,file=paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\SST&chla&SSS_",i,".csv",sep=""),row.names=FALSE)
}

#結合2009-2018資料
table = NULL
for (y in  2009:2018) {
filename=paste("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\SST&chla&SSS_",y,".csv",sep="")
fin_data=read.csv(filename)
table=rbind(table,fin_data)
}
write.csv(table,file="C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\env_data\\SST&chla&SSS.csv",row.names=TRUE)

  
