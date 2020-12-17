############################################################################
# Downloads Water Quality Portal data for DEQ-LRO data viewer
# Jason Williams
# Last updated: 12-17-2020
############################################################################

library(dplyr)

# projects: IDEQ LEW HC, IDEQ LEW SW, Lindsay Cr, Syringa MHP

hucinfo <-read.csv("hucinfo.csv", header = TRUE)

# download WQP data & format----------------------------------------------------------------------------

# sites
sites_file <-download.file("https://www.waterqualitydata.us/data/Station/search?organization=IDEQ_WQX&project=IDEQ%20LEW%20HC&project=IDEQ%20LEW%20SW&project=LindsayCr&project=Syringa%20MHP&mimeType=csv&zip=no",
                          destfile = "sites_file.csv")

sites <-
  read.csv("sites_file.csv") %>%
  mutate(sitename = paste(MonitoringLocationName, MonitoringLocationIdentifier, sep = " - "))

sitenames <-
  sites %>%
  distinct(MonitoringLocationIdentifier, MonitoringLocationName, sitename, HUCEightDigitCode, LatitudeMeasure, LongitudeMeasure)


# results

results_file <-download.file("https://www.waterqualitydata.us/data/Result/search?organization=IDEQ_WQX&project=IDEQ%20LEW%20HC&project=IDEQ%20LEW%20SW&project=LindsayCr&project=Syringa%20MHP&mimeType=csv&zip=no",
                             destfile = "results_file.csv")

results <-
  read.csv("results_file.csv") %>%
  merge(sitenames, by = "MonitoringLocationIdentifier", all.x = TRUE) %>%
  mutate(result = as.numeric(as.character(ResultMeasureValue)),
         date = as.Date(ActivityStartDate, format = "%Y-%m-%d"),
         parameter = paste(CharacteristicName, " (", ResultMeasure.MeasureUnitCode, ")", sep = "")) %>%
  merge(hucinfo, by.x = "HUCEightDigitCode", by.y = "HUC4CODE", all.x = TRUE) %>%
  mutate(hucnames = paste(HUCEightDigitCode, HUC4NAME, sep = " "))

str(results)
colnames(results)

