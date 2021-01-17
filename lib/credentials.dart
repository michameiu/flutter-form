//const PLACES_API_KEY="AIzaSyBTykT0eajPw6mVCAXlEV0BkX4uE4I3AWg";
//const PLACES_API_KEY="AIzaSyDfjGeFjtIg4H9KVwRWwKB9LI-OJBNp_f0";
const PLACES_API_KEY="AIzaSyC19xUUEjqzG1EoFsuhHuECPB_e-F4BeTM";


const PREDICTIONS_EXAMPLES= {
  "status": "OK",
  "predictions": [
    {
      "description": "Paris, France",
      "distance_meters": 8030004,
      "id": "691b237b0322f28988f3ce03e321ff72a12167fd",
      "matched_substrings": [
        {
          "length": 5,
          "offset": 0
        }
      ],
      "place_id": "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
      "reference": "CjQlAAAA_KB6EEceSTfkteSSF6U0pvumHCoLUboRcDlAH05N1pZJLmOQbYmboEi0SwXBSoI2EhAhj249tFDCVh4R-PXZkPK8GhTBmp_6_lWljaf1joVs1SH2ttB_tw",
      "terms": [
        {
          "offset": 0,
          "value": "Paris"
        },
        {
          "offset": 7,
          "value": "France"
        }
      ],
      "types": [ "locality", "political", "geocode"]
    },
    {
      "description": "Paris-Madrid Grocery (Spanish Table Seattle), Western Avenue, Seattle, WA, USA",
      "distance_meters": 12597,
      "id": "f4231a82cfe0633a6a32e63538e61c18277d01c0",
      "matched_substrings": [
        {
          "length": 5,
          "offset": 0
        }
      ],
      "place_id": "ChIJHcYlZ7JqkFQRlpy-6pytmPI",
      "reference": "ChIJHcYlZ7JqkFQRlpy-6pytmPI",
      "structured_formatting": {
        "main_text": "Paris-Madrid Grocery (Spanish Table Seattle)",
        "main_text_matched_substrings": [
          {
            "length": 5,
            "offset": 0
          }
        ],
        "secondary_text": "Western Avenue, Seattle, WA, USA"
      },
      "terms": [
        {
          "offset": 0,
          "value": "Paris-Madrid Grocery (Spanish Table Seattle)"
        },
        {
          "offset": 46,
          "value": "Western Avenue"
        },
        {
          "offset": 62,
          "value": "Seattle"
        },
        {
          "offset": 71,
          "value": "WA"
        },
        {
          "offset": 75,
          "value": "USA"
        }
      ],
      "types": [
        "grocery_or_supermarket",
        "food",
        "store",
        "point_of_interest",
        "establishment"
      ]
    }
  ]
};