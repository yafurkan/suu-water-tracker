class UserProfile {
  int age;
  double weight;
  String gender;
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
}