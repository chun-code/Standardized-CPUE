#目的：使用捕獲量資料透過general linear model(GLM)和generalized additive model(GAM)模型推估目標漁獲的catch per unit effort(CPUE) 
#原始資料:"漁業資料"和"環境資料"
#使用模型:GLM,GAM

#漁業資料----
#經緯度：網格化
#船測水溫：處理缺失值
#捕獲量資料：根據時間、地點整合
#漁場：根據經緯度劃分漁場

#環境資料----
#爬蟲下載每年/月資料
#niza下載的環境資料
#資料網格化
#相關性分析

#漁業資料處理------------------------
fdata=read.csv(choose.files(),header=TRUE)
head(fdata)
summary(fdata)

###(1)網格化經緯度資料-----------------
##刪除遺漏值
test=fdata[!(is.na(fdata$Lat))&!(is.na(fdata$Lon)),]
sum(is.na(test$Lat)); sum(is.na(test$Lon));

##刪除異常值
plot(test$Lon,test$Lat,xlim=c(110,150),ylim=c(10,50))
boxplot(test$Lat)
boxplot(test$Lon)

test=test[test$Lat>=10&test$Lat<=50,]
test=test[test$Lon>=110&test$Lon<=150,]
range(test$Lon); range(test$Lat);

##網格化經緯度
lat_vec = seq(20.1,26.9,0.2)
lon_vec = seq(119.1,134.5,0.2)
mid_lat = seq(20.2,26.8,0.2)
mid_lon = seq(119.2,134.4,0.2)

Table=NULL
for(m in 1:(length(lat_vec)-1)){
  for(n in 1:(length(lon_vec)-1) ){
    temp_data = test[test$Lat>=lat_vec[m] & test$Lat<lat_vec[m+1] & test$Lon>=lon_vec[n] & test$Lon<lon_vec[n+1],] #依據找出經緯度在的類別 
    interval=cbind(temp_data,rep(mid_lat[m],nrow(temp_data)),rep(mid_lon[n],nrow(temp_data))) #將搜尋出的資料給與相應的組別
    Table=rbind(Table,interval) #放入table中
  }
}
names(Table)[24]=c("tran_Lat")
names(Table)[25]=c("tran_Lon")
fdata_grid=Table

###(2)根據經緯度資料劃分4個漁區-----------------
Table1=fdata_grid
for(j in 1:nrow(Table1))
  if (Table1$tran_Lat[j]>=25 & Table1$tran_Lat[j]<26.3 & Table1$tran_Lon[j]>=121.5 & Table1$tran_Lon[j]<123.5){
    Table1$area[j]=1
  }else if(Table1$tran_Lat[j]>=26.3 & Table1$tran_Lat[j]<28 & Table1$tran_Lon[j]>=123.5 & Table1$tran_Lon[j]<=126){
    Table1$area[j]=2
  }else if(Table1$tran_Lat[j]>=28 & Table1$tran_Lat[j]<=30 & Table1$tran_Lon[j]>=120 & Table1$tran_Lon[j]<=126){
    Table1$area[j]=3
  }else if(Table1$tran_Lat[j]>=24 & Table1$tran_Lat[j]<26.3 & Table1$tran_Lon[j]>=120 & Table1$tran_Lon[j]<121.5){
    Table1$area[j]=4
  }else if(Table1$tran_Lat[j]>=26.3 & Table1$tran_Lat[j]<28 & Table1$tran_Lon[j]>=120 & Table1$tran_Lon[j]<123.5){
    Table1$area[j]=4
  }else{
    Table1$area[j]=0
  }
hist(Table1$area)
sum(Table1$area==0) #有512筆資料不是在漁區中
Table1=Table1[!(Table1$area==0),] #將之刪除
fdata_area=Table1

###(3)透過漁獲物資料進行漁獲物組成的分類-----------------
##算出個物種佔一航次的比例
data1=fdata_area[,10:20]
data1[is.na(data1)]=0 #將na填入空值
sum=apply(data1,1,sum)

data2=data1/sum
data2[is.na(data2)]=0
data2=round(data2,2)

##進行cluster分析
table=NULL
for(i in c(1:50)){
  kmeans.cluster=kmeans(data2, centers=i)
  #kmeans.cluster$withinss #群內變異
  SSE=sum(kmeans.cluster$withinss) 
  table=rbind(table,SSE)
}
kvalue=data.frame(cluster=seq(1,50,1),SSE=table)  
plot(x=kvalue$cluster,y=kvalue$SSE,type="o",pch=16,xlab="Number of cluster",ylab="SSE") #選擇有最小的群內變異
abline(v=c(11,12,13),lty=5,col="red")

kmeans.cluster11=kmeans(data2, centers=11)
kmeans.cluster12=kmeans(data2, centers=12)
kmeans.cluster13=kmeans(data2, centers=13)

fdata_clu=fdata_area
fdata_clu$cluster11=kmeans.cluster11$cluster
fdata_clu$cluster12=kmeans.cluster12$cluster
fdata_clu$cluster13=kmeans.cluster13$cluster

###(4)與環境資料合併
env_data=read.csv("C:\\Users\\user\\Desktop\\作品1\\raw data\\env_data\\SST&chla&SSS.csv",header=TRUE)
colnames(env_data)=c("Year","Month","tran_Lat","tran_Lon","SST","chla","SSS")

fdata_env=merge(x=fdata_clu,y=env_data,by=c("Year","Month","tran_Lat","tran_Lon"),all.x =TRUE) 

###(4)利用後續下載的"衛星SST資料"來估計"船測SST資料"-----------------
fdata_sst=fdata_env
#將SST_boat為na值標示出來
missDummy = function(t)
{
  x = dim(length(t))   #x=NULL
  x[which(!is.na(t))] = 1  #which(!is.na(t))指出t中哪個位置是na值 
  x[which(is.na(t))] = 0
  return(x)
}
fdata_sst$dummy=missDummy(fdata_sst$SST.boat.) #dummy=0 為na值

#依據不同year, month做回歸
result=NULL
year=seq(2009,2018,1)
month=seq(1,12,1)

for (y in 1:length(year)){
  for (m in 1:length(month)){
    fdata_sst_ter=fdata_sst[fdata_sst$Year==year[y] & fdata_sst$Month==month[m],] #篩選選出某年每月的資料
    
    if(sum(is.na(fdata_sst_ter$SST.boat.))!=length(fdata_sst_ter$SST.boat.)){ #剔除某些整月沒有sst.boat資料的情況(此情況無法做回歸)
      LM=lm(formula=SST.boat.~SST, fdata_sst_ter) #進行sst.boat和衛星資料T.05m.回歸
      int=as.numeric(coef(LM)[1])
      slop=as.numeric(coef(LM)[2])
      
      for(i in 1:nrow(fdata_sst_ter)){ #對某年每月的資料進行搜尋
        if(fdata_sst_ter$dummy[i] == 0){ #看哪列無sst.boat資料
          fdata_sst_ter$SST.boat.[i] = int + slop * fdata_sst_ter$SST[i] #針對無資料作回歸
        }
      }
      
    }
    result=rbind(result,fdata_sst_ter)
  }
}

###(5)儲存整理後漁業資料
write.csv(result,file="C:\\Users\\user\\Desktop\\作品1\\raw data\\com_data.csv",row.names=FALSE)

















