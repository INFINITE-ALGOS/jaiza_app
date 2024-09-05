// ignore_for_file: file_names

class LawyerModel{
  final String name;
  final String email;
  final String phone;
  final String rating;
  final bool isActive;
  final dynamic createdOn;
  final bool isVerified;
  final String type;
  final String url;
  final Map<String,dynamic> lawyerProfile;
  final List<Map<String,dynamic>> portfolio;
  String address;



  LawyerModel({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.isActive,
    required this.createdOn,
    required this.rating,
    required this.portfolio,
    required this.lawyerProfile,

    required this.isVerified,
    required this.type,
    required this.url,

  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'address':address,
      'phone': phone,
      'lawyerProfile':lawyerProfile,
      'portfolio':portfolio,
      'isActive': isActive,
      'createdOn': createdOn,
      'rating':rating,
      "isVerified":isVerified,
      "type": type,
      "url":url



    };
  }

  // Create a UserModel instance from a JSON map
  factory LawyerModel.fromMap(Map<String, dynamic> json) {
    return LawyerModel(
        name: json['name'],
        portfolio: json['portfolio'],
        lawyerProfile: json['lawyerProfile'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        rating: json['rating'],
        isActive: json['isActive'],
        createdOn: json['createdOn'].toString(),
        isVerified: json['isVerified'],
        type: json["type"],
        url: json["url"],

    );
  }
}