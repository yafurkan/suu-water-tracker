import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = [1200.0, 1500.0, 1700.0, 1600.0, 1800.0, 2000.0, 1900.0];
    const days = ['Pzt','Sal','Çar','Per','Cum','Cmt','Paz'];

    return Scaffold(
      appBar: AppBar(title: const Text('İstatistikler'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Haftalık Su Tüketimi (ml)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 2200,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 500),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            Text(days[value.toInt()]),
                        interval: 1,
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    data.length,
                    (i) => BarChartGroupData(x: i, barRods: [
                      BarChartRodData(toY: data[i], width: 16),
                    ]),
                  ),
                  gridData: FlGridData(show: true, horizontalInterval: 500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
