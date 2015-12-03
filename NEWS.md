
-------------
Version 1.5.0
=============

### NEW FEATURES
* New `time_length` method.
* Added `isoyear` function to line up with `isoweek`.
* [#326](https://github.com/hadley/lubridate/issues/326) Added `exact = TRUE`
  option to `parse_date_time` for faster and much more flexible specification of
  formats.
* New `simple` argument to `fit_to_timeline` and `update` methods mostly
  intended for internal use.
* [#315](https://github.com/hadley/lubridate/issues/315) implement `unique` method for `interval` class 
* [#295](https://github.com/hadley/lubridate/issues/295) New args `preserve_hms` and `roll_to_first` in `rollback` function.
* [#303](https://github.com/hadley/lubridate/issues/303) New `quarter` option in `floor_date` and friends. 
* [#348](https://github.com/hadley/lubridate/issues/348) New `as.list.Interval` S3 method.
* [#278](https://github.com/hadley/lubridate/issues/278) Added settors and accessors for `qday` (quarter day).

### CHANGES
* New maintainer Vitalie Spinu (@vspinu)
* Time span constructors were re-factored; `new_interval`, `new_period`,
  `new_duration`, `new_difftime` were deprecated in favour of the more powerful
  `interval`, `period`, `duration` and `make_difftime` functions.
* `eseconds`, `eminutes` etc. were deprecated in favour of `dsecons`, `dminutes` etc.
* Many documentation improvements.
* New testthat conventions are adopted. Tests are now in `test/testthat`.
* Internally `isodate` was replaced with a much faster `parse_date_time2(paste(...))` alternative 
* [#325](https://github.com/hadley/lubridate/issues/325) `Lubridate`'s `trunc`,
  `ceiling` and `floor` functions have been optimised and now are relying on R's
  `trunc.POSIXct` whenever possible.
* [#285](https://github.com/hadley/lubridate/issues/285) Algebraic computations
  with negative periods are behaving asymmetrically with respect to their
  positive counterparts.
* Made necessary changes to accommodate new zoo-based `fst` objects.

### BUG FIXES
* [#360](https://github.com/hadley/lubridate/issues/360) Fix c parser for Z (zulu) indicator.
* [#322](https://github.com/hadley/lubridate/issues/322) Explicitly encode formatted string with `enc2utf8`.
* [#302](https://github.com/hadley/lubridate/issues/302) Allow parsing long numbers such as 20140911000000 as date+time 
* [#349](https://github.com/hadley/lubridate/issues/349) Fix broken interval -> period conversion.
* [#336](https://github.com/hadley/lubridate/issues/336) Fix broken interval-> period conversion with negative diffs.
* [#227](https://github.com/hadley/lubridate/issues/227) Treat "days" and "years" units specially for pretty.point.
* [#286](https://github.com/hadley/lubridate/issues/286) %m+-% correctly handles dHMS period components. 
* [#323](https://github.com/hadley/lubridate/issues/323) Implement coercion methods for Duration class.
* [#226](https://github.com/hadley/lubridate/issues/226) Propagate NAs in `int_standardize` 
* [#235](https://github.com/hadley/lubridate/issues/235) Fix integer division with months and years. 
* [#240](https://github.com/hadley/lubridate/issues/240) Make `ceiling_date` skip day light gap. 
* [#254](https://github.com/hadley/lubridate/issues/254) Don't preprocess a/A formats if expressly specified by the user.
* [#289](https://github.com/hadley/lubridate/issues/289) Check for valid day-months combinations in C parser.
* [#306](https://github.com/hadley/lubridate/issues/306) When needed double guess with `preproc_wday=T`.
* [#308](https://github.com/hadley/lubridate/issues/308) Document sparce format guessing in `parse_date_time`.
* [#313](https://github.com/hadley/lubridate/issues/313) Fixed and optimized `fit_to_timeline` function.
* [#311](https://github.com/hadley/lubridate/issues/311) Always use UTC in `isoweek` computation 
* [#294](https://github.com/hadley/lubridate/issues/294) Don't use years in `seconds_to_period`.
* Values on `$<-` assignment for periods are now properly recycled.
* Correctly handle NA subscripting in `round_date`.

-------------
Version 1.4.0
=============

### CHANGES
* [#219](//github.com/hadley/lubridate/issues/219) In `interval` use UTC when tzone is missing. 
* [#255](//github.com/hadley/lubridate/issues/255) Parse yy > 68 as 19yy to comply with `strptime`.

### BUG FIXES

* [#266](//github.com/hadley/lubridate/issues/266) Include `time-zones.R` in `coercion.R`.
* [#251](//github.com/hadley/lubridate/issues/251) Correct computation of weeks.
* [#262](//github.com/hadley/lubridate/issues/262) Document that month boundary is the first second of the month. 
* [#270](//github.com/hadley/lubridate/issues/270) Add check for empty unit names in `standardise_lt_names`.
* [#276](//github.com/hadley/lubridate/issues/276) Perform conversion in `as.period.period` if `unit != NULL`.
* [#284](//github.com/hadley/lubridate/issues/284) Compute periods in `as.period.interval` without recurring to modulo arithmetic.
* [#272](//github.com/hadley/lubridate/issues/272) Update examples for `hms`, `hm` and `ms` for new printing style.
* [#236](//github.com/hadley/lubridate/issues/236) Don't allow zeros in month and day during parsing.
* [#247](//github.com/hadley/lubridate/issues/247) Uninitialized index was mistakenly used in subseting.
* [#229](//github.com/hadley/lubridate/issues/229) `guess_formats` now matches flex regexp first. 
* `dmilliseconds` now correctly returns a `Duration` object. 
* Fixed setdiff for discontinuous intervals.


-------------
Version 1.3.3
=============

### CHANGES

* New low level C parser for numeric formats and two new front-end R functions
  parse_date_time2 and fast_strptime. The achieved speed up is 50-100x as
  compared to standard as.POSIXct and strptime functions.

  The user level parser functions of ymd_hms family drop to these C routines
  whenever plain numeric formats are detected.

### BUG FIXES

* olson_time_zones now supports Solaris OS
* infinite recursion on parsing non-existing leap times was fixed


-------------
Version 1.3.2
=============

* Lubridate's s4 methods no longer use the representation argument, which has
  been deprecated in R 3.0.0 (see ?setClass). As a result, lubridate is no
  longer backwards compatible with R <3.0.0.


-------------
Version 1.3.0
=============

### CHANGES

* v1.3.0. treats math with month and year Periods more consistently. If adding 
or subtracting n months would result in a non-existent date, lubridate will 
return an NA instead of a day in the following month or year. For example, 
`ymd("2013-01-31") + months(1)` will return `NA` instead of `2013-03-04` 
as in v1.2.0. `ymd("2012-02-29") + years(1)` will also return an `NA`. This 
rule change helps ensure that date + timespan - timespan = date (or NA). If 
you'd prefer that such arithmetic just returns the last day of the resulting 
month, see `%m+%` and `%m-%`.

* update.POSIXct and update.POSIXlt have been rewritten to be 7x faster than 
their versions in v1.2.0. The speed gain is felt in `force_tz`, `with_tz`, 
`floor_date`, `ceiling_date`, `second<-`, `minute<-`, `hour<-`, `day<-`, 
`month<-`, `year<-`, and other functions that rely on update (such as math with
Periods).

* lubridate includes a Korean translation provided by 
http://korea.gnu.org/gnustats/


### NEW FEATURES

* lubridate parser and stamp functions now handle ISO8601 date format (e.g., 
2013-01-24 19:39:07.880-06:00, 2013-01-24 19:39:07.880Z)

* lubridate v1.3.0 comes with a new R vignette. see 
`browseVignettes("lubridate")` to view it.

* The accessors `second`, `minute`, `hour`, `day`, `month`, `year` and the 
settors `second<-`, `minute<-`, `hour<-`, `day<-`, `month<-`, `year<-` now 
work on Period class objects

* users can control which messages lubridate returns when parsing and estimating
with the global option lubridate.verbose. Run 
`options(lubridate.verbose = TRUE)` to turn parsing messages on. Run 
`options(lubridate.verbose = FALSE)` to turn estimation and coercion messages 
off.

* lubridate parser functions now propagate NA's just as as.POSIXct, strptime and
other functions do. Previously lubridate's parse functions would only return an 
error.

* added [[ and [[<- methods for INterval, Period and Duration class objects

* added `%m+%` and `%m-%` methods for Interval and Duration class objects that 
throw useful errors.

* `olson_time_zones` retreives a character vector is Olson-style time zone names
to use in lubridate

* summary methods for Interval, Period, and Duration classes

* date_decimal converts a date written as a decimal of a year into a POSIXct 
date-time

### BUG FIXES

* fixed bug in way update.POSIXct and update.POSIXlt handle dates that occur in 
the fall daylight savings overlap. update will choose the date-time closest to 
the original date time (on the timeline) when two identical clock times exist 
due to the DST overlap.

* fixed bugs that created unintuitive results for `as.interval`, `int_overlaps`, `%within%` and the interval methods of `c`, `intersect`, `union`, `setdiff`, and `summary`.

* parse functions, `as.interval`, `as.period` and `as.duration` now handle 
vectors of NA's without returning errors.

* parsers better handle vectors of input that have more than 100 elements and 
many NAs

* data frames that contain timespan objects with NAs in thme no longer fail to 
print

* `round_date`, `ceiling_date` and `update` now correctly handle input of length
zero

* `decimal_date` no longer returns NaN for first second of the year

-------------
Version 1.2.0
=============

### CHANGES

* lubridate 1.2.0 is significantly faster than lubridate 1.1.0. This is 
largely thanks to a parser rewrite submitted by Vitalie Spinu. Thank you, 
Vitalie. Some metrics:
  - parser speed up - 60x faster
  - `with_tz` speed up - 15x faster
  - `force_tz` speed up - 3x faster

* Development for 1.2.0 has also focused on improving the way we work with 
months. `rollback` rolls dates back to the last day of the previous month. 
provides more options for working with months. `days_in_month` finds the 
number of days in a date's month. And, `%m+%` and `%m-%` provide a new way to 
### handle unequal month lengths while doing arithmetic. See NEW FEATURES for more 
details

* date parsing can now parse multiple date formats within the same vector of 
date-times. Parsing can also recognize a greater variety of date-time formats 
as well as incomplete (truncated) date-times. Contributed by Vitalie Spinu. 
Thank you, Vitalie.

* 1.2.0 introduces a new display format for periods. The display is more math 
and international friendly.

* 1.2.0 transforms negative intervals into periods much more gracefully (e.g, -
 3 days instead of -1 years, 11 months, and 27 days)

* S3 update methods are now exported

### NEW FEATURES

* `stamp` allows users to print dates in whatever form they like. Contributed 
by Vitalie Spinu. Thank you, Vitalie.

* periods now handle fractional seconds. Contributed by Vitalie Spinu. Thank 
you, Vitalie.

* date parsing can now parse multiple date formats within the same vector of 
date-times. Parsing can also recognize a greater variety of date-time formats 
as well as incomplete (truncated) date-times. Contributed by Vitalie Spinu. 
Thank you, Vitalie.

* `sort`, `order`, `rank` and `xtfrm` now work with periods

* `as.period.Interval` accepts a unit argument. `as.period` will convert 
intervals into periods no larger than the supplied unit.

* `days_in_month` takes a date, returns the number of days in the date's month.
 Contributed by Richard Cotton. Thank you, Richard.

* `%m+%` and `%m-%` perform addition and subtraction with months (and years) 
without rollover at the end of a month. These can be used in place of + and -. 
These can't be used with periods smaller than a month, which should be handled 
separately. An example of the new behavior:

    ymd("2010-01-31") %m+% months(1)
    # "2010-02-28 UTC"
    
    ymd("2010-01-31") + months(1)
    # "2010-03-03 UTC"

    ymd("2010-03-31") %m-% months(1)
    # "2010-02-28 UTC"
    
    ymd("2010-01-31") - months(1)
    # "2010-03-03 UTC"

* `rollback` rolls a date back to the last day of the previous month.

* `quarter` returns the fiscal quarter that a date occurs in. Like `quartes` 
in base R, but returns a numeric instead of a character string.

### BUG FIXES

* date parsers now handle NAs

* periods now handle NAs 

* `[<-` now correctly updates all elements of a period inside a vector, list, 
or data.frame

* `period()` now works with unit = "weeks"

* `ceiling_date` no longer rounds up if a date is already at a ceiling

* the redundant (i.e, repeated) hour of fall daylight savings time now 
displays with the correct time zone

* `update.POSIXct` and `update.POSIXlt` handle vectors that sum to zero in the 
days argument

* the format method for periods, intervals and duration now accurately 
displays objects of length 0.


-------------
Version 1.1.0
=============

### CHANGES

* lubridate no longer overwrites base R methods for +, - , *, /, %%, and %/%. 
To recreate the previous experience of subtracting two date times to create an 
interval, we've added the interval creation function %--%.

* lubridate has moved to an S4 object system. Timespans, Intervals, Durations, 
and Periods have each been redefined as an S4 class with its own methods.

* arithmetic operations will no longer perform implicit class changes between 
timespans. Users must explicitly state how and when they wish class changes to 
occur with as.period(), as.duration(), and as.interval(). This makes code 
written with lubridate more robust, as such implicit changes often did not 
produce consistent behavior across a variety of operations. It also allows 
lubridate to be less chatty with fewer console messages. lubridate does not 
need to explain what it is doing, because it no longer attempts to do things 
whose outcome would not be clear. On the other hand, arithmetic between 
multiple time classes will produce informative error messages.

* the internal structure of lubridate R code has been reorganized at 
https://github.com/hadley/lubridate to make lubridate more development friendly.


### NEW FEATURES

* intervals are now more useful and lubridate has more ways to manipulate them.
Intervals can be created with %--%; modified with int_shift(), int_flip(), and 
int_standardize(); manipulated with intersect(), union(), and setdiff(); and 
used in logical tests with int_aligns(), int_overlaps(), and %within%. 
lubridate will no longer perform arithmetic between two intervals because the 
correct results of such operations is no more obvious than the correct result 
of adding two dates. Instead users are encouraged to use the new set 
operations or to directly modify intervals with int_start() and int_end(), 
which can also be used as settors. lubridate now supports negative intervals 
as well as positive intervals. Intervals also now display with a time zone.

* Modulo methods for timespans have been changed to return a timespan. this 
allows modulo methods to be used with integer division in an intuitive manner, 
e.g.

a = a %/% b * b + a %% b

Users can still acheive a numerical result by using as.numeric() on input 
before performing modulo.

* Periods, durations, and intervals can now all be put into a data frame.

* Periods, durations, and intervals can be intuitively subset with $ and []. 
These operations also can be used as settors with <-.

* The parsing functions and the as.period method for intervals are now 
slightly faster.

* month<- and wday<- settors accept names as well as numbers

* parsing functions now have a quiet argument to parse without messages and a 
tz argument to directly parse times into the desired time zone.

* logical comparison methods now work for period objects.

-------------
Version 0.2.6
=============


* use `test_package` to avoid incompatibility with current version of
  `testthat`
  
* other minor fixes to pass `R CMD check`

-------------
Version 0.2.5
=============

* added ymdThms() for parsing ISO 8061 formatted combned dates and times

### BUG FIXES

* removed bug in parsing dates with "T" in them

* modified as.period.interval() to display periods in positive units

-------------
Version 0.2.4
=============

* Add citations to JSS article

-------------
Version 0.2.3
=============

### NEW FEATURES

* ymd_hms(), hms(), and ms() functions can now parse dates that include 
decimal values in the seconds element.

* milliseconds(), microseconds(), nanoseconds(), and picoseconds() create 
period objects of the specified lengths. dmilliseconds(), dmicroseconds(), 
dnanoseconds(), and dpicoseconds() make duration objects of the specified 
lengths.


### BUG FIXES

* lubridate no longer overwrites months(), start(), and end() from base R. 
Start and end have been replaced with int_start() and int_end(). 

* lubridate imports plyr and stringr packages, instead of depending on them.

-------------
Version 0.2.2
=============

### NEW FEATURES

* made division, modulo, and integer division operations compatible with 
difftimes

* created c() methods for periods and durations


### BUG FIXES

* fixed bug in division, modulo, and integer operations with timespans


-------------
Version 0.2.1
=============

### NEW FEATURES

* created parsing functions ymd_hm ymd_h dmy_hms dmy_hm dmy_h mdy_hms mdy_hm 
mdy_h ydm_hms ydm_hm ydm_h, which operate in the same way as ymd_hms().

### BUG FIXES

* fixed bug in add_dates(). duration objects can now be successfully added to 
numeric objects.


-----------
Version 0.2
===========

### NEW FEATURES

* division between timespans: each timespan class (durations, periods, 
intervals) can be divided by other timespans. For example, how many weeks are 
there between Halloween and Christmas?: (christmas - halloween) / weeks(1)
  
* modulo operations between timespans

* duration objects now have their own class and display format separate from 
difftimes

* interval objects now use an improved data structure and have a cleaner 
display format

* lubridate now loads its own namespace

* math operations now automatically coerce interval objects to duration objects. 
Allows intervals to be used "right out of the box" without error messages.
  
* created start() and end() functions for accessing and changing the boundary 
date-times of an interval


* rep() methods for periods, intervals, and durations



### MINOR ### CHANGES

* added a package help page with functions listed by purpose

* eseconds(), eminutes(), etc. are aliased to dseconds(), dminutes(), etc. to 
make it easier to remember they are duration objects.
  
* changed leap.years() to leap_years() to maintain consistent naming scheme



### BUG FIXES

* rewrote as.period() to create only positive periods.

* fixed rollover bug in update.POSIXct()

* edited make_diff() to display in days when approporiate, not weeks 
