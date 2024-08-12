// ignore_for_file: file_names

class UserModel {
  final String uId;
  final String username;
  final String email;
  final String phone;
  final String userType;
  final bool isActive;
  final dynamic createdOn;
  final bool isVerified;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.createdOn,
    required this.isVerified,
    required this.userType
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'isActive': isActive,
      'createdOn': createdOn,
      "isVerified":isVerified,
      'userType':userType
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
        uId: json['uId'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
       userType: json['userType'],
        isActive: json['isActive'],
        createdOn: json['createdOn'].toString(),
        isVerified: json['isVerified']
    );
  }
}