##GAM和GLM分析
####(1) 輸入資料、整理資料----
data = read.csv("C:\\Users\\user\\Desktop\\StdCPUE\\raw data\\com_data.csv",header=TRUE)

#選取year,month,SST.boat.,sp1,Tonnage.A,HP.A,Light.A,area,cluster11,cluster12,cluster13,chla,SSS欄位作後續分析
data = data[,c(1,2,9,10,21,22,23,24,25,26,27,29,30)]

names(data)[4] = "uro_catch"
data$uro_catch[is.na(data$uro_catch)] = 0 #將捕獲量為NA值欄位填為0
data$uro_catch = data$uro_catch+30 #根據standard CPUE公式，加上一常數項

data = na.omit(data) #扣除其他na值資料
summary(data) #檢查資料狀態
boxplot(data$SST.boat.) #發現sst.boat有異常值
data = data[data$SST.boat.< 40,]

####(2) Pearson Correlation 相關性分析----
#由於船噸位數、馬力數、燈泡總瓦數三者可能存在相關性，例如船越大，馬力越大，空間足夠下可以使用較多燈泡。
#若經過檢驗三者確實有相關性(r>0.05)，僅能保留其中一項因子，避免標準化結果有誤差。
cor(data$Tonnage.A,data$HP.A) 
cor(data$HP.A,data$Light.A)
cor(data$Tonnage.A,data$Light.A)
#檢驗後，兩兩因子的r皆有相關性，因此僅保留燈泡總瓦數(Light.A)此項因子。

####(3) GLM和GAM分析----
fin_data = data
#GLM
library(MASS)
glm11 = glm(formula=log(fin_data$uro_catch)~factor(fin_data$Year)+factor(fin_data$Month)+fin_data$SST.boat.+factor(fin_data$Light.A)+
          factor(fin_data$area)+factor(fin_data$cluster11)+factor(fin_data$chla)+factor(fin_data$SSS)+
          factor(fin_data$Month):factor(fin_data$area),family='Gamma',data=fin_data) #11 cluster (AIC:34116.42)

glm12 = glm(formula=log(fin_data$uro_catch)~factor(fin_data$Year)+factor(fin_data$Month)+fin_data$SST.boat.+factor(fin_data$Light.A)+
            factor(fin_data$area)+factor(fin_data$cluster12)+factor(fin_data$chla)+factor(fin_data$SSS)+
            factor(fin_data$Month):factor(fin_data$area),family='Gamma',data=fin_data) #12 cluster (AIC:32474.56)

glm13 = glm(formula=log(fin_data$uro_catch)~factor(fin_data$Year)+factor(fin_data$Month)+fin_data$SST.boat.+factor(fin_data$Light.A)+
            factor(fin_data$area)+factor(fin_data$cluster13)+factor(fin_data$chla)+factor(fin_data$SSS)+
            factor(fin_data$Month):factor(fin_data$area),family='Gamma',data=fin_data) #13 cluster (AIC:33832.27)
#GAM
library(nlme)
library(mgcv)
gam11 = gam(formula=log(fin_data$uro_catch)~s(fin_data$Year)+s(fin_data$Month)+s(fin_data$SST.boat.)+s(fin_data$Tonnage.A,k=5)+
            s(fin_data$area,k=3)+s(fin_data$cluster11)+s(fin_data$chla)+s(fin_data$SSS)+
            s(fin_data$Month,by=fin_data$area),family='Gamma',data=fin_data) #11 cluster (AIC:34724.69)

gam12 = gam(formula=log(fin_data$uro_catch)~s(fin_data$Year)+s(fin_data$Month)+s(fin_data$SST.boat.)+s(fin_data$Tonnage.A,k=5)+
            s(fin_data$area,k=3)+s(fin_data$cluster12)+s(fin_data$chla)+s(fin_data$SSS)+
            s(fin_data$Month,by=fin_data$area),family='Gamma',data=fin_data) #12 cluster (AIC:34725.15)

gam13 = gam(formula=log(fin_data$uro_catch)~s(fin_data$Year)+s(fin_data$Month)+s(fin_data$SST.boat.)+s(fin_data$Tonnage.A,k=5)+
            s(fin_data$area,k=3)+s(fin_data$cluster13)+s(fin_data$chla)+s(fin_data$SSS)+
            s(fin_data$Month,by=fin_data$area),family='Gamma',data=fin_data) #13 cluster (AIC:24768.93)
#結果顯示以GLM和使用cluster12變數狀況下，有最小的AIC值，因此選擇此模型來作鎖管物種的標準化CPUE。

####(4) 診斷模型表現----
par(mfrow=c(2,2))
plot(glm12)

####(5) 比較標準化CPUE和名目CPUE----
#尚為經過標準化的CPUE稱為"名目CPUE(nominal CPUE)"，也就是直接將捕獲量和努力量相除(catch/effort)。
#多數研究考量了漁業因素(如：燈泡總瓦數、捕撈策略)、環境因素(如：海水溫)等進行標準化CPUE，認為這樣的結果可以排除"漁撈行為"對"估計生物量"造成的偏差，因此較具參考性。
#以下比較standard CPUE和nominal CPUE，藉此了解標準化前後CPUE的差異。

library(dplyr)
step = stepAIC(glm12,trace=FALSE) 

#standard CPUE
pCPUE = predict(step,type="response",fin_data) #standardized cpue
pCPUE_10 = 30
pCPUE = exp(pCPUE)-pCPUE_10
finaldata = cbind(fin_data,pCPUE)

se = function(x) {sd(x)/sqrt(length(x))}
meanCPUE = aggregate(pCPUE~Year,data=finaldata, FUN=mean)
seCPUE = aggregate(pCPUE~Year,data=finaldata, FUN=se)

#nominal CPUE
table = NULL
for (y in 2009:2018){
  d2009 = subset(fin_data,Year==y) 
  NCPUE2009 = mean(d2009$uro_catch)-pCPUE_10
  table = rbind(table,NCPUE2009)
}
NCPUE = cbind(year=seq(2009,2018,1),stdCPUE=as.vector(table))

uro_CPUE = data.frame(year=seq(2009,2018,1),noCPUE=NCPUE[,2],stCPUE_mean=meanCPUE[,2],stCPUE_se=seCPUE[,2])
write.csv(uro_CPUE,file="C:\\Users\\user\\Desktop\\StdCPUE\\uro_CPUE.csv",row.names=FALSE)

#plot
par(mfrow=c(1,1))
plot(uro_CPUE$year,uro_CPUE$noCPUE,type="o",pch=20,xlab="year",ylab="CPUE",xlim=c(2009,2018),ylim=c(0,500),xaxt='n',main=substitute(paste(italic("Uroteuthis")," spp.")))
axis(1,seq(2009,2018,1))
lines(uro_CPUE$year,uro_CPUE$stCPUE_mean,type="o",col=2,pch=20)
arrows(uro_CPUE$year, uro_CPUE$stCPUE_mean-uro_CPUE$stCPUE_se, uro_CPUE$year, uro_CPUE$stCPUE_mean+uro_CPUE$stCPUE_se, length=0.05, angle=90, code=3, col="firebrick3")
legend("topright", c("nominal CPUE","standardized CPUE"), pch=c(16,16),col=c(1,2))

