library(rvest)

jpndistrict::jpnprefs %>% View

tokyo_url <- "https://house.goo.ne.jp/chiiki/kurashi/tsuuin/tokyo.html"

tokyo_josei <- read_html(tokyo_url) %>%
  html_nodes(css = "#contentsarea2_2 > div.kurashi-box.radio-checkbox-L > table") %>%
  html_table() %>%
  .[[1]]

write_csv(tokyo_josei, "tokyo_joseikin.csv")
