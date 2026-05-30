// lib/data/models/user_profile.dart

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final bool darkMode;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.darkMode,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'darkMode': darkMode ? 1 : 0,
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        phone: map['phone'] as String? ?? '',
        darkMode: (map['darkMode'] as int? ?? 0) == 1,
      );

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    bool? darkMode,
  }) =>
      UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        darkMode: darkMode ?? this.darkMode,
      );

  static UserProfile get defaultProfile => UserProfile(
        name: 'Jean Dupont',
        email: 'jean.dupont@email.com',
        phone: '0600000000',
        darkMode: false,
      );
}
