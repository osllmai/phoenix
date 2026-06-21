// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_console_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerStat {

 String get label; String get value; String get hint;
/// Create a copy of ServerStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerStatCopyWith<ServerStat> get copyWith => _$ServerStatCopyWithImpl<ServerStat>(this as ServerStat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerStat&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.hint, hint) || other.hint == hint));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,hint);

@override
String toString() {
  return 'ServerStat(label: $label, value: $value, hint: $hint)';
}


}

/// @nodoc
abstract mixin class $ServerStatCopyWith<$Res>  {
  factory $ServerStatCopyWith(ServerStat value, $Res Function(ServerStat) _then) = _$ServerStatCopyWithImpl;
@useResult
$Res call({
 String label, String value, String hint
});




}
/// @nodoc
class _$ServerStatCopyWithImpl<$Res>
    implements $ServerStatCopyWith<$Res> {
  _$ServerStatCopyWithImpl(this._self, this._then);

  final ServerStat _self;
  final $Res Function(ServerStat) _then;

/// Create a copy of ServerStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? hint = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerStat].
extension ServerStatPatterns on ServerStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerStat value)  $default,){
final _that = this;
switch (_that) {
case _ServerStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerStat value)?  $default,){
final _that = this;
switch (_that) {
case _ServerStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  String hint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerStat() when $default != null:
return $default(_that.label,_that.value,_that.hint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  String hint)  $default,) {final _that = this;
switch (_that) {
case _ServerStat():
return $default(_that.label,_that.value,_that.hint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  String hint)?  $default,) {final _that = this;
switch (_that) {
case _ServerStat() when $default != null:
return $default(_that.label,_that.value,_that.hint);case _:
  return null;

}
}

}

/// @nodoc


class _ServerStat implements ServerStat {
  const _ServerStat({required this.label, required this.value, this.hint = ''});
  

@override final  String label;
@override final  String value;
@override@JsonKey() final  String hint;

/// Create a copy of ServerStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerStatCopyWith<_ServerStat> get copyWith => __$ServerStatCopyWithImpl<_ServerStat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerStat&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.hint, hint) || other.hint == hint));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,hint);

@override
String toString() {
  return 'ServerStat(label: $label, value: $value, hint: $hint)';
}


}

/// @nodoc
abstract mixin class _$ServerStatCopyWith<$Res> implements $ServerStatCopyWith<$Res> {
  factory _$ServerStatCopyWith(_ServerStat value, $Res Function(_ServerStat) _then) = __$ServerStatCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, String hint
});




}
/// @nodoc
class __$ServerStatCopyWithImpl<$Res>
    implements _$ServerStatCopyWith<$Res> {
  __$ServerStatCopyWithImpl(this._self, this._then);

  final _ServerStat _self;
  final $Res Function(_ServerStat) _then;

/// Create a copy of ServerStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? hint = null,}) {
  return _then(_ServerStat(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ServerEndpoint {

 String get kind; String get url;
/// Create a copy of ServerEndpoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerEndpointCopyWith<ServerEndpoint> get copyWith => _$ServerEndpointCopyWithImpl<ServerEndpoint>(this as ServerEndpoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerEndpoint&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,kind,url);

@override
String toString() {
  return 'ServerEndpoint(kind: $kind, url: $url)';
}


}

/// @nodoc
abstract mixin class $ServerEndpointCopyWith<$Res>  {
  factory $ServerEndpointCopyWith(ServerEndpoint value, $Res Function(ServerEndpoint) _then) = _$ServerEndpointCopyWithImpl;
@useResult
$Res call({
 String kind, String url
});




}
/// @nodoc
class _$ServerEndpointCopyWithImpl<$Res>
    implements $ServerEndpointCopyWith<$Res> {
  _$ServerEndpointCopyWithImpl(this._self, this._then);

  final ServerEndpoint _self;
  final $Res Function(ServerEndpoint) _then;

/// Create a copy of ServerEndpoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? url = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerEndpoint].
extension ServerEndpointPatterns on ServerEndpoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerEndpoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerEndpoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerEndpoint value)  $default,){
final _that = this;
switch (_that) {
case _ServerEndpoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerEndpoint value)?  $default,){
final _that = this;
switch (_that) {
case _ServerEndpoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerEndpoint() when $default != null:
return $default(_that.kind,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String url)  $default,) {final _that = this;
switch (_that) {
case _ServerEndpoint():
return $default(_that.kind,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String url)?  $default,) {final _that = this;
switch (_that) {
case _ServerEndpoint() when $default != null:
return $default(_that.kind,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _ServerEndpoint implements ServerEndpoint {
  const _ServerEndpoint({required this.kind, required this.url});
  

@override final  String kind;
@override final  String url;

/// Create a copy of ServerEndpoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerEndpointCopyWith<_ServerEndpoint> get copyWith => __$ServerEndpointCopyWithImpl<_ServerEndpoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerEndpoint&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,kind,url);

@override
String toString() {
  return 'ServerEndpoint(kind: $kind, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ServerEndpointCopyWith<$Res> implements $ServerEndpointCopyWith<$Res> {
  factory _$ServerEndpointCopyWith(_ServerEndpoint value, $Res Function(_ServerEndpoint) _then) = __$ServerEndpointCopyWithImpl;
@override @useResult
$Res call({
 String kind, String url
});




}
/// @nodoc
class __$ServerEndpointCopyWithImpl<$Res>
    implements _$ServerEndpointCopyWith<$Res> {
  __$ServerEndpointCopyWithImpl(this._self, this._then);

  final _ServerEndpoint _self;
  final $Res Function(_ServerEndpoint) _then;

/// Create a copy of ServerEndpoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? url = null,}) {
  return _then(_ServerEndpoint(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$RequestLogEntry {

 String get time; String get method; String get path; String get model; int get status; String get latency;
/// Create a copy of RequestLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestLogEntryCopyWith<RequestLogEntry> get copyWith => _$RequestLogEntryCopyWithImpl<RequestLogEntry>(this as RequestLogEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestLogEntry&&(identical(other.time, time) || other.time == time)&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&(identical(other.model, model) || other.model == model)&&(identical(other.status, status) || other.status == status)&&(identical(other.latency, latency) || other.latency == latency));
}


@override
int get hashCode => Object.hash(runtimeType,time,method,path,model,status,latency);

@override
String toString() {
  return 'RequestLogEntry(time: $time, method: $method, path: $path, model: $model, status: $status, latency: $latency)';
}


}

/// @nodoc
abstract mixin class $RequestLogEntryCopyWith<$Res>  {
  factory $RequestLogEntryCopyWith(RequestLogEntry value, $Res Function(RequestLogEntry) _then) = _$RequestLogEntryCopyWithImpl;
@useResult
$Res call({
 String time, String method, String path, String model, int status, String latency
});




}
/// @nodoc
class _$RequestLogEntryCopyWithImpl<$Res>
    implements $RequestLogEntryCopyWith<$Res> {
  _$RequestLogEntryCopyWithImpl(this._self, this._then);

  final RequestLogEntry _self;
  final $Res Function(RequestLogEntry) _then;

/// Create a copy of RequestLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? method = null,Object? path = null,Object? model = null,Object? status = null,Object? latency = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestLogEntry].
extension RequestLogEntryPatterns on RequestLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _RequestLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _RequestLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time,  String method,  String path,  String model,  int status,  String latency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestLogEntry() when $default != null:
return $default(_that.time,_that.method,_that.path,_that.model,_that.status,_that.latency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time,  String method,  String path,  String model,  int status,  String latency)  $default,) {final _that = this;
switch (_that) {
case _RequestLogEntry():
return $default(_that.time,_that.method,_that.path,_that.model,_that.status,_that.latency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time,  String method,  String path,  String model,  int status,  String latency)?  $default,) {final _that = this;
switch (_that) {
case _RequestLogEntry() when $default != null:
return $default(_that.time,_that.method,_that.path,_that.model,_that.status,_that.latency);case _:
  return null;

}
}

}

/// @nodoc


class _RequestLogEntry implements RequestLogEntry {
  const _RequestLogEntry({required this.time, required this.method, required this.path, required this.model, required this.status, required this.latency});
  

@override final  String time;
@override final  String method;
@override final  String path;
@override final  String model;
@override final  int status;
@override final  String latency;

/// Create a copy of RequestLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestLogEntryCopyWith<_RequestLogEntry> get copyWith => __$RequestLogEntryCopyWithImpl<_RequestLogEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestLogEntry&&(identical(other.time, time) || other.time == time)&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&(identical(other.model, model) || other.model == model)&&(identical(other.status, status) || other.status == status)&&(identical(other.latency, latency) || other.latency == latency));
}


@override
int get hashCode => Object.hash(runtimeType,time,method,path,model,status,latency);

@override
String toString() {
  return 'RequestLogEntry(time: $time, method: $method, path: $path, model: $model, status: $status, latency: $latency)';
}


}

/// @nodoc
abstract mixin class _$RequestLogEntryCopyWith<$Res> implements $RequestLogEntryCopyWith<$Res> {
  factory _$RequestLogEntryCopyWith(_RequestLogEntry value, $Res Function(_RequestLogEntry) _then) = __$RequestLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String time, String method, String path, String model, int status, String latency
});




}
/// @nodoc
class __$RequestLogEntryCopyWithImpl<$Res>
    implements _$RequestLogEntryCopyWith<$Res> {
  __$RequestLogEntryCopyWithImpl(this._self, this._then);

  final _RequestLogEntry _self;
  final $Res Function(_RequestLogEntry) _then;

/// Create a copy of RequestLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? method = null,Object? path = null,Object? model = null,Object? status = null,Object? latency = null,}) {
  return _then(_RequestLogEntry(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ServerConsoleState {

 List<ServerStat> get stats; List<ServerEndpoint> get endpoints; List<RequestLogEntry> get log; bool get logLive;
/// Create a copy of ServerConsoleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerConsoleStateCopyWith<ServerConsoleState> get copyWith => _$ServerConsoleStateCopyWithImpl<ServerConsoleState>(this as ServerConsoleState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerConsoleState&&const DeepCollectionEquality().equals(other.stats, stats)&&const DeepCollectionEquality().equals(other.endpoints, endpoints)&&const DeepCollectionEquality().equals(other.log, log)&&(identical(other.logLive, logLive) || other.logLive == logLive));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(stats),const DeepCollectionEquality().hash(endpoints),const DeepCollectionEquality().hash(log),logLive);

@override
String toString() {
  return 'ServerConsoleState(stats: $stats, endpoints: $endpoints, log: $log, logLive: $logLive)';
}


}

/// @nodoc
abstract mixin class $ServerConsoleStateCopyWith<$Res>  {
  factory $ServerConsoleStateCopyWith(ServerConsoleState value, $Res Function(ServerConsoleState) _then) = _$ServerConsoleStateCopyWithImpl;
@useResult
$Res call({
 List<ServerStat> stats, List<ServerEndpoint> endpoints, List<RequestLogEntry> log, bool logLive
});




}
/// @nodoc
class _$ServerConsoleStateCopyWithImpl<$Res>
    implements $ServerConsoleStateCopyWith<$Res> {
  _$ServerConsoleStateCopyWithImpl(this._self, this._then);

  final ServerConsoleState _self;
  final $Res Function(ServerConsoleState) _then;

/// Create a copy of ServerConsoleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stats = null,Object? endpoints = null,Object? log = null,Object? logLive = null,}) {
  return _then(_self.copyWith(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as List<ServerStat>,endpoints: null == endpoints ? _self.endpoints : endpoints // ignore: cast_nullable_to_non_nullable
as List<ServerEndpoint>,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as List<RequestLogEntry>,logLive: null == logLive ? _self.logLive : logLive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerConsoleState].
extension ServerConsoleStatePatterns on ServerConsoleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerConsoleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerConsoleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerConsoleState value)  $default,){
final _that = this;
switch (_that) {
case _ServerConsoleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerConsoleState value)?  $default,){
final _that = this;
switch (_that) {
case _ServerConsoleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ServerStat> stats,  List<ServerEndpoint> endpoints,  List<RequestLogEntry> log,  bool logLive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerConsoleState() when $default != null:
return $default(_that.stats,_that.endpoints,_that.log,_that.logLive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ServerStat> stats,  List<ServerEndpoint> endpoints,  List<RequestLogEntry> log,  bool logLive)  $default,) {final _that = this;
switch (_that) {
case _ServerConsoleState():
return $default(_that.stats,_that.endpoints,_that.log,_that.logLive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ServerStat> stats,  List<ServerEndpoint> endpoints,  List<RequestLogEntry> log,  bool logLive)?  $default,) {final _that = this;
switch (_that) {
case _ServerConsoleState() when $default != null:
return $default(_that.stats,_that.endpoints,_that.log,_that.logLive);case _:
  return null;

}
}

}

/// @nodoc


class _ServerConsoleState implements ServerConsoleState {
  const _ServerConsoleState({final  List<ServerStat> stats = const <ServerStat>[], final  List<ServerEndpoint> endpoints = const <ServerEndpoint>[], final  List<RequestLogEntry> log = const <RequestLogEntry>[], this.logLive = true}): _stats = stats,_endpoints = endpoints,_log = log;
  

 final  List<ServerStat> _stats;
@override@JsonKey() List<ServerStat> get stats {
  if (_stats is EqualUnmodifiableListView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stats);
}

 final  List<ServerEndpoint> _endpoints;
@override@JsonKey() List<ServerEndpoint> get endpoints {
  if (_endpoints is EqualUnmodifiableListView) return _endpoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_endpoints);
}

 final  List<RequestLogEntry> _log;
@override@JsonKey() List<RequestLogEntry> get log {
  if (_log is EqualUnmodifiableListView) return _log;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_log);
}

@override@JsonKey() final  bool logLive;

/// Create a copy of ServerConsoleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerConsoleStateCopyWith<_ServerConsoleState> get copyWith => __$ServerConsoleStateCopyWithImpl<_ServerConsoleState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerConsoleState&&const DeepCollectionEquality().equals(other._stats, _stats)&&const DeepCollectionEquality().equals(other._endpoints, _endpoints)&&const DeepCollectionEquality().equals(other._log, _log)&&(identical(other.logLive, logLive) || other.logLive == logLive));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stats),const DeepCollectionEquality().hash(_endpoints),const DeepCollectionEquality().hash(_log),logLive);

@override
String toString() {
  return 'ServerConsoleState(stats: $stats, endpoints: $endpoints, log: $log, logLive: $logLive)';
}


}

/// @nodoc
abstract mixin class _$ServerConsoleStateCopyWith<$Res> implements $ServerConsoleStateCopyWith<$Res> {
  factory _$ServerConsoleStateCopyWith(_ServerConsoleState value, $Res Function(_ServerConsoleState) _then) = __$ServerConsoleStateCopyWithImpl;
@override @useResult
$Res call({
 List<ServerStat> stats, List<ServerEndpoint> endpoints, List<RequestLogEntry> log, bool logLive
});




}
/// @nodoc
class __$ServerConsoleStateCopyWithImpl<$Res>
    implements _$ServerConsoleStateCopyWith<$Res> {
  __$ServerConsoleStateCopyWithImpl(this._self, this._then);

  final _ServerConsoleState _self;
  final $Res Function(_ServerConsoleState) _then;

/// Create a copy of ServerConsoleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stats = null,Object? endpoints = null,Object? log = null,Object? logLive = null,}) {
  return _then(_ServerConsoleState(
stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as List<ServerStat>,endpoints: null == endpoints ? _self._endpoints : endpoints // ignore: cast_nullable_to_non_nullable
as List<ServerEndpoint>,log: null == log ? _self._log : log // ignore: cast_nullable_to_non_nullable
as List<RequestLogEntry>,logLive: null == logLive ? _self.logLive : logLive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
