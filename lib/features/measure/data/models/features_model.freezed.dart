// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'features_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeaturesModel {

@JsonKey(name: 'peak_frequency_hz') double get peakFrequencyHz;@JsonKey(name: 'band_power_ratio') double get bandPowerRatio; double get snr;/// Already in g — converted from lib/dsp's m/s² value when this model
/// is built. See `MeasurementModel.fromResult`.
@JsonKey(name: 'band_rms_g') double get bandRmsG; double get consistency;
/// Create a copy of FeaturesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeaturesModelCopyWith<FeaturesModel> get copyWith => _$FeaturesModelCopyWithImpl<FeaturesModel>(this as FeaturesModel, _$identity);

  /// Serializes this FeaturesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeaturesModel&&(identical(other.peakFrequencyHz, peakFrequencyHz) || other.peakFrequencyHz == peakFrequencyHz)&&(identical(other.bandPowerRatio, bandPowerRatio) || other.bandPowerRatio == bandPowerRatio)&&(identical(other.snr, snr) || other.snr == snr)&&(identical(other.bandRmsG, bandRmsG) || other.bandRmsG == bandRmsG)&&(identical(other.consistency, consistency) || other.consistency == consistency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,peakFrequencyHz,bandPowerRatio,snr,bandRmsG,consistency);

@override
String toString() {
  return 'FeaturesModel(peakFrequencyHz: $peakFrequencyHz, bandPowerRatio: $bandPowerRatio, snr: $snr, bandRmsG: $bandRmsG, consistency: $consistency)';
}


}

/// @nodoc
abstract mixin class $FeaturesModelCopyWith<$Res>  {
  factory $FeaturesModelCopyWith(FeaturesModel value, $Res Function(FeaturesModel) _then) = _$FeaturesModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'peak_frequency_hz') double peakFrequencyHz,@JsonKey(name: 'band_power_ratio') double bandPowerRatio, double snr,@JsonKey(name: 'band_rms_g') double bandRmsG, double consistency
});




}
/// @nodoc
class _$FeaturesModelCopyWithImpl<$Res>
    implements $FeaturesModelCopyWith<$Res> {
  _$FeaturesModelCopyWithImpl(this._self, this._then);

  final FeaturesModel _self;
  final $Res Function(FeaturesModel) _then;

/// Create a copy of FeaturesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? peakFrequencyHz = null,Object? bandPowerRatio = null,Object? snr = null,Object? bandRmsG = null,Object? consistency = null,}) {
  return _then(_self.copyWith(
peakFrequencyHz: null == peakFrequencyHz ? _self.peakFrequencyHz : peakFrequencyHz // ignore: cast_nullable_to_non_nullable
as double,bandPowerRatio: null == bandPowerRatio ? _self.bandPowerRatio : bandPowerRatio // ignore: cast_nullable_to_non_nullable
as double,snr: null == snr ? _self.snr : snr // ignore: cast_nullable_to_non_nullable
as double,bandRmsG: null == bandRmsG ? _self.bandRmsG : bandRmsG // ignore: cast_nullable_to_non_nullable
as double,consistency: null == consistency ? _self.consistency : consistency // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FeaturesModel].
extension FeaturesModelPatterns on FeaturesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeaturesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeaturesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeaturesModel value)  $default,){
final _that = this;
switch (_that) {
case _FeaturesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeaturesModel value)?  $default,){
final _that = this;
switch (_that) {
case _FeaturesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'peak_frequency_hz')  double peakFrequencyHz, @JsonKey(name: 'band_power_ratio')  double bandPowerRatio,  double snr, @JsonKey(name: 'band_rms_g')  double bandRmsG,  double consistency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeaturesModel() when $default != null:
return $default(_that.peakFrequencyHz,_that.bandPowerRatio,_that.snr,_that.bandRmsG,_that.consistency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'peak_frequency_hz')  double peakFrequencyHz, @JsonKey(name: 'band_power_ratio')  double bandPowerRatio,  double snr, @JsonKey(name: 'band_rms_g')  double bandRmsG,  double consistency)  $default,) {final _that = this;
switch (_that) {
case _FeaturesModel():
return $default(_that.peakFrequencyHz,_that.bandPowerRatio,_that.snr,_that.bandRmsG,_that.consistency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'peak_frequency_hz')  double peakFrequencyHz, @JsonKey(name: 'band_power_ratio')  double bandPowerRatio,  double snr, @JsonKey(name: 'band_rms_g')  double bandRmsG,  double consistency)?  $default,) {final _that = this;
switch (_that) {
case _FeaturesModel() when $default != null:
return $default(_that.peakFrequencyHz,_that.bandPowerRatio,_that.snr,_that.bandRmsG,_that.consistency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeaturesModel implements FeaturesModel {
  const _FeaturesModel({@JsonKey(name: 'peak_frequency_hz') required this.peakFrequencyHz, @JsonKey(name: 'band_power_ratio') required this.bandPowerRatio, required this.snr, @JsonKey(name: 'band_rms_g') required this.bandRmsG, required this.consistency});
  factory _FeaturesModel.fromJson(Map<String, dynamic> json) => _$FeaturesModelFromJson(json);

@override@JsonKey(name: 'peak_frequency_hz') final  double peakFrequencyHz;
@override@JsonKey(name: 'band_power_ratio') final  double bandPowerRatio;
@override final  double snr;
/// Already in g — converted from lib/dsp's m/s² value when this model
/// is built. See `MeasurementModel.fromResult`.
@override@JsonKey(name: 'band_rms_g') final  double bandRmsG;
@override final  double consistency;

/// Create a copy of FeaturesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeaturesModelCopyWith<_FeaturesModel> get copyWith => __$FeaturesModelCopyWithImpl<_FeaturesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeaturesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeaturesModel&&(identical(other.peakFrequencyHz, peakFrequencyHz) || other.peakFrequencyHz == peakFrequencyHz)&&(identical(other.bandPowerRatio, bandPowerRatio) || other.bandPowerRatio == bandPowerRatio)&&(identical(other.snr, snr) || other.snr == snr)&&(identical(other.bandRmsG, bandRmsG) || other.bandRmsG == bandRmsG)&&(identical(other.consistency, consistency) || other.consistency == consistency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,peakFrequencyHz,bandPowerRatio,snr,bandRmsG,consistency);

@override
String toString() {
  return 'FeaturesModel(peakFrequencyHz: $peakFrequencyHz, bandPowerRatio: $bandPowerRatio, snr: $snr, bandRmsG: $bandRmsG, consistency: $consistency)';
}


}

/// @nodoc
abstract mixin class _$FeaturesModelCopyWith<$Res> implements $FeaturesModelCopyWith<$Res> {
  factory _$FeaturesModelCopyWith(_FeaturesModel value, $Res Function(_FeaturesModel) _then) = __$FeaturesModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'peak_frequency_hz') double peakFrequencyHz,@JsonKey(name: 'band_power_ratio') double bandPowerRatio, double snr,@JsonKey(name: 'band_rms_g') double bandRmsG, double consistency
});




}
/// @nodoc
class __$FeaturesModelCopyWithImpl<$Res>
    implements _$FeaturesModelCopyWith<$Res> {
  __$FeaturesModelCopyWithImpl(this._self, this._then);

  final _FeaturesModel _self;
  final $Res Function(_FeaturesModel) _then;

/// Create a copy of FeaturesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? peakFrequencyHz = null,Object? bandPowerRatio = null,Object? snr = null,Object? bandRmsG = null,Object? consistency = null,}) {
  return _then(_FeaturesModel(
peakFrequencyHz: null == peakFrequencyHz ? _self.peakFrequencyHz : peakFrequencyHz // ignore: cast_nullable_to_non_nullable
as double,bandPowerRatio: null == bandPowerRatio ? _self.bandPowerRatio : bandPowerRatio // ignore: cast_nullable_to_non_nullable
as double,snr: null == snr ? _self.snr : snr // ignore: cast_nullable_to_non_nullable
as double,bandRmsG: null == bandRmsG ? _self.bandRmsG : bandRmsG // ignore: cast_nullable_to_non_nullable
as double,consistency: null == consistency ? _self.consistency : consistency // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
