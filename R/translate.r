#' Translate datasets
#'
#' Translate \link{trcli}, \link{trex} or \link{trexm} data.frames to/from
#' English or Turkish.
#'
#' @param x A \link{data.frame} to translate
#' @param lang Language to translate (\code{tr} or \code{en}).
#'
#' @export
translate <- function(x, lang = "tr") UseMethod("translate")

#' @describeIn translate Default method for \code{data.frame}
#' @export
translate.data.frame <- function(x, lang = "tr") {
  if (!(lang %in% c("en", "tr"))) stop("lang only can be 'en' or 'tr'")
  other_lang <- ifelse(lang == "en", "tr", "en")
  col_dict_en <- c("City", "Parameter", "Unit", month.name, "Annual",
                   "Start", "End", "Date", "Value")
  param_dict_en <- c("Monthly Total Precipitation Mean", "Minimum Temperature",
                     "Maximum Temperature", "Mean of Minimum Temperatures",
                     "Mean of Maximum Temperatures",
                     "Average Sunshine Duration",
                     "Average Temperature", "Mean of precipitation days",
                     "Maximum Snow Depth", "Maximum Daily Wind Speed",
                     "Maximum of Daily Total Precipitation Amount")
  unit_dict_en <- c("C", "d", "mm", "h", "cm", "km/h")
  loc <- Sys.getlocale("LC_TIME")
  Sys.setlocale(category = "LC_TIME", locale = "tr_TR.UTF-8")
  month_names_tr <- format(ISOdate(2000, 1:12, 1), "%B")
  Sys.setlocale(category = "LC_TIME", locale = loc)
  col_dict_tr <- c("Şehir", "Parametre", "Birim", month_names_tr, "Yıllık",
                   "Başlangıç", "Bitiş", "Tarih", "Değer")
  param_dict_tr <- c("Aylık Toplam Yağış Miktarı Ortalaması",
                     "En Düşük Sıcaklık", "En Yüksek Sıcaklık",
                     "Ortalama En Düşük Sıcaklık",
                     "Ortalama En Yüksek Sıcaklık",
                     "Ortalama Güneşlenme Süresi",
                     "Ortalama Sıcaklık", "Ortalama Yağışlı Gün Sayısı",
                     "En Yüksek Kar", "Günlük En Hızlı Rüzgar",
                     "Günlük Toplam En Yüksek Yağış Miktarı")
  unit_dict_tr <- c("C", "g", "mm", "s", "cm", "km/s")
  #
  col_dict <- param_dict <- unit_dict <- NULL
  for (s in c("col_dict", "param_dict", "unit_dict")) {
    eval(parse(text = paste0(s, " <- ", s, "_", lang)))
    eval(parse(text = paste0("names(", s, ") <- ", s, "_", other_lang)))
  }
  translate_base(x, col_dict, param_dict, unit_dict)
}

translate_base <- function(x, col_dict, param_dict, unit_dict) {
  trans <- function(x, dict) {
    sapply(x, function(y) {
      ifelse(tolower(y) %in% tolower(names(dict)), dict[y], y)
    }, USE.NAMES = FALSE)
  }
  #
  colnames(x) <- trans(colnames(x), col_dict)
  for (i in which(sapply(x, inherits, "factor")))
    levels(x[,i]) <- trans(levels(x[,i]), c(param_dict, unit_dict))
  period <- attr(x, "period")
  if (!is.null(period)) {
    colnames(period) <- trans(colnames(period), col_dict)
    attr(x, "period") <- period
  }
  return(x)
}
