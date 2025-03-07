import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesBarChart extends StatelessWidget {
  final List<double> salesData;

  const SalesBarChart({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: List.generate(salesData.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [BarChartRodData(toY: salesData[index])],
          );
        }),
      ),
    );
  }
}
