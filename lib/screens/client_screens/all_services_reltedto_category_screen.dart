import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/get_lawyer_services_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';

class AllServicesRelatedToCategory extends StatefulWidget {
  final String categoryName;
  const AllServicesRelatedToCategory({super.key, required this.categoryName});

  @override
  State<AllServicesRelatedToCategory> createState() => _AllServicesRelatedToCategoryState();
}

class _AllServicesRelatedToCategoryState extends State<AllServicesRelatedToCategory> {
  final TextEditingController requestController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController customDurationController = TextEditingController();
  String? selectedDuration;
  List<String> durationOptions = [
    "1 day",
    "1 week",
    "1 month",
    "1 year",
    "Custom"
  ];
  @override
  Widget build(BuildContext context) {
    GetLawyerServicesController getLawyerServicesController = GetLawyerServicesController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: blueColor,
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
                                  const Icon(Icons.location_on, size: 16, color: blueColor),
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
                      Center(
                        child: InkWell(
                          onTap: ()  {
                            // Show the request dialog and await its completion
                             _showRequestDialog(context, service);

                            // Navigate to BottomNavigationbarClient after the dialog is handled

                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Matches ButtonStyle padding
                            decoration: BoxDecoration(
                              color: blueColor, // Replace with your color
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Request Service',
                                style: TextStyle(
                                  color: Colors.white, // Matches ButtonStyle foregroundColor
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text('Request Service for ${service["title"]}'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: requestController,
                      decoration: const InputDecoration(
                          hintText: 'Enter your request details'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration: const InputDecoration(
                          hintText: 'Enter your offered price'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Duration",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black),
                            ),
                            child: DropdownButton<String>(
                              value: selectedDuration,
                              items: durationOptions.map((String duration) {
                                return DropdownMenuItem<String>(
                                  value: duration,
                                  child: Text(duration),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDuration = newValue;
                                });
                              },
                              hint: const Text("Select Duration"),
                              underline: SizedBox(), // Remove underline
                            ),
                          ),
                          if (selectedDuration == "Custom") ...[
                            SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black),
                              ),
                              child: TextFormField(
                                controller: customDurationController,
                                decoration: const InputDecoration(
                                    hintText: "Enter Custom Duration",
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
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
                      String duration = selectedDuration == "Custom"
                          ? customDurationController.text.trim()
                          : selectedDuration!;
                      final requestDetails = requestController.text;
                      final priceDetails = priceController.text;

                      if (requestDetails.isNotEmpty && priceDetails.isNotEmpty && duration.isNotEmpty) {
                        _submitRequest(service, requestDetails, priceDetails,duration);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationbarClient(selectedIndex: 3)),
                              (Route<dynamic> route) => false,
                        );
                      }
                      else{
                        CustomSnackbar.showError(context: context, title: "Error sending request", message: "PLease fill all the fields");
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submitRequest(Map<String, dynamic> service, String requestDetails,String priceDetails,String duration) async {
    // Add request to Firestore
    DocumentReference docRef = FirebaseFirestore.instance.collection("requests").doc();
    String docId = docRef.id;
    await docRef.set({
      'requestId':docId,
      'duration':duration,
      'serviceId': service['serviceId'],
      //'serviceTitle': service['title'],
      'requestMessage': requestDetails,
      'clientId':FirebaseAuth.instance.currentUser!.uid,
      'lawyerId':service['lawyerId'],
      'requestTimestamp': Timestamp.now(),
      'status':"pending",
      'requestAmount':priceDetails
     // "type":"service"
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request submitted for ${service["title"]}: $requestDetails'),
      ),
    );
  }
}
