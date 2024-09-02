import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/get_lawyer_services_controller.dart';
import 'package:law_education_app/conts.dart';

class AllServicesRelatedToCategory extends StatefulWidget {
  final String categoryName;
  const AllServicesRelatedToCategory({super.key, required this.categoryName});

  @override
  State<AllServicesRelatedToCategory> createState() => _AllServicesRelatedToCategoryState();
}

class _AllServicesRelatedToCategoryState extends State<AllServicesRelatedToCategory> {
  @override
  Widget build(BuildContext context) {
    GetLawyerServicesController getLawyerServicesController = GetLawyerServicesController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text('Services in ${widget.categoryName}', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: getLawyerServicesController.getLawyerServicesMethod(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No services available', style: TextStyle(fontSize: 16)));
          } else {
            List<DocumentSnapshot> filteredDocuments = snapshot.data!.docs
                .where((doc) => doc['category'] == widget.categoryName)
                .toList();

            if (filteredDocuments.isEmpty) {
              return const Center(
                child: Text(
                  "No current Services found",
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: filteredDocuments.length,
                itemBuilder: (context, index) {
                  var service = filteredDocuments[index].data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service["title"],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            service["description"],
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: primaryColor),
                                  const SizedBox(width: 5),
                                  Text(service["location"], style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                              Text(
                                "\$${service["price"]}",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              _showRequestDialog(context, service);
                            },
                            child: const Text('Request Service'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  void _showRequestDialog(BuildContext context, Map<String, dynamic> service) {
    final TextEditingController requestController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request Service for ${service["title"]}'),
          content: TextField(
            controller: requestController,
            decoration: const InputDecoration(hintText: 'Enter your request details'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final requestDetails = requestController.text;
                if (requestDetails.isNotEmpty) {
                  _submitRequest(service, requestDetails);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitRequest(Map<String, dynamic> service, String requestDetails) async {
    // Add request to Firestore
    DocumentReference docRef = FirebaseFirestore.instance.collection("requests").doc();
    String docId = docRef.id;
    await docRef.set({
      'requestId':docId,
      'serviceId': service['serviceId'],
      'serviceTitle': service['title'],
      'requestDetails': requestDetails,
      'clientId':FirebaseAuth.instance.currentUser!.uid,
      'lawyerId':service['lawyerId'],
      'requestTimestamp': Timestamp.now(),
      'status':"pending",
      "type":"service"
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request submitted for ${service["title"]}: $requestDetails'),
      ),
    );
  }
}
