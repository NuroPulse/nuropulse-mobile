// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HistoryState()';
}


}

/// @nodoc
class $HistoryStateCopyWith<$Res>  {
$HistoryStateCopyWith(HistoryState _, $Res Function(HistoryState) __);
}


/// Adds pattern-matching-related methods to [HistoryState].
extension HistoryStatePatterns on HistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HistoryLoading value)?  loading,TResult Function( HistoryLoaded value)?  loaded,TResult Function( HistoryFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HistoryLoading() when loading != null:
return loading(_that);case HistoryLoaded() when loaded != null:
return loaded(_that);case HistoryFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HistoryLoading value)  loading,required TResult Function( HistoryLoaded value)  loaded,required TResult Function( HistoryFailure value)  failure,}){
final _that = this;
switch (_that) {
case HistoryLoading():
return loading(_that);case HistoryLoaded():
return loaded(_that);case HistoryFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HistoryLoading value)?  loading,TResult? Function( HistoryLoaded value)?  loaded,TResult? Function( HistoryFailure value)?  failure,}){
final _that = this;
switch (_that) {
case HistoryLoading() when loading != null:
return loading(_that);case HistoryLoaded() when loaded != null:
return loaded(_that);case HistoryFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<MeasurementRecord> records)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HistoryLoading() when loading != null:
return loading();case HistoryLoaded() when loaded != null:
return loaded(_that.records);case HistoryFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<MeasurementRecord> records)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case HistoryLoading():
return loading();case HistoryLoaded():
return loaded(_that.records);case HistoryFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<MeasurementRecord> records)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case HistoryLoading() when loading != null:
return loading();case HistoryLoaded() when loaded != null:
return loaded(_that.records);case HistoryFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class HistoryLoading implements HistoryState {
  const HistoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HistoryState.loading()';
}


}




/// @nodoc


class HistoryLoaded implements HistoryState {
  const HistoryLoaded(final  List<MeasurementRecord> records): _records = records;
  

 final  List<MeasurementRecord> _records;
 List<MeasurementRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}


/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryLoadedCopyWith<HistoryLoaded> get copyWith => _$HistoryLoadedCopyWithImpl<HistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoaded&&const DeepCollectionEquality().equals(other._records, _records));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records));

@override
String toString() {
  return 'HistoryState.loaded(records: $records)';
}


}

/// @nodoc
abstract mixin class $HistoryLoadedCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryLoadedCopyWith(HistoryLoaded value, $Res Function(HistoryLoaded) _then) = _$HistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<MeasurementRecord> records
});




}
/// @nodoc
class _$HistoryLoadedCopyWithImpl<$Res>
    implements $HistoryLoadedCopyWith<$Res> {
  _$HistoryLoadedCopyWithImpl(this._self, this._then);

  final HistoryLoaded _self;
  final $Res Function(HistoryLoaded) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? records = null,}) {
  return _then(HistoryLoaded(
null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<MeasurementRecord>,
  ));
}


}

/// @nodoc


class HistoryFailure implements HistoryState {
  const HistoryFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryFailureCopyWith<HistoryFailure> get copyWith => _$HistoryFailureCopyWithImpl<HistoryFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'HistoryState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $HistoryFailureCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryFailureCopyWith(HistoryFailure value, $Res Function(HistoryFailure) _then) = _$HistoryFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$HistoryFailureCopyWithImpl<$Res>
    implements $HistoryFailureCopyWith<$Res> {
  _$HistoryFailureCopyWithImpl(this._self, this._then);

  final HistoryFailure _self;
  final $Res Function(HistoryFailure) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(HistoryFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
