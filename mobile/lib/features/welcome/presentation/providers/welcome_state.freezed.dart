// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'welcome_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WelcomeState {

 WelcomeStage get stage; String get selectedModelId; DownloadStatus get download; double get progress; bool get telemetry;
/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WelcomeStateCopyWith<WelcomeState> get copyWith => _$WelcomeStateCopyWithImpl<WelcomeState>(this as WelcomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WelcomeState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.selectedModelId, selectedModelId) || other.selectedModelId == selectedModelId)&&(identical(other.download, download) || other.download == download)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.telemetry, telemetry) || other.telemetry == telemetry));
}


@override
int get hashCode => Object.hash(runtimeType,stage,selectedModelId,download,progress,telemetry);

@override
String toString() {
  return 'WelcomeState(stage: $stage, selectedModelId: $selectedModelId, download: $download, progress: $progress, telemetry: $telemetry)';
}


}

/// @nodoc
abstract mixin class $WelcomeStateCopyWith<$Res>  {
  factory $WelcomeStateCopyWith(WelcomeState value, $Res Function(WelcomeState) _then) = _$WelcomeStateCopyWithImpl;
@useResult
$Res call({
 WelcomeStage stage, String selectedModelId, DownloadStatus download, double progress, bool telemetry
});




}
/// @nodoc
class _$WelcomeStateCopyWithImpl<$Res>
    implements $WelcomeStateCopyWith<$Res> {
  _$WelcomeStateCopyWithImpl(this._self, this._then);

  final WelcomeState _self;
  final $Res Function(WelcomeState) _then;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? selectedModelId = null,Object? download = null,Object? progress = null,Object? telemetry = null,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as WelcomeStage,selectedModelId: null == selectedModelId ? _self.selectedModelId : selectedModelId // ignore: cast_nullable_to_non_nullable
as String,download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as DownloadStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,telemetry: null == telemetry ? _self.telemetry : telemetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WelcomeState].
extension WelcomeStatePatterns on WelcomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WelcomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WelcomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WelcomeState value)  $default,){
final _that = this;
switch (_that) {
case _WelcomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WelcomeState value)?  $default,){
final _that = this;
switch (_that) {
case _WelcomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WelcomeStage stage,  String selectedModelId,  DownloadStatus download,  double progress,  bool telemetry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WelcomeState() when $default != null:
return $default(_that.stage,_that.selectedModelId,_that.download,_that.progress,_that.telemetry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WelcomeStage stage,  String selectedModelId,  DownloadStatus download,  double progress,  bool telemetry)  $default,) {final _that = this;
switch (_that) {
case _WelcomeState():
return $default(_that.stage,_that.selectedModelId,_that.download,_that.progress,_that.telemetry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WelcomeStage stage,  String selectedModelId,  DownloadStatus download,  double progress,  bool telemetry)?  $default,) {final _that = this;
switch (_that) {
case _WelcomeState() when $default != null:
return $default(_that.stage,_that.selectedModelId,_that.download,_that.progress,_that.telemetry);case _:
  return null;

}
}

}

/// @nodoc


class _WelcomeState extends WelcomeState {
  const _WelcomeState({this.stage = WelcomeStage.intro, this.selectedModelId = 'llama-3.2-3b', this.download = DownloadStatus.idle, this.progress = 0.0, this.telemetry = false}): super._();
  

@override@JsonKey() final  WelcomeStage stage;
@override@JsonKey() final  String selectedModelId;
@override@JsonKey() final  DownloadStatus download;
@override@JsonKey() final  double progress;
@override@JsonKey() final  bool telemetry;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WelcomeStateCopyWith<_WelcomeState> get copyWith => __$WelcomeStateCopyWithImpl<_WelcomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WelcomeState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.selectedModelId, selectedModelId) || other.selectedModelId == selectedModelId)&&(identical(other.download, download) || other.download == download)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.telemetry, telemetry) || other.telemetry == telemetry));
}


@override
int get hashCode => Object.hash(runtimeType,stage,selectedModelId,download,progress,telemetry);

@override
String toString() {
  return 'WelcomeState(stage: $stage, selectedModelId: $selectedModelId, download: $download, progress: $progress, telemetry: $telemetry)';
}


}

/// @nodoc
abstract mixin class _$WelcomeStateCopyWith<$Res> implements $WelcomeStateCopyWith<$Res> {
  factory _$WelcomeStateCopyWith(_WelcomeState value, $Res Function(_WelcomeState) _then) = __$WelcomeStateCopyWithImpl;
@override @useResult
$Res call({
 WelcomeStage stage, String selectedModelId, DownloadStatus download, double progress, bool telemetry
});




}
/// @nodoc
class __$WelcomeStateCopyWithImpl<$Res>
    implements _$WelcomeStateCopyWith<$Res> {
  __$WelcomeStateCopyWithImpl(this._self, this._then);

  final _WelcomeState _self;
  final $Res Function(_WelcomeState) _then;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? selectedModelId = null,Object? download = null,Object? progress = null,Object? telemetry = null,}) {
  return _then(_WelcomeState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as WelcomeStage,selectedModelId: null == selectedModelId ? _self.selectedModelId : selectedModelId // ignore: cast_nullable_to_non_nullable
as String,download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as DownloadStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,telemetry: null == telemetry ? _self.telemetry : telemetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
