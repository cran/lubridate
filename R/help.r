#' Dates and times made easy with lubridate
#'
#' Lubridate provides tools that make it easier to parse and
#' manipulate dates. These tools are grouped below by common
#' purpose. More information about each function can be found in
#' its help documentation.
#'
#' Parsing dates
#'
#' Lubridate's parsing functions read strings into R as POSIXct
#' date-time objects. Users should choose the function whose name
#' models the order in which the year ('y'), month ('m') and day
#' ('d') elements appear the string to be parsed:
#' \code{\link{dmy}}, \code{\link{myd}}, \code{\link{ymd}},
#' \code{\link{ydm}}, \code{\link{dym}}, \code{\link{mdy}},
#' \code{\link{ymd_hms}}). A very flexible and user friendly parser
#' is provided by \code{\link{parse_date_time}}.
#'
#' Lubridate can also parse partial dates from strings into
#' \code{\link{Period-class}} objects with the functions
#' \code{\link{hm}}, \code{\link{hms}} and \code{\link{ms}}.
#'
#' Lubridate has an inbuilt very fast POSIX parser, ported from
#' the fasttime package by Simon Urbanek. This functionality is
#' as yet optional and could be activated with
#' \code{options(lubridate.fasttime = TRUE)}. Lubridate will
#' automatically detect POSIX strings and use fast parser instead
#' of the default \code{\link{strptime}} utility.
#'
#' Manipulating dates
#'
#' Lubridate distinguishes between moments in time (known as
#' \code{\link{instants}}) and spans of time (known as time spans, see
#' \code{\link{Timespan-class}}). Time spans are further separated into
#' \code{\link{Duration-class}}, \code{\link{Period-class}} and
#' \code{\link{Interval-class}} objects.
#'
#' Instants
#'
#' Instants are specific moments of time. Date, POSIXct, and
#' POSIXlt are the three object classes Base R recognizes as
#' instants. \code{\link{is.Date}} tests whether an object
#' inherits from the Date class. \code{\link{is.POSIXt}} tests
#' whether an object inherits from the POSIXlt or POSIXct classes.
#' \code{\link{is.instant}} tests whether an object inherits from
#' any of the three classes.
#'
#' \code{\link{now}} returns the current system time as a POSIXct
#' object. \code{\link{today}} returns the current system date.
#' For convenience, 1970-01-01 00:00:00 is saved to
#' \code{\link{origin}}. This is the instant from which POSIXct
#' times are calculated. Try unclass(now()) to see the numeric structure that
#' underlies POSIXct objects. Each POSIXct object is saved as the number of seconds
#' it occurred after 1970-01-01 00:00:00.
#'
#' Conceptually, instants are a combination of measurements on different units
#' (i.e, years, months, days, etc.). The individual values for
#' these units can be extracted from an instant and set with the
#' accessor functions \code{\link{second}}, \code{\link{minute}},
#' \code{\link{hour}}, \code{\link{day}}, \code{\link{yday}},
#' \code{\link{mday}}, \code{\link{wday}}, \code{\link{week}},
#' \code{\link{month}}, \code{\link{year}}, \code{\link{tz}},
#' and \code{\link{dst}}.
#' Note: the accessor functions are named after the singular form
#' of an element. They shouldn't be confused with the period
#' helper functions that have the plural form of the units as a
#' name (e.g, \code{\link{seconds}}).
#'
#' Rounding dates
#'
#' Instants can be rounded to a convenient unit using the
#' functions \code{\link{ceiling_date}}, \code{\link{floor_date}}
#' and \code{\link{round_date}}.
#'
#' Time zones
#'
#' Lubridate provides two helper functions for working with time
#' zones. \code{\link{with_tz}} changes the time zone in which an
#' instant is displayed. The clock time displayed for the instant
#' changes, but the moment of time described remains the same.
#' \code{\link{force_tz}} changes only the time zone element of an
#' instant. The clock time displayed remains the same, but the
#' resulting instant describes a new moment of time.
#'
#' Timespans
#'
#' A timespan is a length of time that may or may not be connected to
#' a particular instant. For example, three months is a timespan. So is an hour and
#' a half. Base R uses difftime class objects to record timespans.
#' However, people are not always consistent in how they expect time to behave.
#' Sometimes the passage of time is a monotone progression of instants that should
#' be as mathematically reliable as the number line. On other occasions time must
#' follow complex conventions and rules so that the clock times we see reflect what
#' we expect to observe in terms of daylight, season, and congruence with the
#' atomic clock. To better navigate the nuances of time, lubridate creates three
#' additional timespan classes, each with its own specific and consistent behavior:
#' \code{\link{Interval-class}}, \code{\link{Period-class}} and
#' \code{\link{Duration-class}}.
#'
#' \code{\link{is.difftime}} tests whether an object
#' inherits from the difftime class. \code{\link{is.timespan}}
#' tests whether an object inherits from any of the four timespan
#' classes.
#'
#'
#' Durations
#'
#' Durations measure the exact amount of time that occurs between two
#' instants. This can create unexpected results in relation to clock times if a
#' leap second, leap year, or change in daylight savings time (DST) occurs in
#' the interval.
#'
#' Functions for working with durations include \code{\link{is.duration}},
#' \code{\link{as.duration}} and \code{\link{duration}}. \code{\link{dseconds}},
#' \code{\link{dminutes}}, \code{\link{dhours}},  \code{\link{ddays}},
#' \code{\link{dweeks}} and \code{\link{dyears}} convenient lengths.
#'
#' Periods
#'
#' Periods measure the change in clock time that occurs between two
#' instants. Periods provide robust predictions of clock time in the presence of
#' leap seconds, leap years, and changes in DST.
#'
#' Functions for working with periods include
#' \code{\link{is.period}}, \code{\link{as.period}} and
#' \code{\link{period}}. \code{\link{seconds}},
#' \code{\link{minutes}}, \code{\link{hours}}, \code{\link{days}},
#' \code{\link{weeks}}, \code{\link{months}} and
#' \code{\link{years}} quickly create periods of convenient
#' lengths.
#'
#' Intervals
#'
#' Intervals are timespans that begin at a specific instant and
#' end at a specific instant. Intervals retain complete information about a
#' timespan. They provide the only reliable way to convert between
#' periods and durations.
#'
#' Functions for working with intervals include
#' \code{\link{is.interval}}, \code{\link{as.interval}},
#' \code{\link{interval}}, \code{\link{int_shift}},
#' \code{\link{int_flip}}, \code{\link{int_aligns}},
#' \code{\link{int_overlaps}}, and
#' \code{\link{\%within\%}}. Intervals can also be manipulated with
#' intersect, union, and setdiff().
#'
#' Miscellaneous
#'
#' \code{\link{decimal_date}} converts an instant to a decimal of
#' its year.
#' \code{\link{leap_year}} tests whether an instant occurs during
#' a leap year.
#' \code{\link{pretty.dates}} provides a method of making pretty
#' breaks for date-times
#' \code{\link{lakers}} is a data set that contains information
#' about the Los Angeles Lakers 2008-2009 basketball season.
#'
#' @references Garrett Grolemund, Hadley Wickham (2011). Dates and Times Made
#'   Easy with lubridate. Journal of Statistical Software, 40(3), 1-25.
#'   \url{http://www.jstatsoft.org/v40/i03/}.
#' @import stringr
#' @importFrom methods setClass setGeneric new show allNames callGeneric is slot slot<- slotNames validObject
#' @importFrom utils packageVersion read.delim
#' @importFrom stats na.omit setNames update
#' @docType package
#' @name lubridate-package
#' @aliases lubridate lubridate-package
NULL
