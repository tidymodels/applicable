# `score_apd_pca_numeric` fails when model has no pcs argument

    Code
      score_apd_pca_numeric(mtcars, mtcars)
    Error <rlang_error>
      The model must contain a pcs argument.

# `score` fails when predictors only contain factors

    Code
      score(model, iris$Species)
    Error <rlang_error>
      The class of `new_data`, 'factor', is not recognized.

# `score` fails when predictors are vectors

    Code
      score(object)
    Error <rlang_error>
      `object` is not of a recognized type.
      i
      Only data.frame, matrix, recipe, and formula objects are allowed.
      i
      A data.frame was specified.

# for score_apd_pca_numeric, missing predictors throws warning

    Code
      pca_score <- score(ames_pca, ames_new)
    Warning <rlang_warning>
      Missing values found in `new_data`
      i This will result in scores of NA
      i Found missing values in rows: 1
      i Found missing values in columns: Bedroom_AbvGr and Kitchen_AbvGr
    Output
                PC1      PC2      PC3      PC4      PC5        PC6       PC7      PC8
      [1,]       NA       NA       NA       NA       NA         NA        NA       NA
      [2,] 2.466408 2.224789 8.789318 3.313106 2.191742 -0.1589545 0.5438994 1.608407
                   PC9      PC10      PC11        PC12        PC13      PC14
      [1,]          NA        NA        NA          NA          NA        NA
      [2,] 0.006762624 0.9847378 -2.540295 -0.09237403 -0.02436368 0.6603319
                PC15      PC16     PC17    PC18       PC19     PC20       PC21
      [1,]        NA        NA       NA      NA         NA       NA         NA
      [2,] 0.1001553 0.9503838 1.852988 3.48042 0.07158267 2.450487 -0.1765622
                PC22       PC23      PC24       PC25     PC26      PC27      PC28
      [1,]        NA         NA        NA         NA       NA        NA        NA
      [2,] 0.8559789 -0.2493769 -1.924213 -0.4703204 1.965143 0.1761022 -1.114555
                PC29      PC30      PC31     PC32      PC33     PC34       PC35
      [1,]        NA        NA        NA       NA        NA       NA         NA
      [2,] -1.704008 0.1218525 0.1133459 1.304231 -1.809555 1.430861 -0.3993946
                PC36      PC37       PC38     PC39     PC40      PC41      PC42
      [1,]        NA        NA         NA       NA       NA        NA        NA
      [2,] 0.4511435 -1.440668 -0.9310547 2.070754 1.871197 -2.178828 -2.100437
                 PC43     PC44       PC45     PC46       PC47      PC48        PC49
      [1,]         NA       NA         NA       NA         NA        NA          NA
      [2,] -0.4931868 1.817395 0.03483991 2.095209 -0.9924086 -1.922843 -0.04406509
               PC50      PC51      PC52     PC53     PC54      PC55      PC56
      [1,]       NA        NA        NA       NA       NA        NA        NA
      [2,] 2.163355 0.1932666 -2.289122 4.152924 3.923092 0.6558053 -0.146487
               PC57     PC58     PC59      PC60     PC61     PC62    PC63      PC64
      [1,]       NA       NA       NA        NA       NA       NA      NA        NA
      [2,] 4.702282 1.774792 5.032135 -2.684171 4.491135 3.247345 3.23191 -1.724397
               PC65     PC66      PC67      PC68         PC69       PC70      PC71
      [1,]       NA       NA        NA        NA           NA         NA        NA
      [2,] 6.197461 1.169659 -1.861305 -2.937525 -0.001389938 -0.4927884 -4.840707
                PC72      PC73     PC74     PC75     PC76      PC77     PC78
      [1,]        NA        NA       NA       NA       NA        NA       NA
      [2,] -1.101356 -9.361695 1.145527 11.85912 8.302862 -4.009509 6.793753
                PC79      PC80      PC81      PC82      PC83     PC84      PC85
      [1,]        NA        NA        NA        NA        NA       NA        NA
      [2,] -1.863549 -9.876324 -11.61375 -5.842962 -11.46002 5.275128 -7.014921
               PC86     PC87     PC88      PC89     PC90     PC91    PC92     PC93
      [1,]       NA       NA       NA        NA       NA       NA      NA       NA
      [2,] 4.923163 2.197609 22.89108 -1.000443 -10.9398 2.149716 5.22019 6.060145
                PC94     PC95      PC96     PC97     PC98     PC99    PC100    PC101
      [1,]        NA       NA        NA       NA       NA       NA       NA       NA
      [2,] -12.89795 13.43826 -5.107594 8.945009 2.940855 10.77334 6.924547 4.022854
               PC102      PC103     PC104     PC105     PC106     PC107    PC108
      [1,]        NA         NA        NA        NA        NA        NA       NA
      [2,] -1.029692 0.01410445 -7.313233 -6.563821 -1.510986 -1.581892 8.223148
              PC109     PC110     PC111  PC112     PC113    PC114     PC115    PC116
      [1,]       NA        NA        NA     NA        NA       NA        NA       NA
      [2,] 3.731099 -6.451179 -1.334733 1.1979 0.8259669 2.347194 -7.509658 3.959916
                PC117     PC118     PC119      PC120     PC121     PC122      PC123
      [1,]         NA        NA        NA         NA        NA        NA         NA
      [2,] -0.9750198 0.9434487 -0.979986 -0.7445349 -6.840922 -5.861902 -0.2311582
               PC124    PC125    PC126     PC127      PC128     PC129     PC130
      [1,]        NA       NA       NA        NA         NA        NA        NA
      [2,] 0.8480181 2.405786 3.118139 -1.521608 -0.8529486 0.0139404 0.9481161
             PC131     PC132     PC133     PC134     PC135    PC136     PC137
      [1,]      NA        NA        NA        NA        NA       NA        NA
      [2,] 1.29129 -0.209817 0.1500509 -1.730899 -3.784003 -3.99342 -1.836885
               PC138    PC139    PC140     PC141    PC142     PC143      PC144
      [1,]        NA       NA       NA        NA       NA        NA         NA
      [2,] -3.516675 2.829933 0.743968 0.9834243 1.577668 -1.563731 -0.3005636
               PC145    PC146     PC147     PC148     PC149     PC150     PC151
      [1,]        NA       NA        NA        NA        NA        NA        NA
      [2,] -1.225604 1.576748 0.7917111 0.3075223 -1.172741 -1.124075 -2.437957
              PC152    PC153      PC154    PC155     PC156     PC157    PC158
      [1,]       NA       NA         NA       NA        NA        NA       NA
      [2,] 1.936248 1.130193 -0.3420632 0.458577 0.6133464 0.3347239 1.085225
               PC159    PC160     PC161      PC162     PC163      PC164     PC165
      [1,]        NA       NA        NA         NA        NA         NA        NA
      [2,] 0.5750897 3.208302 0.7076647 0.09796857 0.6497739 -0.5312429 0.7670607
                PC166      PC167    PC168     PC169     PC170       PC171     PC172
      [1,]         NA         NA       NA        NA        NA          NA        NA
      [2,] -0.5612976 -0.3747512 1.565267 0.1981352 -2.689119 -0.09889842 0.6461733
               PC173     PC174      PC175      PC176     PC177     PC178     PC179
      [1,]        NA        NA         NA         NA        NA        NA        NA
      [2,] -0.404465 0.5910641 -0.2342726 -0.1891361 0.8338145 -0.365551 -0.431737
                PC180     PC181      PC182      PC183     PC184       PC185
      [1,]         NA        NA         NA         NA        NA          NA
      [2,] -0.5679131 0.5836032 -0.2622336 0.09377063 -1.218364 0.001253367
                PC186      PC187      PC188      PC189     PC190       PC191
      [1,]         NA         NA         NA         NA        NA          NA
      [2,] -0.4742433 -0.7744081 -0.5745466 -0.2088734 0.2335767 -0.07257593
               PC192     PC193     PC194     PC195   PC196     PC197     PC198
      [1,]        NA        NA        NA        NA      NA        NA        NA
      [2,] 0.8637293 0.9562595 0.4295023 0.1009075 -1.8282 0.5409864 0.5708284
               PC199      PC200       PC201     PC202    PC203      PC204      PC205
      [1,]        NA         NA          NA        NA       NA         NA         NA
      [2,] 0.3229602 0.09729242 -0.05380656 0.3175692 1.258273 -0.3419031 0.08335253
               PC206   PC207     PC208     PC209      PC210     PC211    PC212
      [1,]        NA      NA        NA        NA         NA        NA       NA
      [2,] -0.143088 1.00227 0.4211266 0.5370274 -0.8873037 0.1068745 0.206711
                 PC213      PC214      PC215      PC216      PC217     PC218
      [1,]          NA         NA         NA         NA         NA        NA
      [2,] -0.01468057 0.08799009 -0.1828264 -0.4346736 -0.2476474 -2.250571
               PC219       PC220      PC221      PC222     PC223     PC224     PC225
      [1,]        NA          NA         NA         NA        NA        NA        NA
      [2,] -2.075462 -0.09826901 -0.8804963 -0.6675988 -2.387204 -1.584932 0.4581717
                PC226   PC227       PC228     PC229     PC230      PC231     PC232
      [1,]         NA      NA          NA        NA        NA         NA        NA
      [2,] 0.07073112 1.28762 -0.03625456 -1.088071 -4.094433 -0.8060144 -0.160211
              PC233
      [1,]       NA
      [2,] 1.174903

