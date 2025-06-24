import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gen_l10n/app_localizations.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';
import '../models/drink_entry.dart';
import '../utils/drink_storage.dart';

class WaterTrackerScreen extends StatefulWidget {
  final VoidCallback onSettingsPressed;
  const WaterTrackerScreen({Key? key, required this.onSettingsPressed}) : super(key: key);

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int _waterConsumed = 0;
  int _dailyGoal = 2000;
  int _caffeineConsumed = 0;
  final int _dailyCaffeineLimit = 400;

  void _addWater() async {
    setState(() {
      _waterConsumed += 200;
    });
    // DrinkEntry kaydı ekle
    final entry = DrinkEntry(
      date: DateTime.now(),
      amount: 200,
      type: 'water',
      caffeine: 0,
    );
    await DrinkStorage.addEntry(entry);
  }

  void _addDrink(String type) async {
    int caffeine = 0;
    if (type == 'coffee') {
      caffeine = 95;
    } else if (type == 'tea') {
      caffeine = 47;
    }
    setState(() {
      _waterConsumed += 200;
      _caffeineConsumed += caffeine;
    });
    // DrinkEntry kaydı ekle
    final entry = DrinkEntry(
      date: DateTime.now(),
      amount: 200,
      type: type,
      caffeine: caffeine.toDouble(),
    );
    await DrinkStorage.addEntry(entry);
  }

  void _showDrinkOptions() {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.local_cafe),
            title: Text(loc.coffee),
            onTap: () {
              Navigator.pop(context);
              _addDrink('coffee');
            },
          ),
          ListTile(
            leading: const Icon(Icons.emoji_food_beverage),
            title: Text(loc.tea),
            onTap: () {
              Navigator.pop(context);
              _addDrink('tea');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final waterProgress = _waterConsumed / _dailyGoal;
    final caffeineProgress = _caffeineConsumed / _dailyCaffeineLimit;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ayarlar',
            onPressed: widget.onSettingsPressed,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: loc.profile,
            onPressed: () async {
              // Profil ekranına geçiş
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              if (updated == true) setState(() {}); // Profil güncellendiğinde verileri yenile
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: loc.reset,
            onPressed: () {
              setState(() {
                _waterConsumed = 0;
                _caffeineConsumed = 0;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(loc.dailyGoal, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(value: waterProgress, strokeWidth: 12),
                  Text('$_waterConsumed / $_dailyGoal ml'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Günlük Kafein Takip', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(value: caffeineProgress, strokeWidth: 12, color: Colors.brown),
                  Text('$_caffeineConsumed / $_dailyCaffeineLimit mg'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ElevatedButton(onPressed: _addWater, child: Text(loc.addWater)),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _showDrinkOptions, child: Text(loc.addDrinkButton)),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                      );
                    },
                    child: Text(loc.statistics),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final entry = DrinkEntry(
                        date: DateTime.now(),
                        amount: 200,
                        type: 'tea',
                        caffeine: 40,
                      );
                      await DrinkStorage.addEntry(entry);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('İçecek kaydedildi!')),
                      );
                    },
                    child: const Text('Çay Ekle'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
