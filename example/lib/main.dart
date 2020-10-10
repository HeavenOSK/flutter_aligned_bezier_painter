import 'package:aligned_bezier_painter/aligned_bezier_painter.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text('Demo')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: GridPaper(
                child: CustomPaint(
                  painter: AlignedBezierPainter(
                    strokeColor: Colors.blue,
                    strokeWidth: 6,
                    startAlignment: Alignment.bottomLeft,
                    firstControlAlignment: Alignment(
                      Alignment.bottomLeft.x + Alignment.bottomRight.x * 0.3,
                      Alignment.bottomLeft.y,
                    ),
                    secondControlAlignment: Alignment(
                      Alignment.topRight.x - 2 * 0.15,
                      Alignment.topRight.y + 1,
                    ),
                    endAlignment: Alignment.topRight,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: SelectableText('Text'),
            ),
          ),
        ],
      ),
    );
  }
}
