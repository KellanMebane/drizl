import 'dart:math';

import 'package:flutter/services.dart';

class SunCalc {
  final double longitude;
  final double latitude;
  double sunRise;
  double sunSet;
  double julianTime;

  SunCalc(this.sunRise, this.sunSet, this.julianTime,
      {this.longitude, this.latitude});

  static SunCalc now({double longitude, double latitude}) {
    int _julianDay;
    double _numberDaysSince2000;
    double _meanSolarNoon;
    double _meanSolarAnomaly;
    double _equationOfTheCenter;
    double _eclipticLongitude;
    double _solarTransit;
    double _declinationOfTheSun;
    double _hourAngle;
    double _radConvert = 0.0174532925;
    double _degConvert = 57.2958;

    _julianDay =
        ((DateTime.now().millisecondsSinceEpoch / 86400000) + 2440587.5)
            .floor();

    _numberDaysSince2000 = _julianDay - 2451545.0 + 0.0008;

    _meanSolarNoon = _numberDaysSince2000 - longitude / 360.0;

    _meanSolarAnomaly = (357.5291 + 0.98560028 * _meanSolarNoon) % 360.0;

    _equationOfTheCenter = 1.9148 * sin(_meanSolarAnomaly * _radConvert) +
        0.0200 * sin(2.0 * _meanSolarAnomaly * _radConvert) +
        0.0003 * sin(3.0 * _meanSolarAnomaly * _radConvert);

    _eclipticLongitude =
        (_meanSolarAnomaly + _equationOfTheCenter + 180.0 + 102.9372) % 360.0;

    _solarTransit = 2451545.0 +
        _meanSolarNoon +
        0.0053 * sin(_meanSolarAnomaly * _radConvert) -
        0.0069 * sin(2.0 * _eclipticLongitude * _radConvert);

    _declinationOfTheSun =
        asin(sin(_eclipticLongitude * _radConvert) * sin(23.44 * _radConvert));

    _hourAngle = acos((sin(-0.83 * _radConvert) -
            sin(latitude * _radConvert) * sin(_declinationOfTheSun)) /
        (cos(latitude * _radConvert) * cos(_declinationOfTheSun)));

    return SunCalc(
        _solarTransit - ((_hourAngle * _degConvert) / 360.0),
        _solarTransit + ((_hourAngle * _degConvert) / 360.0),
        ((DateTime.now().millisecondsSinceEpoch / 86400000) + 2440587.5));
  }
}
