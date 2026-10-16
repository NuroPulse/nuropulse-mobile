// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoctorConnectionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorConnectionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorConnectionState()';
}


}

/// @nodoc
class $DoctorConnectionStateCopyWith<$Res>  {
$DoctorConnectionStateCopyWith(DoctorConnectionState _, $Res Function(DoctorConnectionState) __);
}


/// Adds pattern-matching-related methods to [DoctorConnectionState].
extension DoctorConnectionStatePatterns on DoctorConnectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DoctorConnectionIdle value)?  idle,TResult Function( DoctorConnectionConnecting value)?  connecting,TResult Function( DoctorConnectionConnected value)?  connected,TResult Function( DoctorConnectionFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DoctorConnectionIdle() when idle != null:
return idle(_that);case DoctorConnectionConnecting() when connecting != null:
return connecting(_that);case DoctorConnectionConnected() when connected != null:
return connected(_that);case DoctorConnectionFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DoctorConnectionIdle value)  idle,required TResult Function( DoctorConnectionConnecting value)  connecting,required TResult Function( DoctorConnectionConnected value)  connected,required TResult Function( DoctorConnectionFailure value)  failure,}){
final _that = this;
switch (_that) {
case DoctorConnectionIdle():
return idle(_that);case DoctorConnectionConnecting():
return connecting(_that);case DoctorConnectionConnected():
return connected(_that);case DoctorConnectionFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DoctorConnectionIdle value)?  idle,TResult? Function( DoctorConnectionConnecting value)?  connecting,TResult? Function( DoctorConnectionConnected value)?  connected,TResult? Function( DoctorConnectionFailure value)?  failure,}){
final _that = this;
switch (_that) {
case DoctorConnectionIdle() when idle != null:
return idle(_that);case DoctorConnectionConnecting() when connecting != null:
return connecting(_that);case DoctorConnectionConnected() when connected != null:
return connected(_that);case DoctorConnectionFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  connecting,TResult Function( ConnectedDoctor doctor)?  connected,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DoctorConnectionIdle() when idle != null:
return idle();case DoctorConnectionConnecting() when connecting != null:
return connecting();case DoctorConnectionConnected() when connected != null:
return connected(_that.doctor);case DoctorConnectionFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  connecting,required TResult Function( ConnectedDoctor doctor)  connected,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DoctorConnectionIdle():
return idle();case DoctorConnectionConnecting():
return connecting();case DoctorConnectionConnected():
return connected(_that.doctor);case DoctorConnectionFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  connecting,TResult? Function( ConnectedDoctor doctor)?  connected,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DoctorConnectionIdle() when idle != null:
return idle();case DoctorConnectionConnecting() when connecting != null:
return connecting();case DoctorConnectionConnected() when connected != null:
return connected(_that.doctor);case DoctorConnectionFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DoctorConnectionIdle implements DoctorConnectionState {
  const DoctorConnectionIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorConnectionIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorConnectionState.idle()';
}


}




/// @nodoc


class DoctorConnectionConnecting implements DoctorConnectionState {
  const DoctorConnectionConnecting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorConnectionConnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DoctorConnectionState.connecting()';
}


}




/// @nodoc


class DoctorConnectionConnected implements DoctorConnectionState {
  const DoctorConnectionConnected(this.doctor);
  

 final  ConnectedDoctor doctor;

/// Create a copy of DoctorConnectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorConnectionConnectedCopyWith<DoctorConnectionConnected> get copyWith => _$DoctorConnectionConnectedCopyWithImpl<DoctorConnectionConnected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorConnectionConnected&&(identical(other.doctor, doctor) || other.doctor == doctor));
}


@override
int get hashCode => Object.hash(runtimeType,doctor);

@override
String toString() {
  return 'DoctorConnectionState.connected(doctor: $doctor)';
}


}

/// @nodoc
abstract mixin class $DoctorConnectionConnectedCopyWith<$Res> implements $DoctorConnectionStateCopyWith<$Res> {
  factory $DoctorConnectionConnectedCopyWith(DoctorConnectionConnected value, $Res Function(DoctorConnectionConnected) _then) = _$DoctorConnectionConnectedCopyWithImpl;
@useResult
$Res call({
 ConnectedDoctor doctor
});




}
/// @nodoc
class _$DoctorConnectionConnectedCopyWithImpl<$Res>
    implements $DoctorConnectionConnectedCopyWith<$Res> {
  _$DoctorConnectionConnectedCopyWithImpl(this._self, this._then);

  final DoctorConnectionConnected _self;
  final $Res Function(DoctorConnectionConnected) _then;

/// Create a copy of DoctorConnectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? doctor = null,}) {
  return _then(DoctorConnectionConnected(
null == doctor ? _self.doctor : doctor // ignore: cast_nullable_to_non_nullable
as ConnectedDoctor,
  ));
}


}

/// @nodoc


class DoctorConnectionFailure implements DoctorConnectionState {
  const DoctorConnectionFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of DoctorConnectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoctorConnectionFailureCopyWith<DoctorConnectionFailure> get copyWith => _$DoctorConnectionFailureCopyWithImpl<DoctorConnectionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoctorConnectionFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DoctorConnectionState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DoctorConnectionFailureCopyWith<$Res> implements $DoctorConnectionStateCopyWith<$Res> {
  factory $DoctorConnectionFailureCopyWith(DoctorConnectionFailure value, $Res Function(DoctorConnectionFailure) _then) = _$DoctorConnectionFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$DoctorConnectionFailureCopyWithImpl<$Res>
    implements $DoctorConnectionFailureCopyWith<$Res> {
  _$DoctorConnectionFailureCopyWithImpl(this._self, this._then);

  final DoctorConnectionFailure _self;
  final $Res Function(DoctorConnectionFailure) _then;

/// Create a copy of DoctorConnectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DoctorConnectionFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
