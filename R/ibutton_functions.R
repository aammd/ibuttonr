#' Get the length of the 'preamble' of all ibuttons
#'
#' ibuttons produce csvs with several lines of text at the beginning,
#' which describe how the ibutton was configured. This function
#' determines the length of this text or "preamble".
#'
#' @param allfiles a list of all file names of ibuttons
#' @return an integer giving the number of lines before the header row of the actual data
#' @export
get_preamble_length <- function(allfiles){
  one_top <- readLines(allfiles[1],n = 25)
  which(grepl("^Date",one_top)) - 1
}



#' Add filename to data
#'
#' @param f Filename of ibutton data
#' @return a \code{data.frame} with a column for original file name
#' @export
read_named_ibutton <- function(f, ...){
  cbind(ibutton=sub("\\.csv$", "", basename(f)), read.csv(f, ...))
}


#' Read all files in a folder
#'
#' loads in all the data held in a single folder.
#'
#' This function assumes that you have one folder containing only ibutton data.
#'
#' @param folder Folder containing ibutton data only
#' @return Named list of ibutton data. Names are taken from base names.
#' @export
read_ibutton_folder <- function(folder,...){
  # foldername <- paste0("./",folder)
  ibut.files <- dir(path=folder,full=TRUE,pattern="*.csv")
  nskip <- get_preamble_length(ibut.files)
  ## count the fields
  header_line <- nskip + 1

  ibut.dat <- lapply(ibut.files,read_named_ibutton, skip=nskip, stringsAsFactors=FALSE)
  names(ibut.dat) <- lapply(ibut.files,function(f) sub("\\.csv$", "", basename(f)))
  ibut.dat
}

#' Check for broken ibuttons
#'
#' ibuttons sometimes break, ie. stop recording. This function tries to
#' identify those
#'
#' @param ibutt.list List of ibuttons to combine
#' @return names of suspect ibuttons
#' @export
id_broken <- function(ibutt.list){
  n.obs <- sapply(ibutt.list,nrow)
  med.n.obs <- median(n.obs)
  prob.broken <- which(n.obs<med.n.obs)
  names(ibutt.list)[prob.broken]
}

#' Extracts the registration number for an ibutton
#'
#' This function extracts the registration number from the "preamble", ie the lines
#' of information at the start of an ibutton file
#'
#' @param ibutton.preamble An ibutton preamble
#' @return Registration number (character)
#' @export
preamble_extract_registration_number <- function(ibutton.preamble){
  location.reg.number <- grep(ibutton.preamble,pattern="Registration Number",useBytes=TRUE)
  split.line <- strsplit(ibutton.preamble[location.reg.number],split=" ")
  sapply(split.line,function(x) grep(x,pattern="[0-9,A-Z]{16}",value=TRUE))
}

#' Extract all registration numbers
#'
#' reads all the ibutton files in one folder,
#' read only the top of each file and extract from that the
#' registration numbers
#'
#' @param folder Folder where all ibutton files are kept
#' @export
get_registration_numbers <- function(folder,...){
  # foldername <- paste0("./",folder)
  ibut.files <- dir(path=folder,full=TRUE,pattern="*.csv")
  nread <- get_preamble_length(ibut.files)
  ibutton.preamble <- lapply(ibut.files,function(x) readLines(x,n = nread))
  sapply(ibutton.preamble,preamble_extract_registration_number)
}

#' Combines given list of ibuttons into a data.frame
#'
#' This function takes a list of ibuttons and \code{rbinds} them.
#' Also performs date conversion
#'
#' @param ibut.list List of ibutton data
#' @export
ibuttons_to_data_frame <- function(ibut.list){
  ## attach all together in a complete dataframe
  ibutton.long.dataframe <- do.call(rbind,ibut.list)
  ibutton.long.dataframe[["Date.Time"]] <- strptime(ibutton.long.dataframe[["Date.Time"]],format="%d/%m/%y %I:%M:%S %p")
  ibutton.long.dataframe
}