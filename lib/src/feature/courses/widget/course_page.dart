import 'package:flutter/material.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(_courseTitle),
        ),
        body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => ListTile(
            leading: Text('$index'),
          ),
        ),
      );
}

const _courseTitle = 'Курсы';
