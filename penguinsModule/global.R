library(shiny)
library(shinydashboard)
library(bslib)
library(ggplot2)
library(dplyr)
library(tidyr)
library(palmerpenguins)
library(gt)

# modules.Rの読み込み
source("./components/modules.R")
# functions.Rの読み込み
# source("./components/functions.R")

## アプリ要件
# 1. 選択結果タブ、解析描画タブの2つを作成
# 2. 選択結果タブで解析対象種を選択    
# 3. 解析描画タブで、X軸とY軸を選択し、散布図と回帰直線を描画
# 4. 解析描画タブで、回帰分析の結果と確定ボタンを表示
# 5. 確定ボタンを押して選択結果タブに戻ると解析対象種、X軸とY軸、回帰分析の結果をまとめたテーブルに反映

resultsList <- reactiveValues(results = tibble(NULL)
)

penguinsdata <- palmerpenguins::penguins %>%
    # drop_na(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g)
    drop_na()

penguinsList <- unique(penguinsdata$species)
axixsList <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")