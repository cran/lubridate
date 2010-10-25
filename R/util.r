#' Is a year a leap year?
#'
#' If x is a recognized date-time object, leap_year will return whether x 
#' occurs during a leap year. If x is a number, leap_year returns whether it 
#' would be a leap year under the Gregorian calendar. 
#'
#' @export leap_year
#' @param date a date-time object or a year 
#' @return TRUE if x is a leap year, FALSE otherwise
#' @keywords logic chron
#' @examples
#' x <- as.Date("2009-08-02")
#' leap_year(x) # FALSE
#' leap_year(2009) # FALSE
#' leap_year(2008) # TRUE
#' leap_year(1900) # FALSE
#' leap_year(2000) # TRUE
leap_year <- function(date) {
  recognized <- recognize(date)
  if (recognized)
    year <- year(date)
  else if (all(is.numeric(date)))
    year <- date
  else
    stop("unrecognized date format")
  (year %% 4 == 0) & ((year %% 100 != 0) | (year %% 400 == 0))
}

#' The current time 
#'
#' @export now
#' @param tzone a character vector specifying which time zone you would like 
#'   the current time in. tzone defaults to the system time zone set on your 
#'   computer.
#' @return the current date and time as a POSIXct object
#'
#' @keywords chron utilities
#' @examples
#' now()
#' now("GMT")
#' now() == now() # would be true if computer processed both at the same instant
#' now() < now() # TRUE
#' now() > now() # FALSE
now <- function(tzone = "") 
  with_tz(Sys.time(),tzone)


#' The current date 
#'
#' @export today
#' @param tzone a character vector specifying which time zone you would like to 
#'   find the current date of. tzone defaults to the system time zone set on your 
#'   computer.
#' @return the current date as a Date object
#'
#' @keywords chron utilities
#' @examples
#' today()
#' today("GMT")
#' today() == today("GMT") # not always true
#' today() < as.Date("2999-01-01") # TRUE  (so far)
today <- function(tzone = "") {
  as.Date(force_tz(floor_date(now(tzone), "day"), tz = "UTC"))
}

#' Does date time occur in the am or pm?
#'
#' @export am pm
#' @aliases am pm
#' @param x a date-time object  
#' @return TRUE or FALSE depending on whethe x occurs in the am or pm 
#' @keywords chron 
#' @examples
#' x <- now()
#' am(x) 
#' pm(x) 
am <- function(x) hour(x) < 12
pm <- function(x) !am(x)


#' Get date-time in a different time zone
#' 
#' with_tz returns a date-time as it would appear in a different time zone.  
#' The actual moment of time measured does not change, just the time zone it is 
#' measured in. with_tz defaults to the Universal Coordinated time zone (UTC) when an unrecognized time zone is inputted. See \code{\link{Sys.timezone}} for more information on how R recognizes time zones.
#'
#' @export with_tz
#' @param time a POSIXct, POSIXlt, Date, or chron date-time object.
#' @param tzone a character string containing the time zone to convert to. R must recognize the name 
#'   contained in the string as a time zone on your system.
#' @return a POSIXct object in the updated time zone
#' @keywords chron manip
#' @seealso \code{\link{force_tz}}
#' @examples
#' x <- as.POSIXct("2009-08-07 00:00:01", tz = "America/New_york")
#' with_tz(x, "GMT")
#' # "2009-08-07 04:00:01 GMT"
with_tz <- function (time, tzone = ""){
  new <- as.POSIXct(format(as.POSIXct(time), tz = tzone), 
    tz = tzone)
  reclass_date(new, time)
}

#' Replace time zone to create new date-time
#' 
#' force_tz returns a the date-time that has the same clock time as x in the new time zone.  
#' Although the new date-time has the same clock time (e.g. the 
#' same values in the year, month, days, etc. elements) it is a 
#' different moment of time than the input date-time. force_tz defaults to the Universal Coordinated time zone (UTC) when an unrecognized time zone is inputted. See \code{\link{Sys.timezone}} for more information on how R recognizes time zones.
#'
#' @export force_tz
#'
#' @param time a POSIXct, POSIXlt, Date, or chron date-time object.
#' @param tzone a character string containing the time zone to convert to. R must recognize the name 
#' contained in the string as a time zone on your system.
#' @return a POSIXct object in the updated time zone
#' @keywords chron manip
#' @seealso \code{\link{force_tz}}
#' @examples
#' x <- as.POSIXct("2009-08-07 00:00:01", tz = "America/New_york")
#' force_tz(x, "GMT")
#' # "2009-08-07 00:00:01 GMT"
force_tz <- function(time, tzone = ""){
  x <- as.POSIXlt(time)
  
  if(is.null(tzone)) tzone <- ""
  new <- ISOdatetime(year(x),  month(x), mday(x), hour(x),
    minute(x), second(x), tzone)
  new[hour(with_tz(new, tzone)) != hour(time)] <- NA
    
  reclass_date(new, time)
}


# Note: alternative method? as.POSIXlt(format(as.POSIXct(x)), tz = tz)


#' 1970-01-01 GMT
#'
#' Origin is the date-time for 1970-01-01 GMT in POSIXct format. This date-time 
#' is the origin for the numbering system used by POSIXct, POSIXlt, chron, and 
#' Date classes.
#'
#' @export origin
#' @keywords data chron
#' @examples
#' origin
#' # "1970-01-01 GMT"
origin <- with_tz(structure(0, class = c("POSIXt", "POSIXct")), "UTC")



#' Converts a date to a decimal of its year. 
#'
#' @export decimal_date 
#' @S3method decimal_date default 
#' @S3method decimal_date zoo 
#' @S3method decimal_date its
#' @param date a POSIXt or Date object   
#' @return a numeric object where the date is expressed as a fraction of its year
#' @keywords manip chron methods
#' @examples
#' date <- as.POSIXlt("2009-02-10")
#' decimal_date(date)  # 2009.109
decimal_date <- function(date)
  UseMethod("decimal_date")
  
decimal_date.default <- function(date){
  if(any(!inherits(date, c("POSIXt", "POSIXct", "POSIXlt", "Date"))))
    stop("date(s) not in POSIXt or Date format")
  
decimal <- as.numeric(difftime(date, floor_date(date, "year"), 
  units = "secs"))/as.numeric(difftime(ceiling_date(date, 
  "year"), floor_date(date, "year"), units = "secs"))
  
    year(date) + decimal
}

decimal_date.zoo <- function(date)
  decimal_date(index(date))

decimal_date.its <- function(date)
  decimal_date.default(attr(date, "dates"))


recognize <- function(x){
  recognized <- c("POSIXt", "POSIXlt", "POSIXct", "yearmon", "yearqtr", "Date")
  
  if (all(class(x) %in% recognized))
    return(TRUE)
  return(FALSE)
}


#' Lakers 2008-2009 basketball data set
#' 
#' This data set contains play by play statistics of each Los 
#' Angeles Lakers basketball game in the 2008-2009 season. Data 
#' includes the date, opponent, and type of each game (home or 
#' away). Each play is described by the time on the game clock 
#' when the play was made, the period in which the play was 
#' attempted, the type of play, the player and team who made the 
#' play, the result of the play, and the location on the court 
#' where each play was made.
#'  
#' @name lakers
#' @docType data
#' @references \url{http://www.basketballgeek.com/data/}
#' @keywords data
NULL