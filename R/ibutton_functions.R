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


#' Create more accurate header names for the dataset
#'
#' Occasionally ibuttons produce data with other, unlabelled numbers in a column
#' to the right of the actual data. This function counts the fields in the row below the data
#' and then supplies a nicer header
#'
#' @param allfiles a list of all file names of ibuttons
#' @return an integer giving the number of fields in row below the header
#' @export
header_names <- function(allfiles){
  one_top <- readLines(allfiles[1], n = 25)
  loc_header <- which(grepl("^Date", one_top))
  # the number of fields in the data, one row below the header
  dat_len <- count.fields(textConnection(one_top[loc_header + 1]), sep = ",")
  col_names <- unlist(strsplit(one_top[loc_header], split = ",",))
  if(dat_len == 3) col_names else c(col_names, paste0("V", seq_len(dat_len-3)))
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
read_ibutton_folder <- function(folder, override.col.names = NULL, extra_args = NULL){
  # foldername <- paste0("./",folder)
  ibut.files <- dir(path=folder,full=TRUE,pattern="*.csv")
  nskip <- get_preamble_length(ibut.files)
  ## count the fields
  hnames <- header_names(ibut.files)
  ## assemble arguments
  read_args <- list(skip = nskip,
                    col.names = hnames,
                    stringsAsFactors = FALSE)
  read_args$col.names <- if(!is.null(override.col.names)) override.col.names
  ibut.dat <- lapply(ibut.files,function(x) do.call(read_named_ibutton, c(f = x, read_args)))
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
#' @param date_format a character string indicating the format of the dates. see `?strptime`
#' @export
ibuttons_to_data_frame <- function(ibut.list, date_format = "%d/%m/%y %I:%M:%S %p"){
  ## attach all together in a complete dataframe
  ibutton.long.dataframe <- do.call(rbind,ibut.list)
  ibutton.long.dataframe[["Date.Time"]] <- strptime(ibutton.long.dataframe[["Date.Time"]],format=date_format)
  ibutton.long.dataframe
}