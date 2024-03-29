% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coercion.r
\name{as.interval}
\alias{as.interval}
\alias{as.interval,numeric-method}
\alias{as.interval,difftime-method}
\alias{as.interval,Interval-method}
\alias{as.interval,Duration-method}
\alias{as.interval,Period-method}
\alias{as.interval,POSIXt-method}
\alias{as.interval,logical-method}
\title{Change an object to an \code{interval}}
\usage{
as.interval(x, start, ...)
}
\arguments{
\item{x}{a duration, difftime, period, or numeric object that describes the length of the interval}

\item{start}{a POSIXt or Date object that describes when the interval begins}

\item{...}{additional arguments to pass to as.interval}
}
\value{
an interval object
}
\description{
as.interval changes difftime, Duration, Period and numeric class objects to
intervals that begin at the specified date-time. Numeric objects are first
coerced to timespans equal to the numeric value in seconds.
}
\details{
as.interval can be used to create accurate transformations between Period
objects, which measure time spans in variable length units, and Duration objects,
which measure timespans as an exact number of seconds. A start date-
time must be supplied to make the conversion. Lubridate uses
this start date to look up how many seconds each variable
length unit (e.g. month, year) lasted for during the time span
described. See
\code{\link[=as.duration]{as.duration()}}, \code{\link[=as.period]{as.period()}}.
}
\examples{
diff <- make_difftime(days = 31) # difftime
as.interval(diff, ymd("2009-01-01"))
as.interval(diff, ymd("2009-02-01"))

dur <- duration(days = 31) # duration
as.interval(dur, ymd("2009-01-01"))
as.interval(dur, ymd("2009-02-01"))

per <- period(months = 1) # period
as.interval(per, ymd("2009-01-01"))
as.interval(per, ymd("2009-02-01"))

as.interval(3600, ymd("2009-01-01")) # numeric
}
\seealso{
\code{\link[=interval]{interval()}}
}
\keyword{chron}
\keyword{classes}
\keyword{manip}
\keyword{methods}
