# lubridate overwrites the addition method for POSIXt objects in base R to
# allow mathematics with date time objects.  .base_add_POSIXt preserves the 
# base R addition method for POSIXt objects so it can be referenced within the
# new addition operations.
.base_add_POSIXt <- NULL

.onLoad <- function(...) {
  if (is.null(.base_add_POSIXt)) {
    .base_add_POSIXt <<- base::'+.POSIXt'    
  }
  
  packageStartupMessage(
    "Overriding + and - methods for POSIXt, Date and difftime")

  utils::assignInNamespace("+.Date",     add_dates, "base")
  utils::assignInNamespace("+.POSIXt",   add_dates, "base")
  utils::assignInNamespace("+.difftime", add_dates, "base")
  utils::assignInNamespace("-.Date",     subtract_dates, "base")
  utils::assignInNamespace("-.POSIXt",   subtract_dates, "base")
  utils::assignInNamespace("-.difftime", subtract_dates, "base")

  # Needed so that environment matches environment of add_dates above
  utils::assignInNamespace("+.period",   add_dates, "lubridate")
  utils::assignInNamespace("+.interval", add_dates, "lubridate")
  utils::assignInNamespace("+.duration", add_dates, "lubridate")
  utils::assignInNamespace("-.period",   subtract_dates, "lubridate")
  utils::assignInNamespace("-.interval", subtract_dates, "lubridate")
  utils::assignInNamespace("-.duration", subtract_dates, "lubridate")
  # utils::assignInNamespace("+.period",   add_dates, "base")
  # utils::assignInNamespace("+.interval", add_dates, "base")
  # utils::assignInNamespace("-.period",   subtract_dates, "base")
  # utils::assignInNamespace("-.interval", subtract_dates, "base")
}

"+.period" <- "+.interval" <- "+.duration" <- add_dates
"-.period" <- "-.interval" <- "-.duration" <- subtract_dates

