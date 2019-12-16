require(tidyverse)
require(magrittr)
require(lubridate)

rawBB_G11 <- read_csv("input/G11_budbreak.csv")

#finds the max value for each row
maxBBValues_G11 <- apply(rawBB_G11, 1, function(x) max(as.numeric(x[-1:-2]), na.rm = TRUE))

