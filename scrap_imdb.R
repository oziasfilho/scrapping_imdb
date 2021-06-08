library(rvest)
library(tidyverse)
link<-"https://www.imdb.com/title/tt0386676/episodes?season="
temporadas<-c(1:9)
links<-c(paste0(link,temporadas))

extrair_informacoes<-function(url){
  x<- url %>% 
    read_html()
  #temporada
  temp<- x %>% 
    html_nodes("#episode_top") %>% 
    html_text()
  #numero episodio
  n_ep<- x %>% 
    html_nodes(".info meta")  %>%  
    html_attr("content")
  #avaliação
  nota<- x %>% 
    html_nodes(".ipl-rating-star.small .ipl-rating-star__rating") %>% 
    html_text() %>% 
    as.numeric()
  #nome do episodio
  nome_ep<- x %>% 
    html_nodes(".info strong") %>% 
    html_text()
  
  tibble(temporada = temp,num_ep=n_ep,notas=nota,nome=nome_ep)
}

dados <- purrr::map_dfr(.x = links, .f = extrair_informacoes)
glimpse(dados)
head(dados)

# library(highcharter)
# hchart(dados,'scatter', hcaes(x=num_ep, y=notas,group = temporada)) %>% 
#   hc_title(text = "Avaliação de cada episodio")

write.table(dados,"theoffice.csv",sep = ";",dec = ".",row.names = FALSE)
