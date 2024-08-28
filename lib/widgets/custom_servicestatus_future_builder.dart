import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../conts.dart';

class CustomServiceStreamBuilder extends StatefulWidget {
  final String serviceStatus;
  const CustomServiceStreamBuilder({super.key, required this.serviceStatus});

  @override
  State<CustomServiceStreamBuilder> createState() =>
      _CustomServiceStreamBuilderState();
}

class _CustomServiceStreamBuilderState
    extends State<CustomServiceStreamBuilder> {
  Stream<List<Map<String, dynamic>>> _fetchData() async* {
    var querySnapshot = FirebaseFirestore.instance
        .collection('requests')
        .where('lawyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: widget.serviceStatus)
        .snapshots();

    await for (var requestsSnapshot in querySnapshot) {
      List<Map<String, dynamic>> requestsWithClientDetails = [];
      for (var servicesDoc in requestsSnapshot.docs) {
        var requestData = servicesDoc.data();
        String? clientId = requestData['clientId'] as String?;
        String? serviceId = requestData['serviceId'] as String?;

        if (clientId != null && serviceId != null) {
          var clientSnapshot = await FirebaseFirestore.instance
              .collection('clients')
              .doc(clientId)
              .get();
          var clientData = clientSnapshot.data();

          var serviceSnapshot = await FirebaseFirestore.instance
              .collection('services')
              .doc(serviceId)
              .get();
          var serviceData = serviceSnapshot.data();

          requestsWithClientDetails.add({
            'requestDetails': requestData as Map<String, dynamic>,
            'serviceDetails': serviceData ?? <String, dynamic>{},
            'clientDetails': clientData ?? <String, dynamic>{},
          });
        }
      }
      yield requestsWithClientDetails;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _fetchData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No requests available',
                style: TextStyle(fontSize: 16)),
          );
        } else {
          List<Map<String, dynamic>> filteredDocuments = snapshot.data!;
          return ListView.builder(
            itemCount: filteredDocuments.length,
            itemBuilder: (context, index) {
              var serviceDetails = filteredDocuments[index]['serviceDetails'] ?? {};
              var requestDetails = filteredDocuments[index]['requestDetails'] ?? {};
              var clientDetails = filteredDocuments[index]['clientDetails'] ?? {};

              return Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFf1f1f2), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      serviceDetails["title"] ?? 'No title',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      serviceDetails["description"] ?? 'No description',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.serviceStatus,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "\$ ${requestDetails['requestDetails'] ?? '0'}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(thickness: 1.5),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      clientDetails['name'] ?? 'Unknown Client',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      clientDetails['rating'] ?? 'No rating',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: const CircleAvatar(
                                radius: 20,
                                // Background image can be added here
                              ),
                            ),
                          ],
                        ),
                        // Adding the Accept button
                        const SizedBox(height: 10),
                        if (widget.serviceStatus == 'pending')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  DocumentReference docReference =
                                  FirebaseFirestore.instance
                                      .collection('requests')
                                      .doc(requestDetails['requestId']);
                                  await docReference
                                      .update({"status": "accepted"});
                                },
                                child: Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DocumentReference docReference =
                                  FirebaseFirestore.instance
                                      .collection('requests')
                                      .doc(requestDetails['requestId']);
                                  await docReference
                                      .update({"status": "rejected"});
                                },
                                child: Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (widget.serviceStatus == 'accepted')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  DocumentReference docReference =
                                  FirebaseFirestore.instance
                                      .collection('requests')
                                      .doc(requestDetails['requestId']);
                                  await docReference
                                      .update({"status": "completed"});
                                },
                                child: Container(
                                  height: 30,
                                  width: 190,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Mark as completed',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: whiteColor,
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
                ],
              );
            },
          );
        }
      },
    );
  }
}
