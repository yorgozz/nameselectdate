class UserInfo {
  String userId;
  String firstName;
  String lastName;
  DateTime dateOfBirth;

  UserInfo({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      userId: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
    );
  }
}
