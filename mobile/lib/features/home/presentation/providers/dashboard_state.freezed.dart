// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardStat {

 String get label; String get value; String get unit; String get icon;
/// Create a copy of DashboardStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStatCopyWith<DashboardStat> get copyWith => _$DashboardStatCopyWithImpl<DashboardStat>(this as DashboardStat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardStat&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,unit,icon);

@override
String toString() {
  return 'DashboardStat(label: $label, value: $value, unit: $unit, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $DashboardStatCopyWith<$Res>  {
  factory $DashboardStatCopyWith(DashboardStat value, $Res Function(DashboardStat) _then) = _$DashboardStatCopyWithImpl;
@useResult
$Res call({
 String label, String value, String unit, String icon
});




}
/// @nodoc
class _$DashboardStatCopyWithImpl<$Res>
    implements $DashboardStatCopyWith<$Res> {
  _$DashboardStatCopyWithImpl(this._self, this._then);

  final DashboardStat _self;
  final $Res Function(DashboardStat) _then;

/// Create a copy of DashboardStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? unit = null,Object? icon = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardStat].
extension DashboardStatPatterns on DashboardStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardStat value)  $default,){
final _that = this;
switch (_that) {
case _DashboardStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardStat value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  String unit,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardStat() when $default != null:
return $default(_that.label,_that.value,_that.unit,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  String unit,  String icon)  $default,) {final _that = this;
switch (_that) {
case _DashboardStat():
return $default(_that.label,_that.value,_that.unit,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  String unit,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _DashboardStat() when $default != null:
return $default(_that.label,_that.value,_that.unit,_that.icon);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardStat implements DashboardStat {
  const _DashboardStat({required this.label, required this.value, required this.unit, required this.icon});
  

@override final  String label;
@override final  String value;
@override final  String unit;
@override final  String icon;

/// Create a copy of DashboardStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStatCopyWith<_DashboardStat> get copyWith => __$DashboardStatCopyWithImpl<_DashboardStat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardStat&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,unit,icon);

@override
String toString() {
  return 'DashboardStat(label: $label, value: $value, unit: $unit, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$DashboardStatCopyWith<$Res> implements $DashboardStatCopyWith<$Res> {
  factory _$DashboardStatCopyWith(_DashboardStat value, $Res Function(_DashboardStat) _then) = __$DashboardStatCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, String unit, String icon
});




}
/// @nodoc
class __$DashboardStatCopyWithImpl<$Res>
    implements _$DashboardStatCopyWith<$Res> {
  __$DashboardStatCopyWithImpl(this._self, this._then);

  final _DashboardStat _self;
  final $Res Function(_DashboardStat) _then;

/// Create a copy of DashboardStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? unit = null,Object? icon = null,}) {
  return _then(_DashboardStat(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ResourceMeter {

 String get label; double get fraction; String get detail;
/// Create a copy of ResourceMeter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceMeterCopyWith<ResourceMeter> get copyWith => _$ResourceMeterCopyWithImpl<ResourceMeter>(this as ResourceMeter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResourceMeter&&(identical(other.label, label) || other.label == label)&&(identical(other.fraction, fraction) || other.fraction == fraction)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,label,fraction,detail);

@override
String toString() {
  return 'ResourceMeter(label: $label, fraction: $fraction, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $ResourceMeterCopyWith<$Res>  {
  factory $ResourceMeterCopyWith(ResourceMeter value, $Res Function(ResourceMeter) _then) = _$ResourceMeterCopyWithImpl;
@useResult
$Res call({
 String label, double fraction, String detail
});




}
/// @nodoc
class _$ResourceMeterCopyWithImpl<$Res>
    implements $ResourceMeterCopyWith<$Res> {
  _$ResourceMeterCopyWithImpl(this._self, this._then);

  final ResourceMeter _self;
  final $Res Function(ResourceMeter) _then;

/// Create a copy of ResourceMeter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? fraction = null,Object? detail = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResourceMeter].
extension ResourceMeterPatterns on ResourceMeter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResourceMeter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResourceMeter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResourceMeter value)  $default,){
final _that = this;
switch (_that) {
case _ResourceMeter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResourceMeter value)?  $default,){
final _that = this;
switch (_that) {
case _ResourceMeter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double fraction,  String detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResourceMeter() when $default != null:
return $default(_that.label,_that.fraction,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double fraction,  String detail)  $default,) {final _that = this;
switch (_that) {
case _ResourceMeter():
return $default(_that.label,_that.fraction,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double fraction,  String detail)?  $default,) {final _that = this;
switch (_that) {
case _ResourceMeter() when $default != null:
return $default(_that.label,_that.fraction,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _ResourceMeter implements ResourceMeter {
  const _ResourceMeter({required this.label, required this.fraction, required this.detail});
  

@override final  String label;
@override final  double fraction;
@override final  String detail;

/// Create a copy of ResourceMeter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceMeterCopyWith<_ResourceMeter> get copyWith => __$ResourceMeterCopyWithImpl<_ResourceMeter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResourceMeter&&(identical(other.label, label) || other.label == label)&&(identical(other.fraction, fraction) || other.fraction == fraction)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,label,fraction,detail);

@override
String toString() {
  return 'ResourceMeter(label: $label, fraction: $fraction, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$ResourceMeterCopyWith<$Res> implements $ResourceMeterCopyWith<$Res> {
  factory _$ResourceMeterCopyWith(_ResourceMeter value, $Res Function(_ResourceMeter) _then) = __$ResourceMeterCopyWithImpl;
@override @useResult
$Res call({
 String label, double fraction, String detail
});




}
/// @nodoc
class __$ResourceMeterCopyWithImpl<$Res>
    implements _$ResourceMeterCopyWith<$Res> {
  __$ResourceMeterCopyWithImpl(this._self, this._then);

  final _ResourceMeter _self;
  final $Res Function(_ResourceMeter) _then;

/// Create a copy of ResourceMeter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? fraction = null,Object? detail = null,}) {
  return _then(_ResourceMeter(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,fraction: null == fraction ? _self.fraction : fraction // ignore: cast_nullable_to_non_nullable
as double,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DashboardState {

 List<DashboardStat> get stats; List<ResourceMeter> get resources; bool get serverRunning; String get serverEndpoint;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&const DeepCollectionEquality().equals(other.stats, stats)&&const DeepCollectionEquality().equals(other.resources, resources)&&(identical(other.serverRunning, serverRunning) || other.serverRunning == serverRunning)&&(identical(other.serverEndpoint, serverEndpoint) || other.serverEndpoint == serverEndpoint));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(stats),const DeepCollectionEquality().hash(resources),serverRunning,serverEndpoint);

@override
String toString() {
  return 'DashboardState(stats: $stats, resources: $resources, serverRunning: $serverRunning, serverEndpoint: $serverEndpoint)';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 List<DashboardStat> stats, List<ResourceMeter> resources, bool serverRunning, String serverEndpoint
});




}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stats = null,Object? resources = null,Object? serverRunning = null,Object? serverEndpoint = null,}) {
  return _then(_self.copyWith(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as List<DashboardStat>,resources: null == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as List<ResourceMeter>,serverRunning: null == serverRunning ? _self.serverRunning : serverRunning // ignore: cast_nullable_to_non_nullable
as bool,serverEndpoint: null == serverEndpoint ? _self.serverEndpoint : serverEndpoint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DashboardStat> stats,  List<ResourceMeter> resources,  bool serverRunning,  String serverEndpoint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.stats,_that.resources,_that.serverRunning,_that.serverEndpoint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DashboardStat> stats,  List<ResourceMeter> resources,  bool serverRunning,  String serverEndpoint)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.stats,_that.resources,_that.serverRunning,_that.serverEndpoint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DashboardStat> stats,  List<ResourceMeter> resources,  bool serverRunning,  String serverEndpoint)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.stats,_that.resources,_that.serverRunning,_that.serverEndpoint);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState implements DashboardState {
  const _DashboardState({final  List<DashboardStat> stats = const <DashboardStat>[], final  List<ResourceMeter> resources = const <ResourceMeter>[], this.serverRunning = false, this.serverEndpoint = ''}): _stats = stats,_resources = resources;
  

 final  List<DashboardStat> _stats;
@override@JsonKey() List<DashboardStat> get stats {
  if (_stats is EqualUnmodifiableListView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stats);
}

 final  List<ResourceMeter> _resources;
@override@JsonKey() List<ResourceMeter> get resources {
  if (_resources is EqualUnmodifiableListView) return _resources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_resources);
}

@override@JsonKey() final  bool serverRunning;
@override@JsonKey() final  String serverEndpoint;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&const DeepCollectionEquality().equals(other._stats, _stats)&&const DeepCollectionEquality().equals(other._resources, _resources)&&(identical(other.serverRunning, serverRunning) || other.serverRunning == serverRunning)&&(identical(other.serverEndpoint, serverEndpoint) || other.serverEndpoint == serverEndpoint));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stats),const DeepCollectionEquality().hash(_resources),serverRunning,serverEndpoint);

@override
String toString() {
  return 'DashboardState(stats: $stats, resources: $resources, serverRunning: $serverRunning, serverEndpoint: $serverEndpoint)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 List<DashboardStat> stats, List<ResourceMeter> resources, bool serverRunning, String serverEndpoint
});




}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stats = null,Object? resources = null,Object? serverRunning = null,Object? serverEndpoint = null,}) {
  return _then(_DashboardState(
stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as List<DashboardStat>,resources: null == resources ? _self._resources : resources // ignore: cast_nullable_to_non_nullable
as List<ResourceMeter>,serverRunning: null == serverRunning ? _self.serverRunning : serverRunning // ignore: cast_nullable_to_non_nullable
as bool,serverEndpoint: null == serverEndpoint ? _self.serverEndpoint : serverEndpoint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
