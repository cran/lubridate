#' Get/set time zone component of a date-time.
#'
#' Time zones are stored as character strings in an 
#' attribute of date-time objects. tz returns a date's time zone attribute. 
#' When used as a settor, it changes the time zone attribute. R does not come with 
#' a predefined list zone names, but relies on the user's OS to interpret time zone 
#' names. As a result, some names will be recognized on some computers but not others.
#' Most computers, however, will recognize names in the timezone data base originally 
#' compiled by Arthur Olson. These names normally take the form "Country/City." A 
#' convenient listing of these timezones can be found at 
#' \url{http://en.wikipedia.org/wiki/List_of_tz_database_time_zones}.
#'
#' Setting tz does not update a date-time to display the same moment as measured 
#' at a different time zone. See \code{\link{with_tz}}. Setting a new time zone 
#' creates a new date-time. The numerical value of the hours element stays the 
#' same, only the time zone attribute is replaced.  This creates a new date-time 
#' that occurs an integer value of hours before or after the original date-time.  
#'
#' If x is of a class that displays all date-times in the GMT timezone, such as 
#' chron, then R will update the number in the hours element to display the new 
#' date-time in the GMT timezone. 
#'
#' For a description of the time zone attribute, see \code{\link[base]{timezones}} 
#' or \code{\link[base]{DateTimeClasses}}. 
#'
#' @export
#' @aliases tz tz<-
#' @param x a date-time object of class a POSIXct, POSIXlt, Date, chron, yearmon, 
#' yearqtr, zoo, zooreg, timeDate, xts, its, ti, jul, timeSeries, fts or anything else that can 
#' be coerced to POSIXlt with as.POSIXlt
#' @return the first element of x's tzone attribute vector as a character string. If no tzone 
#'   attribute exists, tz returns "GMT".
#' @keywords utilities manip chron methods
#' @examples
#' x <- ymd("2012-03-26")
#' tz(x) 
#' tz(x) <- "GMT"  
#' x
#' \dontrun{
#' tz(x) <- "America/New_York"
#' x
#' tz(x) <- "America/Chicago"
#' x
#' tz(x) <- "America/Los_Angeles"
#' x
#' tz(x) <- "Pacific/Honolulu"
#' x
#' tz(x) <- "Pacific/Auckland"
#' x
#' tz(x) <- "Europe/London"
#' x
#' tz(x) <- "Europe/Berlin"
#' x
#' }
#' Sys.setenv(TZ = "GMT")
#' now()
#' tz(now())
#' Sys.unsetenv("TZ")
tz <- function (x) 
  UseMethod("tz")

#' @export
tz.default <- function(x) {
  if (is.null(attr(x,"tzone")) && !is.POSIXt(x))
    return("UTC")
  tzs <- attr(as.POSIXlt(x),"tzone")
  tzs[1]
}

#' @export
tz.zoo <- function(x){
  tzs <- attr(as.POSIXlt(zoo::index(x)), "tzone")
  tzs[1]
}

#' @export
tz.timeSeries <- function(x)
  x@FinCenter

#' @export
tz.irts <- function(x)
  return("GMT")

#' @export
"tz<-" <- function(x, value){
  new <- force_tz(x, value)
  reclass_date(new, x)
}
