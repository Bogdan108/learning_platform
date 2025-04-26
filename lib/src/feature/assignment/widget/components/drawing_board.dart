import 'package:flutter/material.dart';

class DrawingBoard extends StatefulWidget {
  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) => GestureDetector(
        onDoubleTap: () => setState(
          () {
            points = [];
          },
        ),
        // Отслеживаем перемещения пальца по экрану
        onPanUpdate: (details) {
          setState(() {
            // Переводим глобальные координаты в локальные относительно контейнера
            final renderBox = context.findRenderObject()! as RenderBox;
            points.add(renderBox.globalToLocal(details.globalPosition));
          });
        },
        // Когда палец оторван от экрана, добавляем null для разделения линий
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: LayoutBuilder(
          builder: (BuildContext context, constraints) => RepaintBoundary(
            child: SizedBox(
              width: constraints.maxWidth,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: CustomPaint(
                  painter: DrawingPainter(points: points),
                ),
              ),
            ),
          ),
        ),
      );
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  const DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (var i = 0; i < points.length - 1; ++i) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
      if (i == 0 && points[i + 1] == null) {
        canvas.drawLine(points[i]!, points[i]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
