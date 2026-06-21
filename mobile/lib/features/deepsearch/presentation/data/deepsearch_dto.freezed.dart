// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deepsearch_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchStartedDto {

 int get id; String get status;@JsonKey(name: 'job_id') String get jobId;
/// Create a copy of SearchStartedDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStartedDtoCopyWith<SearchStartedDto> get copyWith => _$SearchStartedDtoCopyWithImpl<SearchStartedDto>(this as SearchStartedDto, _$identity);

  /// Serializes this SearchStartedDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchStartedDto&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobId, jobId) || other.jobId == jobId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,jobId);

@override
String toString() {
  return 'SearchStartedDto(id: $id, status: $status, jobId: $jobId)';
}


}

/// @nodoc
abstract mixin class $SearchStartedDtoCopyWith<$Res>  {
  factory $SearchStartedDtoCopyWith(SearchStartedDto value, $Res Function(SearchStartedDto) _then) = _$SearchStartedDtoCopyWithImpl;
@useResult
$Res call({
 int id, String status,@JsonKey(name: 'job_id') String jobId
});




}
/// @nodoc
class _$SearchStartedDtoCopyWithImpl<$Res>
    implements $SearchStartedDtoCopyWith<$Res> {
  _$SearchStartedDtoCopyWithImpl(this._self, this._then);

  final SearchStartedDto _self;
  final $Res Function(SearchStartedDto) _then;

/// Create a copy of SearchStartedDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? jobId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchStartedDto].
extension SearchStartedDtoPatterns on SearchStartedDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchStartedDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchStartedDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchStartedDto value)  $default,){
final _that = this;
switch (_that) {
case _SearchStartedDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchStartedDto value)?  $default,){
final _that = this;
switch (_that) {
case _SearchStartedDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String status, @JsonKey(name: 'job_id')  String jobId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchStartedDto() when $default != null:
return $default(_that.id,_that.status,_that.jobId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String status, @JsonKey(name: 'job_id')  String jobId)  $default,) {final _that = this;
switch (_that) {
case _SearchStartedDto():
return $default(_that.id,_that.status,_that.jobId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String status, @JsonKey(name: 'job_id')  String jobId)?  $default,) {final _that = this;
switch (_that) {
case _SearchStartedDto() when $default != null:
return $default(_that.id,_that.status,_that.jobId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchStartedDto implements SearchStartedDto {
  const _SearchStartedDto({required this.id, required this.status, @JsonKey(name: 'job_id') required this.jobId});
  factory _SearchStartedDto.fromJson(Map<String, dynamic> json) => _$SearchStartedDtoFromJson(json);

@override final  int id;
@override final  String status;
@override@JsonKey(name: 'job_id') final  String jobId;

/// Create a copy of SearchStartedDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStartedDtoCopyWith<_SearchStartedDto> get copyWith => __$SearchStartedDtoCopyWithImpl<_SearchStartedDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchStartedDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchStartedDto&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobId, jobId) || other.jobId == jobId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,jobId);

@override
String toString() {
  return 'SearchStartedDto(id: $id, status: $status, jobId: $jobId)';
}


}

/// @nodoc
abstract mixin class _$SearchStartedDtoCopyWith<$Res> implements $SearchStartedDtoCopyWith<$Res> {
  factory _$SearchStartedDtoCopyWith(_SearchStartedDto value, $Res Function(_SearchStartedDto) _then) = __$SearchStartedDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String status,@JsonKey(name: 'job_id') String jobId
});




}
/// @nodoc
class __$SearchStartedDtoCopyWithImpl<$Res>
    implements _$SearchStartedDtoCopyWith<$Res> {
  __$SearchStartedDtoCopyWithImpl(this._self, this._then);

  final _SearchStartedDto _self;
  final $Res Function(_SearchStartedDto) _then;

/// Create a copy of SearchStartedDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? jobId = null,}) {
  return _then(_SearchStartedDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SearchListItemDto {

 int get id; String get query; String get status;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of SearchListItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchListItemDtoCopyWith<SearchListItemDto> get copyWith => _$SearchListItemDtoCopyWithImpl<SearchListItemDto>(this as SearchListItemDto, _$identity);

  /// Serializes this SearchListItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchListItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.query, query) || other.query == query)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,query,status,createdAt);

@override
String toString() {
  return 'SearchListItemDto(id: $id, query: $query, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SearchListItemDtoCopyWith<$Res>  {
  factory $SearchListItemDtoCopyWith(SearchListItemDto value, $Res Function(SearchListItemDto) _then) = _$SearchListItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, String query, String status,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$SearchListItemDtoCopyWithImpl<$Res>
    implements $SearchListItemDtoCopyWith<$Res> {
  _$SearchListItemDtoCopyWithImpl(this._self, this._then);

  final SearchListItemDto _self;
  final $Res Function(SearchListItemDto) _then;

/// Create a copy of SearchListItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? query = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchListItemDto].
extension SearchListItemDtoPatterns on SearchListItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchListItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchListItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchListItemDto value)  $default,){
final _that = this;
switch (_that) {
case _SearchListItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchListItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _SearchListItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String query,  String status, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchListItemDto() when $default != null:
return $default(_that.id,_that.query,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String query,  String status, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SearchListItemDto():
return $default(_that.id,_that.query,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String query,  String status, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SearchListItemDto() when $default != null:
return $default(_that.id,_that.query,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchListItemDto implements SearchListItemDto {
  const _SearchListItemDto({required this.id, required this.query, required this.status, @JsonKey(name: 'created_at') required this.createdAt});
  factory _SearchListItemDto.fromJson(Map<String, dynamic> json) => _$SearchListItemDtoFromJson(json);

@override final  int id;
@override final  String query;
@override final  String status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of SearchListItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchListItemDtoCopyWith<_SearchListItemDto> get copyWith => __$SearchListItemDtoCopyWithImpl<_SearchListItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchListItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchListItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.query, query) || other.query == query)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,query,status,createdAt);

@override
String toString() {
  return 'SearchListItemDto(id: $id, query: $query, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SearchListItemDtoCopyWith<$Res> implements $SearchListItemDtoCopyWith<$Res> {
  factory _$SearchListItemDtoCopyWith(_SearchListItemDto value, $Res Function(_SearchListItemDto) _then) = __$SearchListItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String query, String status,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$SearchListItemDtoCopyWithImpl<$Res>
    implements _$SearchListItemDtoCopyWith<$Res> {
  __$SearchListItemDtoCopyWithImpl(this._self, this._then);

  final _SearchListItemDto _self;
  final $Res Function(_SearchListItemDto) _then;

/// Create a copy of SearchListItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? query = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_SearchListItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SearchSourceDto {

@JsonKey(name: 'document_id') int get documentId; String get title; String get snippet; double get relevance;
/// Create a copy of SearchSourceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSourceDtoCopyWith<SearchSourceDto> get copyWith => _$SearchSourceDtoCopyWithImpl<SearchSourceDto>(this as SearchSourceDto, _$identity);

  /// Serializes this SearchSourceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSourceDto&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.relevance, relevance) || other.relevance == relevance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentId,title,snippet,relevance);

@override
String toString() {
  return 'SearchSourceDto(documentId: $documentId, title: $title, snippet: $snippet, relevance: $relevance)';
}


}

/// @nodoc
abstract mixin class $SearchSourceDtoCopyWith<$Res>  {
  factory $SearchSourceDtoCopyWith(SearchSourceDto value, $Res Function(SearchSourceDto) _then) = _$SearchSourceDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'document_id') int documentId, String title, String snippet, double relevance
});




}
/// @nodoc
class _$SearchSourceDtoCopyWithImpl<$Res>
    implements $SearchSourceDtoCopyWith<$Res> {
  _$SearchSourceDtoCopyWithImpl(this._self, this._then);

  final SearchSourceDto _self;
  final $Res Function(SearchSourceDto) _then;

/// Create a copy of SearchSourceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = null,Object? title = null,Object? snippet = null,Object? relevance = null,}) {
  return _then(_self.copyWith(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,relevance: null == relevance ? _self.relevance : relevance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchSourceDto].
extension SearchSourceDtoPatterns on SearchSourceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchSourceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchSourceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchSourceDto value)  $default,){
final _that = this;
switch (_that) {
case _SearchSourceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchSourceDto value)?  $default,){
final _that = this;
switch (_that) {
case _SearchSourceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'document_id')  int documentId,  String title,  String snippet,  double relevance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchSourceDto() when $default != null:
return $default(_that.documentId,_that.title,_that.snippet,_that.relevance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'document_id')  int documentId,  String title,  String snippet,  double relevance)  $default,) {final _that = this;
switch (_that) {
case _SearchSourceDto():
return $default(_that.documentId,_that.title,_that.snippet,_that.relevance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'document_id')  int documentId,  String title,  String snippet,  double relevance)?  $default,) {final _that = this;
switch (_that) {
case _SearchSourceDto() when $default != null:
return $default(_that.documentId,_that.title,_that.snippet,_that.relevance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchSourceDto implements SearchSourceDto {
  const _SearchSourceDto({@JsonKey(name: 'document_id') required this.documentId, required this.title, required this.snippet, required this.relevance});
  factory _SearchSourceDto.fromJson(Map<String, dynamic> json) => _$SearchSourceDtoFromJson(json);

@override@JsonKey(name: 'document_id') final  int documentId;
@override final  String title;
@override final  String snippet;
@override final  double relevance;

/// Create a copy of SearchSourceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchSourceDtoCopyWith<_SearchSourceDto> get copyWith => __$SearchSourceDtoCopyWithImpl<_SearchSourceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchSourceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchSourceDto&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.relevance, relevance) || other.relevance == relevance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentId,title,snippet,relevance);

@override
String toString() {
  return 'SearchSourceDto(documentId: $documentId, title: $title, snippet: $snippet, relevance: $relevance)';
}


}

/// @nodoc
abstract mixin class _$SearchSourceDtoCopyWith<$Res> implements $SearchSourceDtoCopyWith<$Res> {
  factory _$SearchSourceDtoCopyWith(_SearchSourceDto value, $Res Function(_SearchSourceDto) _then) = __$SearchSourceDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'document_id') int documentId, String title, String snippet, double relevance
});




}
/// @nodoc
class __$SearchSourceDtoCopyWithImpl<$Res>
    implements _$SearchSourceDtoCopyWith<$Res> {
  __$SearchSourceDtoCopyWithImpl(this._self, this._then);

  final _SearchSourceDto _self;
  final $Res Function(_SearchSourceDto) _then;

/// Create a copy of SearchSourceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,Object? title = null,Object? snippet = null,Object? relevance = null,}) {
  return _then(_SearchSourceDto(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,relevance: null == relevance ? _self.relevance : relevance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SearchDetailDto {

 int get id; String get query; String get scope; String get depth; String get status; String get answer; String get error; List<SearchSourceDto> get sources;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of SearchDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchDetailDtoCopyWith<SearchDetailDto> get copyWith => _$SearchDetailDtoCopyWithImpl<SearchDetailDto>(this as SearchDetailDto, _$identity);

  /// Serializes this SearchDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.query, query) || other.query == query)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.status, status) || other.status == status)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,query,scope,depth,status,answer,error,const DeepCollectionEquality().hash(sources),createdAt);

@override
String toString() {
  return 'SearchDetailDto(id: $id, query: $query, scope: $scope, depth: $depth, status: $status, answer: $answer, error: $error, sources: $sources, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SearchDetailDtoCopyWith<$Res>  {
  factory $SearchDetailDtoCopyWith(SearchDetailDto value, $Res Function(SearchDetailDto) _then) = _$SearchDetailDtoCopyWithImpl;
@useResult
$Res call({
 int id, String query, String scope, String depth, String status, String answer, String error, List<SearchSourceDto> sources,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$SearchDetailDtoCopyWithImpl<$Res>
    implements $SearchDetailDtoCopyWith<$Res> {
  _$SearchDetailDtoCopyWithImpl(this._self, this._then);

  final SearchDetailDto _self;
  final $Res Function(SearchDetailDto) _then;

/// Create a copy of SearchDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? query = null,Object? scope = null,Object? depth = null,Object? status = null,Object? answer = null,Object? error = null,Object? sources = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<SearchSourceDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchDetailDto].
extension SearchDetailDtoPatterns on SearchDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _SearchDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _SearchDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String query,  String scope,  String depth,  String status,  String answer,  String error,  List<SearchSourceDto> sources, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchDetailDto() when $default != null:
return $default(_that.id,_that.query,_that.scope,_that.depth,_that.status,_that.answer,_that.error,_that.sources,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String query,  String scope,  String depth,  String status,  String answer,  String error,  List<SearchSourceDto> sources, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SearchDetailDto():
return $default(_that.id,_that.query,_that.scope,_that.depth,_that.status,_that.answer,_that.error,_that.sources,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String query,  String scope,  String depth,  String status,  String answer,  String error,  List<SearchSourceDto> sources, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SearchDetailDto() when $default != null:
return $default(_that.id,_that.query,_that.scope,_that.depth,_that.status,_that.answer,_that.error,_that.sources,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchDetailDto implements SearchDetailDto {
  const _SearchDetailDto({required this.id, required this.query, required this.scope, required this.depth, required this.status, this.answer = '', this.error = '', final  List<SearchSourceDto> sources = const <SearchSourceDto>[], @JsonKey(name: 'created_at') required this.createdAt}): _sources = sources;
  factory _SearchDetailDto.fromJson(Map<String, dynamic> json) => _$SearchDetailDtoFromJson(json);

@override final  int id;
@override final  String query;
@override final  String scope;
@override final  String depth;
@override final  String status;
@override@JsonKey() final  String answer;
@override@JsonKey() final  String error;
 final  List<SearchSourceDto> _sources;
@override@JsonKey() List<SearchSourceDto> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of SearchDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchDetailDtoCopyWith<_SearchDetailDto> get copyWith => __$SearchDetailDtoCopyWithImpl<_SearchDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.query, query) || other.query == query)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.status, status) || other.status == status)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,query,scope,depth,status,answer,error,const DeepCollectionEquality().hash(_sources),createdAt);

@override
String toString() {
  return 'SearchDetailDto(id: $id, query: $query, scope: $scope, depth: $depth, status: $status, answer: $answer, error: $error, sources: $sources, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SearchDetailDtoCopyWith<$Res> implements $SearchDetailDtoCopyWith<$Res> {
  factory _$SearchDetailDtoCopyWith(_SearchDetailDto value, $Res Function(_SearchDetailDto) _then) = __$SearchDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String query, String scope, String depth, String status, String answer, String error, List<SearchSourceDto> sources,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$SearchDetailDtoCopyWithImpl<$Res>
    implements _$SearchDetailDtoCopyWith<$Res> {
  __$SearchDetailDtoCopyWithImpl(this._self, this._then);

  final _SearchDetailDto _self;
  final $Res Function(_SearchDetailDto) _then;

/// Create a copy of SearchDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? query = null,Object? scope = null,Object? depth = null,Object? status = null,Object? answer = null,Object? error = null,Object? sources = null,Object? createdAt = null,}) {
  return _then(_SearchDetailDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<SearchSourceDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
