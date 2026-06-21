// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranscriptSegment {

 String get time; String get speaker; String get text;
/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptSegmentCopyWith<TranscriptSegment> get copyWith => _$TranscriptSegmentCopyWithImpl<TranscriptSegment>(this as TranscriptSegment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptSegment&&(identical(other.time, time) || other.time == time)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,time,speaker,text);

@override
String toString() {
  return 'TranscriptSegment(time: $time, speaker: $speaker, text: $text)';
}


}

/// @nodoc
abstract mixin class $TranscriptSegmentCopyWith<$Res>  {
  factory $TranscriptSegmentCopyWith(TranscriptSegment value, $Res Function(TranscriptSegment) _then) = _$TranscriptSegmentCopyWithImpl;
@useResult
$Res call({
 String time, String speaker, String text
});




}
/// @nodoc
class _$TranscriptSegmentCopyWithImpl<$Res>
    implements $TranscriptSegmentCopyWith<$Res> {
  _$TranscriptSegmentCopyWithImpl(this._self, this._then);

  final TranscriptSegment _self;
  final $Res Function(TranscriptSegment) _then;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? speaker = null,Object? text = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptSegment].
extension TranscriptSegmentPatterns on TranscriptSegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptSegment value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptSegment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptSegment value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time,  String speaker,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
return $default(_that.time,_that.speaker,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time,  String speaker,  String text)  $default,) {final _that = this;
switch (_that) {
case _TranscriptSegment():
return $default(_that.time,_that.speaker,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time,  String speaker,  String text)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
return $default(_that.time,_that.speaker,_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _TranscriptSegment implements TranscriptSegment {
  const _TranscriptSegment({required this.time, required this.speaker, required this.text});
  

@override final  String time;
@override final  String speaker;
@override final  String text;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptSegmentCopyWith<_TranscriptSegment> get copyWith => __$TranscriptSegmentCopyWithImpl<_TranscriptSegment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptSegment&&(identical(other.time, time) || other.time == time)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,time,speaker,text);

@override
String toString() {
  return 'TranscriptSegment(time: $time, speaker: $speaker, text: $text)';
}


}

/// @nodoc
abstract mixin class _$TranscriptSegmentCopyWith<$Res> implements $TranscriptSegmentCopyWith<$Res> {
  factory _$TranscriptSegmentCopyWith(_TranscriptSegment value, $Res Function(_TranscriptSegment) _then) = __$TranscriptSegmentCopyWithImpl;
@override @useResult
$Res call({
 String time, String speaker, String text
});




}
/// @nodoc
class __$TranscriptSegmentCopyWithImpl<$Res>
    implements _$TranscriptSegmentCopyWith<$Res> {
  __$TranscriptSegmentCopyWithImpl(this._self, this._then);

  final _TranscriptSegment _self;
  final $Res Function(_TranscriptSegment) _then;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? speaker = null,Object? text = null,}) {
  return _then(_TranscriptSegment(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PastTranscription {

 String get title; String get duration; String get language; String get date;
/// Create a copy of PastTranscription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PastTranscriptionCopyWith<PastTranscription> get copyWith => _$PastTranscriptionCopyWithImpl<PastTranscription>(this as PastTranscription, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastTranscription&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.language, language) || other.language == language)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,title,duration,language,date);

@override
String toString() {
  return 'PastTranscription(title: $title, duration: $duration, language: $language, date: $date)';
}


}

/// @nodoc
abstract mixin class $PastTranscriptionCopyWith<$Res>  {
  factory $PastTranscriptionCopyWith(PastTranscription value, $Res Function(PastTranscription) _then) = _$PastTranscriptionCopyWithImpl;
@useResult
$Res call({
 String title, String duration, String language, String date
});




}
/// @nodoc
class _$PastTranscriptionCopyWithImpl<$Res>
    implements $PastTranscriptionCopyWith<$Res> {
  _$PastTranscriptionCopyWithImpl(this._self, this._then);

  final PastTranscription _self;
  final $Res Function(PastTranscription) _then;

/// Create a copy of PastTranscription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? duration = null,Object? language = null,Object? date = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PastTranscription].
extension PastTranscriptionPatterns on PastTranscription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PastTranscription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PastTranscription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PastTranscription value)  $default,){
final _that = this;
switch (_that) {
case _PastTranscription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PastTranscription value)?  $default,){
final _that = this;
switch (_that) {
case _PastTranscription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String duration,  String language,  String date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PastTranscription() when $default != null:
return $default(_that.title,_that.duration,_that.language,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String duration,  String language,  String date)  $default,) {final _that = this;
switch (_that) {
case _PastTranscription():
return $default(_that.title,_that.duration,_that.language,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String duration,  String language,  String date)?  $default,) {final _that = this;
switch (_that) {
case _PastTranscription() when $default != null:
return $default(_that.title,_that.duration,_that.language,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _PastTranscription implements PastTranscription {
  const _PastTranscription({required this.title, required this.duration, required this.language, required this.date});
  

@override final  String title;
@override final  String duration;
@override final  String language;
@override final  String date;

/// Create a copy of PastTranscription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PastTranscriptionCopyWith<_PastTranscription> get copyWith => __$PastTranscriptionCopyWithImpl<_PastTranscription>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PastTranscription&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.language, language) || other.language == language)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,title,duration,language,date);

@override
String toString() {
  return 'PastTranscription(title: $title, duration: $duration, language: $language, date: $date)';
}


}

/// @nodoc
abstract mixin class _$PastTranscriptionCopyWith<$Res> implements $PastTranscriptionCopyWith<$Res> {
  factory _$PastTranscriptionCopyWith(_PastTranscription value, $Res Function(_PastTranscription) _then) = __$PastTranscriptionCopyWithImpl;
@override @useResult
$Res call({
 String title, String duration, String language, String date
});




}
/// @nodoc
class __$PastTranscriptionCopyWithImpl<$Res>
    implements _$PastTranscriptionCopyWith<$Res> {
  __$PastTranscriptionCopyWithImpl(this._self, this._then);

  final _PastTranscription _self;
  final $Res Function(_PastTranscription) _then;

/// Create a copy of PastTranscription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? duration = null,Object? language = null,Object? date = null,}) {
  return _then(_PastTranscription(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SpeechState {

 RecorderStatus get status; int get elapsedSeconds; double get progress; List<TranscriptSegment> get transcript; List<PastTranscription> get history;
/// Create a copy of SpeechState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechStateCopyWith<SpeechState> get copyWith => _$SpeechStateCopyWithImpl<SpeechState>(this as SpeechState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechState&&(identical(other.status, status) || other.status == status)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.transcript, transcript)&&const DeepCollectionEquality().equals(other.history, history));
}


@override
int get hashCode => Object.hash(runtimeType,status,elapsedSeconds,progress,const DeepCollectionEquality().hash(transcript),const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'SpeechState(status: $status, elapsedSeconds: $elapsedSeconds, progress: $progress, transcript: $transcript, history: $history)';
}


}

/// @nodoc
abstract mixin class $SpeechStateCopyWith<$Res>  {
  factory $SpeechStateCopyWith(SpeechState value, $Res Function(SpeechState) _then) = _$SpeechStateCopyWithImpl;
@useResult
$Res call({
 RecorderStatus status, int elapsedSeconds, double progress, List<TranscriptSegment> transcript, List<PastTranscription> history
});




}
/// @nodoc
class _$SpeechStateCopyWithImpl<$Res>
    implements $SpeechStateCopyWith<$Res> {
  _$SpeechStateCopyWithImpl(this._self, this._then);

  final SpeechState _self;
  final $Res Function(SpeechState) _then;

/// Create a copy of SpeechState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? elapsedSeconds = null,Object? progress = null,Object? transcript = null,Object? history = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecorderStatus,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegment>,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<PastTranscription>,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeechState].
extension SpeechStatePatterns on SpeechState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeechState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeechState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeechState value)  $default,){
final _that = this;
switch (_that) {
case _SpeechState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeechState value)?  $default,){
final _that = this;
switch (_that) {
case _SpeechState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecorderStatus status,  int elapsedSeconds,  double progress,  List<TranscriptSegment> transcript,  List<PastTranscription> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeechState() when $default != null:
return $default(_that.status,_that.elapsedSeconds,_that.progress,_that.transcript,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecorderStatus status,  int elapsedSeconds,  double progress,  List<TranscriptSegment> transcript,  List<PastTranscription> history)  $default,) {final _that = this;
switch (_that) {
case _SpeechState():
return $default(_that.status,_that.elapsedSeconds,_that.progress,_that.transcript,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecorderStatus status,  int elapsedSeconds,  double progress,  List<TranscriptSegment> transcript,  List<PastTranscription> history)?  $default,) {final _that = this;
switch (_that) {
case _SpeechState() when $default != null:
return $default(_that.status,_that.elapsedSeconds,_that.progress,_that.transcript,_that.history);case _:
  return null;

}
}

}

/// @nodoc


class _SpeechState implements SpeechState {
  const _SpeechState({this.status = RecorderStatus.idle, this.elapsedSeconds = 0, this.progress = 0, final  List<TranscriptSegment> transcript = const <TranscriptSegment>[], final  List<PastTranscription> history = const <PastTranscription>[]}): _transcript = transcript,_history = history;
  

@override@JsonKey() final  RecorderStatus status;
@override@JsonKey() final  int elapsedSeconds;
@override@JsonKey() final  double progress;
 final  List<TranscriptSegment> _transcript;
@override@JsonKey() List<TranscriptSegment> get transcript {
  if (_transcript is EqualUnmodifiableListView) return _transcript;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transcript);
}

 final  List<PastTranscription> _history;
@override@JsonKey() List<PastTranscription> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of SpeechState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeechStateCopyWith<_SpeechState> get copyWith => __$SpeechStateCopyWithImpl<_SpeechState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeechState&&(identical(other.status, status) || other.status == status)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other._transcript, _transcript)&&const DeepCollectionEquality().equals(other._history, _history));
}


@override
int get hashCode => Object.hash(runtimeType,status,elapsedSeconds,progress,const DeepCollectionEquality().hash(_transcript),const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'SpeechState(status: $status, elapsedSeconds: $elapsedSeconds, progress: $progress, transcript: $transcript, history: $history)';
}


}

/// @nodoc
abstract mixin class _$SpeechStateCopyWith<$Res> implements $SpeechStateCopyWith<$Res> {
  factory _$SpeechStateCopyWith(_SpeechState value, $Res Function(_SpeechState) _then) = __$SpeechStateCopyWithImpl;
@override @useResult
$Res call({
 RecorderStatus status, int elapsedSeconds, double progress, List<TranscriptSegment> transcript, List<PastTranscription> history
});




}
/// @nodoc
class __$SpeechStateCopyWithImpl<$Res>
    implements _$SpeechStateCopyWith<$Res> {
  __$SpeechStateCopyWithImpl(this._self, this._then);

  final _SpeechState _self;
  final $Res Function(_SpeechState) _then;

/// Create a copy of SpeechState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? elapsedSeconds = null,Object? progress = null,Object? transcript = null,Object? history = null,}) {
  return _then(_SpeechState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecorderStatus,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,transcript: null == transcript ? _self._transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegment>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<PastTranscription>,
  ));
}


}

// dart format on
