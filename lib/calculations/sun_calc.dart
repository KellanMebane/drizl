import 'dart:math';

import 'package:flutter/services.dart';

class SunCalc {
  final double longitude;
  final double latitude;
  double sunRise;
  double sunSet;
  double julianTime;
  int julianDay;
  double numberDaysSince2000;
  double meanSolarNoon;
  double meanSolarAnomaly;
  double equationOfTheCenter;
  double eclipticLongitude;
  double solarTransit;
  double declinationOfTheSun;
  double hourAngle;
  double preciseDaysSince2000;

  SunCalc({this.latitude, this.longitude}) {
    double radConvert = 0.0174532925;
    double degConvert = 57.2958;
    julianTime =
        ((DateTime.now().millisecondsSinceEpoch / 86400000) + 2440587.5);
    julianDay = julianTime.floor();

    numberDaysSince2000 = julianDay - 2451545.0 + 0.0008;
    preciseDaysSince2000 = julianTime - 2451545.0 + 0.0008;

    meanSolarNoon = numberDaysSince2000 - longitude / 360.0;

    meanSolarAnomaly = (357.5291 + 0.98560028 * meanSolarNoon) % 360.0;

    equationOfTheCenter = 1.9148 * sin(meanSolarAnomaly * radConvert) +
        0.0200 * sin(2.0 * meanSolarAnomaly * radConvert) +
        0.0003 * sin(3.0 * meanSolarAnomaly * radConvert);

    eclipticLongitude =
        (meanSolarAnomaly + equationOfTheCenter + 180.0 + 102.9372) % 360.0;

    solarTransit = 2451545.0 +
        meanSolarNoon +
        0.0053 * sin(meanSolarAnomaly * radConvert) -
        0.0069 * sin(2.0 * eclipticLongitude * radConvert);

    declinationOfTheSun =
        asin(sin(eclipticLongitude * radConvert) * sin(23.44 * radConvert));

    hourAngle = acos((sin(-0.83 * radConvert) -
            sin(latitude * radConvert) * sin(declinationOfTheSun)) /
        (cos(latitude * radConvert) * cos(declinationOfTheSun)));

    sunRise = solarTransit - ((hourAngle * degConvert) / 360.0);
    sunSet = solarTransit + ((hourAngle * degConvert) / 360.0);
  }
}
