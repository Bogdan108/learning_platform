import 'package:flutter/material.dart';
import 'package:learning_platform/drawing_board.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';

/// {@template home_screen}
/// HomeScreen is a simple screen that displays a grid of items.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro home_screen}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _logger = DependenciesScope.of(context).logger;

  @override
  void initState() {
    super.initState();
    _logger.info('Welcome To Learning Platform!');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromARGB(137, 218, 218, 218),
            appBar: AppBar(
              title: const Text(' Learner'),
              backgroundColor: Colors.lightGreen,
              shadowColor: Colors.grey,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Learning Platform!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: DrawingBoard(),
                ),
              ],
            ),
          ),
        ),
      );
}
