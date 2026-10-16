// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MedicationState()';
}


}

/// @nodoc
class $MedicationStateCopyWith<$Res>  {
$MedicationStateCopyWith(MedicationState _, $Res Function(MedicationState) __);
}


/// Adds pattern-matching-related methods to [MedicationState].
extension MedicationStatePatterns on MedicationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MedicationLoading value)?  loading,TResult Function( MedicationLoaded value)?  loaded,TResult Function( MedicationFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MedicationLoading() when loading != null:
return loading(_that);case MedicationLoaded() when loaded != null:
return loaded(_that);case MedicationFailureState() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MedicationLoading value)  loading,required TResult Function( MedicationLoaded value)  loaded,required TResult Function( MedicationFailureState value)  failure,}){
final _that = this;
switch (_that) {
case MedicationLoading():
return loading(_that);case MedicationLoaded():
return loaded(_that);case MedicationFailureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MedicationLoading value)?  loading,TResult? Function( MedicationLoaded value)?  loaded,TResult? Function( MedicationFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case MedicationLoading() when loading != null:
return loading(_that);case MedicationLoaded() when loaded != null:
return loaded(_that);case MedicationFailureState() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<MedicationSchedule> schedules,  List<MedicationLogEntry> logs)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MedicationLoading() when loading != null:
return loading();case MedicationLoaded() when loaded != null:
return loaded(_that.schedules,_that.logs);case MedicationFailureState() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<MedicationSchedule> schedules,  List<MedicationLogEntry> logs)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case MedicationLoading():
return loading();case MedicationLoaded():
return loaded(_that.schedules,_that.logs);case MedicationFailureState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<MedicationSchedule> schedules,  List<MedicationLogEntry> logs)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case MedicationLoading() when loading != null:
return loading();case MedicationLoaded() when loaded != null:
return loaded(_that.schedules,_that.logs);case MedicationFailureState() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MedicationLoading implements MedicationState {
  const MedicationLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MedicationState.loading()';
}


}




/// @nodoc


class MedicationLoaded implements MedicationState {
  const MedicationLoaded({required final  List<MedicationSchedule> schedules, required final  List<MedicationLogEntry> logs}): _schedules = schedules,_logs = logs;
  

 final  List<MedicationSchedule> _schedules;
 List<MedicationSchedule> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}

 final  List<MedicationLogEntry> _logs;
 List<MedicationLogEntry> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}


/// Create a copy of MedicationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationLoadedCopyWith<MedicationLoaded> get copyWith => _$MedicationLoadedCopyWithImpl<MedicationLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationLoaded&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&const DeepCollectionEquality().equals(other._logs, _logs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_schedules),const DeepCollectionEquality().hash(_logs));

@override
String toString() {
  return 'MedicationState.loaded(schedules: $schedules, logs: $logs)';
}


}

/// @nodoc
abstract mixin class $MedicationLoadedCopyWith<$Res> implements $MedicationStateCopyWith<$Res> {
  factory $MedicationLoadedCopyWith(MedicationLoaded value, $Res Function(MedicationLoaded) _then) = _$MedicationLoadedCopyWithImpl;
@useResult
$Res call({
 List<MedicationSchedule> schedules, List<MedicationLogEntry> logs
});




}
/// @nodoc
class _$MedicationLoadedCopyWithImpl<$Res>
    implements $MedicationLoadedCopyWith<$Res> {
  _$MedicationLoadedCopyWithImpl(this._self, this._then);

  final MedicationLoaded _self;
  final $Res Function(MedicationLoaded) _then;

/// Create a copy of MedicationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? schedules = null,Object? logs = null,}) {
  return _then(MedicationLoaded(
schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<MedicationSchedule>,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<MedicationLogEntry>,
  ));
}


}

/// @nodoc


class MedicationFailureState implements MedicationState {
  const MedicationFailureState(this.failure);
  

 final  Failure failure;

/// Create a copy of MedicationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationFailureStateCopyWith<MedicationFailureState> get copyWith => _$MedicationFailureStateCopyWithImpl<MedicationFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationFailureState&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'MedicationState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MedicationFailureStateCopyWith<$Res> implements $MedicationStateCopyWith<$Res> {
  factory $MedicationFailureStateCopyWith(MedicationFailureState value, $Res Function(MedicationFailureState) _then) = _$MedicationFailureStateCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MedicationFailureStateCopyWithImpl<$Res>
    implements $MedicationFailureStateCopyWith<$Res> {
  _$MedicationFailureStateCopyWithImpl(this._self, this._then);

  final MedicationFailureState _self;
  final $Res Function(MedicationFailureState) _then;

/// Create a copy of MedicationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MedicationFailureState(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
