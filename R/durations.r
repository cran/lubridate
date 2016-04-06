#' @include timespans.r
#' @include difftimes.r

check_duration <- function(object){
	if (is.numeric(object@.Data))
		TRUE
	else
		"Duration value is not a number. Should be numeric."
}


#' Duration class
#'
#' Duration is an S4 class that extends the \code{\link{Timespan-class}} class.
#' Durations record the exact number of seconds in a time span. They measure the
#' exact passage of time but do not always align with measurements
#' made in larger units of time such as hours, months and years.
#' This is because the exact length of larger time units can be affected
#' by conventions such as leap years
#' and Daylight Savings Time.
#'
#' Durations provide a method for measuring generalized timespans when we wish to
#' treat time as a mathematical quantity that increases in a uniform, monotone manner
#' along a continuous numberline. They allow exact comparisons with other durations.
#' See \code{\link{Period-class}} for an alternative way to measure timespans that better
#' preserves clock times.
#'
#' Durations class objects have one slot: .Data, a numeric object equal to the number
#' of seconds in the duration.
#'
#' @name Duration-class
#' @rdname Duration-class
#' @exportClass Duration
#' @aliases Compare,Duration,ANY-method Compare,Duration,Duration-method
#' Compare,difftime,Duration-method as.numeric,Duration-method
#' show,Duration-method c,Duration-method rep,Duration-method [,Duration-method
#' [<-,Duration,ANY,ANY,ANY-method [[,Duration-method
#' [[<-,Duration,ANY,ANY,ANY-method $,Duration-method $<-,Duration-method
#' as.difftime,Duration-method as.character,Duration-method
#' +,Duration,Duration-method +,Duration,Interval-method
#' +,Duration,Period-method +,Duration,Date-method +,Date,Duration-method
#' +,Duration,difftime-method +,difftime,Duration-method
#' +,Duration,numeric-method +,numeric,Duration-method +,Duration,POSIXct-method
#' +,POSIXct,Duration-method +,Duration,POSIXlt-method +,POSIXlt,Duration-method
#' /,Duration,Duration-method /,Duration,Interval-method
#' /,Duration,Period-method /,Duration,difftime-method
#' /,difftime,Duration-method /,Duration,numeric-method
#' /,numeric,Duration-method *,Duration,ANY-method *,ANY,Duration-method
#' %%,Duration,Duration-method %%,Duration,Interval-method
#' %%,Duration,Period-method -,Duration,missing-method -,ANY,Duration-method
setClass("Duration", contains = c("Timespan", "numeric"), validity = check_duration)


SECONDS_IN_ONE <- c(
  second = 1,
  minute = 60,
  hour   = 3600,
  day    = 86400,
  year   = 31557600
)

compute_estimate <- function (x) {
  seconds <- abs(na.omit(x))
  unit <- if (length(seconds) == 0 || any(seconds < SECONDS_IN_ONE[["minute"]]))
    "second"
  else if (any(seconds < SECONDS_IN_ONE[["hour"]]))
    "minute"
  else if (any(seconds < SECONDS_IN_ONE[["day"]]))
    "hour"
  else if (any(seconds < SECONDS_IN_ONE[["year"]]))
    "day"
  else "year"
  x <- x / SECONDS_IN_ONE[[unit]]
  approx_prefix <- ifelse(unit != "second" & !is.na(x), "~", "")
  paste(approx_prefix, round(x, 2), " ", unit, "s", sep = "")
}


#' @export
setMethod("show", signature(object = "Duration"), function(object){
	print(format.Duration(object), quote = TRUE)
})

#' @export
format.Duration <- function(x, ...) {
  if (length(x@.Data) == 0) return("Duration(0)")
  show <- vector(mode = "character")
  na <- is.na(x)

	if (all(abs(na.omit(x@.Data)) < 120))
		show <- paste(x@.Data, "s", sep = "")
	else
		show <- paste(x@.Data, "s", " (", compute_estimate(x@.Data), ")", sep = "")
  show[na] <- NA
  show
}

#' @export
setMethod("c", signature(x = "Duration"), function(x, ...){
	durs <- c(x@.Data, unlist(list(...)))
	new("Duration", durs)
})

#' @export
setMethod("rep", signature(x = "Duration"), function(x, ...){
	new("Duration", rep(as.numeric(x), ...))
})

#' @export
setMethod("[", signature(x = "Duration"),
  function(x, i, j, ..., drop = TRUE) {
    new("Duration", x@.Data[i])
})

#' @export
setMethod("[[", signature(x = "Duration"),
  function(x, i, j, ..., exact = TRUE) {
    new("Duration", x@.Data[i])
})

#' @export
setMethod("[<-", signature(x = "Duration"),
  function(x, i, j, ..., value) {
  	x@.Data[i] <- value
    new("Duration", x@.Data)
})

#' @export
setMethod("[[<-", signature(x = "Duration"),
  function(x, i, j, ..., value) {
    x@.Data[i] <- as.numeric(value)
    new("Duration", x@.Data)
})


#' @export
#' @importFrom methods Compare
setMethod("Compare", c(e1 = "Duration", e2 = "ANY"),
          function(e1, e2){
            stop(sprintf("Incompatible duration classes (%s, %s). Please coerce with `as.duration`.",
                         class(e1), class(e2)),
                 call. = FALSE)
          })

#' @export
setMethod("Compare", c(e1 = "difftime", e2 = "Duration"),
          function(e1, e2){
            callGeneric(as.numeric(e1, "secs"),
                        as.numeric(e2, "secs"))
          })

#' @export
setMethod("Compare", c(e1 = "Duration", e2 = "Duration"),
          function(e1, e2){
            callGeneric(e1@.Data, e2@.Data)
          })


#' Create a duration object.
#'
#' \code{duration} creates a duration object with the specified values. Entries
#' for different units are cumulative. durations display as the number of
#' seconds in a time span. When this number is large, durations also display an
#' estimate in larger units,; however, the underlying object is always recorded
#' as a fixed number of seconds. For display and creation purposes, units are
#' converted to seconds using their most common lengths in seconds. Minutes = 60
#' seconds, hours = 3600 seconds, days = 86400 seconds, weeks = 604800. Units
#' larger than weeks are not used due to their variability.
#'
#' Durations record the exact number of seconds in a time span. They measure the
#' exact passage of time but do not always align with measurements
#' made in larger units of time such as hours, months and years.
#' This is because the length of larger time units can be affected
#' by conventions such as leap years
#' and Daylight Savings Time. Base R provides a second class for measuring
#' durations, the difftime class.
#'
#' Duration objects can be easily created with the helper functions
#' \code{\link{dweeks}}, \code{\link{ddays}}, \code{\link{dminutes}},
#' \code{\link{dseconds}}. These objects can be added to and subtracted to date-
#' times to create a user interface similar to object oriented programming.
#'
#' @param num the number of time units to include in the duration
#' @param units a character string that specifies the type of units that num
#'   refers to.
#' @param ... a list of time units to be included in the duration and their
#'   amounts. Seconds, minutes, hours, days, and weeks are supported.
#' @return a duration object
#' @seealso \code{\link{as.duration}}
#' @keywords chron classes
#' @examples
#' duration(day = -1)
#' # -86400s (~-1 days)
#' duration(90, "seconds")
#' # 90s
#' duration(1.5, "minutes")
#' # 90s
#' duration(-1, "days")
#' # -86400s (~-1 days)
#' duration(second = 90)
#' # 90s
#' duration(minute = 1.5)
#' # 90s
#' duration(mins = 1.5)
#' # 90s
#' duration(second = 3, minute = 1.5, hour = 2, day = 6, week = 1)
#' # 1130493s (~13.08 days)
#' duration(hour = 1, minute = -60)
#' # 0s
#' @export
duration <- function(num = NULL, units = "seconds", ...){
  nums <- list(...)
  if(!is.null(num) && length(nums) > 0){
    c(.duration_from_num(num, units), .duration_from_units(nums))
  } else if(!is.null(num)){
    .duration_from_num(num, units)
  } else if(length(nums)){
    .duration_from_units(nums)
  } else {
    stop("No valid values have been passed to 'duration' constructor")
  }
}

.duration_from_num <- function(num, units){
	unit <- standardise_date_names(units)
	mult <- c(second = 1, minute = 60, hour = 3600, mday = 86400,
		wday = 86400, yday =86400, day = 86400, week = 604800,
		month = 60 * 60 * 24 * 365 / 12, year = 60 * 60 * 24 * 365)

	new("Duration", num * unname(mult[unit]))
}

.duration_from_units <- function(pieces){
  names(pieces) <- standardise_difftime_names(names(pieces))

  defaults <- list(secs = 0, mins = 0, hours = 0, days = 0, weeks = 0)
  pieces <- c(pieces, defaults[setdiff(names(defaults), names(pieces))])

  x <- pieces$secs +
    pieces$mins * 60 +
    pieces$hours * 3600 +
    pieces$days * 86400 +
    pieces$weeks * 604800

  new("Duration", x)
}


#' Quickly create duration objects.
#'
#' Quickly create Duration objects for easy date-time manipulation. The units of
#' the duration created depend on the name of the function called. For Duration
#' objects, units are equal to their most common lengths in seconds (i.e.
#' minutes = 60 seconds, hours = 3600 seconds, days = 86400 seconds, weeks =
#' 604800, years = 31536000).
#'
#' When paired with date-times, these functions allow date-times to be
#' manipulated in a method similar to object oriented programming. Duration
#' objects can be added to Date, POSIXt, and Interval objects.
#'
#' Since version 1.4.0 the following functions are deprecated: \code{eseconds},
#' \code{eminutes}, \code{ehours}, \code{edays}, \code{eweeks}, \code{eyears},
#' \code{emilliseconds}, \code{emicroseconds}, \code{enanoseconds},
#' \code{epicoseconds}
#'
#' @name quick_durations
#' @param x numeric value of the number of units to be contained in the duration.
#' @return a duration object
#' @seealso \code{\link{duration}}, \code{\link{days}}
#' @keywords chron manip
#' @examples
#' dseconds(1)
#' # 1s
#' dminutes(3.5)
#' # 210s (~3.5 minutes)
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
#' # "POSIXct" "POSIXt"
#' # converts to POSIXt class to accomodate time units
#'
#' dweeks(1) - ddays(7)
#' # 0s
#' c(1:3) * dhours(1)
#' # 3600s (~1 hours)  7200s (~2 hours)  10800s (~3 hours)
#' #
#' # compare DST handling to durations
#' boundary <- as.POSIXct("2009-03-08 01:59:59")
#' # "2009-03-08 01:59:59 CST"
#' boundary + days(1) # period
#' # "2009-03-09 01:59:59 CDT" (clock time advances by a day)
#' boundary + ddays(1) # duration
#' # "2009-03-09 02:59:59 CDT" (clock time corresponding to 86400 seconds later)
#' @export dseconds dminutes dhours ddays dweeks dyears dmilliseconds dmicroseconds dnanoseconds dpicoseconds
dseconds <- function(x = 1) new("Duration", x)
#' @rdname quick_durations
dminutes <- function(x = 1) new("Duration", x * 60)
#' @rdname quick_durations
dhours <- function(x = 1) new("Duration", x * 3600)
#' @rdname quick_durations
ddays <- function(x = 1) new("Duration", x * 86400)
#' @rdname quick_durations
dweeks <- function(x = 1) new("Duration", x * 604800)
#' @rdname quick_durations
dyears <- function(x = 1) new("Duration", x * 60 * 60 * 24 * 365)
#' @rdname quick_durations
dmilliseconds <- function(x = 1) new("Duration", x / 1000)
#' @rdname quick_durations
dmicroseconds <- function(x = 1) new("Duration", x / 1000 / 1000)
#' @rdname quick_durations
dnanoseconds <- function(x = 1) new("Duration", x / 1000 / 1000 / 1000)
#' @rdname quick_durations
dpicoseconds <- function(x = 1) new("Duration", x / 1000 / 1000 / 1000 / 1000)

#' @rdname duration
#' @param x an R object
#' @export
#' @examples
#' is.duration(as.Date("2009-08-03")) # FALSE
#' is.duration(duration(days = 12.4)) # TRUE
is.duration <- function(x) is(x, "Duration")

#' @export
summary.Duration <- function(object, ...) {
  nas <- is.na(object)
  object <- object[!nas]
  nums <- as.numeric(object)
  qq <- stats::quantile(nums)
  qq <- c(qq[1L:3L], mean(nums), qq[4L:5L])
  qq <- dseconds(qq)
  qq <- as.character(qq)
  names(qq) <- c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.",
                 "Max.")
  if (any(nas))
    c(qq, `NA's` = sum(nas))
  else qq
}
