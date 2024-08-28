// ignore_for_file: file_names

class CreateJobModel {
  final String jobId;
  final String clientId;
  final String title;
  final String description;
  final String price;
  final String status;
  final String location;
  final dynamic createdOn;
  final String category;
  final String duration;

  CreateJobModel({
    required this.jobId,
    required this.clientId,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.createdOn,
    required this.location,
    required this.category,
    required this.duration
  });

  // Serialize the CreateServiceModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'clientId': clientId,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
      'createdOn': createdOn,
      'location':location,
      'category':category,
      'duration':duration,
    };
  }

  // Create a CreateServiceModel instance from a JSON map
  factory CreateJobModel.fromMap(Map<String, dynamic> json) {
    return CreateJobModel(
      jobId: json['jobId'],
      clientId: json['clientId'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      status: json['status'],
      createdOn: json['createdOn'],
      location: json['location'],
      category: json['category'],
      duration:json['duration']
    );
  }
}
