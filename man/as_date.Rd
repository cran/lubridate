% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coercion.r
\name{as_date}
\alias{as_date}
\alias{as_date,ANY-method}
\alias{as_date,POSIXt-method}
\alias{as_date,numeric-method}
\alias{as_date,character-method}
\alias{as_datetime}
\alias{as_datetime,ANY-method}
\alias{as_datetime,POSIXt-method}
\alias{as_datetime,numeric-method}
\alias{as_datetime,character-method}
\alias{as_datetime,Date-method}
\title{Convert an object to a date or date-time}
\usage{
as_date(x, ...)

\S4method{as_date}{ANY}(x, ...)

\S4method{as_date}{POSIXt}(x, tz = NULL)

\S4method{as_date}{numeric}(x, origin = lubridate::origin)

\S4method{as_date}{character}(x, tz = NULL, format = NULL)

as_datetime(x, ...)

\S4method{as_datetime}{ANY}(x, tz = lubridate::tz(x))

\S4method{as_datetime}{POSIXt}(x, tz = lubridate::tz(x))

\S4method{as_datetime}{numeric}(x, origin = lubridate::origin, tz = "UTC")

\S4method{as_datetime}{character}(x, tz = "UTC", format = NULL)

\S4method{as_datetime}{Date}(x, tz = "UTC")
}
\arguments{
\item{x}{a vector of \link{POSIXt}, numeric or character objects}

\item{...}{further arguments to be passed to specific methods (see above).}

\item{tz}{a time zone name (default: time zone of the POSIXt object \code{x}). See
\code{\link[=OlsonNames]{OlsonNames()}}.}

\item{origin}{a Date object, or something which can be coerced by \code{as.Date(origin, ...)} to such an object (default: the Unix epoch of "1970-01-01"). Note that in
this instance, \code{x} is assumed to reflect the number of days since \code{origin} at
\code{"UTC"}.}

\item{format}{format argument for character methods. When supplied parsing is
performed by \code{parse_date_time(x, orders = formats, exact = TRUE)}. Thus, multiple
formats are supported and are tried in turn.}
}
\value{
a vector of \link{Date} objects corresponding to \code{x}.
}
\description{
Convert an object to a date or date-time
}
\section{Compare to base R}{


These are drop in replacements for \code{\link[=as.Date]{as.Date()}} and \code{\link[=as.POSIXct]{as.POSIXct()}}, with a few
tweaks to make them work more intuitively.

\itemize{

\item Called on a \code{POSIXct} object, \code{as_date()} uses the tzone attribute of
the object to return the same date as indicated by the printed representation
of the object. This differs from as.Date, which ignores the attribute and
uses only the tz argument to \code{as.Date()} ("UTC" by default).

\item Both functions provide a default origin argument for numeric vectors.

\item Both functions will generate NAs for invalid date format. Valid formats are
those described by ISO8601 standard. A warning message will provide a count of the
elements that were not converted.

\item \code{as_datetime()} defaults to using UTC.

}
}

\examples{
dt_utc <- ymd_hms("2010-08-03 00:50:50")
dt_europe <- ymd_hms("2010-08-03 00:50:50", tz = "Europe/London")
c(as_date(dt_utc), as.Date(dt_utc))
c(as_date(dt_europe), as.Date(dt_europe))
## need not supply origin
as_date(10)
## Will replace invalid date format with NA
dt_wrong <- c("2009-09-29", "2012-11-29", "2015-29-12")
as_date(dt_wrong)
}
