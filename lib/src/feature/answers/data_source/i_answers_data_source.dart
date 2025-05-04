import 'package:learning_platform/src/feature/answers/model/assignment_answers.dart';

abstract interface class IAnswersDataSource {
  Future<List<AssignmentAnswers>> fetchAnswers(
    String orgId,
    String token,
    String courseId,
  );
}
