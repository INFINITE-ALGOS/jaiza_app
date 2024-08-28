class LawyerModel{
  final String name;
  final String email;
  final String phone;
  final String rating;
  final bool isActive;
  final dynamic createdOn;
  final bool isVerified;
  final String type;
  final int experience;
  LawyerModel({
    required this.name,
    required this.email,
    required this.experience,
    required this.phone,
    required this.isActive,
    required this.createdOn,
    required this.rating,
    required this.isVerified,
    required this.type,
  });
  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'experience':experience,
      'isActive': isActive,
      'createdOn': createdOn,
      'rating':rating,
      "isVerified":isVerified,
      "type": type,
    };
  }
  // Create a UserModel instance from a JSON map
  factory LawyerModel.fromMap(Map<String, dynamic> json) {
    return LawyerModel(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        rating: json['rating'],
        isActive: json['isActive'],
        createdOn: json['createdOn'].toString(),
        isVerified: json['isVerified'],
        type: json["type"],
      experience: json['experience']
    );
  }
}




