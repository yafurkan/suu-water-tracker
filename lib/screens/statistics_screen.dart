import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/drink_storage.dart';
import '../models/drink_entry.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<double> weeklyWater = List.filled(7, 0);
  List<double> weeklyCaffeine = List.filled(7, 0); // <-- EKLE

  @override
  void initState() {
    super.initState();
    _loadWeeklyData();
  }

  Future<void> _loadWeeklyData() async {
    final entries = await DrinkStorage.loadEntries();
    final now = DateTime.now();
    List<double> tempWater = List.filled(7, 0);
    List<double> tempCaffeine = List.filled(7, 0);

    for (var entry in entries) {
      int diff = now.difference(DateTime(entry.date.year, entry.date.month, entry.date.day)).inDays;
      if (diff >= 0 && diff < 7) {
        if (entry.type == 'water') {
          tempWater[6 - diff] += entry.amount;
        }
        tempCaffeine[6 - diff] += entry.caffeine;
      }
    }
    setState(() {
      weeklyWater = tempWater;
      weeklyCaffeine = tempCaffeine;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  maxY: (weeklyWater.reduce((a, b) => a > b ? a : b) + 500).clamp(1000, 4000),
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
                    weeklyWater.length,
                    (i) => BarChartGroupData(x: i, barRods: [
                      BarChartRodData(toY: weeklyWater[i], width: 16),
                    ]),
                  ),
                  gridData: FlGridData(show: true, horizontalInterval: 500),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Haftalık Kafein Tüketimi (mg)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: (weeklyCaffeine.reduce((a, b) => a > b ? a : b) + 50).clamp(100, 500),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 50),
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
                    weeklyCaffeine.length,
                    (i) => BarChartGroupData(x: i, barRods: [
                      BarChartRodData(toY: weeklyCaffeine[i], width: 16, color: Colors.brown),
                    ]),
                  ),
                  gridData: FlGridData(show: true, horizontalInterval: 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
