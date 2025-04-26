import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment_request.freezed.dart';
part 'assignment_request.g.dart';

@freezed
abstract class AssignmentRequest with _$AssignmentRequest {
  const factory AssignmentRequest({
    required String name,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
  }) = _AssignmentRequest;

  factory AssignmentRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignmentRequestFromJson(json);
}
