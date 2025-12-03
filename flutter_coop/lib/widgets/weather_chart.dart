import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeatherChart extends StatelessWidget {
  final List<String> times;
  final List<double> temps;

  const WeatherChart({super.key, required this.times, required this.temps});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: temps.reduce((a, b) => a < b ? a : b) - 1,
        maxY: temps.reduce((a, b) => a > b ? a : b) + 1,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              temps.length,
              (i) => FlSpot(i.toDouble(), temps[i]),
            ),
            isCurved: true,
            barWidth: 3,
            color: Colors.blue,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
