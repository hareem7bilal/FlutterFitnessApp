import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime? dob; // Optional
  final String? gender; // Optional
  final double? weight; // Optional
  final double? height; // Optional

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.dob, // Optional
    this.gender, // Optional
    this.weight, // Optional
    this.height, // Optional
  });

  Map<String, Object?> toDocument() {
    // Handle DateTime serialization if your database expects a specific format (e.g., timestamp)
    // This example serializes `dob` as an ISO8601 String, but adjust based on your database requirements.
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'height': height,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      firstName: doc['firstName'] as String,
      lastName: doc['lastName'] as String,
      dob: doc['dob'] != null
          ? DateTime.tryParse(doc['dob'] as String)
          : null, // Assuming 'dob' is stored as an ISO8601 String
      gender: doc['gender'] as String?,
      weight: (doc['weight'] as num?)?.toDouble(),
      height: (doc['height'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props =>
      [id, email, firstName, lastName, dob, gender, weight, height];

  @override
  String toString() => '''UserEntity: (
  id: $id,
  email: $email,
  firstName: $firstName,
  lastName: $lastName,
  dob: ${dob?.toIso8601String()},
  gender: $gender,
  weight: $weight,
  height: $height
)''';
}
