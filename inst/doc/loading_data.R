## ------------------------------------------------------------------------
library(ibuttonr)
ibutton.data <- read_ibutton_folder(".")
str(ibutton.data)

## ----eval=FALSE----------------------------------------------------------
#  
#  id_broken(ibutton.data)
#  ## get the lengths for your own use:
#  sapply(ibutton.data,nrow)

## ------------------------------------------------------------------------

table(get_registration_numbers("."))


## ------------------------------------------------------------------------
ibutton.dataframe <- ibuttons_to_data_frame(ibutton.data)
head(ibutton.dataframe)
knitr::kable(summary(ibutton.dataframe))

## ------------------------------------------------------------------------
## Here are some ways to graph this data:
with(subset(ibutton.dataframe,ibutton=="10a"),plot(Date.Time,Value,type="n"))
for(i in levels(ibutton.dataframe$ibutton)){
x <- which(ibutton.dataframe$ibutton==i)
lines(ibutton.dataframe$Date.Time[x],ibutton.dataframe$Value[x])
}
###

