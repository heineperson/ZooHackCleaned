
# Bring in libraries
library(data.table)
library(RoogleVision)
library(googleAuthR)

### Plugin Credentials
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))
service_token <- gar_auth_service(json_file="JSON_PATH")

# List files
ImageFiles <- list.files("./Zoohackathon2017_SamplePhotos", full.names = TRUE)

# Function to grab Google ID
grabGoogleID <- function(x) {
  IMG_RESULTS <- getGoogleVisionResponse(x, feature="LABEL_DETECTION", numResults = 10)
  setDT(IMG_RESULTS)
  IMG_RESULTS[, File := basename(x)]
  return(IMG_RESULTS)
}

# Loop through
ImageIDList <- lapply(ImageFiles, grabGoogleID)
ImageIDOutput <- rbindlist(ImageIDList, fill=TRUE)
ImageIDOutput
fwrite(ImageIDOutput, "GoogleImageResults.csv", na = "")

# AWS

# Upload images
system("aws s3 --profile PROFILE cp ./Zoohackathon2017_SamplePhotos s3://BUCKET/Images/ --recursive")

# Function to grab AWS IDs
grabAWS_ID <- function(x) {
  print(x)
  awsCall <- paste0("aws rekognition detect-labels ",
                  "--image '{\"S3Object\":{\"Bucket\":\"BUCKET\",\"Name\":\"Images/",x,"\"}}'",
                  " --region us-west-2 --profile PROFILE")
  awsDat <- fread(awsCall, skip=0)
  awsDat[, File := x]
  return(awsDat)
}

# Loop through
ImageFiles <- list.files("./Zoohackathon2017_SamplePhotos", full.names = FALSE) # List files
AWS_IDList <- lapply(ImageFiles, grabAWS_ID)
AWS_IDOutput <- rbindlist(AWS_IDList, fill=TRUE)
AWS_IDOutput
fwrite(AWS_IDOutput, "AWSImageResults.csv", na = "")

