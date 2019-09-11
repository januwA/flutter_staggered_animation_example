import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

num random(num min, num max, [isDouble = false]) {
  final _random = math.Random();
  if (!isDouble) {
    return min + _random.nextInt(max - min + 1);
  } else {
    return (_random.nextDouble() * (max - min) + min);
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          for (var i = 0; i < 20; i++)
            AnimatedCircular(
              controller: controller,
              r: random(20, 40).toDouble(),
              x: random(0, width.toInt()).toDouble(),
              y: random(0, height.toInt()).toDouble(),
              color: Color.fromRGBO(random(0, 255), random(0, 255), 255, 1),
            ),
        ],
      ),
    );
  }
}

class AnimatedCircular extends StatefulWidget {
  final AnimationController controller;
  final Animation<double> scale;

  final double r;
  final double x;
  final double y;
  final Color color;
  AnimatedCircular({
    Key key,
    this.r,
    this.x,
    this.y,
    this.controller,
    this.color = Colors.black,
  })  : scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              // 这里是交错动画关键，see also: https://flutter.dev/docs/development/ui/animations/staggered-animations
              random(0.1, 0.3, true),
              random(0.5, 1.0, true),
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key);
  @override
  _AnimatedCircularState createState() => _AnimatedCircularState(x: x, y: y);
}

class _AnimatedCircularState extends State<AnimatedCircular> {
  double x;
  double y;

  _AnimatedCircularState({this.x, this.y});
  @override
  void initState() {
    super.initState();
    draw();
  }

  draw() {
    Timer.periodic(Duration(microseconds: 60), (_) {
      update();
    });
  }

  update() {
    setState(() {
      x += random(-5, 5).toDouble();
      y += random(-5, 5).toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = widget.r * 2;
    double h = widget.r * 2;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Positioned(
          left: x + widget.r,
          top: y + widget.r,
          child: Transform.scale(
            scale: widget.scale.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ),
      ),
    );
  }
}