# Standardized-CPUE
## (1) 標準化CPUE的定義：
* CPUE指的是catch per unit effort，中文意思是"單位努力漁獲量"。  
* 標準化後的CPUE可以作為漁業管理的指標，用來評估目標漁獲物的資源豐度。  
* 詳細請參考: https://ws.tfrin.gov.tw/Download.ashx?u=LzAwMS9VcGxvYWQvT2xkRmlsZS9wdWJsaWMvZGF0YS8yMDA0MTAxOS0xNDQ5MTNfMTDmt7roq4fllq7kvY0ucGRm&n=MjAwNDEwMTktMTQ0OTEzXzEw5re66KuH5Zau5L2NLnBkZg%3d%3d  

## (2) 分析目標：
為了了解台灣東北角的棒受網漁船主要漁獲物"鎖管"的資源變化，本研究利用標準化cpue方式來推估鎖管生物量的年間變動，藉此作為漁業管理的依據。

## (3) 資料來源：
使用的資料包含漁業資料和環境資料。 

漁業資料來自於基隆水試所合作的52艘樣本漁船。記錄了2009-2018年的出海資訊，包括：  
(1)No：資料編號   
(2)Year,Month,Day：出航年月日  
(3)Lat,Lon：作業經緯度位置   
(4)SST(boat)：漁船偵測的海表面溫度    
(5)11種物種捕獲量(鎖管、花飛、四破、白帶魚、煙管仔、煙仔、目孔、吻仔魚、青鱗仔、剝皮魚、透抽)，單位以公斤計  
(6)Tonnage A：漁船噸位數。為類別資料，分類方式：1(<10t),2(10-20t),3(20-50t),4(50-100t),5(>100t)  
(7)HP A：漁船馬力數。為類別資料，分類方式：1(<500Hp),2(500-1000Hp),3(100-1500Hp),4(>1500Hp)  
(8)Light A：漁船燈瓦數。為類別資料，分類方式：1(<100kwl),2(100-200kwl),3(200-400kwl),4(>400kwl)。棒受網漁船為一種燈火漁業，利用強燈照射海面達到集魚效果，吸引如鎖管等趨光性物種聚集，接著進行捕撈，當漁船使用的燈瓦數越高，能夠反應漁民投入較高的努力量。  

環境資料下載自網路資源，來自於不同衛星的偵測值。

## (4) 標準化CPUE方法：
本研究使用泛線性模型(General Linear Model, GLM)和泛加成模型(General Additive Model, GAM)來進行標準化cpue。
兩者有統計理論為依據，且時常被用於推估漁獲物生物量，因此有相對較多文獻可參考和比較。我們使用兩種模型進行分析，接著再利用Akaike information criterion (AIC)選擇套適最好的模型。
