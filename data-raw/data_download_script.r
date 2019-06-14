
get_table1 <- function(tab1) {
  s <- unlist(strsplit(tab1$getText(), split = "\n", fixed = TRUE))
  col_names <- unlist(strsplit(s[1], " "))[-1]
  period <- as.numeric(strsplit(substr(s[2], 18, nchar(s[2]) - 1), " - ")[[1]])
  s <- strsplit(s[-c(1:2,9, 12)], " ")
  suppressWarnings(
    vals <- t(sapply(s, function(x) as.numeric(x[(length(x) - 12):length(x)])))
  )
  Parametre <- sapply(s, function(x)
    paste(x[1:(length(x) - 13)], collapse = " "))
  Parametre <- trimws(sapply(strsplit(Parametre, "(", fixed = TRUE),
                             function(x) x[1]))
  Birim <- c("C", "C", "C", "s", "g", "mm", "C", "C")
  df <- as.data.frame(vals)
  colnames(df) <- col_names
  df <- cbind(Parametre, Birim, df)
  df$Parametre <- as.factor(df$Parametre)
  df$Birim <- as.factor(df$Birim)
  attr(df, "period") <- period
  return(df)
}

get_ext <- function(tab1, is_min = TRUE) {
  xp <- sprintf("tbody/tr[%d]/td[%%d]", 9 + is_min)
  Değer <- sapply(1:12, function(i) {
    as.numeric(tab1$findElement(xpath = sprintf(xp, i))$getText())
  })
  Tarih <- as.Date(sapply(1:12, function(i) {
    tab1$findElement(xpath = sprintf(xp, i))$getAttribute(name = "title")
  }), "%d.%m.%Y")
  data.frame(Tarih, Değer)
}

get_extrem_temp <- function(tab1) {
  p <- tab1$findElement(xpath = "tbody/tr[8]/th")$getText()
  period <- as.numeric(strsplit(substr(p, 18, nchar(p) - 1), " - ")[[1]])
  maxs <- data.frame(Parametre = "En Yüksek Sıcaklık", get_ext(tab1, FALSE))
  mins <- data.frame(Parametre = "En Düşük Sıcaklık", get_ext(tab1, TRUE))
  df <- rbind(mins, maxs)
  df$Parametre <- as.factor(df$Parametre)
  attr(df, "period") <- period
  return(df)
}

get_extrems <- function(tab2, df) {
  ext <- cbind(df[c(which.min(df[,3]), which.max(df[,3])),], Birim = "C")
  xp <- "thead/tr/th[%d]"
  Parametre <- sapply(1:3, function(i)
    tab2$findElement(xpath = sprintf(xp, i))$getText())
  xp <- "tbody/tr/td[%d]"
  Tarih <- as.Date(sapply(c(1, 3, 5),function(i)
    tab2$findElement(xpath = sprintf(xp, i))$getText()), "%d.%m.%Y")
  Değer <- suppressWarnings(as.numeric(sapply(c(2, 4, 6),function(i)
    strsplit(tab2$findElement(xpath = sprintf(xp, i))$getText(), " ")[[1]][1])))
  Birim <- sapply(c(2, 4, 6), function(i)
    strsplit(tab2$findElement(xpath = sprintf(xp, i))$getText(), " ")[[1]][2])
  Birim[which(Birim == "km/sa")] <- "km/s"
  df <- data.frame(Parametre, Tarih, Değer, Birim)
  df$Parametre <- as.factor(df$Parametre)
  df <- rbind(ext, df)
  df$Birim <- as.factor(df$Birim)
  df <- df[,c(1, 4, 2, 3)]
  return(df)
}

get_city_names <- function(s) {
  strsplit(
    s$findElement(xpath = "//*[@id=\"nav_iller\"]/p")$getText(), " ")[[1]]
}

get_city_links <- function(s, n) {
  xp <- "//*[@id=\"nav_iller\"]/p/a[%d]"
  sapply(1:n, function(i)
    s$findElement(xpath = sprintf(xp, i))$getAttribute(name = "href"))
}

download_stats_for_city <- function(session, url) {
  session$go(url)
  e <- session$findElement(xpath = "//*[@id=\"cph_body_pnlA\"]/div[1]")
  tab1 <- e$findElement(xpath = "table[1]")
  extreme_temps <- get_extrem_temp(tab1)
  extremes <- get_extrems(e$findElement(xpath = "table[2]"), extreme_temps)
  tab1 <- get_table1(tab1)
  return(list(tab1, extreme_temps, extremes))
}

download_all_stats <- function() {
  url <- paste0("https://www.mgm.gov.tr",
                "/veridegerlendirme/il-ve-ilceler-istatistik.aspx")
  pjs <- webdriver::run_phantomjs()
  session <- webdriver::Session$new(port = pjs$port)
  session$go(url)
  city <- get_city_names(session)
  city_links <- get_city_links(session, length(city))
  x <- lapply(city_links, function(s) download_stats_for_city(session, s))
  session$delete(); pjs$process$kill()
  access_time <- Sys.time()
  #
  p <- lapply(1:2, function(i) {
    p1 <- cbind(city,
                as.data.frame(t(sapply(x, function(y) attr(y[[i]], "period")))))
    colnames(p1) <- c("Şehir", "Başlangıç", "Bitiş")
    p1$Şehir <- as.factor(p1$Şehir); p1
  })
  #
  for (i in 1:length(city))
    for (j in 1:3) x[[i]][[j]] <- cbind(Şehir = city[i], x[[i]][[j]])
  df <- lapply(1:3, function(i) {
    df <- do.call("rbind", lapply(x, function(x) x[[i]]))
    df$Şehir <- as.factor(df$Şehir)
    attr(df, "access") <- access_time
    df
  })
  attr(df[[1]], "period") <- p[[1]]; attr(df[[2]], "period") <- p[[2]]
  return(df)
}

save_data <- function() {
  df <- download_all_stats()
  df <- lapply(df, function(d) {
    d[is.na(d)] <- NA
    rmet::translate(d, "en")
  })
  trcli2 = df[[1]]; trexm2 = df[[2]]; trex2 = df[[3]]
  access_time <- attr(trcli2, "access")
  # load old data
  trcli <- trexm <- trex <- NULL
  files <- paste0("data/", c("trcli", "trexm", "trex"), ".rda")
  for (f in files) if (file.exists(f)) load(f)
  ok <- is.null(trcli) & is.null(trexm) & is.null(trex)
  if (!ok) {
    ok <- any(mapply(FUN = function(x, y) {
      !is.null(x) && !isTRUE(all.equal(x, y, check.attributes = FALSE))
    }, list(trcli, trexm, trex), list(trcli2, trexm2, trex2)))
  }
  if (ok) {
    trcli <- trcli2; trexm <- trexm2; trex <- trex2
    usethis::use_data(access_time, trcli, trexm, trex, overwrite = TRUE)
  } else cat("Data is up-to-date.\n")
}

save_data()
#
