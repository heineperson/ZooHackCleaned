library(data.table)

IBM <- fread("IBM_Watson_results.csv")
Google <- fread("GoogleImageResults.csv")

ImageNames <- Google[, .N, keyby=.(File)]
ImageNames[, Other := tolower(File)]
OtherNames <- IBM[, .N, keyby=.(Other=Filename)]
OtherNames[ImageNames, File := i.File, on=.(Other)]
OtherNames[Other=="pgymnocercus-cara_596-37.jpg", File := "Pgymnocercus-cara 596-37.JPG"]
na.omit(OtherNames, invert=TRUE)

IBM[OtherNames, File := i.File, on=.(Filename=Other)]
na.omit(IBM, invert=TRUE)

IBM[, .N, keyby=.(File)]
IBM[, Filename := File]
IBM[, File := NULL]
fwrite(IBM, "IBM_Watson_results2.csv")
