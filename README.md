# Standardized-CPUE
## (1) 標準化CPUE的定義：
* CPUE指的是catch per unit effort，中文意思是"單位努力漁獲量"。  
* 標準化後的CPUE可以作為漁業管理的指標，用來評估目標漁獲物的資源豐度。   
* 詳細理論介紹請參考https://www.tfrin.gov.tw/News_Content.aspx?n=300&sms=9025&s=25943 

## (2) 分析目標：
為了了解台灣東北角的棒受網漁船主要漁獲物"鎖管"的資源變化，本研究利用標準化CPUE方式來推估鎖管生物量的年間變動，藉此作為漁業管理的依據。

## (3) 資料來源：
使用的資料包含漁業資料和環境資料。 

漁業資料來自於基隆水試所合作的52艘樣本漁船。記錄了2009-2018年的出海資訊，包括：  
(1) No：資料編號   
(2) Year, Month, Day：作業日期 (年 月 日)  
(3) Lat, Lon：作業經緯度位置   
(4) SST (boat)：漁船偵測的海表面溫度    
(5) spe1-11：11種漁獲物的捕獲量，依序為鎖管、花飛、四破、白帶魚、煙管仔、煙仔、目孔、吻仔魚、青鱗仔、剝皮魚、透抽)，重量單位以公斤計。   
(6) Tonnage A：漁船噸位數。為類別資料，分類方式：1 (<10t) , 2 (10-20t) , 3 (20-50t) , 4 (50-100t) , 5 (>100t)。  
(7) HP A：漁船馬力數。為類別資料，分類方式：1 (<500Hp) , 2 (500-1000Hp) , 3 (100-1500Hp) , 4 (>1500Hp)。  
(8) Light A：漁船燈瓦數。為類別資料，分類方式：1 (<100kwl) , 2 (100-200kwl) , 3 (200-400kwl) , 4 (>400kwl)。棒受網漁船為一種燈火漁業，利用強燈照射海面達到集魚效果，吸引如鎖管等趨光性物種聚集，接著漁民下網捕撈。作業時使用的燈瓦數越高，可以反應漁民投入較高的努力量，且往往有較高的捕獲量。  

環境資料包含2009-2018年每月的海表溫 (SST)、海表鹽 (SSS)、葉綠素濃度 (chla) 資料。資料源自兩種衛星的偵測值，下載自網路的開放平台。

## (4) 標準化CPUE方法：
本研究使用泛線性模型 (General Linear Model, GLM) 和泛加成模型 (General Additive Model, GAM) 來進行CPUE標準化。兩種分析方式具有統計理論為依據，且時常用於推估漁獲物生物量，因此有相對多的文獻可以參考和比較。我們使用兩種模型進行分析，接著再利用 Akaike information criterion (AIC) 選擇套適最佳的模型來作CPUE標準化。

## (5) 分析流程：
1. 處理漁業資料：將原始的漁業資料 (Standardized-CPUE > data > raw data > fishery_data.csv) 作組織和清理，整理出後續分析有用的漁業資訊，再與環境資料結合成一個csv檔輸出 (Standardized-CPUE > data > organized data > final_data.csv)。
2. 處理環境資料：利用爬蟲方式下載網路大量衛星資料 (Standardized-CPUE > data > raw data > environment_data.csv)，同樣的也需要作後續的數據整理，包括網格化、依據時間和網格作平均值等。
4. 標準化CPUE：利用整理好的最終數據 (Standardized-CPUE > data > organized data > final_data.csv) 套入GLM和GAM模型進行標準化CPUE，並且診斷模型套適狀況和繪圖呈現結果。

## (5) 結果：
結果顯示
<img src="https://github.com/chun-code/Standardized-CPUE/blob/main/3.%20%E6%A8%99%E6%BA%96%E5%8C%96CPUE/standard%20CPUE%20%26%20nominal%20CPUE.png" width="500" height = "400">
