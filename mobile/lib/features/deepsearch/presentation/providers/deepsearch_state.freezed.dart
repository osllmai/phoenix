// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deepsearch_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResearchStep {

 String get label; String get detail; ResearchStepStatus get status;
/// Create a copy of ResearchStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResearchStepCopyWith<ResearchStep> get copyWith => _$ResearchStepCopyWithImpl<ResearchStep>(this as ResearchStep, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResearchStep&&(identical(other.label, label) || other.label == label)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,label,detail,status);

@override
String toString() {
  return 'ResearchStep(label: $label, detail: $detail, status: $status)';
}


}

/// @nodoc
abstract mixin class $ResearchStepCopyWith<$Res>  {
  factory $ResearchStepCopyWith(ResearchStep value, $Res Function(ResearchStep) _then) = _$ResearchStepCopyWithImpl;
@useResult
$Res call({
 String label, String detail, ResearchStepStatus status
});




}
/// @nodoc
class _$ResearchStepCopyWithImpl<$Res>
    implements $ResearchStepCopyWith<$Res> {
  _$ResearchStepCopyWithImpl(this._self, this._then);

  final ResearchStep _self;
  final $Res Function(ResearchStep) _then;

/// Create a copy of ResearchStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? detail = null,Object? status = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ResearchStepStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ResearchStep].
extension ResearchStepPatterns on ResearchStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResearchStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResearchStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResearchStep value)  $default,){
final _that = this;
switch (_that) {
case _ResearchStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResearchStep value)?  $default,){
final _that = this;
switch (_that) {
case _ResearchStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String detail,  ResearchStepStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResearchStep() when $default != null:
return $default(_that.label,_that.detail,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String detail,  ResearchStepStatus status)  $default,) {final _that = this;
switch (_that) {
case _ResearchStep():
return $default(_that.label,_that.detail,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String detail,  ResearchStepStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ResearchStep() when $default != null:
return $default(_that.label,_that.detail,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ResearchStep implements ResearchStep {
  const _ResearchStep({required this.label, required this.detail, required this.status});
  

@override final  String label;
@override final  String detail;
@override final  ResearchStepStatus status;

/// Create a copy of ResearchStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResearchStepCopyWith<_ResearchStep> get copyWith => __$ResearchStepCopyWithImpl<_ResearchStep>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResearchStep&&(identical(other.label, label) || other.label == label)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,label,detail,status);

@override
String toString() {
  return 'ResearchStep(label: $label, detail: $detail, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ResearchStepCopyWith<$Res> implements $ResearchStepCopyWith<$Res> {
  factory _$ResearchStepCopyWith(_ResearchStep value, $Res Function(_ResearchStep) _then) = __$ResearchStepCopyWithImpl;
@override @useResult
$Res call({
 String label, String detail, ResearchStepStatus status
});




}
/// @nodoc
class __$ResearchStepCopyWithImpl<$Res>
    implements _$ResearchStepCopyWith<$Res> {
  __$ResearchStepCopyWithImpl(this._self, this._then);

  final _ResearchStep _self;
  final $Res Function(_ResearchStep) _then;

/// Create a copy of ResearchStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? detail = null,Object? status = null,}) {
  return _then(_ResearchStep(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ResearchStepStatus,
  ));
}


}

/// @nodoc
mixin _$SearchSource {

 int get rank; String get title; String get domain; String get snippet; int get relevance; bool get isLocal;
/// Create a copy of SearchSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSourceCopyWith<SearchSource> get copyWith => _$SearchSourceCopyWithImpl<SearchSource>(this as SearchSource, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSource&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.title, title) || other.title == title)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.relevance, relevance) || other.relevance == relevance)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal));
}


@override
int get hashCode => Object.hash(runtimeType,rank,title,domain,snippet,relevance,isLocal);

@override
String toString() {
  return 'SearchSource(rank: $rank, title: $title, domain: $domain, snippet: $snippet, relevance: $relevance, isLocal: $isLocal)';
}


}

/// @nodoc
abstract mixin class $SearchSourceCopyWith<$Res>  {
  factory $SearchSourceCopyWith(SearchSource value, $Res Function(SearchSource) _then) = _$SearchSourceCopyWithImpl;
@useResult
$Res call({
 int rank, String title, String domain, String snippet, int relevance, bool isLocal
});




}
/// @nodoc
class _$SearchSourceCopyWithImpl<$Res>
    implements $SearchSourceCopyWith<$Res> {
  _$SearchSourceCopyWithImpl(this._self, this._then);

  final SearchSource _self;
  final $Res Function(SearchSource) _then;

/// Create a copy of SearchSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? title = null,Object? domain = null,Object? snippet = null,Object? relevance = null,Object? isLocal = null,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,relevance: null == relevance ? _self.relevance : relevance // ignore: cast_nullable_to_non_nullable
as int,isLocal: null == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchSource].
extension SearchSourcePatterns on SearchSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchSource value)  $default,){
final _that = this;
switch (_that) {
case _SearchSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchSource value)?  $default,){
final _that = this;
switch (_that) {
case _SearchSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  String title,  String domain,  String snippet,  int relevance,  bool isLocal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchSource() when $default != null:
return $default(_that.rank,_that.title,_that.domain,_that.snippet,_that.relevance,_that.isLocal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  String title,  String domain,  String snippet,  int relevance,  bool isLocal)  $default,) {final _that = this;
switch (_that) {
case _SearchSource():
return $default(_that.rank,_that.title,_that.domain,_that.snippet,_that.relevance,_that.isLocal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  String title,  String domain,  String snippet,  int relevance,  bool isLocal)?  $default,) {final _that = this;
switch (_that) {
case _SearchSource() when $default != null:
return $default(_that.rank,_that.title,_that.domain,_that.snippet,_that.relevance,_that.isLocal);case _:
  return null;

}
}

}

/// @nodoc


class _SearchSource implements SearchSource {
  const _SearchSource({required this.rank, required this.title, required this.domain, required this.snippet, required this.relevance, this.isLocal = false});
  

@override final  int rank;
@override final  String title;
@override final  String domain;
@override final  String snippet;
@override final  int relevance;
@override@JsonKey() final  bool isLocal;

/// Create a copy of SearchSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchSourceCopyWith<_SearchSource> get copyWith => __$SearchSourceCopyWithImpl<_SearchSource>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchSource&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.title, title) || other.title == title)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.relevance, relevance) || other.relevance == relevance)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal));
}


@override
int get hashCode => Object.hash(runtimeType,rank,title,domain,snippet,relevance,isLocal);

@override
String toString() {
  return 'SearchSource(rank: $rank, title: $title, domain: $domain, snippet: $snippet, relevance: $relevance, isLocal: $isLocal)';
}


}

/// @nodoc
abstract mixin class _$SearchSourceCopyWith<$Res> implements $SearchSourceCopyWith<$Res> {
  factory _$SearchSourceCopyWith(_SearchSource value, $Res Function(_SearchSource) _then) = __$SearchSourceCopyWithImpl;
@override @useResult
$Res call({
 int rank, String title, String domain, String snippet, int relevance, bool isLocal
});




}
/// @nodoc
class __$SearchSourceCopyWithImpl<$Res>
    implements _$SearchSourceCopyWith<$Res> {
  __$SearchSourceCopyWithImpl(this._self, this._then);

  final _SearchSource _self;
  final $Res Function(_SearchSource) _then;

/// Create a copy of SearchSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? title = null,Object? domain = null,Object? snippet = null,Object? relevance = null,Object? isLocal = null,}) {
  return _then(_SearchSource(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,relevance: null == relevance ? _self.relevance : relevance // ignore: cast_nullable_to_non_nullable
as int,isLocal: null == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$DeepSearchState {

 String get query; List<ResearchStep> get steps; String get answer; List<SearchSource> get sources; bool get webScope; bool get localScope; SearchDepth get depth; bool get isRunning; bool get hasResult;
/// Create a copy of DeepSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeepSearchStateCopyWith<DeepSearchState> get copyWith => _$DeepSearchStateCopyWithImpl<DeepSearchState>(this as DeepSearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeepSearchState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.webScope, webScope) || other.webScope == webScope)&&(identical(other.localScope, localScope) || other.localScope == localScope)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.hasResult, hasResult) || other.hasResult == hasResult));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(steps),answer,const DeepCollectionEquality().hash(sources),webScope,localScope,depth,isRunning,hasResult);

@override
String toString() {
  return 'DeepSearchState(query: $query, steps: $steps, answer: $answer, sources: $sources, webScope: $webScope, localScope: $localScope, depth: $depth, isRunning: $isRunning, hasResult: $hasResult)';
}


}

/// @nodoc
abstract mixin class $DeepSearchStateCopyWith<$Res>  {
  factory $DeepSearchStateCopyWith(DeepSearchState value, $Res Function(DeepSearchState) _then) = _$DeepSearchStateCopyWithImpl;
@useResult
$Res call({
 String query, List<ResearchStep> steps, String answer, List<SearchSource> sources, bool webScope, bool localScope, SearchDepth depth, bool isRunning, bool hasResult
});




}
/// @nodoc
class _$DeepSearchStateCopyWithImpl<$Res>
    implements $DeepSearchStateCopyWith<$Res> {
  _$DeepSearchStateCopyWithImpl(this._self, this._then);

  final DeepSearchState _self;
  final $Res Function(DeepSearchState) _then;

/// Create a copy of DeepSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? steps = null,Object? answer = null,Object? sources = null,Object? webScope = null,Object? localScope = null,Object? depth = null,Object? isRunning = null,Object? hasResult = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<ResearchStep>,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<SearchSource>,webScope: null == webScope ? _self.webScope : webScope // ignore: cast_nullable_to_non_nullable
as bool,localScope: null == localScope ? _self.localScope : localScope // ignore: cast_nullable_to_non_nullable
as bool,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as SearchDepth,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,hasResult: null == hasResult ? _self.hasResult : hasResult // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeepSearchState].
extension DeepSearchStatePatterns on DeepSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeepSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeepSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeepSearchState value)  $default,){
final _that = this;
switch (_that) {
case _DeepSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeepSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _DeepSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  List<ResearchStep> steps,  String answer,  List<SearchSource> sources,  bool webScope,  bool localScope,  SearchDepth depth,  bool isRunning,  bool hasResult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeepSearchState() when $default != null:
return $default(_that.query,_that.steps,_that.answer,_that.sources,_that.webScope,_that.localScope,_that.depth,_that.isRunning,_that.hasResult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  List<ResearchStep> steps,  String answer,  List<SearchSource> sources,  bool webScope,  bool localScope,  SearchDepth depth,  bool isRunning,  bool hasResult)  $default,) {final _that = this;
switch (_that) {
case _DeepSearchState():
return $default(_that.query,_that.steps,_that.answer,_that.sources,_that.webScope,_that.localScope,_that.depth,_that.isRunning,_that.hasResult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  List<ResearchStep> steps,  String answer,  List<SearchSource> sources,  bool webScope,  bool localScope,  SearchDepth depth,  bool isRunning,  bool hasResult)?  $default,) {final _that = this;
switch (_that) {
case _DeepSearchState() when $default != null:
return $default(_that.query,_that.steps,_that.answer,_that.sources,_that.webScope,_that.localScope,_that.depth,_that.isRunning,_that.hasResult);case _:
  return null;

}
}

}

/// @nodoc


class _DeepSearchState implements DeepSearchState {
  const _DeepSearchState({this.query = '', final  List<ResearchStep> steps = const <ResearchStep>[], this.answer = '', final  List<SearchSource> sources = const <SearchSource>[], this.webScope = true, this.localScope = true, this.depth = SearchDepth.standard, this.isRunning = false, this.hasResult = false}): _steps = steps,_sources = sources;
  

@override@JsonKey() final  String query;
 final  List<ResearchStep> _steps;
@override@JsonKey() List<ResearchStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override@JsonKey() final  String answer;
 final  List<SearchSource> _sources;
@override@JsonKey() List<SearchSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override@JsonKey() final  bool webScope;
@override@JsonKey() final  bool localScope;
@override@JsonKey() final  SearchDepth depth;
@override@JsonKey() final  bool isRunning;
@override@JsonKey() final  bool hasResult;

/// Create a copy of DeepSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeepSearchStateCopyWith<_DeepSearchState> get copyWith => __$DeepSearchStateCopyWithImpl<_DeepSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeepSearchState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.webScope, webScope) || other.webScope == webScope)&&(identical(other.localScope, localScope) || other.localScope == localScope)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.hasResult, hasResult) || other.hasResult == hasResult));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_steps),answer,const DeepCollectionEquality().hash(_sources),webScope,localScope,depth,isRunning,hasResult);

@override
String toString() {
  return 'DeepSearchState(query: $query, steps: $steps, answer: $answer, sources: $sources, webScope: $webScope, localScope: $localScope, depth: $depth, isRunning: $isRunning, hasResult: $hasResult)';
}


}

/// @nodoc
abstract mixin class _$DeepSearchStateCopyWith<$Res> implements $DeepSearchStateCopyWith<$Res> {
  factory _$DeepSearchStateCopyWith(_DeepSearchState value, $Res Function(_DeepSearchState) _then) = __$DeepSearchStateCopyWithImpl;
@override @useResult
$Res call({
 String query, List<ResearchStep> steps, String answer, List<SearchSource> sources, bool webScope, bool localScope, SearchDepth depth, bool isRunning, bool hasResult
});




}
/// @nodoc
class __$DeepSearchStateCopyWithImpl<$Res>
    implements _$DeepSearchStateCopyWith<$Res> {
  __$DeepSearchStateCopyWithImpl(this._self, this._then);

  final _DeepSearchState _self;
  final $Res Function(_DeepSearchState) _then;

/// Create a copy of DeepSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? steps = null,Object? answer = null,Object? sources = null,Object? webScope = null,Object? localScope = null,Object? depth = null,Object? isRunning = null,Object? hasResult = null,}) {
  return _then(_DeepSearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<ResearchStep>,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<SearchSource>,webScope: null == webScope ? _self.webScope : webScope // ignore: cast_nullable_to_non_nullable
as bool,localScope: null == localScope ? _self.localScope : localScope // ignore: cast_nullable_to_non_nullable
as bool,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as SearchDepth,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,hasResult: null == hasResult ? _self.hasResult : hasResult // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
