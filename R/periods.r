#' Create a period object.
#'
#' new_period creates a period object with the specified values. Within a 
#' period object, time units do not have a fixed length (except for seconds) 
#' until they are added to a date-time. The length of each time unit will 
#' depend on the date-time to which it is added. For example, a year that 
#' begins on 2009-01-01 will be 365 days long.  A year that begins on 
#' 2012-01-01 will be 366 days long. When math is performed with a period 
#' object, each unit is applied separately. How a period is distributed among 
#' the time units is non-trivial. For example, when leap seconds occur 1 minute 
#' is longer than 60 seconds.
#'
#' Periods track the change in the "clock time" between two date-times. They 
#' are measured in common time related units: years, months, days, hours, 
#' minutes, and seconds. Each unit except for seconds must be expressed in 
#' integer values. 
#'
#' Period objects can be easily created with the helper functions 
#' \code{\link{years}}, \code{\link{months}}, \code{\link{weeks}}, 
#' \code{\link{days}}, \code{\link{minutes}}, \code{\link{seconds}}. These objects 
#' can be added to and subtracted to date-times to create a user interface 
#' similar to object oriented programming.
#'
#' @param ... a list of time units to be included in the period and their amounts. Seconds, minutes, 
#'   hours, days, weeks, months, and years are supported. See \code{\link{standardise_date_names}} 
#'   for more details.
#' @return a period object
#' @seealso \code{\link{period}}, \code{\link{as.period}}
#' @keywords chron classes
#' @examples
#' new_period (second = 90, minute = 5)
#' #  5 minutes and 90 seconds
#' new_period(day = -1)
#' # -1 days
#' new_period(second = 3, minute = 1, hour = 2, day = 6, week = 1)
#' # 13 days, 2 hours, 1 minute and 3 seconds
#' new_period(hour = 1, minute = -60)
#' # 1 hour and -60 minutes
#' new_period(second = 0)
#' # 0 seconds
new_period <- function(...) {
  pieces <- data.frame(...)
    
  names(pieces) <- standardise_date_names(names(pieces))
  defaults <- data.frame(
    second = 0, minute = 0, hour = 0, day = 0, week = 0, 
    month = 0, year = 0
  )
  
  pieces <- cbind(pieces, defaults[setdiff(names(defaults), names(pieces))])
  pieces <- pieces[c("year", "month", "week", "day", "hour", "minute", "second")] 
  
  pieces$day <- pieces$day + pieces$week * 7
  pieces <- pieces[,-3]
  
  if(any(trunc(pieces[,1:5]) - pieces[,1:5] != 0))
    stop("periods must have integer values", call. = FALSE)
  
  structure(pieces, class = c("period", "data.frame"))
}

#' Quickly create relative timespans.
#'
#' Quickly create period objects for easy date-time manipulation. The units of 
#' the period created depend on the name of the function called. For period 
#' objects, units do not have a fixed length until they are added to a specific 
#' date time, contrast this with \code{\link{durations}}. This makes periods 
#' useful for manipulations with clock times because units expand or contract 
#' in length to accomodate conventions such as leap years, leap seconds, and 
#' Daylight Savings Time. 
#'
#' When paired with date-times, these functions allow date-times to be 
#' manipulated in a method similar to object oriented programming. Period 
#' objects can be added to Date, POSIXt, and Interval objects.
#' 
#' y, m, w, d are predefined period objects such that y = 1 year, m = 1 month, w = 1 week, d = 1 day.
#'
#' @aliases seconds minutes hours days weeks months years y m w d
#' @param x numeric value of the number of units to be contained in the period. With the exception 
#'   of seconds(), x must be an integer. 
#' @return a period object
#' @seealso \code{\link{period}}, \code{\link{new_period}}, \code{\link{edays}}
#' @keywords chron manip
#' @examples
#' eseconds(1) 
#' # Time difference of 1 secs
#' eminutes(3.5) 
#' # Time difference of 3.5 mins
#'
#' x <- as.POSIXct("2009-08-03") 
#' # "2009-08-03 CDT"
#' x + days(1) + hours(6) + minutes(30)
#' # "2009-08-04 06:30:00 CDT"
#' x + days(100) - hours(8) 
#' # "2009-11-10 15:00:00 CST"
#' 
#' class(as.Date("2009-08-09") + days(1)) # retains Date class
#' # "Date"
#' as.Date("2009-08-09") + hours(12) 
#' # "2009-08-09 12:00:00 UTC"
#' class(as.Date("2009-08-09") + hours(12)) 
#' # "POSIXt"  "POSIXct"
#' # converts to POSIXt class to accomodate time units
#' 
#' years(1) - months(7) 
#' # 1 year and -7 months
#' c(1:3) * hours(1) 
#' # 1 hour   2 hours   3 hours
#' hours(1:3)
#' # 1 hour   2 hours   3 hours
#'
#' #sequencing
#' y <- ymd(090101) # "2009-01-01 CST"
#' y + months(0:11)
#' # [1] "2009-01-01 CST" "2009-02-01 CST" "2009-03-01 CST" "2009-04-01 CDT"
#' # [5] "2009-05-01 CDT" "2009-06-01 CDT" "2009-07-01 CDT" "2009-08-01 CDT"
#' # [9] "2009-09-01 CDT" "2009-10-01 CDT" "2009-11-01 CDT" "2009-12-01 CST"
#' 
#' # end of month handling
#' ymd(20090131) + months(0:11)
#' # Undefined date. Defaulting to last previous real day.
#' # [1] "2009-01-31 CST" "2009-02-28 CST" "2009-03-31 CDT" "2009-04-30 CDT"
#' # [5] "2009-05-31 CDT" "2009-06-30 CDT" "2009-07-31 CDT" "2009-08-31 CDT"
#' # [9] "2009-09-30 CDT" "2009-10-31 CDT" "2009-11-30 CST" "2009-12-31 CST"
#' 
#' # compare DST handling to durations
#' boundary <- as.POSIXct("2009-03-08 01:59:59")
#' # "2009-03-08 01:59:59 CST"
#' boundary + days(1) # period
#' # "2009-03-09 01:59:59 CDT" (clock time advances by a day)
#' boundary + edays(1) # duration
#' # "2009-03-09 02:59:59 CDT" (clock time corresponding to 86400 seconds later)
seconds <- function(x = 1) new_period(second = x)
minutes <- function(x = 1) new_period(minute = x)
hours <-   function(x = 1) new_period(hour = x)
days <-    function(x = 1) new_period(day = x)  
weeks <-   function(x = 1) new_period(week = x)
months <-  function(x = 1) new_period(month = x)
years <-   function(x = 1) new_period(year = x)

#' Internal function. Formats period objects.
#'
#' @method format period
#' @keywords internal print chron
format.period <- function(x, ...){
  show <- vector(mode = "character")
  for (i in 1:nrow(x)){
    per <- x[i,]
  
    per <- per[which(per != 0)]
    if (length(per) == 0) show[i] <- "0 seconds"
    
    else{
      singular <- names(per)
         plural <- paste(singular, "s", sep = "")
    
        IDs <-paste(per, ifelse(!is.na(per) & per == 1, singular, plural))
          if(length(IDs) == 1) show[i] <- IDs
        else
          show[i] <- paste(paste(IDs[-length(IDs)], collapse = ", "), IDs[length(IDs)],sep = " and ")
      }
    }
    paste(show, collapse = "   ")
}

#' Internal method for printing interval objects.
#'
#' @keywords internal print chron
#' @method print period
print.period <- function(x, ...) {
  print(format(x), ..., quote = FALSE)
}

#' Change an object to a period.
#'
#' as.period changes interval, duration (i.e., difftime)  and numeric objects 
#' to period objects with the specified units.
#'
#' Users must specify which time units to measure the period in. The length of 
#' each time unit in a period depends on when it occurs. See 
#' \code{\link{periods}}. The choice of units is not trivial; units that are 
#' normally equal may differ in length depending on when the time period 
#' occurs. For example, when a leap second occurs one minute is longer than 60 
#' seconds.
#'
#' Because periods do not have a fixed length, they can not be accurately 
#' converted to and from duration objects. Duration objects measure time spans 
#' in exact numbers of seconds, see \code{\link{duration}}. Hence, a one to one 
#' mapping does not exist between durations and periods. When used with a 
#' duration object, as.period provides an inexact estimate; the duration is 
#' broken into time units based on the most common lengths of time units, in 
#' seconds. Because the length of months are particularly variable, a period 
#' with a months unit can not be coerced from a duration object. For an exact 
#' transformation, first transform the duration to an interval with 
#' \code{\link{as.interval}}.
#'
#' @aliases as.period as.period.default as.period.difftime as.period.interval
#' @param x an interval, difftime, or numeric object   
#' @param units a character vector. The names of the units to divide the
#'   period among. Years, months, days, hours, minutes, and seconds are
#'   supported, see \code{\link{standardise_date_names}} for more details. The
#'   largest units should be listed first. As much of the period as possible
#'   will be assigned to the first unit. As much of the remainder as possible
#'   will be assigned to the second unit and so on until all listed units have
#'   been handled. After the period has been distributed across all listed
#'   units, any remaining time will be added to the period in seconds units.
#'   If no units are provided, as.period will use all available units by
#'   default.
#' @return a period object
#' @seealso \code{\link{period}}, \code{\link{new_period}}
#' @keywords classes manip methods chron
#' @examples
#' span <- new_interval(as.POSIXct("2009-01-01"), as.POSIXct("2010-02-02 01:01:01")) #interval
#' # 397.0424 days beginning at 2009-01-01
#' as.period(span)
#' # 1 year, 1 month, 1 day, 1 hour, 1 minute and 1 second
#' as.period(span, units = c("year")) 
#' # 1 year and 2768461 seconds
#' as.period(span, units = c("day", "minute")) 
#' # 1 day, 1 minute and 34218001 seconds
as.period <- function(x, units)
  UseMethod("as.period")
  
as.period.default <- function(x, units = c("seconds")){
  x <- as.numeric(x)
  unit <- standardise_date_names(units[1])
  f <- match.fun(paste(unit, "s", sep = ""))
  f(x)
}

as.period.interval <- function(x, units = NULL){
  start <- as.POSIXlt(x$start)
  end <- as.POSIXlt(x$end)

  to.per <- as.data.frame(unclass(end)) - 
    as.data.frame(unclass(start))
    
  names(to.per)[1:6] <- c("second", "minute", "hour", "day", "month", "year")
  
  new_period(to.per[,1:6])
}

as.period.difftime <- function(x, units = c("year", "day", "hour", "minute", "seconds")){
  units <- standardise_date_names(units)
  span <- as.double(x, "secs")
  remainder <- abs(span)
  newper <- new_period(second = rep(0, length(x)))
  denominator <- c(second = 1, minute = 60, hour = 3600, day = (3600 * 24), year =  (3600 * 24 * 7 * 365))
  
  if ("month" %in% units) 
    stop("month length cannot be estimated from durations", call. = FALSE)
  
  for (i in 1:length(units)){
    bite <- switch(units[i], 
      "second" = remainder, 
      "minute" = remainder %/% 60 * 60, 
      "hour" = remainder %/% 3600 * 3600, 
      "day" = remainder %/% (3600 * 24) * (3600 * 24), 
      "year" = remainder %/% (3600 * 24 * 7 * 365) * (3600 * 24 * 7 * 365))
    remainder <- remainder - bite
    newper[units[i]] <- bite / denominator[[units[i]]]
  }
  
  newper$second <- newper$second + remainder
  newper * sign(span)
}
