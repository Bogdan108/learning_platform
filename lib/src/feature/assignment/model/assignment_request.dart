import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment_request.freezed.dart';
part 'assignment_request.g.dart';

@freezed
abstract class AssignmentRequest with _$AssignmentRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AssignmentRequest({
    required String name,
    @JsonKey(name: 'started_at') required String startedAt,
    @JsonKey(name: 'ended_at') String? endedAt,
  }) = _AssignmentRequest;

  factory AssignmentRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignmentRequestFromJson(json);
}
