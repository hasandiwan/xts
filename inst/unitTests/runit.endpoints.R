
# index crosses the unix epoch
test.double_index_cross_epoch <- function() {
  x <- .xts(1:22, 1.0*(-10:11), tzone="UTC")
  ep <- endpoints(x, "seconds", 2)
  checkIdentical(ep, 0:11*2L)
}
test.integer_index_cross_epoch <- function() {
  x <- .xts(1:22, -10:11, tzone="UTC")
  ep <- endpoints(x, "seconds", 2)
  checkIdentical(ep, 0:11*2L)
}

#{{{daily data
data(sample_matrix)
xDailyDblIdx <- as.xts(sample_matrix, dateFormat="Date")
xDailyIntIdx <- xDailyDblIdx
storage.mode(.index(xDailyIntIdx)) <- "integer"

test.days_double_index <- function() {
  ep <- endpoints(xDailyDblIdx, "days", 7)
  checkIdentical(ep, c(0L, 1:25*7L-1L, nrow(xDailyDblIdx)))
}
test.days_integer_index <- function() {
  ep <- endpoints(xDailyIntIdx, "days", 7)
  checkIdentical(ep, c(0L, 1:25*7L-1L, nrow(xDailyIntIdx)))
}

test.weeks_double_index <- function() {
  ep <- endpoints(xDailyDblIdx, "weeks", 1)
  checkIdentical(ep, c(0L, 1:25*7L-1L, nrow(xDailyDblIdx)))
}
test.weeks_integer_index <- function() {
  ep <- endpoints(xDailyIntIdx, "weeks", 1)
  checkIdentical(ep, c(0L, 1:25*7L-1L, nrow(xDailyIntIdx)))
}

test.months_double_index <- function() {
  ep <- endpoints(xDailyDblIdx, "months", 1)
  checkIdentical(ep, c(0L, 30L, 58L, 89L, 119L, 150L, 180L))
}
test.months_integer_index <- function() {
  ep <- endpoints(xDailyIntIdx, "months", 1)
  checkIdentical(ep, c(0L, 30L, 58L, 89L, 119L, 150L, 180L))
}

test.quarters_double_index <- function() {
  ep <- endpoints(xDailyDblIdx, "quarters", 1)
  checkIdentical(ep, c(0L, 89L, 180L))
}
test.quarters_integer_index <- function() {
  ep <- endpoints(xDailyIntIdx, "quarters", 1)
  checkIdentical(ep, c(0L, 89L, 180L))
}

test.years_double_index <- function() {
  d <- seq(as.Date("1970-01-01"), by="1 day", length.out=365*5)
  x <- xts(seq_along(d), d)
  ep <- endpoints(x, "years", 1)
  checkIdentical(ep, c(0L, 365L, 730L, 1096L, 1461L, 1825L))
}
test.years_integer_index <- function() {
  d <- seq(as.Date("1970-01-01"), by="1 day", length.out=365*5)
  x <- xts(seq_along(d), d)
  storage.mode(.index(x)) <- "integer"
  ep <- endpoints(x, "years", 1)
  checkIdentical(ep, c(0L, 365L, 730L, 1096L, 1461L, 1825L))
}
#}}}

#{{{second data
n <- 86400L %/% 30L * 365L * 2L
xSecIntIdx <- .xts(1L:n,
    seq(.POSIXct(0, tz="UTC"), by="30 sec", length.out=n), tzone="UTC")
xSecDblIdx <- xSecIntIdx 
storage.mode(.index(xSecDblIdx)) <- "double"

test.seconds_double_index <- function() {
  ep <- endpoints(xSecDblIdx, "seconds", 3600)
  checkIdentical(ep, seq(0L, nrow(xSecDblIdx), 120L))
}
test.seconds_integer_index <- function() {
  ep <- endpoints(xSecIntIdx, "seconds", 3600)
  checkIdentical(ep, seq(0L, nrow(xSecIntIdx), 120L))
}
test.seconds_secs <- function() {
  x <- .xts(1:10, 1:10/6)
  ep1 <- endpoints(x, "seconds")
  ep2 <- endpoints(x, "secs")
  checkIdentical(ep1, ep2)
}

test.minutes_double_index <- function() {
  ep <- endpoints(xSecDblIdx, "minutes", 60)
  checkIdentical(ep, seq(0L, nrow(xSecDblIdx), 120L))
}
test.minutes_integer_index <- function() {
  ep <- endpoints(xSecIntIdx, "minutes", 60)
  checkIdentical(ep, seq(0L, nrow(xSecIntIdx), 120L))
}
test.minutes_mins <- function() {
  x <- .xts(1:10, 1:10*10)
  ep1 <- endpoints(x, "minutes")
  ep2 <- endpoints(x, "mins")
  checkIdentical(ep1, ep2)
}

test.hours_double_index <- function() {
  ep <- endpoints(xSecDblIdx, "hours", 1)
  checkIdentical(ep, seq(0L, nrow(xSecDblIdx), 120L))
}
test.hours_integer_index <- function() {
  ep <- endpoints(xSecIntIdx, "hours", 1)
  checkIdentical(ep, seq(0L, nrow(xSecIntIdx), 120L))
}

test.days_double_index <- function() {
  ep <- endpoints(xSecDblIdx, "days", 1)
  checkIdentical(ep, seq(0L, by=2880L, length.out=length(ep)))
}
test.days_integer_index <- function() {
  ep <- endpoints(xSecIntIdx, "days", 1)
  checkIdentical(ep, seq(0L, by=2880L, length.out=length(ep)))
}

test.weeks_double_index <- function() {
  ep <- endpoints(xSecDblIdx, "weeks", 1)
  ep2 <- c(0L, seq(11520L, nrow(xSecDblIdx)-1L, 20160L), nrow(xSecDblIdx))
  checkIdentical(ep, ep2)
}
test.weeks_integer_index <- function() {
  ep <- endpoints(xSecIntIdx, "weeks", 1)
  ep2 <- c(0L, seq(11520L, nrow(xSecIntIdx)-1L, 20160L), nrow(xSecIntIdx))
  checkIdentical(ep, ep2)
}

test.months_double_index <- function() {
  ep <- endpoints(xSecDblIdx, "months", 1)
  n <- 86400L * c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31) / 30
  ep2 <- as.integer(cumsum(c(0L, n, n)))
  checkIdentical(ep, ep2)
}
test.months_integer_index <- function() {
  ep <- endpoints(xSecIntIdx, "months", 1)
  n <- 86400L * c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31) / 30
  ep2 <- as.integer(cumsum(c(0L, n, n)))
  checkIdentical(ep, ep2)
}

test.quarters_double_index <- function() {
  ep <- endpoints(xSecDblIdx, "quarters", 1)
  n <- 86400L * c(90, 91, 92, 92) / 30
  ep2 <- as.integer(cumsum(c(0L, n, n)))
  checkIdentical(ep, ep2)
}
test.quarters_integer_index <- function() {
  ep <- endpoints(xSecIntIdx, "quarters", 1)
  n <- 86400L * c(90, 91, 92, 92) / 30
  ep2 <- as.integer(cumsum(c(0L, n, n)))
  checkIdentical(ep, ep2)
}

test.years_double_index <- function() {
  ep <- endpoints(xSecDblIdx, "years", 1)
  checkIdentical(ep, c(0L, 1051200L, 2102400L))
}
test.years_integer_index <- function() {
  ep <- endpoints(xSecIntIdx, "years", 1)
  checkIdentical(ep, c(0L, 1051200L, 2102400L))
}
#}}}

# sparse endpoints could be a problem with POSIXlt elements (#169)
# TODO: sparse intraday endpoints
test.sparse_years <- function() {
  x <- xts(2:6, as.Date(sprintf("199%d-06-01", 2:6)))
  ep <- endpoints(x, "years")
  checkIdentical(ep, 0:5)
}
test.sparse_quarters <- function() {
  x <- xts(2:6, as.Date(sprintf("199%d-06-01", 2:6)))
  ep <- endpoints(x, "quarters")
  checkIdentical(ep, 0:5)
}
test.sparse_months <- function() {
  x <- xts(2:6, as.Date(sprintf("199%d-06-01", 2:6)))
  ep <- endpoints(x, "months")
  checkIdentical(ep, 0:5)
}
test.sparse_weeks <- function() {
  x <- xts(2:6, as.Date(sprintf("199%d-06-01", 2:6)))
  ep <- endpoints(x, "weeks")
  checkIdentical(ep, 0:5)
}
test.sparse_days <- function() {
  x <- xts(2:6, as.Date(sprintf("199%d-06-01", 2:6)))
  ep <- endpoints(x, "days")
  checkIdentical(ep, 0:5)
}

# sub-second resolution on Windows
test.sub_second_resolution <- function() {
  x <- .xts(1:6, .POSIXct(0:5 / 10 + 0.01))
  ep <- endpoints(x, "ms", 250)
  checkIdentical(ep, c(0L, 3L, 5L, 6L))
}

# precision issues
test.sub_second_resolution_exact <- function() {
  x <- .xts(1:6, .POSIXct(0:5 / 10))
  ep <- endpoints(x, "ms", 250)
  checkIdentical(ep, c(0L, 3L, 5L, 6L))
}
test.sub_second_resolution_representation <- function() {
  x <- .xts(1:10, .POSIXct(1.5e9 + 0:9 / 10))
  ep <- endpoints(x, "ms", 200)
  checkIdentical(ep, seq(0L, 10L, 2L))
}

# on = "quarters", k > 1
test.multiple_quarters <- function() {
  x <- xts(1:48, as.yearmon("2015-01-01") + 0:47 / 12)
  checkIdentical(endpoints(x, "quarters", 1), seq(0L, 48L, 3L))
  checkIdentical(endpoints(x, "quarters", 2), seq(0L, 48L, 6L))
  checkIdentical(endpoints(x, "quarters", 3), c(seq(0L, 48L, 9L), 48L))
  checkIdentical(endpoints(x, "quarters", 4), seq(0L, 48L,12L))
  checkIdentical(endpoints(x, "quarters", 5), c(seq(0L, 48L,15L), 48L))
  checkIdentical(endpoints(x, "quarters", 6), c(seq(0L, 48L,18L), 48L))
}

# end(x) always in endpoints(x) result
test.last_obs_always_in_output <- function() {
  N <- 341*12
  xx <- xts(rnorm(N), seq(Sys.Date(), by = "day", length.out = N))

  ep <- endpoints(xx, on = "quarters", k = 2) # OK
  checkIdentical(end(xx), end(xx[ep,]), "quarters, k=2")

  ep <- endpoints(xx, on = "quarters", k = 3) # NOPE
  checkIdentical(end(xx), end(xx[ep,]), "quarters, k=3")

  ep <- endpoints(xx, on = "quarters", k = 4) # NOPE
  checkIdentical(end(xx), end(xx[ep,]), "quarters, k=4")

  ep <- endpoints(xx, on = "quarters", k = 5) # NOPE
  checkIdentical(end(xx), end(xx[ep,]), "quarters, k=5")

  ep <- endpoints(xx, on = "months", k = 2) # NOPE
  checkIdentical(end(xx), end(xx[ep,]), "months, k=2")

  ep <- endpoints(xx, on = "months", k = 3) # OK
  checkIdentical(end(xx), end(xx[ep,]), "months, k=3")

  ep <- endpoints(xx, on = "months", k = 4) # NOPE
  checkIdentical(end(xx), end(xx[ep,]), "months, k=4")

  # For the "weeks" case works fine

  ep <- endpoints(xx, on = "weeks", k = 2) # OK
  checkIdentical(end(xx), end(xx[ep,]), "weeks, k=2")

  ep <- endpoints(xx, on = "weeks", k = 3) # OK
  checkIdentical(end(xx), end(xx[ep,]), "weeks, k=3")

  ep <- endpoints(xx, on = "weeks", k = 4) # OK
  checkIdentical(end(xx), end(xx[ep,]), "weeks, k=4")
}

test.k_less_than_1_errors <- function() {
  x <- xDailyIntIdx

  checkException(endpoints(x, on = "years", k =  0))
  checkException(endpoints(x, on = "years", k = -1))

  checkException(endpoints(x, on = "quarters", k =  0))
  checkException(endpoints(x, on = "quarters", k = -1))

  checkException(endpoints(x, on = "months", k =  0))
  checkException(endpoints(x, on = "months", k = -1))

  checkException(endpoints(x, on = "weeks", k =  0))
  checkException(endpoints(x, on = "weeks", k = -1))

  checkException(endpoints(x, on = "days", k =  0))
  checkException(endpoints(x, on = "days", k = -1))

  x <- xSecIntIdx

  checkException(endpoints(x, on = "hours", k =  0))
  checkException(endpoints(x, on = "hours", k = -1))

  checkException(endpoints(x, on = "minutes", k =  0))
  checkException(endpoints(x, on = "minutes", k = -1))

  checkException(endpoints(x, on = "seconds", k =  0))
  checkException(endpoints(x, on = "seconds", k = -1))

  x <- .xts(1:10, sort(1 + runif(10)))

  checkException(endpoints(x, on = "ms", k =  0))
  checkException(endpoints(x, on = "ms", k = -1))

  checkException(endpoints(x, on = "us", k =  0))
  checkException(endpoints(x, on = "us", k = -1))
}
