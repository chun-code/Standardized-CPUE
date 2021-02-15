# Standardized-CPUE
## (1) 標準化CPUE的定義：
* CPUE指的是catch per unit effort，中文意思是"單位努力漁獲量"。  
* 標準化後的CPUE可以作為漁業管理的指標，用來評估目標漁獲物的資源豐度。  
* 詳細請參考: https://ws.tfrin.gov.tw/Download.ashx?u=LzAwMS9VcGxvYWQvT2xkRmlsZS9wdWJsaWMvZGF0YS8yMDA0MTAxOS0xNDQ5MTNfMTDmt7roq4fllq7kvY0ucGRm&n=MjAwNDEwMTktMTQ0OTEzXzEw5re66KuH5Zau5L2NLnBkZg%3d%3d  

## (2) 分析目標：
為了了解台灣東北角的棒受網漁船主要漁獲物"鎖管"的資源變化，本研究利用標準化cpue方式來推估鎖管生物量的年間變動，藉此作為漁業管理的依據。

## (3) 資料來源：
原始資料來自於基隆水試所合作的52艘樣本船。記錄了2009-2018年的出海資訊，包括：___。

## (4) 標準化CPUE方法：
本研究使用泛線性模型(General Linear Model, GLM)和泛加成模型(General Additive Model, GAM)來進行標準化cpue。
兩者有統計理論為依據，且時常被用於推估漁獲物生物量，因此有相對較多文獻可參考和比較。我們使用兩種模型進行分析，接著再利用Akaike information criterion (AIC)選擇套適最好的模型。
