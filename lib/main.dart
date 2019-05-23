import 'dart:io';
import 'dart:math';

import 'package:drizl/calculations/sun_calc.dart';
import 'package:drizl/views/map_sample.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/sun_ui.dart';
import 'config/config.dart';
import 'generic_widgets/radial_position.dart';
import 'stack/sky_background.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: Skeleton(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey[900],
        accentColor: Colors.indigo[300],
      ),
    );
  }
}

class SineTween extends Tween<double> {
  SineTween({double begin, double end}) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((sin((t) * 2 * pi) + 1) / 2);
  }
}

class CosTween extends Tween<double> {
  CosTween({double begin, double end}) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((cos((t) * 2 * pi) + 1) / 2);
  }
}

class Skeleton extends StatefulWidget {
  @override
  State<Skeleton> createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  final Config _config = Config();

  Animation animation_y;
  Animation animation_x;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    );

    SunCalc sunCalc = SunCalc.now(latitude: 35.6762, longitude: 139.6503);

    // this is the position of the sun in the sky in
    // percentange of it's path from sunrise to sunset
    double timeOfDayRatio = (sunCalc.julianTime - sunCalc.sunRise) /
        (sunCalc.sunSet - sunCalc.sunRise);

    // use this to calculate angle between 0 and pi (this is the circular position of the sun)
    // the duration is set by current position (begin) and sunset (end) * the percent of sky left to go
    // e.g. there is 4 hours until sunset, and the sun is halfway in the sky, the duration should be 4 hours

    animation_y = Tween(begin: pi - (pi * timeOfDayRatio), end: 2.0 * pi)
        .animate(animationController)
          ..addListener(() {
            setState(() {});
          });

    animation_x = SineTween(begin: 2.5, end: -2.5).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          SkyBackground(),
          Container(
            alignment: Alignment(0.0, 1.0),
            child: RadialPosition(
              child: Transform(
                  transform: Matrix4.translationValues(0.0, 10.0, 0.0),
                  child: SunUI()),
              radius: 140.0,
              angle: animation_y.value,
            ),
          ),
          Container(
            alignment: Alignment(0.0, 1.0),
            child: Container(
              color: Colors.green,
              height: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
