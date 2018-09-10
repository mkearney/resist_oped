## install tidyverse if not already
if (!requireNamespace("tidyverse", quietly = TRUE)) {
	install.packages("tidyverse")
}

## install remotes if not already
if (!requireNamespace("remotes", quietly = TRUE)) {
	install.packages("remotes")
}

## install rvest if not already
if (!requireNamespace("rvest", quietly = TRUE)) {
	install.packages("rvest")
}

## install/upgrade rtweet
if (!requireNamespace("textfeatures", quietly = TRUE) ||
		packageVersion("textfeatures") < "0.1.4") {
	remotes::install_github("mkearney/textfeatures")
}

## install/upgrade textfeatures
if (!requireNamespace("rtweet", quietly = TRUE) ||
		packageVersion("rtweet") < "0.6.7.9000") {
	remotes::install_github("mkearney/rtweet")
}

## load tidyverse set of packages
## note: instead of loading rtweet, textfeatures, & rvest (and xml2) packages,
##       the code below uses fully qualified namespaces (double colon).
library(tidyverse)


## download Twitter profiles via CSPAN's cabinet list
cab_twits <- rtweet::lists_members(
	owner_user = "CSPAN", slug = "the-cabinet")

## get up to 3200 of most recent tweets for each
cab_tweets <- cab_twits %>%
	filter(screen_name != "realDonaldTrump") %>%
	pull(user_id) %>%
	map(rtweet::get_timeline, n = 3200) %>%
	bind_rows()

## scrape source code for op-ed
nyt <- xml2::read_html(
	"https://www.nytimes.com/2018/09/05/opinion/trump-white-house-anonymous-resistance.html")

## return just the paragraph text
nyt_text <- nyt %>%
	rvest::html_nodes("p") %>%
	rvest::html_text() %>%
	.[3:31]

## create data set with just author (id) and text
data <- data_frame(
	id = c(cab_tweets$screen_name, rep("op-ed", length(nyt_text))),
	text = c(cab_tweets$text, nyt_text)
)

## feature extraction
tf <- textfeatures::textfeatures(data, word_dims = 80, threads = 20)

## summarise by id
tfsum <- tf %>%
	group_by(id) %>%
	summarise_all(mean, na.rm = TRUE) %>%
	ungroup()

## vector of unique authors
authors <- unique(tfsum$id)

## create numeric vectors of equal length for each author
cols <- map(authors,
	~ filter(tfsum, id == .x) %>% select(-id) %>% as.list() %>% unlist()
)

## create matrix
mat <- cols %>%
	unlist() %>%
	as.numeric() %>%
	matrix(nrow = length(authors), byrow = TRUE)

## set row and column names
row.names(mat) <- authors

## dipslay matrix
cor(t(mat))[, "op-ed"] %>% sort()
