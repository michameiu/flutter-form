// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepairProfile _$RepairProfileFromJson(Map<String, dynamic> json) {
  return RepairProfile(
    email: json['email'] as String,
    role: _$enumDecodeNullable(_$RoleEnumMap, json['role']),
    role_display: json['role_display'] as String,
    id: json['id'] as int,
    location: json['location'],
    first_name: json['first_name'] as String,
    full_name: json['full_name'] as String,
    last_name: json['last_name'] as String,
    phone: json['phone'] as String,
    profile_image: json['profile_image'] as String,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$RepairProfileToJson(RepairProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'role': _$RoleEnumMap[instance.role],
      'role_display': instance.role_display,
      'profile_image': instance.profile_image,
      'full_name': instance.full_name,
      'location': instance.location,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$RoleEnumMap = {
  Role.A: 'A',
  Role.T: 'T',
  Role.N: 'N',
  Role.C: 'C',
};

Repair _$RepairFromJson(Map<String, dynamic> json) {
  return Repair(
    id: json['id'] as int,
    appointment: json['appointment'] == null
        ? null
        : DateTime.parse(json['appointment'] as String),
    before_image: json['before_image'] as String,
    car_category: json['car_category'] as int,
    car_category_name: json['car_category_name'] as String,
    car_model: json['car_model'] as int,
    car_model_name: json['car_model_name'] as String,
    car_type: json['car_type'] as int,
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    has_appointment: json['has_appointment'] as bool,
    is_active: json['is_active'] as bool,
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
    location: (json['location'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as num)?.toDouble()),
    ),
    location_description: json['location_description'] as String,
    modified: json['modified'] == null
        ? null
        : DateTime.parse(json['modified'] as String),
    mpesa_confirmation_code: json['mpesa_confirmation_code'] as String,
    payment_method:
        _$enumDecodeNullable(_$PaymentMethodEnumMap, json['payment_method']),
    plate_number: json['plate_number'] as String,
    plate_number_image: json['plate_number_image'] as String,
    reason_for_cancellation: json['reason_for_cancellation'] as String,
    status_display: json['status_display'] as String,
    technician: json['technician'] as int,
    technician_details: json['technician_details'] == null
        ? null
        : RepairProfile.fromJson(
            json['technician_details'] as Map<String, dynamic>),
    user: json['user'] as int,
    amount: (json['amount'] as num)?.toDouble(),
    user_details: json['user_details'] == null
        ? null
        : RepairProfile.fromJson(json['user_details'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RepairToJson(Repair instance) => <String, dynamic>{
      'id': instance.id,
      'user_details': instance.user_details?.toJson(),
      'technician_details': instance.technician_details?.toJson(),
      'status_display': instance.status_display,
      'location': instance.location,
      'is_active': instance.is_active,
      'has_appointment': instance.has_appointment,
      'car_category_name': instance.car_category_name,
      'car_model_name': instance.car_model_name,
      'created': instance.created?.toIso8601String(),
      'modified': instance.modified?.toIso8601String(),
      'lat': instance.lat,
      'lng': instance.lng,
      'location_description': instance.location_description,
      'payment_method': _$PaymentMethodEnumMap[instance.payment_method],
      'reason_for_cancellation': instance.reason_for_cancellation,
      'appointment': instance.appointment?.toIso8601String(),
      'plate_number': instance.plate_number,
      'plate_number_image': instance.plate_number_image,
      'before_image': instance.before_image,
      'mpesa_confirmation_code': instance.mpesa_confirmation_code,
      'car_type': instance.car_type,
      'user': instance.user,
      'technician': instance.technician,
      'car_model': instance.car_model,
      'car_category': instance.car_category,
      'amount': instance.amount,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.I: 'I',
  PaymentMethod.C: 'C',
};
