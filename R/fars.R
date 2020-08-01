#' fars_read ()is a function that read in data from a csv file.
#' FARS stand for "Fatality Analysis Reporting System" and is a nationwide census, providing the American public yearly data,
#' regarding fatal injuries suffered in motor vehicle traffic crashes
#' @importFrom dplyr tbl_df
#' @importFrom readr read_csv
#'
#' @param filename is for the file to be read. if this file name not exist, function will stop and print "does not exist".
#'
#' @return This function returns the data to be read
#'
#' @examples
#' fars_read(accident_2013.csv.bz2)
#' fars_read(accident_2014.csv.bz2)
#' fars_read(accident_2015.csv.bz2)
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' make_filename is function that creates a filename based on a single year as input.
#'
#' @param year is a single year in the data.
#'
#' @return this function returns a data file with file name defined
#'
#' @examples
#' make_filename(2003)
#' make_filename(2004)
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' fars_read_years is function that read in multiple files by years.
#' internal functions need for fars_read_years are make_filename () in this code.
#' external package needed is dplyr. Two functions of it are selection(),mutate().
#' @importFrom dplyr mutate select
#'
#' @param years is a vector of years as the argument for the fars_read_years() function.
#'  if a year not exist, warning message will print "invalid year".
#'
#' @return this function returns data files with file names defined
#'
#' @examples
#' fars_read_years(years = c(2013, 2015)
#' fars_read_years(2013:2015)
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' fars_summarize_years()
#' this function summarizes yearly accidents data, by month and produces a summary of the simple counts of fatalities by month and year
#' internal functions needed is fars_read_years()
#' external package needed is dplyr and tidyr. Thre functions of dplyr are used :sbind_rows(),group_by(),summarize().
#' function spread() from tidyr is used as well.
#' @importFrom dplyr bind_rows group_by summarize
#' @importFrom tidyr spread
#'
#' @param years is a vector of years as the argument.
#' The fars_summarize_years() function take the same argument as the fars_read_years().
#'
#' @examples
#' fars_summarize_years(years = c(2013, 2015)
#' fars_summarize_years(2013:2015)
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' fars_map_state ()
#' this function that plots points where accidents for given state.num
#' in other words, the fars_map_state function takes a state ID number and a year, and maps that state's fatalities with a dot at the fatality location.
#'
#' internal functions needed are make_filename() and fars_read()
#' external packages needed are:  dplyr,maps, graphics. functiion filter() from dplyr, map() from maps and points () from graphics are used.
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @param  state.num is state ID number (one interger from unique(data$STATE) if invalid state number used, the function will stop.
#' @param  year is a single year as the argument for make_filename() function.
#'
#' @examples
#' state_num <- 49 # Utah
#' yr <- 2014
#  fars_map_state(state_num, yr)
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
