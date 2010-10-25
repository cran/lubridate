#' Description of time span classes in lubridate.
#'
#' A time span can be measured in three ways: as a duration, an interval, or a 
#' period. 
#'
#' Durations record the exact number of seconds in a time span. They measure the 
#' exact passage of time but do not always align with measurements 
#' made in larger units of time such as hours, months and years. 
#' This is because the length of larger time units can be affected 
#' by conventions such as leap years 
#' and Daylight Savings Time. Base R measures durations with the 
#' difftime class. lubridate provides an additional class, the duration class,
#' to facilitate working with durations. 
#'
#' durations display as the number of seconds that occur during a time span. If the number is large, a duration object will also display the length in a more convenient unit, but these measurements are only estimates 
#' given for convenience. The underlying object is always recorded as a fixed 
#' number of seconds. For display and creation purposes, units are converted to 
#' seconds using their most common lengths in seconds. Minutes = 60 seconds, 
#' hours = 3600 seconds, days = 86400 seconds. Units larger than 
#' days are not used due to their variability.
#' 
#' duration objects can be easily created with the helper functions 
#' \code{\link{dweeks}}, \code{\link{ddays}}, \code{\link{dhours}}, \code{\link{dminutes}} and 
#' \code{\link{dseconds}}. These objects can be added to and subtracted from date-
#' times to create a user interface similar to object oriented programming. 
#' Duration objects can be added to Date, POSIXt, and Interval objects.
#'
#' Periods record the change in the clock time between two date-times. They are 
#' measured in common time related units: years, months, days, hours, minutes, 
#' and seconds. Each unit except for seconds must be expressed in integer 
#' values. With the exception of seconds, none of these units have a fixed 
#' length. Leap years, leap seconds, and Daylight Savings Time can expand or 
#' contract a unit of time depending on when it occurs.  For this reason, periods 
#' do not have a fixed length until they are paired with a start date. Periods 
#' can be used to track changes in clock time. Because periods 
#' have a variable length, they must be paired with a start date 
#' as an interval (\code{\link{as.interval}}) before they can be  
#' accurately converted to and from durations.
#'
#' Period objects can be easily created with the helper functions 
#' \code{\link{years}}, \code{\link{months}}, \code{\link{weeks}}, 
#' \code{\link{days}}, \code{\link{minutes}}, \code{\link{seconds}}. These objects 
#' can be added to and subtracted to date-times to create a user interface 
#' similar to object oriented programming. Period objects can be added to Date, 
#' POSIXt, and Interval objects.
#'
#' Intervals are time spans bound by two real date-times.  Intervals can be 
#' accurately converted to periods and durations. Since an interval is anchored 
#' to a fixed moment of time, the exact length of all units of 
#' time during the interval can be calculated. To 
#' accurately convert between periods and durations, a period or duration should 
#' first be converted to an interval with \code{\link{as.interval}}. Subtracting two date times automatically 
#' creates an interval object. An interval displays as the start 
#' and end points of the time span it represents. By default, the #' date-time that occurs first is considered the start point. 
#' Hence, intervals are always positive.
#'
#' @aliases duration durations dur periods period interval intervals timespans
#' @name duration
#' @seealso \code{\link{new_duration}} for creating duration objects and
#'   \code{\link{as.duration}} for converting objects into durations, 
#'   \code{\link{new_interval}} for creating interval objects and
#'   \code{\link[lubridate]{as.interval}} for converting objects to intervals
#' @keywords classes chron
#' @examples
#' new_duration(second = 3690)
#' # 3690s (1.02h)
#' new_period(second = 3690)
#' # 3690 seconds
#' new_period(second = 30, minute = 1, hour = 1)
#' # 1 hour, 1 minute and 30 seconds
#' new_interval(ymd_hms("2009-08-09 13:01:30"), ymd_hms("2009-08-09 12:00:00"))
#' # 2009-08-09 12:00:00 -- 2009-08-09 13:01:30
#'
#' date <- as.POSIXct("2009-03-08 01:59:59") # DST boundary
#' # "2009-03-08 01:59:59 CST"
#' date + days(1)
#' # "2009-03-09 01:59:59 CDT" periods preserve clock time
#' date + edays(1)
#' # "2009-03-09 02:59:59 CDT" durations preserve exact passage of time
#'
#' date2 <- as.POSIXct("2000-02-29 12:00:00")
#' date2 + years(1)
#' # "2001-02-28 12:00:00 CST" 
#' # self corrects to most recent real day
#'
#' date3 <- as.POSIXct("2009-01-31 01:00:00")
#' date3 + c(0:11) * months(1)
#' # [1] "2009-01-31 01:00:00 CST" "2009-02-28 01:00:00 CST"
#' # [3] "2009-03-31 01:00:00 CDT" "2009-04-30 01:00:00 CDT"
#' # [5] "2009-05-31 01:00:00 CDT" "2009-06-30 01:00:00 CDT"
#' # [7] "2009-07-31 01:00:00 CDT" "2009-08-31 01:00:00 CDT"
#' # [9] "2009-09-30 01:00:00 CDT" "2009-10-31 01:00:00 CDT"
#' #[11] "2009-11-30 01:00:00 CST" "2009-12-31 01:00:00 CST"
#'
#' span <- date2 - date  #creates interval 
#' # 2000-02-29 12:00:00 -- 2009-03-08 01:59:59
#' span - days(294)
#' # 2000-02-29 12:00:00 -- 2008-05-18 01:59:59
#' span - ddays(294)
#' # 2000-02-29 12:00:00 -- 2008-05-18 02:59:59
#'
#' date <- as.POSIXct("2009-01-01 00:00:00") 
#' # "2009-01-01 GMT"
#' date + years(1)
#' # "2010-01-01 GMT"
#' date - days(3) + hours(6)
#' # "2008-12-29 06:00:00 GMT"
#' date + 3 * seconds(10)
#' # "2009-01-01 00:00:30 GMT"
#'
#' months(6) + days(1)
#' # 6 months and 1 day
NULL

#' Create a duration object.
#'
#' new_duration creates a duration object with the specified values. Entries for 
#' different units are cumulative. durations display as the number of seconds in a time span. When this number is large, durations also display an estimate in larger units,; however, the underlying object is 
#' always recorded as a fixed number of seconds. For display and creation 
#' purposes, units are converted to seconds using their most common lengths in 
#' seconds. Minutes = 60 seconds, hours = 3600 seconds, days = 86400 seconds, 
#' weeks = 604800. Units larger than weeks are not used due to their 
#' variability.
#'
#' Durations record the exact number of seconds in a time span. They measure the 
#' exact passage of time but do not always align with measurements 
#' made in larger units of time such as hours, months and years. 
#' This is because the length of larger time units can be affected 
#' by conventions such as leap years 
#' and Daylight Savings Time. Base R provides a second class for measuring durations, the difftime class.
#'
#' duration objects can be easily created with the helper functions 
#' \code{\link{dweeks}}, \code{\link{ddays}}, \code{\link{dminutes}}, 
#' \code{\link{dseconds}}. These objects can be added to and subtracted to date-
#' times to create a user interface similar to object oriented programming. 
#'
#' @param num the number of seconds to be included in the period (if not listing time units).
#' @param ... a list of time units to be included in the duration and their amounts. Seconds, 
#'   minutes, hours, days, and weeks are supported.
#' @return a duration object
#' @S3method format duration
#' @S3method print duration
#' @S3method rep duration
#' @S3method "%%" duration
#' @S3method "%/%" duration
#' @S3method "%%" difftime
#' @S3method "%/%" difftime
#' @S3method "/" duration
#' @S3method "*" duration
#' @S3method "+" duration
#' @S3method "-" duration
#' @S3method format duration
#' @S3method print duration
#' @S3method rep duration
#' @export new_duration
#' @seealso \code{\link{duration}}, \code{\link{as.duration}}
#' @keywords chron classes
#' @examples
#' new_duration(second = 90)
#' # 90s
#' new_duration(minute = 1.5)
#' # 90s
#' new_duration(second = 3, minute = 1.5, hour = 2, day = 6, week = 1)
#' # 1130493s (13.08d)
#' new_duration(hour = 1, minute = -60)
#' # 0s
#' new_duration(day = -1)
#' # -86400s (-1d)
new_duration <- function(num = 0,...){
  pieces <- list(...)
  names(pieces) <- standardise_difftime_names(names(pieces))
  
  defaults <- list(secs = 0, mins = 0, hours = 0, days = 0, weeks = 0)
  pieces <- c(pieces, defaults[setdiff(names(defaults), names(pieces))])
  
  x <- num + pieces$secs +
    pieces$mins * 60 +
    pieces$hours * 3600 +
    pieces$days * 86400 +
    pieces$weeks * 604800
  
  structure(x, class = c("duration", "numeric"))
}





#' Create a difftime object.
#'
#' new_difftime creates a difftime object with the specified number of units. Entries for 
#' different units are cumulative. difftime displays durations in various units, 
#' but these units are estimates given for convenience. The underlying object is 
#' always recorded as a fixed number of seconds. For display and creation 
#' purposes, units are converted to seconds using their most common lengths in 
#' seconds. Minutes = 60 seconds, hours = 3600 seconds, days = 86400 seconds, 
#' weeks = 604800. Units larger than weeks are not used due to their 
#' variability.
#'
#' difftime objects are durations. Durations are time spans measured in seconds. They measure the 
#' exact passage of time but do not always align with measurements 
#' made in larger units of time such as hours, months and years. 
#' This is because the length of larger time units can be affected 
#' by conventions such as leap years 
#' and Daylight Savings Time. lubridate provides a second class for measuring durations, the duration class.
#'
#' @param ... a list of time units to be included in the difftime and their amounts. Seconds, 
#'   minutes, hours, days, and weeks are supported. 
#' @return a difftime object
#' @export new_difftime
#' @seealso \code{\link{duration}}, \code{\link{as.duration}}
#' @keywords chron classes
#' @examples
#' new_difftime(second = 90)
#' # Time difference of 1.5 mins
#' new_difftime(minute = 1.5)
#' # Time difference of 1.5 mins
#' new_difftime(second = 3, minute = 1.5, hour = 2, day = 6, week = 1)
#' # Time difference of 1.869201 weeks
#' new_difftime(hour = 1, minute = -60)
#' # Time difference of 0 secs
#' new_difftime(day = -1)
#' # Time difference of -1 days
new_difftime <- function(...){
  pieces <- list(...)
  names(pieces) <- standardise_difftime_names(names(pieces))
  
  defaults <- list(secs = 0, mins = 0, hours = 0, days = 0, weeks = 0)
  pieces <- c(pieces, defaults[setdiff(names(defaults), names(pieces))])
  
  x <- pieces$secs +
    pieces$mins * 60 +
    pieces$hours * 3600 +
    pieces$days * 86400 +
    pieces$weeks * 604800
  
  make_difftime(x)
}

#' Change an object to a duration (difftime).
#'
#' as.duration changes interval, period and numeric objects to 
#' duration objects. Numeric objects are changed to duration objects 
#' with the seconds unit equal to the numeric value. 
#'
#' Durations are exact time measurements, whereas periods are relative time 
#' measurements. See \code{\link{periods}}. The length of a period depends on 
#' when it occurs. Hence, a one to one mapping does not exist between durations 
#' and periods. When used with a period object, as.duration provides an inexact 
#' estimate of the length of the period; each time unit is assigned its most 
#' common number of seconds. Periods with a months unit cannot be coerced to 
#' durations because of the variability of month lengths. For an exact 
#' transformation, first transform the period to an interval with 
#' \code{\link{as.interval}}.
#'
#' @export as.duration 
#' @S3method as.duration default 
#' @S3method as.duration period 
#' @S3method as.duration interval 
#' @S3method as.duration difftime
#' @param x an interval, period, or numeric object   
#' @return a duration object
#' @seealso \code{\link{duration}}, \code{\link{new_duration}}
#' @keywords classes manip methods chron
#' @examples
#' span <- new_interval(ymd("2009-01-01"), ymd("2009-08-01")) #interval
#' # 2009-01-01 -- 2009-08-01 
#' as.duration(span)
#' # 18316800s (212d)
#' as.duration(10) # numeric
#' # 10s
as.duration <- function(x)
  UseMethod("as.duration")
  

as.duration.period <- function(x){
	message("estimate only: convert periods to intervals for accuracy")
	dur <- x$second +
		   60 * x$minute +
		   60 * 60 * x$hour +
		   60 * 60 * 24 * x$day +
		   60 * 60 * 24 * 30 * x$month +
		   60 * 60 * 24 * 365.25 * x$year
	structure(dur, class = c("duration", "numeric"))
}


as.duration.difftime <- function(x)
  structure(as.numeric(x, "secs"), class = c("duration", "numeric"))
  
as.duration.interval <- function(x){
  structure(unclass(x), class = c("duration", "numeric"))
}

as.duration.default <- function(x)
  structure(x, class = c("duration", "numeric"))


as.POSIXt <- function(x) as.POSIXlt(x)

#' Quickly create exact time spans.
#'
#' Quickly create duration objects for easy date-time manipulation. The units of 
#' the duration created depend on the name of the function called. For duration 
#' objects, units are equal to their most common lengths in seconds (i.e. 
#' minutes = 60 seconds, hours = 3600 seconds, days = 86400 seconds, weeks = 
#' 604800, years = 31536000).
#'
#' When paired with date-times, these functions allow date-times to be 
#' manipulated in a method similar to object oriented programming. Duration 
#' objects can be added to Date, POSIXt, and Interval objects.
#'
#' @export eseconds eminutes ehours edays eweeks eyears dseconds dminutes dhours ddays dweeks dyears
#' @aliases eseconds eminutes ehours edays eweeks eyears dseconds dminutes dhours ddays dweeks dyears
#' @param x numeric value of the number of units to be contained in the duration. 
#' @return a duration object
#' @seealso \code{\link{duration}}, \code{\link{new_duration}}, \code{\link{days}}
#' @keywords chron manip
#' @examples
#' dseconds(1) 
#' # 1s
#' dminutes(3.5) 
#' # 210s
#'
#' x <- as.POSIXct("2009-08-03") 
#' # "2009-08-03 CDT"
#' x + ddays(1) + dhours(6) + dminutes(30)
#' # "2009-08-04 06:30:00 CDT"
#' x + ddays(100) - dhours(8) 
#' # "2009-11-10 15:00:00 CST"
#' 
#' class(as.Date("2009-08-09") + ddays(1)) # retains Date class
#' # "Date"
#' as.Date("2009-08-09") + dhours(12) 
#' # "2009-08-09 12:00:00 UTC"
#' class(as.Date("2009-08-09") + dhours(12)) 
#' # "POSIXt"  "POSIXct"
#' # converts to POSIXt class to accomodate time units
#' 
#' dweeks(1) - ddays(7) 
#' # 0s
#' c(1:3) * dhours(1) 
#' # 3600s  7200s  10800s
#' #
#' # compare DST handling to durations
#' boundary <- as.POSIXct("2009-03-08 01:59:59")
#' # "2009-03-08 01:59:59 CST"
#' boundary + days(1) # period
#' # "2009-03-09 01:59:59 CDT" (clock time advances by a day)
#' boundary + ddays(1) # duration
#' # "2009-03-09 02:59:59 CDT" (clock time corresponding to 86400 seconds later)
dseconds <- eseconds <- function(x = 1) new_duration(second = x)
dminutes <- eminutes <- function(x = 1) new_duration(minute = x)
dhours <- ehours <-   function(x = 1) new_duration(hour = x)
ddays <- edays <-    function(x = 1) new_duration(day = x)  
dweeks <- eweeks <-   function(x = 1) new_duration(week = x)
dyears <- eyears <- function(x = 1) new_duration(second = x * 31536000)


#' Is x a date-time object?
#'
#' An instant is a specific moment in time. Most common date-time 
#' objects (e.g, POSIXct, POSIXlt, and Date objects) are instants.
#'
#' @export is.instant is.timepoint
#' @aliases instant instants is.instant timepoint is.timepoint
#' @param x an R object   
#' @return TRUE if x is a POSIXct, POSIXlt, or Date object, FALSE otherwise.
#' @seealso \code{\link{is.timespan}}, \code{\link{is.POSIXt}}, \code{\link{is.Date}}
#' @keywords logic chron
#' @examples
#' is.instant(as.Date("2009-08-03")) # TRUE
#' is.timepoint(5) # FALSE
is.instant <- is.timepoint <- function(x) inherits(x, c("POSIXt", "POSIXct", "POSIXlt", "Date"))

#' Is x a length of time?
#'
#' @export is.timespan 
#' @aliases is.timespan
#' @param x an R object   
#' @return TRUE if x is a period, interval, duration, or difftime object, FALSE otherwise.
#' @seealso \code{\link{is.instant}}, \code{\link{is.duration}}, \code{\link{is.difftime}}, \code{\link{is.period}}, \code{\link{is.interval}}
#' @keywords logic chron
#' @examples
#' is.timespan(as.Date("2009-08-03")) # FALSE
#' is.timespan(new_duration(second = 1)) # TRUE
is.timespan <- function(x) inherits(x,c("period", "difftime", "duration", "interval"))

#' Is x a POSIXct or POSIXlt object?
#'
#' @export is.POSIXt is.POSIXlt is.POSIXct
#' @aliases is.POSIXt is.POSIXlt is.POSIXct
#' @param x an R object   
#' @return TRUE if x is a POSIXct or POSIXlt object, FALSE otherwise.
#' @seealso \code{\link{is.instant}}, \code{\link{is.timespan}}, \code{\link{is.Date}}
#' @keywords logic chron
#' @examples
#' is.POSIXt(as.Date("2009-08-03")) # FALSE
#' is.POSIXt(as.POSIXct("2009-08-03")) # TRUE
is.POSIXt <- function(x) inherits(x, c("POSIXt", "POSIXct", "POSIXlt"))
is.POSIXlt <- function(x) inherits(x, "POSIXlt")
is.POSIXct <- function(x) inherits(x, "POSIXct")

#' Is x a duration object?
#'
#' @export is.duration
#' @param x an R object   
#' @return TRUE if x is a duration object, FALSE otherwise.
#' @seealso \code{\link{is.instant}}, \code{\link{is.timespan}}, \code{\link{is.interval}}, 
#'   \code{\link{is.period}}, \code{\link{duration}}
#' @keywords logic chron
#' @examples
#' is.duration(as.Date("2009-08-03")) # FALSE
#' is.duration(new_duration(days = 12.4)) # TRUE
is.duration <- function(x) inherits(x, "duration")

#' Is x a difftime object?
#'
#' @export is.difftime
#' @param x an R object   
#' @return TRUE if x is a difftime object, FALSE otherwise.
#' @seealso \code{\link{is.instant}}, \code{\link{is.timespan}}, \code{\link{is.interval}}, 
#'   \code{\link{is.period}}.
#' @keywords logic chron
#' @examples
#' is.difftime(as.Date("2009-08-03")) # FALSE
#' is.difftime(new_difftime(days = 12.4)) # TRUE
is.difftime <- function(x) inherits(x, "difftime")

#' Is x a Date object?
#'
#' @export is.Date
#' @param x an R object   
#' @return TRUE if x is a Date object, FALSE otherwise.
#' @seealso \code{\link{is.instant}}, \code{\link{is.timespan}}, \code{\link{is.POSIXt}}
#' @keywords logic chron
#' @examples
#' is.Date(as.Date("2009-08-03")) # TRUE
#' is.Date(difftime(now() + 5, now())) # FALSE
is.Date <- function(x) inherits(x, "Date")


#' Is x a period object?
#'
#' @export is.period
#' @param x an R object   
#' @return TRUE if x is a period object, FALSE otherwise.
#' @seealso \code{\link{is.instant}}, \code{\link{is.timespan}}, \code{\link{is.interval}}, 
#'   \code{\link{is.duration}}, \code{\link{period}}
#' @keywords logic chron
#' @examples
#' is.period(as.Date("2009-08-03")) # FALSE
#' is.period(new_period(months= 1, days = 15)) # TRUE
is.period <- function(x) inherits(x,"period")

#' Is x an interval object?
#'
#' @export is.interval
#' @param x an R object   
#' @return TRUE if x is an interval object, FALSE otherwise.
#' @seealso \code{\link{is.instant}}, \code{\link{is.timespan}}, \code{\link{is.period}}, 
#'   \code{\link{is.duration}}, \code{\link{interval}}
#' @keywords logic chron
#' @examples
#' is.interval(new_period(months= 1, days = 15)) # FALSE
#' is.interval(new_interval(ymd(20090801), ymd(20090809))) # TRUE
is.interval <- function(x) inherits(x, c("interval"))


standardise_difftime_names <- function(x) {
  dates <- c("secs", "mins", "hours", "days", "weeks")
  y <- gsub("(.)s$", "\\1", x)
  y <- substr(y, 1, 3)
  res <- dates[pmatch(y, dates)]
  if (any(is.na(res))) {
    stop("Invalid difftime name: ", paste(x[is.na(res)], collapse = ", "), 
      call. = FALSE)
  }
  res
}

compute_estimate <- function (x) {  
  seconds <- abs(x)
    if (any(seconds < 60)) 
        units <- "secs"
    else if (any(seconds < 3600))
        units <- "mins"
    else if (any(seconds < 86400))
        units <- "hours"
    else if (any(seconds < 31557600))
        units <- "days"
    else
    	units <- "years"
    
    switch(units, secs = paste(round(x, 2), "s", sep = ""), 
      mins = paste(round(x/60, 2), "m", sep = ""), 
      hours = paste(round(x/3600, 2), "h", sep = ""), 
      days = paste(round(x/86400, 2), "d", sep = ""), 
      years = paste(round(x/31557600, 2), "y", sep = ""))
}


format.duration <- function(x, ...){
  if (all(abs(unclass(x)) < 3600))
  	return(paste(format(unclass(x),...), "s", sep = ""))
  else
  	paste(format(unclass(x),...), "s", " (", compute_estimate(x), ") ", sep = "") 
}


print.duration <- function(x, ...) {
  print(format(x), ..., quote = FALSE)
}


rep.duration <- function(x, ...){
	structure(rep(as.numeric(x), ...), class = c("duration", "numeric"))
}