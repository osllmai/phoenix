// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extension_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExtensionEntry {

 int get id; String get slug; String get name; String get publisher; String get icon; ExtensionCategory get category; String get version; String get description; bool get verified; bool get installed; double get rating; int get installsCount;
/// Create a copy of ExtensionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtensionEntryCopyWith<ExtensionEntry> get copyWith => _$ExtensionEntryCopyWithImpl<ExtensionEntry>(this as ExtensionEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtensionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.category, category) || other.category == category)&&(identical(other.version, version) || other.version == version)&&(identical(other.description, description) || other.description == description)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.installed, installed) || other.installed == installed)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.installsCount, installsCount) || other.installsCount == installsCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,slug,name,publisher,icon,category,version,description,verified,installed,rating,installsCount);

@override
String toString() {
  return 'ExtensionEntry(id: $id, slug: $slug, name: $name, publisher: $publisher, icon: $icon, category: $category, version: $version, description: $description, verified: $verified, installed: $installed, rating: $rating, installsCount: $installsCount)';
}


}

/// @nodoc
abstract mixin class $ExtensionEntryCopyWith<$Res>  {
  factory $ExtensionEntryCopyWith(ExtensionEntry value, $Res Function(ExtensionEntry) _then) = _$ExtensionEntryCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String name, String publisher, String icon, ExtensionCategory category, String version, String description, bool verified, bool installed, double rating, int installsCount
});




}
/// @nodoc
class _$ExtensionEntryCopyWithImpl<$Res>
    implements $ExtensionEntryCopyWith<$Res> {
  _$ExtensionEntryCopyWithImpl(this._self, this._then);

  final ExtensionEntry _self;
  final $Res Function(ExtensionEntry) _then;

/// Create a copy of ExtensionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? publisher = null,Object? icon = null,Object? category = null,Object? version = null,Object? description = null,Object? verified = null,Object? installed = null,Object? rating = null,Object? installsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExtensionCategory,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,installed: null == installed ? _self.installed : installed // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,installsCount: null == installsCount ? _self.installsCount : installsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtensionEntry].
extension ExtensionEntryPatterns on ExtensionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtensionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtensionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtensionEntry value)  $default,){
final _that = this;
switch (_that) {
case _ExtensionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtensionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ExtensionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  String publisher,  String icon,  ExtensionCategory category,  String version,  String description,  bool verified,  bool installed,  double rating,  int installsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtensionEntry() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.publisher,_that.icon,_that.category,_that.version,_that.description,_that.verified,_that.installed,_that.rating,_that.installsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String name,  String publisher,  String icon,  ExtensionCategory category,  String version,  String description,  bool verified,  bool installed,  double rating,  int installsCount)  $default,) {final _that = this;
switch (_that) {
case _ExtensionEntry():
return $default(_that.id,_that.slug,_that.name,_that.publisher,_that.icon,_that.category,_that.version,_that.description,_that.verified,_that.installed,_that.rating,_that.installsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String name,  String publisher,  String icon,  ExtensionCategory category,  String version,  String description,  bool verified,  bool installed,  double rating,  int installsCount)?  $default,) {final _that = this;
switch (_that) {
case _ExtensionEntry() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.publisher,_that.icon,_that.category,_that.version,_that.description,_that.verified,_that.installed,_that.rating,_that.installsCount);case _:
  return null;

}
}

}

/// @nodoc


class _ExtensionEntry extends ExtensionEntry {
  const _ExtensionEntry({required this.id, required this.slug, required this.name, required this.publisher, required this.icon, required this.category, required this.version, this.description = '', this.verified = false, this.installed = false, this.rating = 0.0, this.installsCount = 0}): super._();
  

@override final  int id;
@override final  String slug;
@override final  String name;
@override final  String publisher;
@override final  String icon;
@override final  ExtensionCategory category;
@override final  String version;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool verified;
@override@JsonKey() final  bool installed;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int installsCount;

/// Create a copy of ExtensionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtensionEntryCopyWith<_ExtensionEntry> get copyWith => __$ExtensionEntryCopyWithImpl<_ExtensionEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtensionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.category, category) || other.category == category)&&(identical(other.version, version) || other.version == version)&&(identical(other.description, description) || other.description == description)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.installed, installed) || other.installed == installed)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.installsCount, installsCount) || other.installsCount == installsCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,slug,name,publisher,icon,category,version,description,verified,installed,rating,installsCount);

@override
String toString() {
  return 'ExtensionEntry(id: $id, slug: $slug, name: $name, publisher: $publisher, icon: $icon, category: $category, version: $version, description: $description, verified: $verified, installed: $installed, rating: $rating, installsCount: $installsCount)';
}


}

/// @nodoc
abstract mixin class _$ExtensionEntryCopyWith<$Res> implements $ExtensionEntryCopyWith<$Res> {
  factory _$ExtensionEntryCopyWith(_ExtensionEntry value, $Res Function(_ExtensionEntry) _then) = __$ExtensionEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String name, String publisher, String icon, ExtensionCategory category, String version, String description, bool verified, bool installed, double rating, int installsCount
});




}
/// @nodoc
class __$ExtensionEntryCopyWithImpl<$Res>
    implements _$ExtensionEntryCopyWith<$Res> {
  __$ExtensionEntryCopyWithImpl(this._self, this._then);

  final _ExtensionEntry _self;
  final $Res Function(_ExtensionEntry) _then;

/// Create a copy of ExtensionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? publisher = null,Object? icon = null,Object? category = null,Object? version = null,Object? description = null,Object? verified = null,Object? installed = null,Object? rating = null,Object? installsCount = null,}) {
  return _then(_ExtensionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExtensionCategory,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,installed: null == installed ? _self.installed : installed // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,installsCount: null == installsCount ? _self.installsCount : installsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
