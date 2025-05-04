import 'package:learning_platform/src/feature/answers/data_source/i_answers_data_source.dart';
import 'package:learning_platform/src/feature/answers/model/assignment_answers.dart';
import 'package:learning_platform/src/feature/answers/repository/i_answers_repository.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/i_storage.dart';
import 'package:learning_platform/src/feature/authorization/data/storage/token_storage.dart';

class AnswersRepository implements IAnswersRepository {
  final IAnswersDataSource _dataSource;
  final TokenStorage _token;
  final IStorage<String> _org;

  AnswersRepository({
    required IAnswersDataSource dataSource,
    required TokenStorage tokenStorage,
    required IStorage<String> orgIdStorage,
  })  : _dataSource = dataSource,
        _token = tokenStorage,
        _org = orgIdStorage;

  @override
  Future<List<AssignmentAnswers>> getAnswersByCourse(String courseId) =>
      _dataSource.fetchAnswers(
        _org.load() ?? '',
        _token.load() ?? '',
        courseId,
      );
}
