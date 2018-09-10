data_frame(screen_name = names(est), r = est) %>%
	arrange(est) %>%
	mutate(screen_name = factor(screen_name, levels = screen_name)) %>%
	ggplot(aes(x = screen_name, y = r)) +
	geom_col(aes(fill = r > 0), width = .3) +
	geom_point(shape = 21, fill = "greenyellow", size = 2.75) +
	tfse::theme_mwk(light = "white", base_family = "Avenir Next LT Pro") +
	coord_flip() +
	labs(title = "Text similarity of NYT op-ed and Cabinet tweets",
		subtitle = "Correlation estimates based on 100+ features extracted from texts",
		y = NULL, x = NULL,
		caption = "Source: Texts from Twitter & New York Times analyzed by @kearneymw") +
	theme(legend.position = "none") +
	scale_fill_manual(values = c("#2244ee", "#dd2222")) +
	ggsave("plot.png", width = 7, height = 6.5)
