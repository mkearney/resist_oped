## load tidyverse
library(tidyverse)
library(rtweet)
library(rvest)

## download Twitter profiles via CSPAN's cabinet list
cab_twits <- lists_members(
	owner_user = "CSPAN", slug = "the-cabinet")

## get up to 3200 of most recent tweets for each
cab_tweets <- cab_twits %>%
	filter(screen_name != "realDonaldTrump") %>%
	pull(user_id) %>%
	map(get_timeline, n = 3200) %>%
	bind_rows()

## save data
saveRDS(cab_tweets, "data/cab_tweets.rds")

## scrape source code for op-ed
nyt <- read_html(
	"https://www.nytimes.com/2018/09/05/opinion/trump-white-house-anonymous-resistance.html")

## return just the paragraph text
nyt_text <- nyt %>%
	html_nodes("p") %>%
	html_text() %>%
	.[3:31]

## create data set with just author (id) and text
data <- data_frame(
	id = c(cab_tweets$screen_name, rep("op-ed", length(nyt_text))),
	text = c(cab_tweets$text, nyt_text)
)

## feature extraction
tf <- textfeatures::textfeatures(data, word_dims = 80, threads = 20)

## summarise by author (id)
tfsum <- tf %>%
	group_by(id) %>%
	summarise_all(mean, na.rm = TRUE) %>%
	ungroup()

## save numeric feature data
saveRDS(tfsum, "data/tfsum.rds")

## vector of unique authors
authors <- unique(tfsum$id)

## create numeric vectors of equal length for each author
cols <- map(authors,
	~ filter(tfsum, id == .x) %>% select(-id) %>% as.list() %>% unlist())

## create matrix
mat <- cols %>%
	unlist() %>%
	as.numeric() %>%
	matrix(nrow = length(authors), byrow = TRUE)

## set row and column names
row.names(mat) <- authors

## save matrix in data folder
saveRDS(mat, "data/mat.rds")

## dipslay matrix
cor(t(mat))[, "op-ed"] %>% sort()
