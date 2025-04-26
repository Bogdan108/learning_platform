import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment.freezed.dart';
part 'assignment.g.dart';

@freezed
abstract class Assignment with _$Assignment {
  const factory Assignment({
    required String id,
    required String name,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
}
