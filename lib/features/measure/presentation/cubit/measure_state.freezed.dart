// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measure_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeasureState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MeasureState()';
}


}

/// @nodoc
class $MeasureStateCopyWith<$Res>  {
$MeasureStateCopyWith(MeasureState _, $Res Function(MeasureState) __);
}


/// Adds pattern-matching-related methods to [MeasureState].
extension MeasureStatePatterns on MeasureState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MeasureIdle value)?  idle,TResult Function( MeasureCountdown value)?  countdown,TResult Function( MeasureRecording value)?  recording,TResult Function( MeasureProcessing value)?  processing,TResult Function( MeasureSuccess value)?  success,TResult Function( MeasureInvalid value)?  invalid,TResult Function( MeasureFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MeasureIdle() when idle != null:
return idle(_that);case MeasureCountdown() when countdown != null:
return countdown(_that);case MeasureRecording() when recording != null:
return recording(_that);case MeasureProcessing() when processing != null:
return processing(_that);case MeasureSuccess() when success != null:
return success(_that);case MeasureInvalid() when invalid != null:
return invalid(_that);case MeasureFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MeasureIdle value)  idle,required TResult Function( MeasureCountdown value)  countdown,required TResult Function( MeasureRecording value)  recording,required TResult Function( MeasureProcessing value)  processing,required TResult Function( MeasureSuccess value)  success,required TResult Function( MeasureInvalid value)  invalid,required TResult Function( MeasureFailure value)  failure,}){
final _that = this;
switch (_that) {
case MeasureIdle():
return idle(_that);case MeasureCountdown():
return countdown(_that);case MeasureRecording():
return recording(_that);case MeasureProcessing():
return processing(_that);case MeasureSuccess():
return success(_that);case MeasureInvalid():
return invalid(_that);case MeasureFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MeasureIdle value)?  idle,TResult? Function( MeasureCountdown value)?  countdown,TResult? Function( MeasureRecording value)?  recording,TResult? Function( MeasureProcessing value)?  processing,TResult? Function( MeasureSuccess value)?  success,TResult? Function( MeasureInvalid value)?  invalid,TResult? Function( MeasureFailure value)?  failure,}){
final _that = this;
switch (_that) {
case MeasureIdle() when idle != null:
return idle(_that);case MeasureCountdown() when countdown != null:
return countdown(_that);case MeasureRecording() when recording != null:
return recording(_that);case MeasureProcessing() when processing != null:
return processing(_that);case MeasureSuccess() when success != null:
return success(_that);case MeasureInvalid() when invalid != null:
return invalid(_that);case MeasureFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( int secondsLeft)?  countdown,TResult Function( Duration elapsed,  LiveWindow window)?  recording,TResult Function()?  processing,TResult Function( TremorResult result,  String measurementId)?  success,TResult Function( List<InvalidReason> reasons)?  invalid,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MeasureIdle() when idle != null:
return idle();case MeasureCountdown() when countdown != null:
return countdown(_that.secondsLeft);case MeasureRecording() when recording != null:
return recording(_that.elapsed,_that.window);case MeasureProcessing() when processing != null:
return processing();case MeasureSuccess() when success != null:
return success(_that.result,_that.measurementId);case MeasureInvalid() when invalid != null:
return invalid(_that.reasons);case MeasureFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( int secondsLeft)  countdown,required TResult Function( Duration elapsed,  LiveWindow window)  recording,required TResult Function()  processing,required TResult Function( TremorResult result,  String measurementId)  success,required TResult Function( List<InvalidReason> reasons)  invalid,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case MeasureIdle():
return idle();case MeasureCountdown():
return countdown(_that.secondsLeft);case MeasureRecording():
return recording(_that.elapsed,_that.window);case MeasureProcessing():
return processing();case MeasureSuccess():
return success(_that.result,_that.measurementId);case MeasureInvalid():
return invalid(_that.reasons);case MeasureFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( int secondsLeft)?  countdown,TResult? Function( Duration elapsed,  LiveWindow window)?  recording,TResult? Function()?  processing,TResult? Function( TremorResult result,  String measurementId)?  success,TResult? Function( List<InvalidReason> reasons)?  invalid,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case MeasureIdle() when idle != null:
return idle();case MeasureCountdown() when countdown != null:
return countdown(_that.secondsLeft);case MeasureRecording() when recording != null:
return recording(_that.elapsed,_that.window);case MeasureProcessing() when processing != null:
return processing();case MeasureSuccess() when success != null:
return success(_that.result,_that.measurementId);case MeasureInvalid() when invalid != null:
return invalid(_that.reasons);case MeasureFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MeasureIdle implements MeasureState {
  const MeasureIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MeasureState.idle()';
}


}




/// @nodoc


class MeasureCountdown implements MeasureState {
  const MeasureCountdown(this.secondsLeft);
  

 final  int secondsLeft;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasureCountdownCopyWith<MeasureCountdown> get copyWith => _$MeasureCountdownCopyWithImpl<MeasureCountdown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureCountdown&&(identical(other.secondsLeft, secondsLeft) || other.secondsLeft == secondsLeft));
}


@override
int get hashCode => Object.hash(runtimeType,secondsLeft);

@override
String toString() {
  return 'MeasureState.countdown(secondsLeft: $secondsLeft)';
}


}

/// @nodoc
abstract mixin class $MeasureCountdownCopyWith<$Res> implements $MeasureStateCopyWith<$Res> {
  factory $MeasureCountdownCopyWith(MeasureCountdown value, $Res Function(MeasureCountdown) _then) = _$MeasureCountdownCopyWithImpl;
@useResult
$Res call({
 int secondsLeft
});




}
/// @nodoc
class _$MeasureCountdownCopyWithImpl<$Res>
    implements $MeasureCountdownCopyWith<$Res> {
  _$MeasureCountdownCopyWithImpl(this._self, this._then);

  final MeasureCountdown _self;
  final $Res Function(MeasureCountdown) _then;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? secondsLeft = null,}) {
  return _then(MeasureCountdown(
null == secondsLeft ? _self.secondsLeft : secondsLeft // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MeasureRecording implements MeasureState {
  const MeasureRecording({required this.elapsed, required this.window});
  

 final  Duration elapsed;
 final  LiveWindow window;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasureRecordingCopyWith<MeasureRecording> get copyWith => _$MeasureRecordingCopyWithImpl<MeasureRecording>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureRecording&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.window, window) || other.window == window));
}


@override
int get hashCode => Object.hash(runtimeType,elapsed,window);

@override
String toString() {
  return 'MeasureState.recording(elapsed: $elapsed, window: $window)';
}


}

/// @nodoc
abstract mixin class $MeasureRecordingCopyWith<$Res> implements $MeasureStateCopyWith<$Res> {
  factory $MeasureRecordingCopyWith(MeasureRecording value, $Res Function(MeasureRecording) _then) = _$MeasureRecordingCopyWithImpl;
@useResult
$Res call({
 Duration elapsed, LiveWindow window
});




}
/// @nodoc
class _$MeasureRecordingCopyWithImpl<$Res>
    implements $MeasureRecordingCopyWith<$Res> {
  _$MeasureRecordingCopyWithImpl(this._self, this._then);

  final MeasureRecording _self;
  final $Res Function(MeasureRecording) _then;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? elapsed = null,Object? window = null,}) {
  return _then(MeasureRecording(
elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as LiveWindow,
  ));
}


}

/// @nodoc


class MeasureProcessing implements MeasureState {
  const MeasureProcessing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureProcessing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MeasureState.processing()';
}


}




/// @nodoc


class MeasureSuccess implements MeasureState {
  const MeasureSuccess({required this.result, required this.measurementId});
  

 final  TremorResult result;
 final  String measurementId;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasureSuccessCopyWith<MeasureSuccess> get copyWith => _$MeasureSuccessCopyWithImpl<MeasureSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureSuccess&&(identical(other.result, result) || other.result == result)&&(identical(other.measurementId, measurementId) || other.measurementId == measurementId));
}


@override
int get hashCode => Object.hash(runtimeType,result,measurementId);

@override
String toString() {
  return 'MeasureState.success(result: $result, measurementId: $measurementId)';
}


}

/// @nodoc
abstract mixin class $MeasureSuccessCopyWith<$Res> implements $MeasureStateCopyWith<$Res> {
  factory $MeasureSuccessCopyWith(MeasureSuccess value, $Res Function(MeasureSuccess) _then) = _$MeasureSuccessCopyWithImpl;
@useResult
$Res call({
 TremorResult result, String measurementId
});




}
/// @nodoc
class _$MeasureSuccessCopyWithImpl<$Res>
    implements $MeasureSuccessCopyWith<$Res> {
  _$MeasureSuccessCopyWithImpl(this._self, this._then);

  final MeasureSuccess _self;
  final $Res Function(MeasureSuccess) _then;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,Object? measurementId = null,}) {
  return _then(MeasureSuccess(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as TremorResult,measurementId: null == measurementId ? _self.measurementId : measurementId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MeasureInvalid implements MeasureState {
  const MeasureInvalid(final  List<InvalidReason> reasons): _reasons = reasons;
  

 final  List<InvalidReason> _reasons;
 List<InvalidReason> get reasons {
  if (_reasons is EqualUnmodifiableListView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasons);
}


/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasureInvalidCopyWith<MeasureInvalid> get copyWith => _$MeasureInvalidCopyWithImpl<MeasureInvalid>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureInvalid&&const DeepCollectionEquality().equals(other._reasons, _reasons));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reasons));

@override
String toString() {
  return 'MeasureState.invalid(reasons: $reasons)';
}


}

/// @nodoc
abstract mixin class $MeasureInvalidCopyWith<$Res> implements $MeasureStateCopyWith<$Res> {
  factory $MeasureInvalidCopyWith(MeasureInvalid value, $Res Function(MeasureInvalid) _then) = _$MeasureInvalidCopyWithImpl;
@useResult
$Res call({
 List<InvalidReason> reasons
});




}
/// @nodoc
class _$MeasureInvalidCopyWithImpl<$Res>
    implements $MeasureInvalidCopyWith<$Res> {
  _$MeasureInvalidCopyWithImpl(this._self, this._then);

  final MeasureInvalid _self;
  final $Res Function(MeasureInvalid) _then;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reasons = null,}) {
  return _then(MeasureInvalid(
null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<InvalidReason>,
  ));
}


}

/// @nodoc


class MeasureFailure implements MeasureState {
  const MeasureFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasureFailureCopyWith<MeasureFailure> get copyWith => _$MeasureFailureCopyWithImpl<MeasureFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'MeasureState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MeasureFailureCopyWith<$Res> implements $MeasureStateCopyWith<$Res> {
  factory $MeasureFailureCopyWith(MeasureFailure value, $Res Function(MeasureFailure) _then) = _$MeasureFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MeasureFailureCopyWithImpl<$Res>
    implements $MeasureFailureCopyWith<$Res> {
  _$MeasureFailureCopyWithImpl(this._self, this._then);

  final MeasureFailure _self;
  final $Res Function(MeasureFailure) _then;

/// Create a copy of MeasureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MeasureFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
