import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SkyBackground extends StatefulWidget {
  @override
  State<SkyBackground> createState() => SkyBackgroundState();
}

class SkyBackgroundState extends State<SkyBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 0.6, 0.8, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.lightBlue[400],
            Colors.lightBlue[300],
            Colors.lightBlue[200],
            Colors.lightBlue[100],
          ],
        ),
      ),
    );
  }
}
