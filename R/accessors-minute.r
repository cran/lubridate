#' @include periods.r
NULL

#' Get/set minutes component of a date-time
#'
#' Date-time must be a  POSIXct, POSIXlt, Date, Period, chron, yearmon, yearqtr, zoo,
#' zooreg, timeDate, xts, its, ti, jul, timeSeries, and fts objects.
#'
#' @export
#' @param x a date-time object
#' @param value numeric value to be assigned
#' @keywords utilities manip chron methods
#' @return the minutes element of x as a decimal number
#' @examples
#' x <- ymd("2012-03-26")
#' minute(x)
#' minute(x) <- 1
#' minute(x) <- 61
#' minute(x) > 2
minute <- function(x) {
  UseMethod("minute")
}

#' @export
minute.default <- function(x) {
  as.POSIXlt(x, tz = tz(x))$min
}

#' @export
minute.Period <- function(x) {
  slot(x, "minute")
}

#' @rdname minute
#' @export
setGeneric("minute<-",
  function (x, value) standardGeneric("minute<-"),
  useAsDefault = function(x, value) {
    y <- update_datetime(as.POSIXct(x), minutes = value)
    reclass_date(y, x)
  }
)

#' @export
setMethod("minute<-", "Duration", function(x, value) {
  x <- x + minutes(value - minute(x))
})

#' @export
setMethod("minute<-", signature("Period"), function(x, value) {
  slot(x, "minute") <- value
  x
})

#' @export
setMethod("minute<-", "Interval", function(x, value) {
  x <- x + minutes(value - minute(x))
})

#' @export
setMethod("minute<-", "POSIXt", function(x, value) {
  update_datetime(x, minutes = value)
})

#' @export
setMethod("minute<-", "Date", function(x, value) {
  update_datetime(x, minutes = value)
})
