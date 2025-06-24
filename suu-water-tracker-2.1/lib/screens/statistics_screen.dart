import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/drink_storage.dart';
import '../models/drink_entry.dart';

enum StatsRange { daily, weekly, monthly }

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<double> weeklyWater = List.filled(7, 0);
  List<double> weeklyCaffeine = List.filled(7, 0);
  List<double> monthlyWater = List.filled(30, 0);
  List<double> dailyWater = List.filled(24, 0);
  List<double> monthlyCaffeine = List.filled(30, 0);
  List<double> dailyCaffeine = List.filled(24, 0);
  StatsRange _selectedRange = StatsRange.weekly;

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

  Future<void> _loadMonthlyData() async {
    final entries = await DrinkStorage.loadEntries();
    final now = DateTime.now();
    List<double> tempWater = List.filled(30, 0);
    List<double> tempCaffeine = List.filled(30, 0);

    for (var entry in entries) {
      int diff = now.difference(DateTime(entry.date.year, entry.date.month, entry.date.day)).inDays;
      if (diff >= 0 && diff < 30) {
        if (entry.type == 'water') {
          tempWater[29 - diff] += entry.amount;
        }
        tempCaffeine[29 - diff] += entry.caffeine;
      }
    }
    setState(() {
      monthlyWater = tempWater;
      monthlyCaffeine = tempCaffeine;
    });
  }

  Future<void> _loadDailyData() async {
    final entries = await DrinkStorage.loadEntries();
    final now = DateTime.now();
    List<double> tempWater = List.filled(24, 0);
    List<double> tempCaffeine = List.filled(24, 0);

    for (var entry in entries) {
      if (entry.date.year == now.year &&
          entry.date.month == now.month &&
          entry.date.day == now.day) {
        if (entry.type == 'water') {
          tempWater[entry.date.hour] += entry.amount;
        }
        tempCaffeine[entry.date.hour] += entry.caffeine;
      }
    }
    setState(() {
      dailyWater = tempWater;
      dailyCaffeine = tempCaffeine;
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
            DropdownButton<StatsRange>(
              value: _selectedRange,
              items: const [
                DropdownMenuItem(
                  value: StatsRange.daily,
                  child: Text('Günlük'),
                ),
                DropdownMenuItem(
                  value: StatsRange.weekly,
                  child: Text('Haftalık'),
                ),
                DropdownMenuItem(
                  value: StatsRange.monthly,
                  child: Text('Aylık'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRange = value;
                  });
                  if (value == StatsRange.monthly) {
                    _loadMonthlyData();
                  } else if (value == StatsRange.weekly) {
                    _loadWeeklyData();
                  } else if (value == StatsRange.daily) {
                    _loadDailyData();
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            if (_selectedRange == StatsRange.weekly) ...[
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
            ]
            else if (_selectedRange == StatsRange.monthly) ...[
              const Text(
                'Aylık Su Tüketimi (ml)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: (monthlyWater.reduce((a, b) => a > b ? a : b) + 500).clamp(1000, 4000),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, interval: 500),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) => Text('${value.toInt() + 1}'),
                          interval: 1,
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      monthlyWater.length,
                      (i) => BarChartGroupData(x: i, barRods: [
                        BarChartRodData(toY: monthlyWater[i], width: 16),
                      ]),
                    ),
                    gridData: FlGridData(show: true, horizontalInterval: 500),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Aylık Kafein Tüketimi (mg)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: (monthlyCaffeine.reduce((a, b) => a > b ? a : b) + 50).clamp(100, 500),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, interval: 50),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) => Text('${value.toInt() + 1}'),
                          interval: 1,
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      monthlyCaffeine.length,
                      (i) => BarChartGroupData(x: i, barRods: [
                        BarChartRodData(toY: monthlyCaffeine[i], width: 16, color: Colors.brown),
                      ]),
                    ),
                    gridData: FlGridData(show: true, horizontalInterval: 50),
                  ),
                ),
              ),
            ]
            else if (_selectedRange == StatsRange.daily) ...[
              const Text(
                'Günlük Su Tüketimi (ml)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: (dailyWater.reduce((a, b) => a > b ? a : b) + 50).clamp(100, 500),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, interval: 50),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) => Text('${value.toInt()}:00'),
                          interval: 1,
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      dailyWater.length,
                      (i) => BarChartGroupData(x: i, barRods: [
                        BarChartRodData(toY: dailyWater[i], width: 16),
                      ]),
                    ),
                    gridData: FlGridData(show: true, horizontalInterval: 50),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Günlük Kafein Tüketimi (mg)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: (dailyCaffeine.reduce((a, b) => a > b ? a : b) + 50).clamp(100, 500),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, interval: 50),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) => Text('${value.toInt()}:00'),
                          interval: 1,
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      dailyCaffeine.length,
                      (i) => BarChartGroupData(x: i, barRods: [
                        BarChartRodData(toY: dailyCaffeine[i], width: 16, color: Colors.brown),
                      ]),
                    ),
                    gridData: FlGridData(show: true, horizontalInterval: 50),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
