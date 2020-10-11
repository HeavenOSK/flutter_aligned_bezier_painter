import 'package:aligned_bezier_painter/aligned_bezier_painter.dart';
import 'package:example/guid_painter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  Alignment _startAlignment = Alignment.bottomLeft;

  Alignment _firstControl = Alignment(
    Alignment.bottomLeft.x + Alignment.bottomRight.x * 0.3,
    Alignment.bottomLeft.y,
  );
  Alignment _secondControl = Alignment(
    Alignment.topRight.x - 2 * 0.15,
    Alignment.topRight.y + 1,
  );
  Alignment _endAlignment = Alignment.topRight;

  bool _guideOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AlignedBezierPainter Demo')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FractionallySizedBox(
              heightFactor: 0.95,
              widthFactor: 0.95,
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
                                startAlignment: _startAlignment,
                                firstControlAlignment: _firstControl,
                                secondControlAlignment: _secondControl,
                                endAlignment: _endAlignment,
                              ),
                            ),
                          ),
                          if (_guideOn)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: GuidePainter(
                                  startAlignment: _startAlignment,
                                  firstControlAlignment: _firstControl,
                                  secondControlAlignment: _secondControl,
                                  endAlignment: _endAlignment,
                                ),
                              ),
                            ),
                          if (_guideOn)
                            PositionedGuideCircle(
                              top: _startAlignment.alongSize(viewPortSize).dy -
                                  _GuideCircle.radius / 2,
                              left: _startAlignment.alongSize(viewPortSize).dx -
                                  _GuideCircle.radius / 2,
                              onMove: (Offset localDelta) {
                                final xp = localDelta.dx / viewPortSize.width;
                                final yp = localDelta.dy / viewPortSize.height;
                                final newX = _startAlignment.x + xp * 2;
                                final newY = _startAlignment.y + yp * 2;
                                setState(() {
                                  _startAlignment = Alignment(
                                    newX,
                                    newY,
                                  );
                                });
                              },
                            ),
                          if (_guideOn)
                            PositionedGuideCircle(
                              left: _firstControl.alongSize(viewPortSize).dx -
                                  _GuideCircle.radius / 2,
                              top: _firstControl.alongSize(viewPortSize).dy -
                                  _GuideCircle.radius / 2,
                              onMove: (Offset local) {
                                final xp = local.dx / viewPortSize.width;
                                final yp = local.dy / viewPortSize.height;
                                final newX = _firstControl.x + xp * 2;
                                final newY = _firstControl.y + yp * 2;
                                setState(() {
                                  _firstControl = Alignment(
                                    newX,
                                    newY,
                                  );
                                });
                              },
                            ),
                          if (_guideOn)
                            PositionedGuideCircle(
                              left: _secondControl.alongSize(viewPortSize).dx -
                                  _GuideCircle.radius / 2,
                              top: _secondControl.alongSize(viewPortSize).dy -
                                  _GuideCircle.radius / 2,
                              onMove: (Offset local) {
                                final xp = local.dx / viewPortSize.width;
                                final yp = local.dy / viewPortSize.height;
                                final newX = _secondControl.x + xp * 2;
                                final newY = _secondControl.y + yp * 2;
                                setState(
                                  () {
                                    _secondControl = Alignment(
                                      newX,
                                      newY,
                                    );
                                  },
                                );
                              },
                            ),
                          PositionedGuideCircle(
                            left: _endAlignment.alongSize(viewPortSize).dx -
                                _GuideCircle.radius / 2,
                            top: _endAlignment.alongSize(viewPortSize).dy -
                                _GuideCircle.radius / 2,
                            onMove: (Offset local) {
                              final xp = local.dx / viewPortSize.width;
                              final yp = local.dy / viewPortSize.height;
                              final newX = _endAlignment.x + xp * 2;
                              final newY = _endAlignment.y + yp * 2;
                              setState(() {
                                _endAlignment = Alignment(
                                  newX,
                                  newY,
                                );
                              });
                            },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _guideOn = !_guideOn;
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class PositionedGuideCircle extends StatelessWidget {
  const PositionedGuideCircle({
    Key key,
    @required this.left,
    @required this.top,
    @required this.onMove,
  }) : super(key: key);

  final double left;
  final double top;
  final Null Function(Offset localDelta) onMove;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Listener(
        onPointerMove: (PointerMoveEvent detail) {
          onMove?.call(detail.localDelta);
        },
        behavior: HitTestBehavior.opaque,
        child: _GuideCircle(),
      ),
    );
  }
}

class _GuideCircle extends StatelessWidget {
  const _GuideCircle({
    this.dragging = false,
  });

  final bool dragging;

  static double get radius => 16.0 + 12 * 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.0,
      width: 16.0,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: dragging ? Colors.red : Colors.black),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}
