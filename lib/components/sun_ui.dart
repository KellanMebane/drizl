import 'package:flutter/material.dart';

class SunUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.clip,
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Opacity(
          opacity: 1.0,
          child: Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              shape: BoxShape.circle,
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              shape: BoxShape.circle,
            ),
          ),
        ),
        Opacity(
          opacity: 0.2,
          child: Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
