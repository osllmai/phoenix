// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhoenixDocument {

 String get id; String get title; DocKind get kind; DocStatus get status; String get meta; String get badge; String get pipeline; String? get grade; int get progress; String get markdown;
/// Create a copy of PhoenixDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoenixDocumentCopyWith<PhoenixDocument> get copyWith => _$PhoenixDocumentCopyWithImpl<PhoenixDocument>(this as PhoenixDocument, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoenixDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.pipeline, pipeline) || other.pipeline == pipeline)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.markdown, markdown) || other.markdown == markdown));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,kind,status,meta,badge,pipeline,grade,progress,markdown);

@override
String toString() {
  return 'PhoenixDocument(id: $id, title: $title, kind: $kind, status: $status, meta: $meta, badge: $badge, pipeline: $pipeline, grade: $grade, progress: $progress, markdown: $markdown)';
}


}

/// @nodoc
abstract mixin class $PhoenixDocumentCopyWith<$Res>  {
  factory $PhoenixDocumentCopyWith(PhoenixDocument value, $Res Function(PhoenixDocument) _then) = _$PhoenixDocumentCopyWithImpl;
@useResult
$Res call({
 String id, String title, DocKind kind, DocStatus status, String meta, String badge, String pipeline, String? grade, int progress, String markdown
});




}
/// @nodoc
class _$PhoenixDocumentCopyWithImpl<$Res>
    implements $PhoenixDocumentCopyWith<$Res> {
  _$PhoenixDocumentCopyWithImpl(this._self, this._then);

  final PhoenixDocument _self;
  final $Res Function(PhoenixDocument) _then;

/// Create a copy of PhoenixDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? status = null,Object? meta = null,Object? badge = null,Object? pipeline = null,Object? grade = freezed,Object? progress = null,Object? markdown = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocStatus,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String,badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String,pipeline: null == pipeline ? _self.pipeline : pipeline // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,markdown: null == markdown ? _self.markdown : markdown // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoenixDocument].
extension PhoenixDocumentPatterns on PhoenixDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoenixDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoenixDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoenixDocument value)  $default,){
final _that = this;
switch (_that) {
case _PhoenixDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoenixDocument value)?  $default,){
final _that = this;
switch (_that) {
case _PhoenixDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DocKind kind,  DocStatus status,  String meta,  String badge,  String pipeline,  String? grade,  int progress,  String markdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoenixDocument() when $default != null:
return $default(_that.id,_that.title,_that.kind,_that.status,_that.meta,_that.badge,_that.pipeline,_that.grade,_that.progress,_that.markdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DocKind kind,  DocStatus status,  String meta,  String badge,  String pipeline,  String? grade,  int progress,  String markdown)  $default,) {final _that = this;
switch (_that) {
case _PhoenixDocument():
return $default(_that.id,_that.title,_that.kind,_that.status,_that.meta,_that.badge,_that.pipeline,_that.grade,_that.progress,_that.markdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DocKind kind,  DocStatus status,  String meta,  String badge,  String pipeline,  String? grade,  int progress,  String markdown)?  $default,) {final _that = this;
switch (_that) {
case _PhoenixDocument() when $default != null:
return $default(_that.id,_that.title,_that.kind,_that.status,_that.meta,_that.badge,_that.pipeline,_that.grade,_that.progress,_that.markdown);case _:
  return null;

}
}

}

/// @nodoc


class _PhoenixDocument implements PhoenixDocument {
  const _PhoenixDocument({required this.id, required this.title, required this.kind, required this.status, required this.meta, this.badge = '', this.pipeline = '', this.grade = null, this.progress = 0, this.markdown = ''});
  

@override final  String id;
@override final  String title;
@override final  DocKind kind;
@override final  DocStatus status;
@override final  String meta;
@override@JsonKey() final  String badge;
@override@JsonKey() final  String pipeline;
@override@JsonKey() final  String? grade;
@override@JsonKey() final  int progress;
@override@JsonKey() final  String markdown;

/// Create a copy of PhoenixDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoenixDocumentCopyWith<_PhoenixDocument> get copyWith => __$PhoenixDocumentCopyWithImpl<_PhoenixDocument>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoenixDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.pipeline, pipeline) || other.pipeline == pipeline)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.markdown, markdown) || other.markdown == markdown));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,kind,status,meta,badge,pipeline,grade,progress,markdown);

@override
String toString() {
  return 'PhoenixDocument(id: $id, title: $title, kind: $kind, status: $status, meta: $meta, badge: $badge, pipeline: $pipeline, grade: $grade, progress: $progress, markdown: $markdown)';
}


}

/// @nodoc
abstract mixin class _$PhoenixDocumentCopyWith<$Res> implements $PhoenixDocumentCopyWith<$Res> {
  factory _$PhoenixDocumentCopyWith(_PhoenixDocument value, $Res Function(_PhoenixDocument) _then) = __$PhoenixDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DocKind kind, DocStatus status, String meta, String badge, String pipeline, String? grade, int progress, String markdown
});




}
/// @nodoc
class __$PhoenixDocumentCopyWithImpl<$Res>
    implements _$PhoenixDocumentCopyWith<$Res> {
  __$PhoenixDocumentCopyWithImpl(this._self, this._then);

  final _PhoenixDocument _self;
  final $Res Function(_PhoenixDocument) _then;

/// Create a copy of PhoenixDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? status = null,Object? meta = null,Object? badge = null,Object? pipeline = null,Object? grade = freezed,Object? progress = null,Object? markdown = null,}) {
  return _then(_PhoenixDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocStatus,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String,badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String,pipeline: null == pipeline ? _self.pipeline : pipeline // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,markdown: null == markdown ? _self.markdown : markdown // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
