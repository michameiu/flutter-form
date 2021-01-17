import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoginForm {
  String username;
  String password;

  String toString() => "Username:$username : password:$password";

  Map<String, String> toJson() => {"username": username, "password": password};
}

class Location {
  String type;
  List<dynamic> coordinates;
  get latLng => coordinates.length < 2
      ? null
      : {"lat": coordinates[0], "lng": coordinates[1]};
  get lat => coordinates.length < 2 ? null : coordinates[0];

  get lng => coordinates.length < 2 ? null : coordinates[1];
  String toString() => "LOCATION: lat:${lat}, lng:${lng}";

  LatLng toLatLng() =>
      coordinates.length < 2 ? null : LatLng(coordinates[0], coordinates[1]);
  Location({this.type, this.coordinates});

  static Location parseJson(location) {
    if (location==null){
      return null;
    }
    if (!location.containsKey("type") || !location.containsKey("coordinates")) {
      throw "Not a valid location";
    }
    return Location(type: location["type"], coordinates: location["coordinates"]);
  }
}

enum Role { A, T, N,C }

enum PaymentMode {
  I,
  C
}

class Profile {
  int id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phone;
  String password;
  Role role;
  String role_display;
  String profileImage;
  String fullName;
  dynamic location;

  // String get fullName{
  //   return "${firstName??""} ${lastName??""}";
  // }


  String toString() => "PROFILE: $firstName, $username, ${role} $location";
}



Role parseRole(String role) {
  print(role);
  switch (role) {
    case 'A':
      return Role.A;
    case 'T':
      return Role.T;
    case 'C':
      return Role.C;
    default:
      return Role.N;
  }
}
extension LocationParsing on  Map<String, dynamic> {
  Location parseLocation() {
    if (!this.containsKey("type") || !this.containsKey("coordinates")) {
      throw "Not a valid location";
    }
    return Location(type: this["type"], coordinates: this["coordinates"]);
  }
}

extension VtrackParsing on Map<String, dynamic> {
  Profile parseProfile() {
    var prof = Profile();
    if(this==null)return prof;
    if (!this.containsKey("username")) {
      return prof;
    }
    prof.username = this["username"];
    prof.firstName = this["first_name"];
    prof.id = this["id"];
    prof.lastName = this["last_name"];
    prof.phone = this["phone"];
    prof.role_display=this["role_display"];
    prof.role = parseRole(this["role"]);
    prof.profileImage=this["profile_image"];
    prof.fullName=this["full_name"];
    return prof;
  }


}
