// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 AppThemeMode get theme; double get fontSize; int get accentIndex; int get contextLength; int get gpuLayers; int get cpuThreads; bool get telemetry; bool get usageAnalytics; String get activeSection;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.accentIndex, accentIndex) || other.accentIndex == accentIndex)&&(identical(other.contextLength, contextLength) || other.contextLength == contextLength)&&(identical(other.gpuLayers, gpuLayers) || other.gpuLayers == gpuLayers)&&(identical(other.cpuThreads, cpuThreads) || other.cpuThreads == cpuThreads)&&(identical(other.telemetry, telemetry) || other.telemetry == telemetry)&&(identical(other.usageAnalytics, usageAnalytics) || other.usageAnalytics == usageAnalytics)&&(identical(other.activeSection, activeSection) || other.activeSection == activeSection));
}


@override
int get hashCode => Object.hash(runtimeType,theme,fontSize,accentIndex,contextLength,gpuLayers,cpuThreads,telemetry,usageAnalytics,activeSection);

@override
String toString() {
  return 'SettingsState(theme: $theme, fontSize: $fontSize, accentIndex: $accentIndex, contextLength: $contextLength, gpuLayers: $gpuLayers, cpuThreads: $cpuThreads, telemetry: $telemetry, usageAnalytics: $usageAnalytics, activeSection: $activeSection)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 AppThemeMode theme, double fontSize, int accentIndex, int contextLength, int gpuLayers, int cpuThreads, bool telemetry, bool usageAnalytics, String activeSection
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? fontSize = null,Object? accentIndex = null,Object? contextLength = null,Object? gpuLayers = null,Object? cpuThreads = null,Object? telemetry = null,Object? usageAnalytics = null,Object? activeSection = null,}) {
  return _then(_self.copyWith(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as AppThemeMode,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,accentIndex: null == accentIndex ? _self.accentIndex : accentIndex // ignore: cast_nullable_to_non_nullable
as int,contextLength: null == contextLength ? _self.contextLength : contextLength // ignore: cast_nullable_to_non_nullable
as int,gpuLayers: null == gpuLayers ? _self.gpuLayers : gpuLayers // ignore: cast_nullable_to_non_nullable
as int,cpuThreads: null == cpuThreads ? _self.cpuThreads : cpuThreads // ignore: cast_nullable_to_non_nullable
as int,telemetry: null == telemetry ? _self.telemetry : telemetry // ignore: cast_nullable_to_non_nullable
as bool,usageAnalytics: null == usageAnalytics ? _self.usageAnalytics : usageAnalytics // ignore: cast_nullable_to_non_nullable
as bool,activeSection: null == activeSection ? _self.activeSection : activeSection // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppThemeMode theme,  double fontSize,  int accentIndex,  int contextLength,  int gpuLayers,  int cpuThreads,  bool telemetry,  bool usageAnalytics,  String activeSection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.theme,_that.fontSize,_that.accentIndex,_that.contextLength,_that.gpuLayers,_that.cpuThreads,_that.telemetry,_that.usageAnalytics,_that.activeSection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppThemeMode theme,  double fontSize,  int accentIndex,  int contextLength,  int gpuLayers,  int cpuThreads,  bool telemetry,  bool usageAnalytics,  String activeSection)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.theme,_that.fontSize,_that.accentIndex,_that.contextLength,_that.gpuLayers,_that.cpuThreads,_that.telemetry,_that.usageAnalytics,_that.activeSection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppThemeMode theme,  double fontSize,  int accentIndex,  int contextLength,  int gpuLayers,  int cpuThreads,  bool telemetry,  bool usageAnalytics,  String activeSection)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.theme,_that.fontSize,_that.accentIndex,_that.contextLength,_that.gpuLayers,_that.cpuThreads,_that.telemetry,_that.usageAnalytics,_that.activeSection);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.theme = AppThemeMode.dark, this.fontSize = 15.0, this.accentIndex = 0, this.contextLength = 8192, this.gpuLayers = 32, this.cpuThreads = 8, this.telemetry = false, this.usageAnalytics = false, this.activeSection = 'appearance'});
  

@override@JsonKey() final  AppThemeMode theme;
@override@JsonKey() final  double fontSize;
@override@JsonKey() final  int accentIndex;
@override@JsonKey() final  int contextLength;
@override@JsonKey() final  int gpuLayers;
@override@JsonKey() final  int cpuThreads;
@override@JsonKey() final  bool telemetry;
@override@JsonKey() final  bool usageAnalytics;
@override@JsonKey() final  String activeSection;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.accentIndex, accentIndex) || other.accentIndex == accentIndex)&&(identical(other.contextLength, contextLength) || other.contextLength == contextLength)&&(identical(other.gpuLayers, gpuLayers) || other.gpuLayers == gpuLayers)&&(identical(other.cpuThreads, cpuThreads) || other.cpuThreads == cpuThreads)&&(identical(other.telemetry, telemetry) || other.telemetry == telemetry)&&(identical(other.usageAnalytics, usageAnalytics) || other.usageAnalytics == usageAnalytics)&&(identical(other.activeSection, activeSection) || other.activeSection == activeSection));
}


@override
int get hashCode => Object.hash(runtimeType,theme,fontSize,accentIndex,contextLength,gpuLayers,cpuThreads,telemetry,usageAnalytics,activeSection);

@override
String toString() {
  return 'SettingsState(theme: $theme, fontSize: $fontSize, accentIndex: $accentIndex, contextLength: $contextLength, gpuLayers: $gpuLayers, cpuThreads: $cpuThreads, telemetry: $telemetry, usageAnalytics: $usageAnalytics, activeSection: $activeSection)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 AppThemeMode theme, double fontSize, int accentIndex, int contextLength, int gpuLayers, int cpuThreads, bool telemetry, bool usageAnalytics, String activeSection
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? fontSize = null,Object? accentIndex = null,Object? contextLength = null,Object? gpuLayers = null,Object? cpuThreads = null,Object? telemetry = null,Object? usageAnalytics = null,Object? activeSection = null,}) {
  return _then(_SettingsState(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as AppThemeMode,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,accentIndex: null == accentIndex ? _self.accentIndex : accentIndex // ignore: cast_nullable_to_non_nullable
as int,contextLength: null == contextLength ? _self.contextLength : contextLength // ignore: cast_nullable_to_non_nullable
as int,gpuLayers: null == gpuLayers ? _self.gpuLayers : gpuLayers // ignore: cast_nullable_to_non_nullable
as int,cpuThreads: null == cpuThreads ? _self.cpuThreads : cpuThreads // ignore: cast_nullable_to_non_nullable
as int,telemetry: null == telemetry ? _self.telemetry : telemetry // ignore: cast_nullable_to_non_nullable
as bool,usageAnalytics: null == usageAnalytics ? _self.usageAnalytics : usageAnalytics // ignore: cast_nullable_to_non_nullable
as bool,activeSection: null == activeSection ? _self.activeSection : activeSection // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
