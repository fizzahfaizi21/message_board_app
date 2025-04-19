class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final DateTime registrationDateTime;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.registrationDateTime,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      registrationDateTime: data['registrationDateTime'] != null
          ? DateTime.parse(data['registrationDateTime'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'registrationDateTime': registrationDateTime.toIso8601String(),
    };
  }
}
