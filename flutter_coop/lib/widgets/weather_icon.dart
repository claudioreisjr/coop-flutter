import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherIcon extends StatelessWidget {
  final double temp;

  const WeatherIcon({super.key, required this.temp});

  @override
  Widget build(BuildContext context) {
    IconData icon;

    if (temp >= 30) {
      icon = WeatherIcons.hot;
    } else if (temp >= 20) {
      icon = WeatherIcons.day_sunny;
    } else if (temp >= 10) {
      icon = WeatherIcons.cloud;
    } else {
      icon = WeatherIcons.snow;
    }

    return BoxedIcon(
      icon,
      size: 60,
      color: Colors.blue,
    );
  }
}
