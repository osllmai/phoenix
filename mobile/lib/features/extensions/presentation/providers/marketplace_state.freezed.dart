// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketplaceState {

 String? get selectedSlug; Set<String> get installing;
/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketplaceStateCopyWith<MarketplaceState> get copyWith => _$MarketplaceStateCopyWithImpl<MarketplaceState>(this as MarketplaceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketplaceState&&(identical(other.selectedSlug, selectedSlug) || other.selectedSlug == selectedSlug)&&const DeepCollectionEquality().equals(other.installing, installing));
}


@override
int get hashCode => Object.hash(runtimeType,selectedSlug,const DeepCollectionEquality().hash(installing));

@override
String toString() {
  return 'MarketplaceState(selectedSlug: $selectedSlug, installing: $installing)';
}


}

/// @nodoc
abstract mixin class $MarketplaceStateCopyWith<$Res>  {
  factory $MarketplaceStateCopyWith(MarketplaceState value, $Res Function(MarketplaceState) _then) = _$MarketplaceStateCopyWithImpl;
@useResult
$Res call({
 String? selectedSlug, Set<String> installing
});




}
/// @nodoc
class _$MarketplaceStateCopyWithImpl<$Res>
    implements $MarketplaceStateCopyWith<$Res> {
  _$MarketplaceStateCopyWithImpl(this._self, this._then);

  final MarketplaceState _self;
  final $Res Function(MarketplaceState) _then;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedSlug = freezed,Object? installing = null,}) {
  return _then(_self.copyWith(
selectedSlug: freezed == selectedSlug ? _self.selectedSlug : selectedSlug // ignore: cast_nullable_to_non_nullable
as String?,installing: null == installing ? _self.installing : installing // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketplaceState].
extension MarketplaceStatePatterns on MarketplaceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketplaceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketplaceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketplaceState value)  $default,){
final _that = this;
switch (_that) {
case _MarketplaceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketplaceState value)?  $default,){
final _that = this;
switch (_that) {
case _MarketplaceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? selectedSlug,  Set<String> installing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketplaceState() when $default != null:
return $default(_that.selectedSlug,_that.installing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? selectedSlug,  Set<String> installing)  $default,) {final _that = this;
switch (_that) {
case _MarketplaceState():
return $default(_that.selectedSlug,_that.installing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? selectedSlug,  Set<String> installing)?  $default,) {final _that = this;
switch (_that) {
case _MarketplaceState() when $default != null:
return $default(_that.selectedSlug,_that.installing);case _:
  return null;

}
}

}

/// @nodoc


class _MarketplaceState implements MarketplaceState {
  const _MarketplaceState({this.selectedSlug, final  Set<String> installing = const <String>{}}): _installing = installing;
  

@override final  String? selectedSlug;
 final  Set<String> _installing;
@override@JsonKey() Set<String> get installing {
  if (_installing is EqualUnmodifiableSetView) return _installing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_installing);
}


/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketplaceStateCopyWith<_MarketplaceState> get copyWith => __$MarketplaceStateCopyWithImpl<_MarketplaceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketplaceState&&(identical(other.selectedSlug, selectedSlug) || other.selectedSlug == selectedSlug)&&const DeepCollectionEquality().equals(other._installing, _installing));
}


@override
int get hashCode => Object.hash(runtimeType,selectedSlug,const DeepCollectionEquality().hash(_installing));

@override
String toString() {
  return 'MarketplaceState(selectedSlug: $selectedSlug, installing: $installing)';
}


}

/// @nodoc
abstract mixin class _$MarketplaceStateCopyWith<$Res> implements $MarketplaceStateCopyWith<$Res> {
  factory _$MarketplaceStateCopyWith(_MarketplaceState value, $Res Function(_MarketplaceState) _then) = __$MarketplaceStateCopyWithImpl;
@override @useResult
$Res call({
 String? selectedSlug, Set<String> installing
});




}
/// @nodoc
class __$MarketplaceStateCopyWithImpl<$Res>
    implements _$MarketplaceStateCopyWith<$Res> {
  __$MarketplaceStateCopyWithImpl(this._self, this._then);

  final _MarketplaceState _self;
  final $Res Function(_MarketplaceState) _then;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedSlug = freezed,Object? installing = null,}) {
  return _then(_MarketplaceState(
selectedSlug: freezed == selectedSlug ? _self.selectedSlug : selectedSlug // ignore: cast_nullable_to_non_nullable
as String?,installing: null == installing ? _self._installing : installing // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
