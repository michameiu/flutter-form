import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../credentials.dart';

class GooglePlaceAutoComplete extends StatefulWidget {
  final Function placeSelected;

  const GooglePlaceAutoComplete({Key key, @required this.placeSelected}) : super(key: key);
  @override
  _GooglePlaceAutoCompleteState createState() =>
      _GooglePlaceAutoCompleteState();
}

class _GooglePlaceAutoCompleteState extends State<GooglePlaceAutoComplete> {
  TextEditingController _searchController = new TextEditingController();
  Timer _throttle;
  FocusNode searchFocusNode=FocusNode();

  List<GestureDetector> predictions = [];


  _GooglePlaceAutoCompleteState();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_throttle?.isActive ?? false) _throttle.cancel();
    _throttle = Timer(const Duration(milliseconds: 500), () {
      getLocationResults(_searchController.text);
    });
  }

  Future<LatLng> placeIdToLatLng(place_id) async{
    String request="https://maps.googleapis.com/maps/api/place/details/json?placeid=$place_id&key=$PLACES_API_KEY";
    http.Response response = await http.get(request);
    if(response.statusCode==200){
      var body=json.decode(response.body);
      print(body);
      if(body["status"]=="OK"){
        var latlng=body["result"]["geometry"]["location"];
        return LatLng(latlng["lat"],latlng["lng"]);
      }
    }
    return null;
  }

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      return;
    }

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';
    // TODO Add session token

    String request = '$baseURL?input=$input&key=$PLACES_API_KEY';

    var response=await http.get(request);
    var mypredictions={};
    if(response.statusCode==200){
      var body=json.decode(response.body);
      print(body);
      mypredictions=body;
    }
    if(mypredictions["status"]!="OK"){
      mypredictions={};
    }

    var all_predictions=mypredictions.containsKey("status")?mypredictions: PREDICTIONS_EXAMPLES;
//    print(all_predictions["predictions"][0]);
    if (all_predictions["status"] == "OK") {
      var _predictions =
      all_predictions["predictions"] as List<dynamic>;
      setState(() {
        predictions = _predictions.map((e) {
          var description=e["description"] as String;
          var title = description.split(",")[0];
          var subtitle = description.split(",").sublist(1).join(",");
          var place_id=e["place_id"];
          return GestureDetector(
            onTap: () async {
              print("Hello $place_id");
              widget.placeSelected(place_id);
              setState(() {
                predictions=[];
                _searchController.text="";
                searchFocusNode.unfocus();
              });
              //geodecode and place a map
//              var latlng=await placeIdToLatLng(place_id);
//              if(latlng !=null){
//                widget.placeSelected(latlng);
//              }
            },
            child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text(title),
                subtitle: Text(
                  subtitle,
                  style: TextStyle(fontSize: 13),
                )),
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(18),
      child: Container(
//        decoration: BoxDecoration(color: Colors.blue),
        height: deviceSize.height*.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 4,
              child: TextField(
                controller: _searchController,
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: "Search for your location",
                    hintStyle: TextStyle(
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: predictions.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      child: predictions[index],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
