#' Monthly Climatological Means
#'
#' This dataset contains monthly climatological means and extremes for
#' \code{81} cities in Turkey.
#'
#' Data contains following parameters:
#' \enumerate{
#'   \item{Monthly Total Precipitation Mean}{ (\code{mm})}
#'   \item{Minimum Temperature}{ (\code{degree Celcius})}
#'   \item{Maximum Temperature}{ (\code{degree Celcius})}
#'   \item{Mean of Minimum Temperatures}{ (\code{degree Celcius})}
#'   \item{Mean of Maximum Temperatures}{ (\code{degree Celcius})}
#'   \item{Average Sunshine Duration}{ (\code{hour})}
#'   \item{Average Temperature}{ (\code{degree Celcius})}
#'   \item{Mean of precipitation days}{ (\code{day})}
#' }
#'
#' Column Names:
#' \enumerate{
#'   \item{City}{ (\code{Factor})}
#'   \item{Parameter}{ (\code{factor})}
#'   \item{Unit}{ (\code{factor})}
#'   \item{January}{ (\code{numeric})}
#'   \item{February}{ (\code{numeric})}
#'   \item{March}{ (\code{numeric})}
#'   \item{April}{ (\code{numeric})}
#'   \item{May}{ (\code{factor})}
#'   \item{June}{ (\code{numeric})}
#'   \item{July}{ (\code{numeric})}
#'   \item{August}{ (\code{numeric})}
#'   \item{September}{ (\code{numeric})}
#'   \item{October}{ (\code{numeric})}
#'   \item{November}{ (\code{numeric})}
#'   \item{December}{ (\code{numeric})}
#'   \item{Annual}{ (\code{numeric})}
#' }
#'
#' Also you can obtain oberservation period by \code{period} attribute attached
#' to the data.
#'
#' @seealso \link{translate}
#' @source Source: \url{http://www.mgm.gov.tr}
#'
"trcli"

#' Monthly Extreme temperatures and dates
#'
#' Data contains monthly recorded minimum and maximum temperatures for \code{81}
#' cities in Turkey.
#'
#' Column Names:
#' \enumerate{
#'   \item{City}{ (\code{Factor})}
#'   \item{Parameter}{ (\code{factor})}
#'   \item{Date}{ (\code{date})}
#'   \item{Value}{ (\code{numeric})}
#' }
#'
#' Also you can obtain oberservation period by \code{period} attribute attached
#' to the data.
#'
#' @seealso \link{translate}
#' @source Source: \url{http://www.mgm.gov.tr}
#'
"trexm"

#' Extremes and dates
#'
#' Data contains minimum & maximum recorded temperatures, maximum total daily
#' precipitation amount, maximum daily wind speed and maxmimum depth of snow
#' for 81 cities in Turkey.
#'
#' Data contains following parameters:
#' \enumerate{
#'   \item{Minimum Temperature}{ (\code{degree Celcius})}
#'   \item{Maximum Temperature}{ (\code{degree Celcius})}
#'   \item{Maximum Snow Depth}{ (\code{cm})}
#'   \item{Maximum Daily Wind Speed}{ (\code{km/h})}
#'   \item{Maximum of Daily Total Precipitation Amount}{ (\code{mm})}
#' }
#'
#' Column Names:
#' \enumerate{
#'   \item{City}{ (\code{Factor})}
#'   \item{Parameter}{ (\code{factor})}
#'   \item{Unit}{ (\code{factor})}
#'   \item{Date}{ (\code{date})}
#'   \item{Value}{ (\code{numeric})}
#' }
#'
#' @seealso \link{translate}
#' @source Source: \url{http://www.mgm.gov.tr}
#'
"trex"

#' Access Time
#'
#' Access Time of datasets.
#'
"access_time"