import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/get_client_jobs_controller.dart';
import 'package:law_education_app/conts.dart';

class AllJobsRelatedToCategory extends StatefulWidget {
  final String categoryName;
  const AllJobsRelatedToCategory({super.key, required this.categoryName});

  @override
  State<AllJobsRelatedToCategory> createState() => _AllJobsRelatedToCategoryState();
}

class _AllJobsRelatedToCategoryState extends State<AllJobsRelatedToCategory> {
  @override
  Widget build(BuildContext context) {
    GetClientJobsController getClientJobsController = GetClientJobsController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: blueColor,
        title: Text('Jobs in ${widget.categoryName}', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: getClientJobsController.getClientJobsMethod(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No jobs available', style: TextStyle(fontSize: 16)));
          } else {
            List<DocumentSnapshot> filteredDocuments = snapshot.data!.docs
                .where((doc) => doc['category'] == widget.categoryName)
                .toList();

            if (filteredDocuments.isEmpty) {
              return const Center(
                child: Text(
                  "No current Jobs found",
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: filteredDocuments.length,
                itemBuilder: (context, index) {
                  var job = filteredDocuments[index].data() as Map<String, dynamic>;
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
                            job["title"],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            job["description"],
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
                                  Text(job["location"], style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                              Text(
                                "\$${job["price"]}",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              _showOfferDialog(context, job);
                            },
                            child: const Text('Give Offer'),
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

  void _showOfferDialog(BuildContext context, Map<String, dynamic> job) {
    final TextEditingController offerController = TextEditingController();
    final TextEditingController msgController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Give Offer for ${job["title"]}'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: msgController,
                  decoration: const InputDecoration(hintText: 'Enter your message'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: offerController,
                  decoration: const InputDecoration(hintText: 'Enter your offer amount'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
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
                final offerAmount = offerController.text;
                if (offerAmount.isNotEmpty && msgController.text.isNotEmpty) {
                  _submitOffer(job, offerAmount,msgController.text);
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

  void _submitOffer(Map<String, dynamic> job, String offerAmount, String offerMsg) async {
    // Add offer to Firestore
    DocumentReference docRef = FirebaseFirestore.instance.collection("offers").doc();
    String docId = docRef.id;
    await docRef.set({
      'offerId':docId,
      'jobId': job['jobId'],
      "clientId":job['clientId'],
      //"jobStatus":job['status'],
      "lawyerId":FirebaseAuth.instance.currentUser!.uid,
      'offerAmount': offerAmount,
      'offerTimestamp': Timestamp.now(),
      "status":"pending",
      "offerMessage":offerMsg
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Offer submitted for ${job["title"]}: \$${offerAmount}'),
      ),
    );
  }
}
