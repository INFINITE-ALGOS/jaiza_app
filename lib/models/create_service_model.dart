// ignore_for_file: file_names

class CreateServiceModel {
  final String serviceId;
  final String lawyerId;
  final String title;
  final String description;
  final String price;
  final String status;
  final String location;
  final dynamic createdOn;
  final String category;

  CreateServiceModel({
    required this.serviceId,
    required this.lawyerId,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.createdOn,
    required this.location,
    required this.category
  });

  // Serialize the CreateServiceModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'lawyerId': lawyerId,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
      'createdOn': createdOn,
      'location':location,
      'category':category
    };
  }

  // Create a CreateServiceModel instance from a JSON map
  factory CreateServiceModel.fromMap(Map<String, dynamic> json) {
    return CreateServiceModel(
        serviceId: json['serviceId'],
        lawyerId: json['lawyerId'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        status: json['status'],
        createdOn: json['createdOn'],
        location: json['location'],
        category: json['category']
    );
  }
}
