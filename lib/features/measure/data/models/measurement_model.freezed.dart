// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeasurementModel {

 String get id;@JsonKey(name: 'patient_id') String? get patientId;/// UTC ISO-8601, device time.
@JsonKey(name: 'measured_at') String get measuredAt;/// Always "rest" in this version.
 String get condition;@JsonKey(name: 'duration_s') int get durationS;/// "none" | "tremor" | "invalid".
 String get status;@JsonKey(name: 'invalid_reason') String? get invalidReason;@JsonKey(toJson: _featuresToJson) FeaturesModel? get features;@JsonKey(name: 'algo_version') String get algoVersion;@JsonKey(toJson: _deviceToJson) DeviceModel get device;
/// Create a copy of MeasurementModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementModelCopyWith<MeasurementModel> get copyWith => _$MeasurementModelCopyWithImpl<MeasurementModel>(this as MeasurementModel, _$identity);

  /// Serializes this MeasurementModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasurementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidReason, invalidReason) || other.invalidReason == invalidReason)&&(identical(other.features, features) || other.features == features)&&(identical(other.algoVersion, algoVersion) || other.algoVersion == algoVersion)&&(identical(other.device, device) || other.device == device));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,measuredAt,condition,durationS,status,invalidReason,features,algoVersion,device);

@override
String toString() {
  return 'MeasurementModel(id: $id, patientId: $patientId, measuredAt: $measuredAt, condition: $condition, durationS: $durationS, status: $status, invalidReason: $invalidReason, features: $features, algoVersion: $algoVersion, device: $device)';
}


}

/// @nodoc
abstract mixin class $MeasurementModelCopyWith<$Res>  {
  factory $MeasurementModelCopyWith(MeasurementModel value, $Res Function(MeasurementModel) _then) = _$MeasurementModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'patient_id') String? patientId,@JsonKey(name: 'measured_at') String measuredAt, String condition,@JsonKey(name: 'duration_s') int durationS, String status,@JsonKey(name: 'invalid_reason') String? invalidReason,@JsonKey(toJson: _featuresToJson) FeaturesModel? features,@JsonKey(name: 'algo_version') String algoVersion,@JsonKey(toJson: _deviceToJson) DeviceModel device
});


$FeaturesModelCopyWith<$Res>? get features;$DeviceModelCopyWith<$Res> get device;

}
/// @nodoc
class _$MeasurementModelCopyWithImpl<$Res>
    implements $MeasurementModelCopyWith<$Res> {
  _$MeasurementModelCopyWithImpl(this._self, this._then);

  final MeasurementModel _self;
  final $Res Function(MeasurementModel) _then;

/// Create a copy of MeasurementModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = freezed,Object? measuredAt = null,Object? condition = null,Object? durationS = null,Object? status = null,Object? invalidReason = freezed,Object? features = freezed,Object? algoVersion = null,Object? device = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,invalidReason: freezed == invalidReason ? _self.invalidReason : invalidReason // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as FeaturesModel?,algoVersion: null == algoVersion ? _self.algoVersion : algoVersion // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceModel,
  ));
}
/// Create a copy of MeasurementModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeaturesModelCopyWith<$Res>? get features {
    if (_self.features == null) {
    return null;
  }

  return $FeaturesModelCopyWith<$Res>(_self.features!, (value) {
    return _then(_self.copyWith(features: value));
  });
}/// Create a copy of MeasurementModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceModelCopyWith<$Res> get device {
  
  return $DeviceModelCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeasurementModel].
extension MeasurementModelPatterns on MeasurementModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurementModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurementModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurementModel value)  $default,){
final _that = this;
switch (_that) {
case _MeasurementModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurementModel value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurementModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'patient_id')  String? patientId, @JsonKey(name: 'measured_at')  String measuredAt,  String condition, @JsonKey(name: 'duration_s')  int durationS,  String status, @JsonKey(name: 'invalid_reason')  String? invalidReason, @JsonKey(toJson: _featuresToJson)  FeaturesModel? features, @JsonKey(name: 'algo_version')  String algoVersion, @JsonKey(toJson: _deviceToJson)  DeviceModel device)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurementModel() when $default != null:
return $default(_that.id,_that.patientId,_that.measuredAt,_that.condition,_that.durationS,_that.status,_that.invalidReason,_that.features,_that.algoVersion,_that.device);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'patient_id')  String? patientId, @JsonKey(name: 'measured_at')  String measuredAt,  String condition, @JsonKey(name: 'duration_s')  int durationS,  String status, @JsonKey(name: 'invalid_reason')  String? invalidReason, @JsonKey(toJson: _featuresToJson)  FeaturesModel? features, @JsonKey(name: 'algo_version')  String algoVersion, @JsonKey(toJson: _deviceToJson)  DeviceModel device)  $default,) {final _that = this;
switch (_that) {
case _MeasurementModel():
return $default(_that.id,_that.patientId,_that.measuredAt,_that.condition,_that.durationS,_that.status,_that.invalidReason,_that.features,_that.algoVersion,_that.device);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'patient_id')  String? patientId, @JsonKey(name: 'measured_at')  String measuredAt,  String condition, @JsonKey(name: 'duration_s')  int durationS,  String status, @JsonKey(name: 'invalid_reason')  String? invalidReason, @JsonKey(toJson: _featuresToJson)  FeaturesModel? features, @JsonKey(name: 'algo_version')  String algoVersion, @JsonKey(toJson: _deviceToJson)  DeviceModel device)?  $default,) {final _that = this;
switch (_that) {
case _MeasurementModel() when $default != null:
return $default(_that.id,_that.patientId,_that.measuredAt,_that.condition,_that.durationS,_that.status,_that.invalidReason,_that.features,_that.algoVersion,_that.device);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeasurementModel extends MeasurementModel {
  const _MeasurementModel({required this.id, @JsonKey(name: 'patient_id') this.patientId, @JsonKey(name: 'measured_at') required this.measuredAt, required this.condition, @JsonKey(name: 'duration_s') required this.durationS, required this.status, @JsonKey(name: 'invalid_reason') this.invalidReason, @JsonKey(toJson: _featuresToJson) this.features, @JsonKey(name: 'algo_version') required this.algoVersion, @JsonKey(toJson: _deviceToJson) required this.device}): super._();
  factory _MeasurementModel.fromJson(Map<String, dynamic> json) => _$MeasurementModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'patient_id') final  String? patientId;
/// UTC ISO-8601, device time.
@override@JsonKey(name: 'measured_at') final  String measuredAt;
/// Always "rest" in this version.
@override final  String condition;
@override@JsonKey(name: 'duration_s') final  int durationS;
/// "none" | "tremor" | "invalid".
@override final  String status;
@override@JsonKey(name: 'invalid_reason') final  String? invalidReason;
@override@JsonKey(toJson: _featuresToJson) final  FeaturesModel? features;
@override@JsonKey(name: 'algo_version') final  String algoVersion;
@override@JsonKey(toJson: _deviceToJson) final  DeviceModel device;

/// Create a copy of MeasurementModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementModelCopyWith<_MeasurementModel> get copyWith => __$MeasurementModelCopyWithImpl<_MeasurementModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeasurementModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasurementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidReason, invalidReason) || other.invalidReason == invalidReason)&&(identical(other.features, features) || other.features == features)&&(identical(other.algoVersion, algoVersion) || other.algoVersion == algoVersion)&&(identical(other.device, device) || other.device == device));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,measuredAt,condition,durationS,status,invalidReason,features,algoVersion,device);

@override
String toString() {
  return 'MeasurementModel(id: $id, patientId: $patientId, measuredAt: $measuredAt, condition: $condition, durationS: $durationS, status: $status, invalidReason: $invalidReason, features: $features, algoVersion: $algoVersion, device: $device)';
}


}

/// @nodoc
abstract mixin class _$MeasurementModelCopyWith<$Res> implements $MeasurementModelCopyWith<$Res> {
  factory _$MeasurementModelCopyWith(_MeasurementModel value, $Res Function(_MeasurementModel) _then) = __$MeasurementModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'patient_id') String? patientId,@JsonKey(name: 'measured_at') String measuredAt, String condition,@JsonKey(name: 'duration_s') int durationS, String status,@JsonKey(name: 'invalid_reason') String? invalidReason,@JsonKey(toJson: _featuresToJson) FeaturesModel? features,@JsonKey(name: 'algo_version') String algoVersion,@JsonKey(toJson: _deviceToJson) DeviceModel device
});


@override $FeaturesModelCopyWith<$Res>? get features;@override $DeviceModelCopyWith<$Res> get device;

}
/// @nodoc
class __$MeasurementModelCopyWithImpl<$Res>
    implements _$MeasurementModelCopyWith<$Res> {
  __$MeasurementModelCopyWithImpl(this._self, this._then);

  final _MeasurementModel _self;
  final $Res Function(_MeasurementModel) _then;

/// Create a copy of MeasurementModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = freezed,Object? measuredAt = null,Object? condition = null,Object? durationS = null,Object? status = null,Object? invalidReason = freezed,Object? features = freezed,Object? algoVersion = null,Object? device = null,}) {
  return _then(_MeasurementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,invalidReason: freezed == invalidReason ? _self.invalidReason : invalidReason // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as FeaturesModel?,algoVersion: null == algoVersion ? _self.algoVersion : algoVersion // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceModel,
  ));
}

/// Create a copy of MeasurementModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeaturesModelCopyWith<$Res>? get features {
    if (_self.features == null) {
    return null;
  }

  return $FeaturesModelCopyWith<$Res>(_self.features!, (value) {
    return _then(_self.copyWith(features: value));
  });
}/// Create a copy of MeasurementModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceModelCopyWith<$Res> get device {
  
  return $DeviceModelCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

// dart format on
