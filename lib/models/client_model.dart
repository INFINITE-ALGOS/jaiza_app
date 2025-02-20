// ignore_for_file: file_names

class ClientModel{
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final double rating;
  final bool isActive;
  final dynamic createdOn;
  final bool isVerified;
  final String type;
  final String url;



  ClientModel({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.address,
    required this.isActive,
    required this.createdOn,
    required this.rating,
    required this.isVerified,
    required this.type,
    required this.url,

  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id':id,
      'email': email,
      'phone': phone,
      'address':address,
      'isActive': isActive,
      'createdOn': createdOn,
      'rating':rating,
      "isVerified":isVerified,
      "type": type,
      "url":url
    };
  }

  // Create a UserModel instance from a JSON map
  factory ClientModel.fromMap(Map<String, dynamic> json) {
    return ClientModel(
        name: json['name'],
        id: json['id'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        rating: json['rating'],
        isActive: json['isActive'],
        createdOn: json['createdOn'].toString(),
        isVerified: json['isVerified'],
        type: json["type"],
        url:json["url"]

    );
  }
}