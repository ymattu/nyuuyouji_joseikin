library(rvest)
library(here)
library(glue)

# 都道府県名をアルファベットで取得
prefs_list_url <- "https://gist.githubusercontent.com/koseki/38926/raw/671d5279db1e5cb2c137465e22424c6ba27f4524/todouhuken.txt"
prefs <- read_tsv(prefs_list_url, col_names = FALSE) %>%
  pull(X3)

# 対象URL 作成
base_url <- "https://house.goo.ne.jp/chiiki/kurashi/tsuuin/"
target_url <- NULL
for (i in 1:length(prefs)) {
  target_url[i] <- glue(base_url, "{prefs[i]}", ".html")
}
# 茨城が間違ってる
target_url[8] <- "https://house.goo.ne.jp/chiiki/kurashi/tsuuin/ibaragi.html"
# 大阪も
target_url[27] <- "https://house.goo.ne.jp/chiiki/kurashi/tsuuin/oosaka.html"
# 兵庫
target_url[28] <- "https://house.goo.ne.jp/chiiki/kurashi/tsuuin/hyougo.html"
# 高知
target_url[39] <- "https://house.goo.ne.jp/chiiki/kurashi/tsuuin/kouchi.html"
# 高知
target_url[44] <- "https://house.goo.ne.jp/chiiki/kurashi/tsuuin/ooita.html"

# 出力ファイル名の準備
if(!dir.exists("output")) {
  dir.create("output")
}
output_files <- NULL
for (j in 1:length(target_url)) {
  output_files[j] <- glue(here("output"), "/", "{prefs[j]}", ".csv")
}

# スクレイピングand出力
for (k in 1:length(target_url)) {
  joseikin <- read_html(target_url[k]) %>%
    html_nodes(css = "#contentsarea2_2 > div.kurashi-box.radio-checkbox-L > table") %>%
    html_table() %>%
    .[[1]]
  
  write_csv(joseikin, output_files[k])
  
  Sys.sleep(1)
}


