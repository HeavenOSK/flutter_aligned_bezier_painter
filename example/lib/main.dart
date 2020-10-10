import 'package:aligned_bezier_painter/aligned_bezier_painter.dart';
import 'package:example/guid_painter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final startAlignment = Alignment.bottomLeft;

    final firstControl = Alignment(
      Alignment.bottomLeft.x + Alignment.bottomRight.x * 0.3,
      Alignment.bottomLeft.y,
    );
    final secondControl = Alignment(
      Alignment.topRight.x - 2 * 0.15,
      Alignment.topRight.y + 1,
    );
    final endAlignment = Alignment.topRight;
    return Scaffold(
      appBar: AppBar(title: Text('Demo')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (_context, constraints) {
                  final viewPortSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                    ),
                    child: GridPaper(
                      child: Stack(
                        overflow: Overflow.visible,
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: AlignedBezierPainter(
                                strokeColor: Colors.red,
                                strokeWidth: 3,
                                startAlignment: startAlignment,
                                firstControlAlignment: firstControl,
                                secondControlAlignment: secondControl,
                                endAlignment: endAlignment,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: CustomPaint(
                              painter: GuidePainter(
                                startAlignment: startAlignment,
                                firstControlAlignment: firstControl,
                                secondControlAlignment: secondControl,
                                endAlignment: endAlignment,
                              ),
                            ),
                          ),
                          Positioned(
                            left: startAlignment.alongSize(viewPortSize).dx -
                                _GuideCircle.radius / 2,
                            top: startAlignment.alongSize(viewPortSize).dy -
                                _GuideCircle.radius / 2,
                            child: _GuideCircle(),
                          ),
                          Positioned(
                            left: firstControl.alongSize(viewPortSize).dx -
                                _GuideCircle.radius / 2,
                            top: firstControl.alongSize(viewPortSize).dy -
                                _GuideCircle.radius / 2,
                            child: _GuideCircle(),
                          ),
                          Positioned(
                            left: secondControl.alongSize(viewPortSize).dx -
                                _GuideCircle.radius / 2,
                            top: secondControl.alongSize(viewPortSize).dy -
                                _GuideCircle.radius / 2,
                            child: _GuideCircle(),
                          ),
                          Positioned(
                            left: endAlignment.alongSize(viewPortSize).dx -
                                _GuideCircle.radius / 2,
                            top: endAlignment.alongSize(viewPortSize).dy -
                                _GuideCircle.radius / 2,
                            child: _GuideCircle(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Text(''),
          ),
        ],
      ),
    );
  }
}

class _GuideCircle extends StatelessWidget {
  const _GuideCircle();

  static double get radius => 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
