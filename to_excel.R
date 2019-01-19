library(tidyverse)

# 都道府県名を用意
prefs_list_url <- "https://gist.githubusercontent.com/koseki/38926/raw/671d5279db1e5cb2c137465e22424c6ba27f4524/todouhuken.txt"
pref_names <- read_tsv(prefs_list_url, col_names = FALSE) %>%
  arrange(X3) %>%
  pull(X2)

jpn <- jpndistrict::jpnprefs %>%
  select(prefecture, jis_code) %>%
  mutate_if(is.factor, as.character)

# 全csvを読み込み、リストに
csv_files <- list.files(path = "output",
                        pattern = "csv",
                        full.names = T)
pref_list <- csv_files %>%
  map(read_csv)

# 都道府県の列を追加
reslist <- list()
for (i in 1:length(pref_list)) {
  reslist[[i]] <- pref_list[[i]] %>%
    mutate(都道府県 = pref_names[i])
}

# 結合
res <- reslist %>%
  bind_rows() %>%
  left_join(jpn, by = c("都道府県" = "prefecture")) %>%
  arrange(jis_code) %>%
  select(都道府県, 市区名, 対象年齢, 自己負担, 所得制限)

# 出力
openxlsx::write.xlsx(res, "output/乳幼児医療費助成.xlsx")
