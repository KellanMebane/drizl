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
  double startPosition = 0.0;
  double sunAngleRelative = 0.0;
  double long = -122;
  double lat = 47;
  double dayPercent = 0.0;

  @override
  void initState() {
    super.initState();
    SunCalc sunCalc = SunCalc(latitude: lat, longitude: long);

    double sunAngle = 90 - ((sunCalc.declinationOfTheSun * 57.2958) - lat);

    sunAngleRelative = sunAngle;
    dayPercent = (sunCalc.meanSolarNoon - sunCalc.preciseDaysSince2000).abs();
    print("Day percent: ${dayPercent}");

    animationController = AnimationController(
      duration: Duration(seconds: 86400),
      vsync: this,
    );

    animation_y = Tween(begin: 0.0, end: 2 * pi).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    // animation_x = SineTween(begin: 2.5, end: -2.5).animate(animationController)
    //   ..addListener(() {
    //     setState(() {});
    //   });

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
            child: Transform(
              transform: Matrix4.translationValues(0.0, 90.0, 0.0),
              child: Container(
                width: 280.0,
                height: 280.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment(0.0, 1.0),
            child: RadialPosition(
              child: Transform(
                transform: Matrix4.translationValues(0.0,
                    10.0 + (140.0 * (1.0 - (sunAngleRelative / 90.0))), 0.0),
                child: SunUI(),
              ),
              radius: 140.0,
              angle: animation_y.value + (2 * pi * (dayPercent - 0.25)),
            ),
          ),
          Container(
            alignment: Alignment(0.0, 1.0),
            child: Container(
              color: Colors.white30,
              height: 67.5,
            ),
          ),
        ],
      ),
    );
  }
}
