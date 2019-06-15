import 'dart:math';

// sun calculations are based on http://aa.quae.nl/en/reken/zonpositie.html formulas

const int dayMs = 1000 * 60 * 60 * 24;
const int julian1970 = 2440588;
const int julian2000 = 2451545;

double rad = pi / 180;

// date/time constants and conversions

double toJulian(DateTime date) {
  return date.millisecondsSinceEpoch / dayMs - 0.5 + julian1970;
}

DateTime fromJulian(double julian) {
  return DateTime.fromMillisecondsSinceEpoch(
      (julian + 0.5 - julian1970) * dayMs as int);
}

double toDays(DateTime date) {
  return toJulian(date) - julian2000;
}

// general calculations for position

double e = rad * 23.4397;

double rightAscension(double l, double b) {
  return atan2(sin(l) * cos(e) - tan(b) * sin(e), cos(l));
}

double declination(double l, double b) {
  return asin(sin(b) * cos(e) + cos(b) * sin(e) * sin(l));
}

double azimuth(double h, double phi, double dec) {
  return atan2(sin(h), cos(h) * sin(phi) - tan(dec) * cos(phi));
}

double altitude(double h, double phi, double dec) {
  return asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(h));
}

double siderealTime(double d, double lw) {
  return rad * (280.16 + 360.9856235 * d) - lw;
}

double astroRefraction(double h) {
  if (h < 0) // the following formula works for positive altitudes only.
    h = 0; // if h = -0.08901179 a div/0 would occur.

  // formula 16.4 of "Astronomical Algorithms" 2nd edition by Jean Meeus (Willmann-Bell, Richmond) 1998.
  // 1.02 / tan(h + 10.26 / (h + 5.10)) h in degrees, result in arc minutes -> converted to rad:
  return 0.0002967 / tan(h + 0.00312536 / (h + 0.08901179));
}

// general sun calculations

double solarMeanAnomaly(double d) {
  return rad * (357.5291 + 0.98560028 * d);
}

double eclipticLongitude(double m) {
  double c = rad *
      (1.9148 * sin(m) +
          0.02 * sin(2 * m) +
          0.0003 * sin(3 * m)); // equation of center

  double p = rad * 102.9372; // perihelion of the Earth

  return m + c + p + pi;
}

class SunCoord {
  double declination;
  double rightAscension;

  SunCoord({this.declination, this.rightAscension});
}

SunCoord sunCoords(double d) {
  double m = solarMeanAnomaly(d);
  double l = eclipticLongitude(m);

  return SunCoord(
      declination: declination(l, 0), rightAscension: rightAscension(l, 0));
}

class SunPos {
  double azimuth;
  double altitude;

  SunPos({this.altitude, this.azimuth});
}

SunPos getSunPosition(DateTime date, double lat, double lng) {
  double lw = rad * -lng;
  double phi = rad * lat;
  double d = toDays(date);

  SunCoord c = sunCoords(d);
  double h = siderealTime(d, lw) - c.rightAscension;

  return SunPos(
      altitude: altitude(h, phi, c.declination),
      azimuth: azimuth(h, phi, c.declination));
}
