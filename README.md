
<!-- README.md is generated from README.Rmd. Please edit that file -->

# resist\_oped

🕵🏽 ♀️ Identifying the author behind New York Time’s op-ed from [*inside
the Trump White
House*](https://www.nytimes.com/2018/09/05/opinion/trump-white-house-anonymous-resistance.html).

``` r
## corr matrix
mat <- readRDS("data/mat.rds")

## print matrix
cor(t(mat))[, "op-ed"] %>% sort()
#>           USDOT  DeptVetAffairs           USDOL          HUDgov 
#>      -0.7923443      -0.6046442      -0.5116041      -0.4989040 
#>             EPA            USDA        Interior          SBAgov 
#>      -0.4929554      -0.4810160      -0.4326364      -0.3840941 
#>      USTreasury  SecretaryZinke      SecShulkin          DHSgov 
#>      -0.3413849      -0.2922546      -0.2605447      -0.2237110 
#>  TheJusticeDept      SecPriceMD         Cabinet         usedgov 
#>      -0.2231511      -0.2102655      -0.1861103      -0.1610005 
#>  SecretaryPerry   SecElaineChao          HHSGov          ENERGY 
#>      -0.0998643      -0.0936370      -0.0794056      -0.0606396 
#>      mike_pence        OMBPress     CommerceGov      nikkihaley 
#>      -0.0563475      -0.0364755      -0.0270086       0.0452229 
#>        SBALinda             CIA   DeptofDefense            USUN 
#>       0.1009770       0.1139948       0.1398299       0.1790831 
#>      USTradeRep SecretaryAcosta  stevenmnuchin1  SecretarySonny 
#>       0.1840837       0.1860960       0.1905300       0.3356500 
#> SecretaryCarson     EPAAWheeler    BetsyDeVosED         SecAzar 
#>       0.4894218       0.4931722       0.5488558       0.6268701 
#>      SecNielsen       StateDept   SecretaryRoss       SecPompeo 
#>       0.6716064       0.6843869       0.7373439       0.7669710 
#>           POTUS              VP           op-ed 
#>       0.7986615       0.8010629       1.0000000

## plot estimates
est <- cor(t(mat))[, "op-ed"] %>% sort()
```

``` r
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
```

<p style="align:center">

<img src="plot.png"/>\</\>

## Data

I compared the paragraphs of the op-ed to tweets posted to timelines by
members of the Cabinet.

## Implementation

The implementation can be found in [R/data-twitter.R](https://github.com/mkearney/resist_oped/blob/master/R/data-twitter.R).
My [textfeatures](https://github.com/mkearney/textfeatures) package is used
for extracting the features. 80 word2vec dimensions are used in addition to
the usual "stylistic" features.
were used 
