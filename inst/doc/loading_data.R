## ------------------------------------------------------------------------
library(ibuttonr)
ibutton.data <- read_ibutton_folder(".")
str(ibutton.data)

## ----eval=FALSE----------------------------------------------------------
#  ## which ones failed? you could just check the number of rows in each, and pick
#  ## the ones which are suspiciously short, indicating that the ibutton stopped
#  ## recording temperature. This function automates this process to make it a bit
#  ## more objective: it points out ones which recorded less than the median number
#  ## of datapoints for the experiment. It assumes that all the ibuttons were
#  ## supposed to run for equal amounts of time
#  id.broken(ibutton.data)
#  ## get the lengths for your own use:
#  sapply(ibutton.data,nrow)
#  ## sometimes, fieldworkers record the data incorrectly -- for example, one
#  ## common mistake is to save data from the same ibutton twice with different
#  ## filenames. However, each ibutton has a unique registration number. check
#  ## for any number >1 in this table to identify this error. Additionally, if you
#  ## recorded the registration numbers (written on the back of the ibuttons) you
#  ## could use this to get them from the datafiles themselves
#  table(get.registration.numbers("example.data/"))
#  ## correct the dates and make dataframe
#  ## Now that the data is checked, this function takes the list of ibuttons and
#  ## combines them together. It also reformats the "Date.Time" variable, into a
#  ## format that R recognizes as a date and time.
#  ibutton.dataframe <- ibuttons.to.data.frame(ibutton.data)
#  head(ibutton.dataframe)
#  summary(ibutton.dataframe)
#  ## Here are some ways to graph this data:
#  with(subset(ibutton.dataframe,ibutton=="10a"),plot(Date.Time,Value,type="n"))
#  for(i in levels(ibutton.dataframe$ibutton)){
#  x <- which(ibutton.dataframe$ibutton==i)
#  lines(ibutton.dataframe$Date.Time[x],ibutton.dataframe$Value[x])
#  }

