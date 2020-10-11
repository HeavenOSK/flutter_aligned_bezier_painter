import 'package:aligned_bezier_painter/aligned_bezier_painter.dart';
import 'package:example/guid_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _snapThreshold = 0.05;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

// TODO(HeavenOSK): Refactor
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

  String get generated => '''
CustomPaint(
  painter: AlignedBezierPainter(
    strokeColor: Colors.red,
    strokeWidth: 3,
    startAlignment: 
      Alignment(${_startAlignment.x},${_startAlignment.y}),
    firstControlAlignment:  
      Alignment(${_firstControl.x},${_firstControl.y}),
    secondControlAlignment: 
      Alignment(${_secondControl.x},${_secondControl.y}),
    endAlignment: 
      Alignment(${_endAlignment.x},${_endAlignment.y}),
  ),
),
  ''';

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
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: LayoutBuilder(
                  builder: (_context, constraints) {
                    final viewPortSize = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );

                    return GridPaper(
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
                            _GuideCircle(
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
                              onUp: () {
                                final x = _startAlignment.x;
                                final y = _startAlignment.y;
                                final shouldSnapX =
                                    (1 - x.abs()) <= _snapThreshold;
                                final shouldSnapY =
                                    (1 - y.abs()) <= _snapThreshold;
                                if (shouldSnapX || shouldSnapY) {
                                  setState(() {
                                    _startAlignment = Alignment(
                                      shouldSnapX ? x.roundToDouble() : x,
                                      shouldSnapY ? y.roundToDouble() : y,
                                    );
                                  });
                                }
                              },
                            ),
                          if (_guideOn)
                            _GuideCircle(
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
                              onUp: () {
                                final x = _firstControl.x;
                                final y = _firstControl.y;
                                final shouldSnapX =
                                    (1 - x.abs()) <= _snapThreshold;
                                final shouldSnapY =
                                    (1 - y.abs()) <= _snapThreshold;
                                if (shouldSnapX || shouldSnapY) {
                                  setState(() {
                                    _firstControl = Alignment(
                                      shouldSnapX ? x.roundToDouble() : x,
                                      shouldSnapY ? y.roundToDouble() : y,
                                    );
                                  });
                                }
                              },
                            ),
                          if (_guideOn)
                            _GuideCircle(
                              left: _secondControl.alongSize(viewPortSize).dx -
                                  _GuideCircle.radius / 2,
                              top: _secondControl.alongSize(viewPortSize).dy -
                                  _GuideCircle.radius / 2,
                              onMove: (Offset local) {
                                setState(
                                  () {
                                    _secondControl = newAlignment(
                                      viewPortSize,
                                      _secondControl,
                                      local,
                                    );
                                  },
                                );
                              },
                              onUp: () {
                                final x = _secondControl.x;
                                final y = _secondControl.y;
                                final shouldSnapX =
                                    (1 - x.abs()) <= _snapThreshold;
                                final shouldSnapY =
                                    (1 - y.abs()) <= _snapThreshold;
                                if (shouldSnapX || shouldSnapY) {
                                  setState(() {
                                    _secondControl = Alignment(
                                      shouldSnapX ? x.roundToDouble() : x,
                                      shouldSnapY ? y.roundToDouble() : y,
                                    );
                                  });
                                }
                              },
                            ),
                          if (_guideOn)
                            _GuideCircle(
                              left: _endAlignment.alongSize(viewPortSize).dx -
                                  _GuideCircle.radius / 2,
                              top: _endAlignment.alongSize(viewPortSize).dy -
                                  _GuideCircle.radius / 2,
                              onMove: (Offset local) {
                                setState(() {
                                  _endAlignment = newAlignment(
                                    viewPortSize,
                                    _endAlignment,
                                    local,
                                  );
                                });
                              },
                              onUp: () {
                                final x = _endAlignment.x;
                                final y = _endAlignment.y;
                                final shouldSnapX =
                                    (1 - x.abs()) <= _snapThreshold;
                                final shouldSnapY =
                                    (1 - y.abs()) <= _snapThreshold;
                                if (shouldSnapX || shouldSnapY) {
                                  setState(() {
                                    _endAlignment = Alignment(
                                      shouldSnapX ? x.roundToDouble() : x,
                                      shouldSnapY ? y.roundToDouble() : y,
                                    );
                                  });
                                }
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sample code',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      OutlineButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: generated));
                        },
                        child: Text('COPY ALL'),
                      ),
                    ],
                  ),
                  FittedBox(
                    child: SelectableText(
                      generated,
                    ),
                  ),
                ],
              ),
            ),
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

  Alignment newAlignment(
    Size viewPortSize,
    Alignment old,
    Offset local,
  ) {
    final xp = local.dx / viewPortSize.width;
    final yp = local.dy / viewPortSize.height;
    final newX = old.x + xp * 2;
    final newY = old.y + yp * 2;

    return Alignment(
      newX,
      newY,
    );
  }
}

class _GuideCircle extends StatelessWidget {
  const _GuideCircle({
    @required this.left,
    @required this.top,
    @required this.onMove,
    @required this.onUp,
    Key key,
  }) : super(key: key);

  final double left;
  final double top;
  final ValueChanged<Offset> onMove;
  final VoidCallback onUp;

  static double get radius => 16.0 + 12 * 2;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Listener(
        onPointerUp: (d) {
          onUp?.call();
        },
        onPointerMove: (PointerMoveEvent detail) {
          onMove?.call(detail.localDelta);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 16.0,
          width: 16.0,
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(),
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
