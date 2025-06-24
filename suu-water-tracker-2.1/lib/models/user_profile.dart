class UserProfile {
  final String gender; // "male" veya "female"
  final int age;
  final double weight; // kilogram
  String? photoPath;

  UserProfile({
    required this.age,
    required this.weight,
    required this.gender,
    this.photoPath,
  });

  Map<String, dynamic> toMap() => {
    'age': age,
    'weight': weight,
    'gender': gender,
    'photoPath': photoPath,
  };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
    age: map['age'] ?? 0,
    weight: (map['weight'] ?? 0).toDouble(),
    gender: map['gender'] ?? 'other',
    photoPath: map['photoPath'],
  );

  double get dailyWaterGoal {
    if (gender == "male") {
      return weight * 35; // ml
    } else {
      return weight * 31; // ml
    }
  }
}