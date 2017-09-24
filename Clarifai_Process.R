
# Bring in libraries
library(RJSONIO)
library(data.table)

# Run clarifai
allImages <- list.files("./Zoohackathon2017_SamplePhotos")
allImagesNoSpaces <- gsub("\\s+","",allImages)
AllImages <- data.table(Orig=allImages,New=allImagesNoSpaces)
sapply(1:nrow(AllImages), function(x) system(paste0("cp ./Zoohackathon2017_SamplePhotos/'",AllImages$Orig[x],
  "' ./ZooNoSpace/",AllImages$New[x])))
length(list.files("./ZooNoSpace"))
#system("gsutil cp -r ./ZooNoSpace gs://BUCKET")

processImage <- function(x) {
  
  # Set assumptions
  print(x)
  OrigImage <- AllImages[x, Orig]
  NewImage <- AllImages[x, New]
  
  # Pull data
  runStatement <- paste0("bash clarifai.sh ",NewImage," > out.json")
  runSys <- system(runStatement, intern=TRUE)
  
  # Read in JSON files
  json_file <- "out.json"
  json_file <- fromJSON(json_file)
  
  # Convert JSON to data
  imageNames <- lapply(json_file$outputs[[1]]$data$concepts, "[[", "name")
  imageValues <- lapply(json_file$outputs[[1]]$data$concepts, "[[", "value")
  imageDat <- data.table(description=imageNames, score=imageValues)
  imageDat[, File := OrigImage]
  system("rm out.json")
  return(imageDat[])
}

# Process all images
resultImageList <- lapply(1:nrow(AllImages), processImage)
resultImageDat <- rbindlist(resultImageList, fill=TRUE)
resultImageDat[, .N, keyby=.(File)][order(-N)]

# Which didn't work? Most seemed to fail because of encoding??
missing <- setdiff(AllImages$Orig, unique(resultImageDat$File))
AllImages[Orig %in% missing]
AllImages[Orig %in% missing, which=TRUE]

fwrite(resultImageDat, "ClarifaiImageResults.csv")


