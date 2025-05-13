// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_platform/src/common/widget/custom_elevated_button.dart';
import 'package:learning_platform/src/common/widget/custom_error_widget.dart';
import 'package:learning_platform/src/common/widget/custom_snackbar.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/task/bloc/answer_tasks_bloc/answer_tasks_bloc.dart';
import 'package:learning_platform/src/feature/task/bloc/answer_tasks_bloc/answer_tasks_event.dart';
import 'package:learning_platform/src/feature/task/bloc/answer_tasks_bloc/answer_tasks_state.dart';
import 'package:learning_platform/src/feature/task/data/data_source/tasks_data_source.dart';
import 'package:learning_platform/src/feature/task/data/repository/tasks_repository.dart';
import 'package:learning_platform/src/feature/task/model/answer_type.dart';
import 'package:learning_platform/src/feature/task/model/question_type.dart';
import 'package:learning_platform/src/feature/task/model/task.dart';
import 'package:learning_platform/src/feature/task/widget/components/answer_type_widget.dart';
import 'package:learning_platform/src/feature/task/widget/components/finish_answer_card.dart';
import 'package:share_plus/share_plus.dart';

class AnswerTasksPage extends StatefulWidget {
  final String assignmentId;
  final String title;

  const AnswerTasksPage({
    required this.assignmentId,
    required this.title,
    super.key,
  });

  @override
  State<AnswerTasksPage> createState() => _AnswerTasksPageState();
}

class _AnswerTasksPageState extends State<AnswerTasksPage> {
  late final TasksRepository tasksRepository;
  late final AnswerTasksBloc _bloc;

  final _pageController = PageController();
  int _currentIndex = 0;
  bool needUpdate = false;
  bool isFinished = false;

  final Map<int, String> _textAnswers = {};
  final Map<int, int?> _variantAnswers = {};
  final Map<int, PlatformFile?> _fileAnswers = {};

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    tasksRepository = TasksRepository(
      dataSource: TasksDataSource(dio: deps.dio),
      tokenStorage: deps.tokenStorage,
      orgIdStorage: deps.organizationIdStorage,
    );
    _bloc = AnswerTasksBloc(
      tasksRepository: tasksRepository,
    )..add(
        AnswerTasksEvent.fetch(
          assignmentId: widget.assignmentId,
        ),
      );
  }

  @override
  void dispose() {
    _bloc.close();
    _pageController.dispose();
    super.dispose();
  }

  void _sendAnswer(
    Task task, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) {
    final aid = widget.assignmentId;
    final tid = task.id;
    if (needUpdate) {
      switch (task.answerType) {
        case AnswerType.text:
          final txt = _textAnswers[_currentIndex];
          if (txt != null && txt.isNotEmpty) {
            _bloc.add(
              AnswerTasksEvent.answerText(
                assignmentId: aid,
                taskId: tid,
                text: txt,
                onSuccess: onSuccess,
                onError: onError,
              ),
            );
          }
        case AnswerType.file:
          final f = _fileAnswers[_currentIndex];
          final bytes = f?.bytes;
          if (bytes != null) {
            _bloc.add(
              AnswerTasksEvent.answerFile(
                assignmentId: aid,
                taskId: tid,
                file: bytes,
                fileName: f?.name ?? 'answer',
                onSuccess: onSuccess,
                onError: onError,
              ),
            );
          }
        case AnswerType.variants:
          final v = _variantAnswers[_currentIndex];
          if (v != null && task.answerVariants?[v] != null) {
            _bloc.add(
              AnswerTasksEvent.answerText(
                assignmentId: aid,
                taskId: tid,
                text: task.answerVariants![v],
                onSuccess: onSuccess,
                onError: onError,
              ),
            );
          }
      }
    } else {
      onSuccess?.call();
    }
  }

  Future<void> _pickFile(int idx, Task task) async {
    try {
      final res = await FilePicker.platform.pickFiles(withData: true);
      if (res != null && res.files.single.path != null) {
        final file = res.files.first;
        if (_fileAnswers[idx] != file) {
          setState(
            () => _fileAnswers[idx] = file,
          );
          needUpdate = true;
        }
      }
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 200);
    const animation = Curves.easeInOut;

    return BlocListener<AnswerTasksBloc, AnswerTasksState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is AnswerTasksState$Idle) {
          state.event?.onSuccess?.call();
          state.event?.onError?.call();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: BlocBuilder<AnswerTasksBloc, AnswerTasksState>(
          bloc: _bloc,
          builder: (ctx, state) {
            if (state is AnswerTasksState$Error) {
              return CustomErrorWidget(
                errorMessage: state.error,
                onRetry: state.event != null ? () => _bloc.add(state.event!) : null,
              );
            }

            final tasks = state.tasks;
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        itemCount: tasks.length + 1,
                        onPageChanged: (newIdx) {
                          if (newIdx == tasks.length) {
                            isFinished = true;
                          }

                          needUpdate = false;
                          setState(() => _currentIndex = newIdx);
                        },
                        itemBuilder: (_, idx) {
                          if (idx == tasks.length) {
                            return FinishAnswerCard(
                              onViewAnswers: () => _pageController.animateTo(
                                0,
                                duration: const Duration(seconds: 1),
                                curve: animation,
                              ),
                            );
                          }
                          final task = tasks[idx];
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: ListView(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        '${idx + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: task.questionType == QuestionType.text
                                          ? Text(
                                              task.questionText ?? '',
                                              style: const TextStyle(fontSize: 16),
                                            )
                                          : Row(
                                              children: [
                                                const Icon(
                                                  Icons.insert_drive_file,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    task.questionFile ?? 'Файл задания',
                                                  ),
                                                ),
                                                GestureDetector(
                                                  child: const Icon(Icons.download),
                                                  onTap: () async {
                                                    CustomSnackBar.showSuccessful(
                                                      context,
                                                      title: 'Скачиваем ...',
                                                    );

                                                    try {
                                                      final filePath = await tasksRepository
                                                          .downloadQuestionFile(
                                                        task.id,
                                                        task.questionFile,
                                                      );
                                                      if (filePath != null) {
                                                        final params = ShareParams(
                                                          title: task.questionFile,
                                                          files: [XFile(filePath)],
                                                        );

                                                        await SharePlus.instance.share(params);
                                                      }
                                                    } catch (e) {
                                                      CustomSnackBar.showError(
                                                        context,
                                                        title: 'Ошибка: $e',
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // ── Ответ ─────────────────────────────
                                IgnorePointer(
                                  ignoring: isFinished,
                                  child: AnswerTypeWidget(
                                    task: task,
                                    fileName: _fileAnswers[idx]?.name,
                                    onTextAnswer: (txt) {
                                      if (_textAnswers[idx] != txt) {
                                        _textAnswers[idx] = txt;
                                        needUpdate = true;
                                      }
                                    },
                                    onFileChangeAnswer: () => _pickFile(idx, task),
                                    onVariantChangeAnswer: (index) {
                                      setState(
                                        () => _variantAnswers[idx] = index,
                                      );
                                      needUpdate = true;
                                    },
                                    varinalAnswerIndex: _variantAnswers[idx],
                                    initialText: _textAnswers[idx],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // ── Управление ────────────────────────────
                    if (_currentIndex != tasks.length)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: _currentIndex > 0
                                    ? () {
                                        if (needUpdate) {
                                          _sendAnswer(
                                            tasks[_currentIndex],
                                            onSuccess: () => _pageController.previousPage(
                                              duration: duration,
                                              curve: animation,
                                            ),
                                          );
                                        } else {
                                          _pageController.previousPage(
                                            duration: duration,
                                            curve: animation,
                                          );
                                        }
                                      }
                                    : null,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Назад',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: () {
                                  if (_currentIndex == tasks.length - 1) {
                                    final missing = <int>[];
                                    for (var i = 0; i < tasks.length; i++) {
                                      final t = tasks[i];
                                      final answered = switch (t.answerType) {
                                        AnswerType.text =>
                                          _textAnswers[i]?.trim().isNotEmpty ?? false,
                                        AnswerType.file => _fileAnswers[i] != null,
                                        AnswerType.variants => _variantAnswers[i] != null,
                                      };
                                      if (!answered) missing.add(i + 1);
                                    }

                                    if (missing.isNotEmpty) {
                                      final nums = missing.join(', ');
                                      CustomSnackBar.showError(
                                        context,
                                        title: 'Пожалуйста, ответьте на задания №$nums',
                                      );
                                      return;
                                    }
                                  }
                                  if (needUpdate) {
                                    _sendAnswer(
                                      tasks[_currentIndex],
                                      onSuccess: () => _pageController.nextPage(
                                        duration: duration,
                                        curve: animation,
                                      ),
                                    );
                                  } else {
                                    _pageController.nextPage(
                                      duration: duration,
                                      curve: animation,
                                    );
                                  }
                                },
                                title: _currentIndex < tasks.length - 1 ? 'Далее' : 'Завершить',
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (state is AnswerTasksState$Loading)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
