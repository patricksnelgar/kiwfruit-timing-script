require(tidyverse)
require(magrittr)
require(lubridate)

raw <- read_csv("input/G11_flowering.csv")


# first column always IDs
iden <- raw[,1]

# row by row?
# iterate through each colmun, edge case for first, if na then 0
# need to check names.. or remove the remainders..
# carry over a max value, subsequent columsn will be:
#	if NA, or 'x' then = maxValue

datesOnly <- raw %>% select(-matches("^X"))
tmp <- datesOnly

log <- data.frame(CaneID = double(), Date = character(), information = character(), stringsAsFactors = FALSE)

for(i in seq_along(datesOnly[[1]])) {
	
	maxValue <- 0
	
	for(j in 2:(length(datesOnly[i,]))) {
		
		if(is.na(datesOnly[[i,j]]) | datesOnly[[i,j]] == "x")
			datesOnly[[i,j]] <- maxValue
		
		if(datesOnly[[i,j]] > maxValue)
			maxValue <- as.numeric(datesOnly[[i,j]])
		
		if(datesOnly[[i,j]] < maxValue){

			log %<>% rbind(., data.frame(CaneID = datesOnly[i,1],
						   Date = names(datesOnly)[j],
						   information = paste("Value smaller than max: previous =", datesOnly[i,j], ": new =", maxValue)))
			datesOnly[[i, j]] <- maxValue
		}
			
	}
}


longFormat <- datesOnly %>%
	gather(key = "Date", value = "FlowerCount", -CaneID) %>%
	group_by(CaneID) %>%
	mutate(FlowerPercentage = FlowerCount / max(FlowerCount)) %>%
	arrange(CaneID)


longFormat$information <- sapply(1:nrow(longFormat), function(x) log$information[log$CaneID == longFormat$CaneID[x] & log$Date == longFormat$Date[x]][1])

longFormat %<>% mutate(Date = dmy(paste(Date, "2019", sep = "")))

write_csv(longFormat, "output/G11_flowering_longFormat.csv")

###################################  R19  ##########################################################

rawR19 <- read_csv("input/R19_flowering.csv")

#rawR19 %<>% select(-matches("^X"))

logR19 <- data.frame(CaneID = double(), Date = character(), information = character(), stringsAsFactors = FALSE)

rawR19 %>% 
	filter(!is.na(X5)) %>%
	count()

rawR19 %>% 
	filter(!is.na(X7)) %>%
	count()

rawR19 %>%
	filter(!is.na(`29-Oct`)) %>%
	count()

hasX <- apply(rawR19, 1, function(x) any(x %in% c("x", "X", "xx")))

rawR19 %>%
	filter(hasX) %>%
	count()


# filter 'usable' rows == has an x or a total count - use remainder columns to establish if total count exists
processedR19 <- 
	rawR19 %>% filter(hasX | !is.na(`29-Oct`) | !is.na(X5) | !is.na(X7))

#write_csv(processedR19, "workspace/usable_canes.csv")

for(i in seq_along(processedR19[[1]])) {
	
	maxValue <- 0
	
	for(j in 2:(length(processedR19[i,]))) {
		
		if(is.na(processedR19[[i,j]]) | processedR19[[i,j]] == "x")
			processedR19[[i,j]] <- maxValue
		
		
		if(processedR19[[i,j]] > maxValue)
			maxValue <- as.numeric(processedR19[[i,j]])
		
		if(processedR19[[i,j]] < maxValue){
			
			logR19 %<>% rbind(., data.frame(CaneID = processedR19[i,1],
										 Date = names(processedR19)[j],
										 information = paste("Value smaller than max: previous =", processedR19[i,j], ": new =", maxValue), stringsAsFactors = FALSE))
			processedR19[[i, j]] <- maxValue
		}
		
	}
}


longR19 <- processedR19 %>%
	gather(key = "Date", value = "FlowerCount", -CaneID) %>%
	group_by(CaneID) %>%
	mutate(FlowerCount = as.numeric(FlowerCount), FlowerPercentage = FlowerCount / max(FlowerCount)) %>%
	arrange(CaneID)
	


longR19$information <- sapply(1:nrow(longR19), function(x) logR19$information[logR19$CaneID == longR19$CaneID[x] & logR19$Date == longR19$Date[x]][1])

longR19 %<>% mutate(Date = dmy(paste(Date, "2019", "")))

write_csv(longR19, "output/R19_flowering_longFormat.csv")

