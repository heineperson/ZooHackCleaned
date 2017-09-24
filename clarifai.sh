curl -X POST \
  -H "Authorization: Key KEYNOTINQUOTES" \
  -H "Content-Type: application/json" \
  -d '
  {
    "inputs": [
{
  "data": {
    "image": {
    "url": "https://storage.googleapis.com/metabiota-playground/ZooNoSpace/'$1'"
    }
  }
}
    ]
  }'\
  https://api.clarifai.com/v2/models/aaa03c23b3724a16a56b629203edc62c/outputs