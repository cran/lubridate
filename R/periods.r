#' @include timespans.r
#' @include util.r
#' @include durations.r
NULL

check_period <- function(object) {
  errors <- character()
  ## if (!is.numeric(object@.Data)) {
  ##   msg <- "seconds (.Data) value must be numeric."
  ##   errors <- c(errors, msg)
  ## }
  ## if (!is.numeric(object@year)) {
  ##   msg <- "year value must be numeric."
  ##   errors <- c(errors, msg)
  ## }
  ## if (!is.numeric(object@month)) {
  ##   msg <- "year value must be numeric."
  ##   errors <- c(errors, msg)
  ## }
  ## if (!is.numeric(object@day)) {
  ##   msg <- "year value must be numeric."
  ##   errors <- c(errors, msg)
  ## }
  ## if (!is.numeric(object@hour)) {
  ##   msg <- "year value must be numeric."
  ##   errors <- c(errors, msg)
  ## }
  ## if (!is.numeric(object@minute)) {
  ##   msg <- "year value must be numeric."
  ##   errors <- c(errors, msg)
  ## }

  length(object@.Data) -> n
  lengths <- c(length(object@year), length(object@month),
               length(object@day), length(object@hour), length(object@minute))

  if (any(lengths != n)) {
    msg <- paste("Inconsistent lengths: year = ", lengths[1],
      ", month = ", lengths[2],
      ", day = ", lengths[3],
      ", hour = ", lengths[4],
      ", minute = ", lengths[5],
      ", second = ", n,
      sep = "")
    errors <- c(errors, msg)
  }

  values <- c(object@year, object@month, object@day, object@hour, object@minute)
  values <- na.omit(values)
  if (sum(values - trunc(values))) {
    msg <- "periods must have integer values"
    errors <- c(errors, msg)
  }

  if (length(errors) == 0)
    TRUE
  else
    errors
}

#' Period class
#'
#' Period is an S4 class that extends the [Timespan-class] class.
#' Periods track the change in the "clock time" between two date-times. They
#' are measured in common time related units: years, months, days, hours,
#' minutes, and seconds. Each unit except for seconds must be expressed in
#' integer values.
#'
#' The exact length of a period is not defined until the period is placed at a
#' specific moment of time. This is because the precise length of one year,
#' month, day, etc. can change depending on when it occurs due to daylight savings,
#' leap years, and other conventions. A period can be
#' associated with a specific moment in time by coercing it to an
#' [Interval-class] object with [as.interval()] or by adding
#' it to a date-time with "+".
#'
#' Periods provide a method for measuring generalized timespans when we wish to
#' model clock times. Periods will attain intuitive results at this task even
#' when leap years, leap seconds, gregorian days, daylight savings changes, and
#' other events happen during the period.
#'
#' Because Period represents imprecise amount of time it cannot be compared to
#' precise timestamps as Durations and Intervals are. You need to explicitely
#' conver to durations. See [Duration-class].
#'
#' The logic that guides arithmetic with periods can be unintuitive. Starting
#' with version 1.3.0, \pkg{lubridate} enforces the reversible property of arithmetic
#' (e.g. a date + period - period = date) by returning an NA if you create an
#' implausible date by adding periods with months or years units to a date. For
#' example,  adding one month to January 31st, 2013 results in February 31st,
#' 2013, which is not a real date. \pkg{lubridate} users have argued in the past that
#' February 31st, 2013 should be rolled over to March 3rd, 2013 or rolled back
#' to February 28, 2013. However, each of these corrections would destroy the
#' reversibility of addition (Mar 3 - one month == Feb 3 != Jan 31, Feb 28 - one
#' month == Jan 28 != Jan 31). If you would like to add and subtract months in a
#' way that rolls the results back to the last day of a month (when appropriate)
#' use the special operators, \code{\link{\%m+\%}},  \code{\link{\%m-\%}} or a
#' bit more flexible [add_with_rollback()].
#'
#' Period class objects have six slots. 1) .Data, a numeric object. The
#' apparent amount of seconds to add to the period. 2) minute, a numeric object.
#' The apparent amount of minutes to add to the period. 3) hour, a numeric object.
#' The apparent amount of hours to add to the period.4) day, a numeric object.
#' The apparent amount of days to add to the period.5) month, a numeric object.
#' The apparent amount of months to add to the period. 6) year, a numeric object.
#' The apparent amount of years to add to the period.
#'
#' @export
#' @keywords internal
setClass("Period", contains = c("Timespan", "numeric"),
  slots = c(year = "numeric", month = "numeric", day = "numeric",
    hour = "numeric", minute = "numeric"),
  prototype = prototype(year = 0, month = 0, day = 0, hour = 0, minute = 0),
  validity = check_period)

#' @name hidden_aliases
#' @aliases Arith,ANY,Period-method Arith,Duration,Period-method
#'   Arith,Period,Duration-method Compare,Period,Duration-method
#'   Compare,Period,Period-method Compare,Period,character-method
#'   Compare,Period,numeric-method Compare,character,Period-method
#'   second,Period-method second<-,Period-method minute,Period-method
#'   minute<-,Period-method hour,Period-method hour<-,Period-method
#'   Arith,Period,ANY-method day,Period-method day<-,Period-method
#'   month,Period-method month<-,Period-method year,Period-method
#'   year<-,Period-method date,Period-method date<-,Period-method
#'   as.numeric,Period-method show,Period-method c,Period-method
#'   rep,Period-method [,Period-method [<-,Period,ANY,ANY,Period-method
#'   [[,Period-method [[<-,Period,ANY,ANY,Period-method $,Period-method
#'   $<-,Period-method as.difftime,Period-method as.character,Period-method
#'   +,Period,Duration-method +,Period,Interval-method +,Period,Period-method
#'   +,Period,Date-method +,Date,Period-method +,Period,difftime-method
#'   +,difftime,Period-method +,Period,numeric-method +,numeric,Period-method
#'   +,Period,POSIXct-method +,POSIXct,Period-method +,Period,POSIXlt-method
#'   +,POSIXlt,Period-method /,Period,Duration-method /,Period,Interval-method
#'   /,Period,Period-method /,Period,difftime-method /,difftime,Period-method
#'   /,Period,numeric-method /,numeric,Period-method *,Period,ANY-method
#'   *,ANY,Period-method -,Period,ANY-method -,Period,missing-method
#'   -,ANY,Period-method %%,Period,Duration-method %%,Period,Interval-method
#'   %%,Period,Period-method >,Period,Period-method >=,Period,Period-method
#'   ==,Period,Period-method !=,Period,Period-method <=,Period,Period-method
#'   <,Period,Period-method >,Period,Duration-method >=,Period,Duration-method
#'   ==,Period,Duration-method !=,Period,Duration-method
#'   <=,Period,Duration-method <,Period,Duration-method >,Duration,Period-method
#'   >=,Duration,Period-method ==,Duration,Period-method
#'   !=,Duration,Period-method <=,Duration,Period-method
#'   <,Duration,Period-method >,Period,numeric-method >=,Period,numeric-method
#'   ==,Period,numeric-method !=,Period,numeric-method <=,Period,numeric-method
#'   <,Period,numeric-method >,numeric,Period-method >=,numeric,Period-method
#'   ==,numeric,Period-method !=,numeric,Period-method <=,numeric,Period-method
#'   <,numeric,Period-method !=,Duration,Period !=,Period,Duration
#'   !=,Period,Period !=,Period,numeric !=,numeric,Period %%,Period,Duration
#'   %%,Period,Interval %%,Period,Period *,ANY,Period *,Period,ANY -,ANY,Period
#'   -,Period,Interval -,Period,missing /,numeric,Period <,Duration,Period
#'   <,Period,Duration <,Period,Period <,Period,numeric <,numeric,Period
#'   <=,Duration,Period <=,Period,Duration <=,Period,Period <=,Period,numeric
#'   <=,numeric,Period ==,Duration,Period ==,Period,Duration ==,Period,Period
#'   ==,Period,numeric ==,numeric,Period >,Duration,Period >,Period,Duration
#'   >,Period,Period >,Period,numeric >,numeric,Period >=,Duration,Period
#'   >=,Period,Duration >=,Period,Period >=,Period,numeric >=,numeric,Period
NULL

setMethod("initialize", "Period", function(.Object, ...) {
  dots <- list(...)
  names(dots)[!nzchar(allNames(dots))] <- ".Data"
  len <- max(unlist(lapply(dots, length), F, F))
  for (nm in slotNames(.Object)) {
    slot(.Object, nm) <-
      if (is.null(obj <- dots[[nm]])) {
        rep.int(0L, len)
      } else {
        if (length(obj) < len) rep_len(obj, len)
        else obj
      }
  }
  validObject(.Object)
  .Object
})

#' @export
setMethod("show", signature(object = "Period"), function(object) {
  print(format(object))
})

#' @export
format.Period <- function(x, ...) {
  if (length(x@.Data) == 0) return("Period(0)")
  show <- vector(mode = "character")
  na <- is.na(x)

  show <- paste(x@year, "y ", x@month, "m ", x@day, "d ",
    x@hour, "H ", x@minute, "M ", x@.Data, "S", sep = "")
  start <- regexpr("[-1-9]|(0\\.)", show)
  show <- ifelse(start > 0, substr(show, start, nchar(show)), "0S")

  show[na] <- NA
  show
}

#' @export
xtfrm.Period <- function(x) {
  xtfrm(period_to_seconds(x))
}

#' @export
setMethod("c", signature(x = "Period"), function(x, ...) {
  elements <- lapply(list(...), as.period)
  seconds <- c(x@.Data, unlist(lapply(elements, slot, ".Data")))
  years <- c(x@year, unlist(lapply(elements, slot, "year")))
  months <- c(x@month, unlist(lapply(elements, slot, "month")))
  days <- c(x@day, unlist(lapply(elements, slot, "day")))
  hours <- c(x@hour, unlist(lapply(elements, slot, "hour")))
  minutes <- c(x@minute, unlist(lapply(elements, slot, "minute")))
  new("Period", seconds, year = years, month = months, day = days,
    hour = hours, minute = minutes)
})

#' @export
setMethod("rep", signature(x = "Period"), function(x, ...) {
  new("Period", rep(x@.Data, ...), year = rep(x@year, ...),
    month = rep(x@month, ...), day = rep(x@day, ...),
    hour = rep(x@hour, ...), minute = rep(x@minute, ...))
})

#' @export
setMethod("[", signature(x = "Period"),
  function(x, i, j, ..., drop = TRUE) {
    new("Period", x@.Data[i], year = x@year[i], month = x@month[i],
      day = x@day[i], hour = x@hour[i], minute = x@minute[i])
})

#' @export
setMethod("[[", signature(x = "Period"),
          function(x, i, j, ..., exact = TRUE) {
            new("Period", x@.Data[i], year = x@year[i], month = x@month[i],
                day = x@day[i], hour = x@hour[i], minute = x@minute[i])
})

#' @export
setMethod("[<-", signature(x = "Period", value = "Period"),
  function(x, i, j, ..., value) {
    x@.Data[i] <- value@.Data
    x@year[i] <- value@year
    x@month[i] <- value@month
    x@day[i] <- value@day
    x@hour[i] <- value@hour
    x@minute[i] <- value@minute
    x
})

#' @export
setMethod("[[<-", signature(x = "Period", value = "Period"),
          function(x, i, j, ..., value) {
            x@.Data[i] <- value@.Data
            x@year[i] <- value@year
            x@month[i] <- value@month
            x@day[i] <- value@day
            x@hour[i] <- value@hour
            x@minute[i] <- value@minute
            x
})

#' @export
setMethod("$", signature(x = "Period"), function(x, name) {
  if (name == "second") name <- ".Data"
    slot(x, name)
})

#' @export
setMethod("$<-", signature(x = "Period"), function(x, name, value) {
  if (name == "second") name <- ".Data"
    slot(x, name) <- rep_len(value, length(x))
    x
})

#' Create a period object
#'
#' `period()` creates a period object with the specified values.
#'
#' Within a Period object, time units do not have a fixed length (except for
#' seconds) until they are added to a date-time. The length of each time unit
#' will depend on the date-time to which it is added. For example, a year that
#' begins on 2009-01-01 will be 365 days long.  A year that begins on 2012-01-01
#' will be 366 days long. When math is performed with a period object, each unit
#' is applied separately. How the length of a period is distributed among its
#' units is non-trivial. For example, when leap seconds occur 1 minute is longer
#' than 60 seconds.
#'
#' Periods track the change in the "clock time" between two date-times. They
#' are measured in common time related units: years, months, days, hours,
#' minutes, and seconds. Each unit except for seconds must be expressed in
#' integer values.
#'
#' Period objects can be easily created with the helper functions
#' [years()], [months()], [weeks()],
#' [days()], [hours()], [minutes()],
#' and [seconds()]. These objects can be added to and subtracted
#' to date-times to create a user interface similar to object oriented programming.
#'
#' Note: Arithmetic with periods can results in undefined behavior when
#' non-existent dates are involved (such as February 29th). Please see
#' [Period-class] for more details and \code{\link{\%m+\%}} and
#' [add_with_rollback()] for alternative operations. Note: Arithmetic with
#' periods can results in undefined behavior when non-existent dates are
#' involved (such as February 29th in non-leap years). Please see [Period-class]
#' for more details and \code{\link{\%m+\%}} and [add_with_rollback()] for
#' alternative operations.
#'
#' @name period
#' @aliases periods
#' @param num a numeric vector that lists the number of time units to be
#'   included in the period. From v1.6.0 `num` can also be a character vector
#'   that specifies durations in a convenient shorthand format. All unambiguous
#'   name units and abbreviations are supported, "m" stands for months, "M" for
#'   minutes; see examples. Fractional units are supported but the fractional
#'   part is always converted to seconds.
#' @param units a character vector that lists the type of units to be used. The
#'   units in units are matched to the values in num according to their
#'   order. When `num` is character, this argument is ignored.
#' @param ... a list of time units to be included in the period and their
#'   amounts. Seconds, minutes,  hours, days, weeks, months, and years are
#'   supported. Normally only one of `num` or `...` are present. If both are
#'   present, the periods are concatenated.
#' @param x Any R object for `is.periods` and a numeric value of the number of
#'   units for elementary constructors. With the exception of seconds(), x must
#'   be an integer.
#' @param abbreviate Ignored. For consistency with S3 generic in base namespace.
#' @seealso [Period-class], [period()], \code{\link{\%m+\%}},
#'   [add_with_rollback()]
#' @return a period object
#' @keywords chron classes
#' @examples
#'
#' period(c(90, 5), c("second", "minute"))
#' #  "5M 90S"
#' period(-1, "days")
#' period(c(3, 1, 2, 13, 1), c("second", "minute", "hour", "day", "week"))
#' period(c(1, -60), c("hour", "minute"))
#' period(0, "second")
#' period (second = 90, minute = 5)
#' period(day = -1)
#' period(second = 3, minute = 1, hour = 2, day = 13, week = 1)
#' period(hour = 1, minute = -60)
#' period(second = 0)
#' period(c(1, -60), c("hour", "minute"), hour = c(1, 2), minute = c(3, 4))
#' period("2M 1sec")
#' period("2hours 2minutes 1second")
#' period("2d 2H 2M 2S")
#' period("2days 2hours 2mins 2secs")
#' # Missing numerals default to 1. Repeated units are added up.
#' duration("day day")
#' # Comparison with characters is supported from v1.6.0.
#' duration("day 2 sec") > "day 1sec"
#'
#' ### ELEMENTARY CONSTRUCTORS
#'
#' x <- ymd("2009-08-03")
#' x + days(1) + hours(6) + minutes(30)
#' x + days(100) - hours(8)
#'
#' class(as.Date("2009-08-09") + days(1)) # retains Date class
#' as.Date("2009-08-09") + hours(12)
#' class(as.Date("2009-08-09") + hours(12))
#' # converts to POSIXt class to accomodate time units
#'
#' years(1) - months(7)
#' c(1:3) * hours(1)
#' hours(1:3)
#'
#' #sequencing
#' y <- ymd(090101) # "2009-01-01 CST"
#' y + months(0:11)
#'
#' # compare DST handling to durations
#' boundary <- ymd_hms("2009-03-08 01:59:59", tz="America/Chicago")
#' boundary + days(1) # period
#' boundary + ddays(1) # duration
#' @export
period <- function(num = NULL, units = "second", ...) {
  nums <- list(...)
  if (is.character(num)) {
    parse_period(num)
  } else if (!is.null(num) && length(nums) > 0) {
    c(.period_from_num(num, units), .period_from_units(nums))
  } else if (!is.null(num)) {
    .period_from_num(num, units)
  } else if (length(nums)) {
    .period_from_units(nums)
  } else {
    stop("No valid values have been passed to 'period' constructor")
  }
}

parse_period <- function(x) {
  out <- matrix(.Call(C_parse_period, as.character(x)), nrow = 7L)
  new("Period", out[1, ],
      minute = out[2, ],
      hour   = out[3, ],
      day    = out[4, ] + 7L*out[5, ],
      month  = out[6, ],
      year   = out[7, ])
}

.period_from_num <- function(num, units) {

  if (!is.numeric(num)) {
    stop(sprintf("First argument to `period` constructor must be character or numeric. Supplied object of class '%s'", class(num)))
  }

  if (is.interval(num))
    stop("Interval objects cannot be used as input to 'period' constructor. Plese use 'as.period'.")

  if (length(units) %% length(num) != 0)
    stop("Arguments `num` and `units` must have same length")

  num <- num + rep(0, length(units))
  unit <- standardise_date_names(units)
  pieces <- setNames(as.list(num), unit)

  defaults <- list(second = 0, minute = 0, hour = 0, day = 0, week = 0,
                   month = 0, year = 0)
  pieces <- c(pieces, defaults[setdiff(names(defaults), names(pieces))])
  pieces$day <- pieces$day + 7 * pieces$week

  new("Period", pieces$second, year = pieces$year, month = pieces$month,
      day = pieces$day, hour = pieces$hour, minute = pieces$minute)
}

.period_from_units <- function(units) {
  pieces <- data.frame(lapply(units, as.numeric))

  ## fixme: syncronize this with the initialize method
  names(pieces) <- standardise_date_names(names(pieces))
  defaults <- data.frame(
    second = 0, minute = 0, hour = 0, day = 0, week = 0,
    month = 0, year = 0
  )

  if (nrow(pieces) == 0) defaults <- defaults[0, ]

  pieces <- cbind(pieces, defaults[setdiff(names(defaults), names(pieces))])
  ## pieces <- pieces[c("year", "month", "week", "day", "hour", "minute", "second")]

  pieces$day <- pieces$day + pieces$week * 7

  na <- is.na(rowSums(pieces))
  pieces$second[na] <- NA ## if any of supplied pieces is NA whole vector should be NA

  new("Period", pieces$second, year = pieces$year, month = pieces$month,
      day = pieces$day, hour = pieces$hour, minute = pieces$minute)
}

#' @rdname period
#' @examples
#' is.period(as.Date("2009-08-03")) # FALSE
#' is.period(period(months= 1, days = 15)) # TRUE
#' @export
is.period <- function(x) is(x, "Period")

#' @export seconds minutes hours days weeks years milliseconds microseconds microseconds nanoseconds picoseconds
#' @rdname period
seconds <- function(x = 1) period(second = x)
#' @rdname period
minutes <- function(x = 1) period(minute = x)
#' @rdname period
hours <- function(x = 1) period(hour = x)
#' @rdname period
days <- function(x = 1) period(day = x)
#' @rdname period
weeks <- function(x = 1) period(week = x)
#' @rdname period
years <- function(x = 1) period(year = x)
#' @rdname period
milliseconds <- function(x = 1) seconds(x/1000)
#' @rdname period
microseconds <- function(x = 1) seconds(x/1000000)
#' @rdname period
nanoseconds <- function(x = 1) seconds(x/1e9)
#' @rdname period
picoseconds <- function(x = 1) seconds(x/1e12)

#' @rdname period
#' @export
months.numeric <- function(x, abbreviate) {
  period(month = x)
}

#' Contrive a period to/from a given number of seconds
#'
#' `period_to_seconds()` approximately converts a period to seconds assuming
#' there are 365.25 days in a calendar year and 365.25/12 days in a month.
#'
#' @param x A numeric object. The number of seconds to coerce into a period.
#' @return A number (period) that roughly equates to the period (seconds) given.
#' @export
period_to_seconds <- function(x) {
  x@.Data +
    60 * x@minute +
    60 * 60 * x@hour +
    60 * 60 * 24 * x@day +
    60 * 60 * 24 * 365.25 / 12 * x@month +
    60 * 60 * 24 * 365.25 * x@year
}

#' @description
#' `seconds_to_period()` create a period that has the maximum number of
#' non-zero elements (days, hours, minutes, seconds). This computation is exact
#' because it doesn't involve years or months.
#' @rdname period_to_seconds
#' @export
seconds_to_period <- function(x) {
  span <- as.double(x)
  remainder <- abs(span)
  newper <- period(second = rep(0, length(x)))

  ## slot(newper, "year") <- remainder %/% (3600 * 24 * 365.25)
  ## remainder <- remainder %% (3600 * 24 * 365.25)

  slot(newper, "day") <- remainder %/% (3600 * 24)
  remainder <- remainder %% (3600 * 24)

  slot(newper, "hour") <- remainder %/% (3600)
  remainder <- remainder %% (3600)

  slot(newper, "minute") <- remainder %/% (60)

  slot(newper, ".Data") <- remainder %% (60)

  newper * sign(span)
}

#' @export
summary.Period <- function(object, ...) {
  nas <- is.na(object)
  object <- object[!nas]
  persecs <- period_to_seconds(object)
  qq <- stats::quantile(persecs)
  qq <- c(qq[1L:3L], mean(persecs), qq[4L:5L])
  qq <- seconds_to_period(qq)
  qq <- as.character(qq)
  names(qq) <- c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.",
                 "Max.")
  if (any(nas))
    c(qq, `NA's` = sum(nas))
  else qq
}

#' @export
setMethod("Arith", signature(e1 = "Period", e2 = "ANY"), undefined_arithmetic)

#' @export
setMethod("Arith", signature(e1 = "ANY", e2 = "Period"), undefined_arithmetic)

## duration is.numeric. So we need these explicits here:
#' @export
setMethod("Arith", signature(e1 = "Duration", e2 = "Period"), undefined_arithmetic)

#' @export
setMethod("Arith", signature(e1 = "Period", e2 = "Duration"), undefined_arithmetic)

#' @export
setMethod("Compare", signature(e1 = "character", e2 = "Period"),
          function(e1, e2) {
            callGeneric(as.period(e1), e2)
          })

#' @export
setMethod("Compare", signature(e1 = "Period", e2 = "character"),
          function(e1, e2) {
            callGeneric(e1, as.period(e2))
          })

#' @export
setMethod("Compare", signature(e1 = "Period", e2 = "Period"),
          function(e1, e2) {
            callGeneric(period_to_seconds(e1), period_to_seconds(e2))
          })

#' @export
setMethod("Compare", signature(e1 = "Period", e2 = "Duration"),
          function(e1, e2) {
            stop("cannot compare Period to Duration:\ncoerce with 'as.duration' first.")
          })

#' @export
setMethod("Compare", signature(e1 = "Duration", e2 = "Period"),
          function(e1, e2) {
            callGeneric(e1, as.duration(e2))
          })

#' @export
setMethod("Compare", signature(e1 = "Period", e2 = "numeric"),
          function(e1, e2) {
            stop("cannot compare Period to Duration:\ncoerce with 'as.numeric' first.")
          })
