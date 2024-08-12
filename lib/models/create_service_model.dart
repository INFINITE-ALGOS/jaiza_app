// ignore_for_file: file_names

class CreateServiceModel {
  final String serviceId;
  final String clientId;
  final String title;
  final String description;
  final String price;
  final String serviceStatus;
  final String location;
  final dynamic createdOn;
  final String category;

  CreateServiceModel({
    required this.serviceId,
    required this.clientId,
    required this.title,
    required this.description,
    required this.price,
    required this.serviceStatus,
    required this.createdOn,
    required this.location,
    required this.category
  });

  // Serialize the CreateServiceModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'clientId': clientId,
      'title': title,
      'description': description,
      'price': price,
      'serviceStatus': serviceStatus,
      'createdOn': createdOn,
      'location':location,
      'category':category
    };
  }

  // Create a CreateServiceModel instance from a JSON map
  factory CreateServiceModel.fromMap(Map<String, dynamic> json) {
    return CreateServiceModel(
      serviceId: json['serviceId'],
      clientId: json['clientId'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      serviceStatus: json['serviceStatus'],
      createdOn: json['createdOn'],
      location: json['location'],
      category: json['category']
    );
  }
}
