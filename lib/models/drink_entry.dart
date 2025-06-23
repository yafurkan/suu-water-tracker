class DrinkEntry {
  final DateTime date;
  final double amount; // ml cinsinden
  final String type;   // "water", "tea", "coffee" vs.
  final double caffeine; // mg cinsinden

  DrinkEntry({
    required this.date,
    required this.amount,
    required this.type,
    required this.caffeine,
  });

  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String(),
    'amount': amount,
    'type': type,
    'caffeine': caffeine,
  };

  factory DrinkEntry.fromMap(Map<String, dynamic> map) => DrinkEntry(
    date: DateTime.parse(map['date']),
    amount: (map['amount'] ?? 0).toDouble(),
    type: map['type'] ?? 'water',
    caffeine: (map['caffeine'] ?? 0).toDouble(),
  );
}