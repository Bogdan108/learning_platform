import 'package:learning_platform/src/feature/answers/model/assignment_answers.dart';

abstract interface class IAnswersRepository {
  Future<List<AssignmentAnswers>> getAnswersByCourse(String courseId);
}
