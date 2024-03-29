###### subtraction for everything

test_that("subtraction works as expected for instants", {
  x <- as.POSIXct("2008-01-01 00:00:02", tz = "UTC")
  y <- as.POSIXlt("2008-01-01 00:00:02", tz = "UTC")
  z <- as.Date("2008-01-03")

  expect_equal(x - years(1), as.POSIXct("2007-01-01 00:00:02", tz = "UTC"))
  expect_equal(y - years(1), as.POSIXlt("2007-01-01 00:00:02", tz = "UTC"))
  expect_equal(z - years(1), as.Date("2007-01-03"))

  expect_equal(x - dyears(1), as.POSIXct("2006-12-31 18:00:02", tz = "UTC"))
  expect_equal(y - dyears(1), as.POSIXlt("2006-12-31 18:00:02", tz = "UTC"))
  expect_equal(z - dyears(1), as.POSIXct("2007-01-02 18:00:00", tz = "UTC"))

  time1 <- as.POSIXct("2007-08-03 13:01:59", tz = "UTC")
  time2 <- as.POSIXct("2008-01-01 00:00:59", tz = "UTC")
  int <- interval(time1, time2)
  num <- as.numeric(time2) - as.numeric(time1)

  expect_error(x - int)
  expect_error(y - int)
  expect_error(z - int)
})

test_that("subtraction with instants returns correct class", {
  x <- as.POSIXct("2008-01-01 12:00:00", tz = "UTC")
  y <- as.POSIXlt("2008-01-01 12:00:00", tz = "UTC")
  z <- as.Date("2008-01-01")

  expect_s3_class(x - years(1), "POSIXct")
  expect_s3_class(y - years(1), "POSIXlt")
  expect_s3_class(z - years(1), "Date")
  expect_s3_class(x - dyears(1), "POSIXct")
  expect_s3_class(y - dyears(1), "POSIXlt")
})


test_that("subtraction works as expected for periods", {
  time1 <- as.POSIXct("2008-01-02 00:00:00", tz = "UTC")
  time2 <- as.POSIXct("2009-02-02 00:00:00", tz = "UTC")
  int <- interval(time1, time2)

  expect_equal(years(1) - 1, period(seconds = -1, years = 1))
  expect_error(years(1) - as.POSIXct("2008-01-01 00:00:00", tz = "UTC"))
  expect_error(years(1) - as.POSIXct("2008-01-01 00:00:00", tz = "UTC"))
  expect_equal(years(1) - minutes(3), period(minutes = -3, years = 1))
  expect_error(years(1) - dyears(1))
  expect_error(years(1) - int)
})

test_that("subtraction with periods returns correct class", {
  expect_s4_class(years(1) - 1, "Period")
  expect_s4_class(years(1) - minutes(3), "Period")
})


test_that("subtraction works as expected for durations", {
  time1 <- as.POSIXct("2008-01-02 00:00:00", tz = "UTC")
  time2 <- as.POSIXct("2009-08-03 00:00:00", tz = "UTC")
  int <- interval(time1, time2)

  expect_equal(dyears(1) - 1, duration(31557599))
  expect_error(dyears(1) - as.POSIXct("2008-01-01 00:00:00", tz = "UTC"))
  expect_error(dyears(1) - minutes(3))
  expect_equal(dyears(2) - dyears(1), dyears(1))
  expect_error(dyears(1) - int)
})

test_that("subtraction with durations returns correct class", {
  expect_s4_class(dyears(1) - 1, "Duration")
  expect_s4_class(dyears(1) - dyears(1), "Duration")
})


test_that("subtraction works as expected for intervals", {
  time1 <- as.POSIXct("2008-08-03 00:00:00", tz = "UTC")
  time2 <- as.POSIXct("2009-08-03 00:00:00", tz = "UTC")
  time3 <- as.POSIXct("2008-11-02 00:00:00", tz = "UTC")
  int <- interval(time1, time2)
  int2 <- interval(time3, time2)

  expect_error(time2 - int)
  expect_error(int - 1)
  expect_error(int - time1)
  expect_error(int - minutes(3))
  expect_error(int - dminutes(3))
  expect_error(int - int2)
})


test_that("%m-% correctly subtracts months without rollover", {
  may <- ymd_hms("2010-05-31 03:04:05")
  ends <- ymd_hms(c("2010-04-30 03:04:05", "2010-03-31 03:04:05", "2010-02-28 03:04:05"))

  expect_equal(may %m-% months(1:3), ends)
})

test_that("%m-% correctly subtracts years without rollover", {
  leap <- ymd("2012-02-29")
  next1 <- ymd("2011-02-28")
  next2 <- ymd("2011-01-29")
  next3 <- ymd("2011-03-29")

  expect_equal(leap %m-% years(1), next1)
  expect_equal(leap %m-% period(years = 1, months = 1), next2)
  expect_equal(leap %m-% period(years = 1, months = -1), next3)
})

test_that("%m-% correctly subtract negative months without rollover", {
  jan <- ymd_hms("2010-01-31 03:04:05")
  ends <- ymd_hms(c("2010-02-28 03:04:05", "2010-03-31 03:04:05", "2010-04-30 03:04:05"))

  expect_equal(jan %m-% -months(1:3), ends)
})

test_that("%m-% correctly subtracts negative years without rollover", {
  leap <- ymd("2012-02-29")
  next1 <- ymd("2013-02-28")
  next2 <- ymd("2013-03-29")
  next3 <- ymd("2013-01-29")

  expect_equal(leap %m-% years(-1), next1)
  expect_equal(leap %m-% period(years = -1, months = -1), next2)
  expect_equal(leap %m-% period(years = -1, months = 1), next3)
})
