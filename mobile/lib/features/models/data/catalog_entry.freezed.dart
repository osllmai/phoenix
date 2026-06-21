// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogEntry {

 String get org; String get modelName; String get name; String get filename; String get url; double get filesizeGb; String get quant; int get ramRequired; String get parameters; String get requires; String get md5sum; String get description; String get promptTemplate; String get systemPrompt; String get type; bool get recommended; String get order; int get downloadCount; int get likeCount; String get capability; String get hfLink; String get license; bool get gpuRequired; String get uploadDate;
/// Create a copy of CatalogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogEntryCopyWith<CatalogEntry> get copyWith => _$CatalogEntryCopyWithImpl<CatalogEntry>(this as CatalogEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogEntry&&(identical(other.org, org) || other.org == org)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.name, name) || other.name == name)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.url, url) || other.url == url)&&(identical(other.filesizeGb, filesizeGb) || other.filesizeGb == filesizeGb)&&(identical(other.quant, quant) || other.quant == quant)&&(identical(other.ramRequired, ramRequired) || other.ramRequired == ramRequired)&&(identical(other.parameters, parameters) || other.parameters == parameters)&&(identical(other.requires, requires) || other.requires == requires)&&(identical(other.md5sum, md5sum) || other.md5sum == md5sum)&&(identical(other.description, description) || other.description == description)&&(identical(other.promptTemplate, promptTemplate) || other.promptTemplate == promptTemplate)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.type, type) || other.type == type)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.order, order) || other.order == order)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.capability, capability) || other.capability == capability)&&(identical(other.hfLink, hfLink) || other.hfLink == hfLink)&&(identical(other.license, license) || other.license == license)&&(identical(other.gpuRequired, gpuRequired) || other.gpuRequired == gpuRequired)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate));
}


@override
int get hashCode => Object.hashAll([runtimeType,org,modelName,name,filename,url,filesizeGb,quant,ramRequired,parameters,requires,md5sum,description,promptTemplate,systemPrompt,type,recommended,order,downloadCount,likeCount,capability,hfLink,license,gpuRequired,uploadDate]);

@override
String toString() {
  return 'CatalogEntry(org: $org, modelName: $modelName, name: $name, filename: $filename, url: $url, filesizeGb: $filesizeGb, quant: $quant, ramRequired: $ramRequired, parameters: $parameters, requires: $requires, md5sum: $md5sum, description: $description, promptTemplate: $promptTemplate, systemPrompt: $systemPrompt, type: $type, recommended: $recommended, order: $order, downloadCount: $downloadCount, likeCount: $likeCount, capability: $capability, hfLink: $hfLink, license: $license, gpuRequired: $gpuRequired, uploadDate: $uploadDate)';
}


}

/// @nodoc
abstract mixin class $CatalogEntryCopyWith<$Res>  {
  factory $CatalogEntryCopyWith(CatalogEntry value, $Res Function(CatalogEntry) _then) = _$CatalogEntryCopyWithImpl;
@useResult
$Res call({
 String org, String modelName, String name, String filename, String url, double filesizeGb, String quant, int ramRequired, String parameters, String requires, String md5sum, String description, String promptTemplate, String systemPrompt, String type, bool recommended, String order, int downloadCount, int likeCount, String capability, String hfLink, String license, bool gpuRequired, String uploadDate
});




}
/// @nodoc
class _$CatalogEntryCopyWithImpl<$Res>
    implements $CatalogEntryCopyWith<$Res> {
  _$CatalogEntryCopyWithImpl(this._self, this._then);

  final CatalogEntry _self;
  final $Res Function(CatalogEntry) _then;

/// Create a copy of CatalogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? org = null,Object? modelName = null,Object? name = null,Object? filename = null,Object? url = null,Object? filesizeGb = null,Object? quant = null,Object? ramRequired = null,Object? parameters = null,Object? requires = null,Object? md5sum = null,Object? description = null,Object? promptTemplate = null,Object? systemPrompt = null,Object? type = null,Object? recommended = null,Object? order = null,Object? downloadCount = null,Object? likeCount = null,Object? capability = null,Object? hfLink = null,Object? license = null,Object? gpuRequired = null,Object? uploadDate = null,}) {
  return _then(_self.copyWith(
org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,filesizeGb: null == filesizeGb ? _self.filesizeGb : filesizeGb // ignore: cast_nullable_to_non_nullable
as double,quant: null == quant ? _self.quant : quant // ignore: cast_nullable_to_non_nullable
as String,ramRequired: null == ramRequired ? _self.ramRequired : ramRequired // ignore: cast_nullable_to_non_nullable
as int,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as String,requires: null == requires ? _self.requires : requires // ignore: cast_nullable_to_non_nullable
as String,md5sum: null == md5sum ? _self.md5sum : md5sum // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,promptTemplate: null == promptTemplate ? _self.promptTemplate : promptTemplate // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,capability: null == capability ? _self.capability : capability // ignore: cast_nullable_to_non_nullable
as String,hfLink: null == hfLink ? _self.hfLink : hfLink // ignore: cast_nullable_to_non_nullable
as String,license: null == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String,gpuRequired: null == gpuRequired ? _self.gpuRequired : gpuRequired // ignore: cast_nullable_to_non_nullable
as bool,uploadDate: null == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogEntry].
extension CatalogEntryPatterns on CatalogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogEntry value)  $default,){
final _that = this;
switch (_that) {
case _CatalogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String org,  String modelName,  String name,  String filename,  String url,  double filesizeGb,  String quant,  int ramRequired,  String parameters,  String requires,  String md5sum,  String description,  String promptTemplate,  String systemPrompt,  String type,  bool recommended,  String order,  int downloadCount,  int likeCount,  String capability,  String hfLink,  String license,  bool gpuRequired,  String uploadDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogEntry() when $default != null:
return $default(_that.org,_that.modelName,_that.name,_that.filename,_that.url,_that.filesizeGb,_that.quant,_that.ramRequired,_that.parameters,_that.requires,_that.md5sum,_that.description,_that.promptTemplate,_that.systemPrompt,_that.type,_that.recommended,_that.order,_that.downloadCount,_that.likeCount,_that.capability,_that.hfLink,_that.license,_that.gpuRequired,_that.uploadDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String org,  String modelName,  String name,  String filename,  String url,  double filesizeGb,  String quant,  int ramRequired,  String parameters,  String requires,  String md5sum,  String description,  String promptTemplate,  String systemPrompt,  String type,  bool recommended,  String order,  int downloadCount,  int likeCount,  String capability,  String hfLink,  String license,  bool gpuRequired,  String uploadDate)  $default,) {final _that = this;
switch (_that) {
case _CatalogEntry():
return $default(_that.org,_that.modelName,_that.name,_that.filename,_that.url,_that.filesizeGb,_that.quant,_that.ramRequired,_that.parameters,_that.requires,_that.md5sum,_that.description,_that.promptTemplate,_that.systemPrompt,_that.type,_that.recommended,_that.order,_that.downloadCount,_that.likeCount,_that.capability,_that.hfLink,_that.license,_that.gpuRequired,_that.uploadDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String org,  String modelName,  String name,  String filename,  String url,  double filesizeGb,  String quant,  int ramRequired,  String parameters,  String requires,  String md5sum,  String description,  String promptTemplate,  String systemPrompt,  String type,  bool recommended,  String order,  int downloadCount,  int likeCount,  String capability,  String hfLink,  String license,  bool gpuRequired,  String uploadDate)?  $default,) {final _that = this;
switch (_that) {
case _CatalogEntry() when $default != null:
return $default(_that.org,_that.modelName,_that.name,_that.filename,_that.url,_that.filesizeGb,_that.quant,_that.ramRequired,_that.parameters,_that.requires,_that.md5sum,_that.description,_that.promptTemplate,_that.systemPrompt,_that.type,_that.recommended,_that.order,_that.downloadCount,_that.likeCount,_that.capability,_that.hfLink,_that.license,_that.gpuRequired,_that.uploadDate);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogEntry extends CatalogEntry {
  const _CatalogEntry({required this.org, required this.modelName, required this.name, required this.filename, required this.url, this.filesizeGb = 0.0, this.quant = '', this.ramRequired = 0, this.parameters = '', this.requires = '', this.md5sum = '', this.description = '', this.promptTemplate = '', this.systemPrompt = '', this.type = '', this.recommended = false, this.order = '', this.downloadCount = 0, this.likeCount = 0, this.capability = '', this.hfLink = '', this.license = '', this.gpuRequired = false, this.uploadDate = ''}): super._();
  

@override final  String org;
@override final  String modelName;
@override final  String name;
@override final  String filename;
@override final  String url;
@override@JsonKey() final  double filesizeGb;
@override@JsonKey() final  String quant;
@override@JsonKey() final  int ramRequired;
@override@JsonKey() final  String parameters;
@override@JsonKey() final  String requires;
@override@JsonKey() final  String md5sum;
@override@JsonKey() final  String description;
@override@JsonKey() final  String promptTemplate;
@override@JsonKey() final  String systemPrompt;
@override@JsonKey() final  String type;
@override@JsonKey() final  bool recommended;
@override@JsonKey() final  String order;
@override@JsonKey() final  int downloadCount;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  String capability;
@override@JsonKey() final  String hfLink;
@override@JsonKey() final  String license;
@override@JsonKey() final  bool gpuRequired;
@override@JsonKey() final  String uploadDate;

/// Create a copy of CatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogEntryCopyWith<_CatalogEntry> get copyWith => __$CatalogEntryCopyWithImpl<_CatalogEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogEntry&&(identical(other.org, org) || other.org == org)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.name, name) || other.name == name)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.url, url) || other.url == url)&&(identical(other.filesizeGb, filesizeGb) || other.filesizeGb == filesizeGb)&&(identical(other.quant, quant) || other.quant == quant)&&(identical(other.ramRequired, ramRequired) || other.ramRequired == ramRequired)&&(identical(other.parameters, parameters) || other.parameters == parameters)&&(identical(other.requires, requires) || other.requires == requires)&&(identical(other.md5sum, md5sum) || other.md5sum == md5sum)&&(identical(other.description, description) || other.description == description)&&(identical(other.promptTemplate, promptTemplate) || other.promptTemplate == promptTemplate)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.type, type) || other.type == type)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.order, order) || other.order == order)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.capability, capability) || other.capability == capability)&&(identical(other.hfLink, hfLink) || other.hfLink == hfLink)&&(identical(other.license, license) || other.license == license)&&(identical(other.gpuRequired, gpuRequired) || other.gpuRequired == gpuRequired)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate));
}


@override
int get hashCode => Object.hashAll([runtimeType,org,modelName,name,filename,url,filesizeGb,quant,ramRequired,parameters,requires,md5sum,description,promptTemplate,systemPrompt,type,recommended,order,downloadCount,likeCount,capability,hfLink,license,gpuRequired,uploadDate]);

@override
String toString() {
  return 'CatalogEntry(org: $org, modelName: $modelName, name: $name, filename: $filename, url: $url, filesizeGb: $filesizeGb, quant: $quant, ramRequired: $ramRequired, parameters: $parameters, requires: $requires, md5sum: $md5sum, description: $description, promptTemplate: $promptTemplate, systemPrompt: $systemPrompt, type: $type, recommended: $recommended, order: $order, downloadCount: $downloadCount, likeCount: $likeCount, capability: $capability, hfLink: $hfLink, license: $license, gpuRequired: $gpuRequired, uploadDate: $uploadDate)';
}


}

/// @nodoc
abstract mixin class _$CatalogEntryCopyWith<$Res> implements $CatalogEntryCopyWith<$Res> {
  factory _$CatalogEntryCopyWith(_CatalogEntry value, $Res Function(_CatalogEntry) _then) = __$CatalogEntryCopyWithImpl;
@override @useResult
$Res call({
 String org, String modelName, String name, String filename, String url, double filesizeGb, String quant, int ramRequired, String parameters, String requires, String md5sum, String description, String promptTemplate, String systemPrompt, String type, bool recommended, String order, int downloadCount, int likeCount, String capability, String hfLink, String license, bool gpuRequired, String uploadDate
});




}
/// @nodoc
class __$CatalogEntryCopyWithImpl<$Res>
    implements _$CatalogEntryCopyWith<$Res> {
  __$CatalogEntryCopyWithImpl(this._self, this._then);

  final _CatalogEntry _self;
  final $Res Function(_CatalogEntry) _then;

/// Create a copy of CatalogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? org = null,Object? modelName = null,Object? name = null,Object? filename = null,Object? url = null,Object? filesizeGb = null,Object? quant = null,Object? ramRequired = null,Object? parameters = null,Object? requires = null,Object? md5sum = null,Object? description = null,Object? promptTemplate = null,Object? systemPrompt = null,Object? type = null,Object? recommended = null,Object? order = null,Object? downloadCount = null,Object? likeCount = null,Object? capability = null,Object? hfLink = null,Object? license = null,Object? gpuRequired = null,Object? uploadDate = null,}) {
  return _then(_CatalogEntry(
org: null == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,filesizeGb: null == filesizeGb ? _self.filesizeGb : filesizeGb // ignore: cast_nullable_to_non_nullable
as double,quant: null == quant ? _self.quant : quant // ignore: cast_nullable_to_non_nullable
as String,ramRequired: null == ramRequired ? _self.ramRequired : ramRequired // ignore: cast_nullable_to_non_nullable
as int,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as String,requires: null == requires ? _self.requires : requires // ignore: cast_nullable_to_non_nullable
as String,md5sum: null == md5sum ? _self.md5sum : md5sum // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,promptTemplate: null == promptTemplate ? _self.promptTemplate : promptTemplate // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,capability: null == capability ? _self.capability : capability // ignore: cast_nullable_to_non_nullable
as String,hfLink: null == hfLink ? _self.hfLink : hfLink // ignore: cast_nullable_to_non_nullable
as String,license: null == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String,gpuRequired: null == gpuRequired ? _self.gpuRequired : gpuRequired // ignore: cast_nullable_to_non_nullable
as bool,uploadDate: null == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
