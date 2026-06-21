// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocumentListItemDto {

 int get id; String get title; String get status;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of DocumentListItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentListItemDtoCopyWith<DocumentListItemDto> get copyWith => _$DocumentListItemDtoCopyWithImpl<DocumentListItemDto>(this as DocumentListItemDto, _$identity);

  /// Serializes this DocumentListItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentListItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,createdAt);

@override
String toString() {
  return 'DocumentListItemDto(id: $id, title: $title, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DocumentListItemDtoCopyWith<$Res>  {
  factory $DocumentListItemDtoCopyWith(DocumentListItemDto value, $Res Function(DocumentListItemDto) _then) = _$DocumentListItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String status,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$DocumentListItemDtoCopyWithImpl<$Res>
    implements $DocumentListItemDtoCopyWith<$Res> {
  _$DocumentListItemDtoCopyWithImpl(this._self, this._then);

  final DocumentListItemDto _self;
  final $Res Function(DocumentListItemDto) _then;

/// Create a copy of DocumentListItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentListItemDto].
extension DocumentListItemDtoPatterns on DocumentListItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentListItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentListItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentListItemDto value)  $default,){
final _that = this;
switch (_that) {
case _DocumentListItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentListItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentListItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String status, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentListItemDto() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String status, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DocumentListItemDto():
return $default(_that.id,_that.title,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String status, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DocumentListItemDto() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentListItemDto implements DocumentListItemDto {
  const _DocumentListItemDto({required this.id, required this.title, required this.status, @JsonKey(name: 'created_at') required this.createdAt});
  factory _DocumentListItemDto.fromJson(Map<String, dynamic> json) => _$DocumentListItemDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of DocumentListItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentListItemDtoCopyWith<_DocumentListItemDto> get copyWith => __$DocumentListItemDtoCopyWithImpl<_DocumentListItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentListItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentListItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,createdAt);

@override
String toString() {
  return 'DocumentListItemDto(id: $id, title: $title, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentListItemDtoCopyWith<$Res> implements $DocumentListItemDtoCopyWith<$Res> {
  factory _$DocumentListItemDtoCopyWith(_DocumentListItemDto value, $Res Function(_DocumentListItemDto) _then) = __$DocumentListItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String status,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$DocumentListItemDtoCopyWithImpl<$Res>
    implements _$DocumentListItemDtoCopyWith<$Res> {
  __$DocumentListItemDtoCopyWithImpl(this._self, this._then);

  final _DocumentListItemDto _self;
  final $Res Function(_DocumentListItemDto) _then;

/// Create a copy of DocumentListItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_DocumentListItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DocumentDetailDto {

 int get id; String get title; String get status;@JsonKey(name: 'created_at') DateTime get createdAt; String get markdown; String get error;
/// Create a copy of DocumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentDetailDtoCopyWith<DocumentDetailDto> get copyWith => _$DocumentDetailDtoCopyWithImpl<DocumentDetailDto>(this as DocumentDetailDto, _$identity);

  /// Serializes this DocumentDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.markdown, markdown) || other.markdown == markdown)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,createdAt,markdown,error);

@override
String toString() {
  return 'DocumentDetailDto(id: $id, title: $title, status: $status, createdAt: $createdAt, markdown: $markdown, error: $error)';
}


}

/// @nodoc
abstract mixin class $DocumentDetailDtoCopyWith<$Res>  {
  factory $DocumentDetailDtoCopyWith(DocumentDetailDto value, $Res Function(DocumentDetailDto) _then) = _$DocumentDetailDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String status,@JsonKey(name: 'created_at') DateTime createdAt, String markdown, String error
});




}
/// @nodoc
class _$DocumentDetailDtoCopyWithImpl<$Res>
    implements $DocumentDetailDtoCopyWith<$Res> {
  _$DocumentDetailDtoCopyWithImpl(this._self, this._then);

  final DocumentDetailDto _self;
  final $Res Function(DocumentDetailDto) _then;

/// Create a copy of DocumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? createdAt = null,Object? markdown = null,Object? error = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,markdown: null == markdown ? _self.markdown : markdown // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentDetailDto].
extension DocumentDetailDtoPatterns on DocumentDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _DocumentDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  String markdown,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentDetailDto() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.createdAt,_that.markdown,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  String markdown,  String error)  $default,) {final _that = this;
switch (_that) {
case _DocumentDetailDto():
return $default(_that.id,_that.title,_that.status,_that.createdAt,_that.markdown,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  String markdown,  String error)?  $default,) {final _that = this;
switch (_that) {
case _DocumentDetailDto() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.createdAt,_that.markdown,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentDetailDto implements DocumentDetailDto {
  const _DocumentDetailDto({required this.id, required this.title, required this.status, @JsonKey(name: 'created_at') required this.createdAt, this.markdown = '', this.error = ''});
  factory _DocumentDetailDto.fromJson(Map<String, dynamic> json) => _$DocumentDetailDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey() final  String markdown;
@override@JsonKey() final  String error;

/// Create a copy of DocumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentDetailDtoCopyWith<_DocumentDetailDto> get copyWith => __$DocumentDetailDtoCopyWithImpl<_DocumentDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.markdown, markdown) || other.markdown == markdown)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,createdAt,markdown,error);

@override
String toString() {
  return 'DocumentDetailDto(id: $id, title: $title, status: $status, createdAt: $createdAt, markdown: $markdown, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DocumentDetailDtoCopyWith<$Res> implements $DocumentDetailDtoCopyWith<$Res> {
  factory _$DocumentDetailDtoCopyWith(_DocumentDetailDto value, $Res Function(_DocumentDetailDto) _then) = __$DocumentDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String status,@JsonKey(name: 'created_at') DateTime createdAt, String markdown, String error
});




}
/// @nodoc
class __$DocumentDetailDtoCopyWithImpl<$Res>
    implements _$DocumentDetailDtoCopyWith<$Res> {
  __$DocumentDetailDtoCopyWithImpl(this._self, this._then);

  final _DocumentDetailDto _self;
  final $Res Function(_DocumentDetailDto) _then;

/// Create a copy of DocumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? createdAt = null,Object? markdown = null,Object? error = null,}) {
  return _then(_DocumentDetailDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,markdown: null == markdown ? _self.markdown : markdown // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DocumentCreatedDto {

 int get id; String get title; String get status;@JsonKey(name: 'job_id') String get jobId;
/// Create a copy of DocumentCreatedDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentCreatedDtoCopyWith<DocumentCreatedDto> get copyWith => _$DocumentCreatedDtoCopyWithImpl<DocumentCreatedDto>(this as DocumentCreatedDto, _$identity);

  /// Serializes this DocumentCreatedDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentCreatedDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobId, jobId) || other.jobId == jobId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,jobId);

@override
String toString() {
  return 'DocumentCreatedDto(id: $id, title: $title, status: $status, jobId: $jobId)';
}


}

/// @nodoc
abstract mixin class $DocumentCreatedDtoCopyWith<$Res>  {
  factory $DocumentCreatedDtoCopyWith(DocumentCreatedDto value, $Res Function(DocumentCreatedDto) _then) = _$DocumentCreatedDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String status,@JsonKey(name: 'job_id') String jobId
});




}
/// @nodoc
class _$DocumentCreatedDtoCopyWithImpl<$Res>
    implements $DocumentCreatedDtoCopyWith<$Res> {
  _$DocumentCreatedDtoCopyWithImpl(this._self, this._then);

  final DocumentCreatedDto _self;
  final $Res Function(DocumentCreatedDto) _then;

/// Create a copy of DocumentCreatedDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? jobId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentCreatedDto].
extension DocumentCreatedDtoPatterns on DocumentCreatedDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentCreatedDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentCreatedDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentCreatedDto value)  $default,){
final _that = this;
switch (_that) {
case _DocumentCreatedDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentCreatedDto value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentCreatedDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String status, @JsonKey(name: 'job_id')  String jobId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentCreatedDto() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.jobId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String status, @JsonKey(name: 'job_id')  String jobId)  $default,) {final _that = this;
switch (_that) {
case _DocumentCreatedDto():
return $default(_that.id,_that.title,_that.status,_that.jobId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String status, @JsonKey(name: 'job_id')  String jobId)?  $default,) {final _that = this;
switch (_that) {
case _DocumentCreatedDto() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.jobId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentCreatedDto implements DocumentCreatedDto {
  const _DocumentCreatedDto({required this.id, required this.title, required this.status, @JsonKey(name: 'job_id') required this.jobId});
  factory _DocumentCreatedDto.fromJson(Map<String, dynamic> json) => _$DocumentCreatedDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String status;
@override@JsonKey(name: 'job_id') final  String jobId;

/// Create a copy of DocumentCreatedDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentCreatedDtoCopyWith<_DocumentCreatedDto> get copyWith => __$DocumentCreatedDtoCopyWithImpl<_DocumentCreatedDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentCreatedDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentCreatedDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobId, jobId) || other.jobId == jobId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,jobId);

@override
String toString() {
  return 'DocumentCreatedDto(id: $id, title: $title, status: $status, jobId: $jobId)';
}


}

/// @nodoc
abstract mixin class _$DocumentCreatedDtoCopyWith<$Res> implements $DocumentCreatedDtoCopyWith<$Res> {
  factory _$DocumentCreatedDtoCopyWith(_DocumentCreatedDto value, $Res Function(_DocumentCreatedDto) _then) = __$DocumentCreatedDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String status,@JsonKey(name: 'job_id') String jobId
});




}
/// @nodoc
class __$DocumentCreatedDtoCopyWithImpl<$Res>
    implements _$DocumentCreatedDtoCopyWith<$Res> {
  __$DocumentCreatedDtoCopyWithImpl(this._self, this._then);

  final _DocumentCreatedDto _self;
  final $Res Function(_DocumentCreatedDto) _then;

/// Create a copy of DocumentCreatedDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? jobId = null,}) {
  return _then(_DocumentCreatedDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
