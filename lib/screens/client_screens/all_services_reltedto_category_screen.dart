import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/get_lawyer_services_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/see_lawyer_profile.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';
import 'package:law_education_app/widgets/see_more_text.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/check_already_service_buy.dart';

class AllServicesRelatedToCategory extends StatefulWidget {
  final String categoryName;
  final String url;
  const AllServicesRelatedToCategory({super.key, required this.categoryName,required this.url});

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
        backgroundColor: primaryColor,
        title: Text('Services in ${widget.categoryName}', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: getLawyerServicesController.getAllServicesWithLawyerDetails(),
        builder: (BuildContext context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }  if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }  if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No services available', style: TextStyle(fontSize: 16)));
          } else {
            // List of all documents
            List<Map<String, dynamic>> allDocuments = snapshot.data!;

// Filter documents based on the category in 'serviceDetails'
            List<Map<String, dynamic>> filteredDocuments = allDocuments.where((doc) {
              // Check if 'serviceDetails' is present and 'category' matches
              return doc['serviceDetails'] != null &&
                  doc['serviceDetails']['category'] == widget.categoryName;
            }).toList();

// 'filteredDocuments' will now contain only those documents where 'category' matches 'widget.category'

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
                  var service = filteredDocuments[index]['serviceDetails'] as Map<String, dynamic>;
                  var lawyer = filteredDocuments[index]['lawyerDetails'] as Map<String, dynamic>;

                  final check = CheckAlreadyServiceBuy();
                  return FutureBuilder<bool>(
                    future: check.checkAlreadyService(service['lawyerId'], service['serviceId']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),

                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 20,
                                    color: Colors.grey[100],  // Placeholder for title shimmer
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    height: 14,
                                    color: Colors.grey[300],  // Placeholder for description shimmer
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 14,
                                        color: Colors.grey[300],  // Placeholder for location shimmer
                                      ),
                                      Container(
                                        width: 50,
                                        height: 16,
                                        color: Colors.grey[300],  // Placeholder for price shimmer
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    height: 40,
                                    color: Colors.grey[300],  // Placeholder for button shimmer
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                      }

                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      bool alreadyget = snapshot.data ?? false;
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
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Row(
                                    children: [
                                      Text(
                                        lawyer['name'] ?? '??',
                                        style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(width: 15,),
                                      InkWell(
                                          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeLawyerProfile(lawyer: lawyer)));},
                                          child: Text("View Profile",style: TextStyle(color: primaryColor,fontSize: 12,decoration: TextDecoration.underline,decorationColor: primaryColor),))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: yellowColor,
                                        ),
                                        Text(
                                          lawyer['rating'] ?? '0.0',
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                                InkWell(onTap: () {}, child:  Container(
                                  height: 35, // Increase the size to make the circular image more visible
                                  width: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect( // Clip the image in a circular shape
                                    borderRadius: BorderRadius.circular(17.5), // Half of the width/height to make it circular
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      lawyer['url'],
                                      fit: BoxFit.cover, // This will make sure the image covers the entire circular area
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Divider(),
                          SizedBox(height: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             SeeMoreTextCustom(text: service['title'],                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                             ),
                              const SizedBox(height: 10),
                              SeeMoreTextCustom(text:service["description"],
                                style:  TextStyle(fontSize: 14),),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 200), // Limit the width of the container

                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16, color: primaryColor),
                                        const SizedBox(width: 5),
                                        Flexible(child: Text(service["location"],overflow: TextOverflow.ellipsis,maxLines: 1, style: const TextStyle(fontSize: 14))),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "\$${service["price"]}",overflow: TextOverflow.ellipsis,maxLines: 1,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green,),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                                               alreadyget?Container(
                           margin: EdgeInsets.all(10),
                           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Matches ButtonStyle padding
                           decoration: BoxDecoration(
                             color: primaryColor, // Replace with your color
                             borderRadius: BorderRadius.circular(8),
                           ),
                           child: Center(
                             child: Text(
                               'Requested',
                               style: TextStyle(
                                 color: Colors.white, // Matches ButtonStyle foregroundColor
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           ),
                                               ): Center(
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
                                  color: primaryColor, // Replace with your color
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
                        ],
                      ),
                    ),
                  );});
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
              child: Center(
                child: AlertDialog(
                  contentPadding: EdgeInsets.all(20),
                  backgroundColor: Colors.white,
                  title: Text('Request Service for ${service["title"]}',maxLines: 5,overflow: TextOverflow.ellipsis,),
                  content: SizedBox(
                    width: double.maxFinite, // Ensure content takes full width
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: requestController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your request details',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: priceController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your offered price',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Duration",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity, // Make the container full width
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
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
                            isExpanded: true, // Ensure DropdownButton expands to full width
                            underline: SizedBox(), // Remove underline
                          ),
                        ),
                        if (selectedDuration == "Custom") ...[
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity, // Make the container full width
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextFormField(
                              controller: customDurationController,
                              decoration: const InputDecoration(
                                hintText: "Enter Custom Duration",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        String duration = selectedDuration == "Custom"
                            ? customDurationController.text.trim()
                            : selectedDuration ?? '';
                        final requestDetails = requestController.text;
                        final priceDetails = priceController.text;

                        if (requestDetails.isNotEmpty &&
                            priceDetails.isNotEmpty &&
                            duration.isNotEmpty) {
                          _submitRequest(service, requestDetails, priceDetails, duration);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigationbarClient(selectedIndex: 3),
                            ),
                                (Route<dynamic> route) => false,
                          );
                        } else {
                          CustomSnackbar.showError(
                            context: context,
                            title: "Error sending request",
                            message: "Please fill all the fields",
                          );
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                )
                ,
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
