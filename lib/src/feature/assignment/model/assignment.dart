import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_platform/src/feature/assignment/model/assignment_status.dart';

part 'assignment.freezed.dart';
part 'assignment.g.dart';

@freezed
abstract class Assignment with _$Assignment {
  const factory Assignment({
    required String id,
    required String name,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'status') AssignmentStatus? status,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) => _$AssignmentFromJson(json);
}
