import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import '../auth/model.dart';

part 'repair.g.dart';

enum PaymentMethod { I, C }

@JsonSerializable()
class RepairProfile {
  int id;
  String first_name;
  String last_name;
  String username;
  String email;
  String phone;
  Role role;
  String role_display;
  String profile_image;
  String full_name;
  dynamic location;

  RepairProfile(
      {this.email,
      this.role,
      this.role_display,
      this.id,
      this.location,
      this.first_name,
      this.full_name,
      this.last_name,
      this.phone,
      this.profile_image,
      this.username});

  factory RepairProfile.fromJson(Map<String, dynamic> json) =>
      _$RepairProfileFromJson(json);

  Map<String, dynamic> toJson() => _$RepairProfileToJson(this);

  String toString() =>
      "RepairPROFILE: $first_name, $username, ${role} $location";


}

@JsonSerializable(explicitToJson: true)
class Repair {
  int id;
  RepairProfile user_details;
  RepairProfile technician_details;
  String status_display;
  Map<String, double> location;
  bool is_active;
  bool has_appointment;
  String car_category_name;
  String car_model_name;
  DateTime created;
  DateTime modified;
  double lat;
  double lng;
  String location_description;
  PaymentMethod payment_method;
  String reason_for_cancellation;
  DateTime appointment;
  String plate_number;
  String plate_number_image;
  String before_image;
  String mpesa_confirmation_code;
  int car_type;
  int user;
  int technician;
  int car_model;
  int car_category;
  double amount;
  String car_type_engine_capacity;

  Repair(
      {this.id,
      this.appointment,
      this.before_image,
      this.car_category,
      this.car_category_name,
      this.car_model,
      this.car_model_name,
      this.car_type,
      this.created,
      this.has_appointment,
      this.is_active,
      this.lat,
      this.lng,
      this.location,
      this.location_description,
      this.modified,
      this.mpesa_confirmation_code,
      this.payment_method,
      this.plate_number,
      this.plate_number_image,
      this.reason_for_cancellation,
      this.status_display,
      this.technician,
      this.technician_details,
      this.user,
      this.amount,
      this.car_type_engine_capacity,
      this.user_details});

  get repairDate{
    return this.appointment??this.created;
  }

  get repairDateDisplay{
    return DateFormat.yMEd().add_jms().format(repairDate);
  }

  factory Repair.fromJson(Map<String, dynamic> json) => _$RepairFromJson(json);

  static List<Repair> fromJsonArray(List<dynamic> data) {
    return data.map((e) => Repair.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => _$RepairToJson(this);

  String toHttpBody(){
    var obj=toJson();
    var params={};
    obj.forEach((key,value){
      if(value !=null){
        params[key]=value;
      }
    });
    return json.encode(params);
  }
}
