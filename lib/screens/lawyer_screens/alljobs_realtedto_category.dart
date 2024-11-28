import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/get_client_jobs_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/lawyer_screens/see_client_profile.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/see_more_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/check_already_service_buy.dart';

class AllJobsRelatedToCategory extends StatefulWidget {
  final String name;
  final String url;

  const AllJobsRelatedToCategory(
      {super.key, required this.name, required this.url});

  @override
  State<AllJobsRelatedToCategory> createState() =>
      _AllJobsRelatedToCategoryState();
}

class _AllJobsRelatedToCategoryState extends State<AllJobsRelatedToCategory> {
  List<Map<String, dynamic>> allDocuments=[];
  List<Map<String, dynamic>> filteredDocuments=[];
  bool hasResult=true;
  double screenHeight = 0;
  double screenWidth = 0;
  TextEditingController searchController = TextEditingController();

  void filterDocuments() {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      filteredDocuments = allDocuments.where((document) {
        final title = document['jobDetails']['title'].toLowerCase();
        final titleMatches = title.contains(searchTerm);

        final description = document['jobDetails']['description'].toLowerCase();
        final descriptionMatches = description.contains(searchTerm);
        return titleMatches || descriptionMatches;
      }).toList();
      if(filteredDocuments.isEmpty){
        hasResult=false;
      }
    });
  }


  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterDocuments();
    });
  }
  @override
  Widget build(BuildContext context) {
    GetClientJobsController getClientJobsController = GetClientJobsController();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text('Jobs in ${widget.name}',
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.075,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: lightGreyColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by title or description ...",
                      border: InputBorder.none,
                      icon: const Icon(CupertinoIcons.search, color: greyColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: FutureBuilder(
            future: getClientJobsController.getClientJobsWithDetails(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child:
                    Text('No jobs available', style: TextStyle(fontSize: 16)));
              } else {
                 allDocuments = snapshot.data!
                    .where((doc) => doc['jobDetails']['category'] == widget.name)
                    .where((doc) => doc['jobDetails']['status'] == 'pending')
                    .toList();
                if (allDocuments.isEmpty) {
                  return const Center(
                    child: Text(
                      "No current Jobs found",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  if (filteredDocuments.isEmpty && hasResult==true) {
                    filteredDocuments = allDocuments;
                    return _buildGridView();// Initially, show all lawyers
                  }
                  if (filteredDocuments.isEmpty && hasResult==false) {
                    return Center(child: Text("No matching result found"),);// Initially, show all lawyers
                  }
                  else{
                    return _buildGridView();
                  }
                }
              }
            },
          ),)
        ],
      )
    );
  }

  void _showOfferDialog(BuildContext context, Map<String, dynamic> job) {
    final TextEditingController offerController = TextEditingController();
    final TextEditingController msgController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title: Text(
            'Give Offer for ${job["title"]}',
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          content: Container(
            height: 150,
            child: Column(
              children: [
                TextField(
                  controller: msgController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your message'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: offerController,
                  decoration: const InputDecoration(
                      hintText: 'Enter your offer amount'),
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
              child: const Text(
                'Cancel',
                style: TextStyle(color: primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                final offerAmount = offerController.text;
                if (offerAmount.isNotEmpty && msgController.text.isNotEmpty) {
                  _submitOffer(job, offerAmount, msgController.text);
                  Navigator.of(context).pop();
                }
              },
              child:
                  const Text('Submit', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  void _submitOffer(
      Map<String, dynamic> job, String offerAmount, String offerMsg) async {
    // Add offer to Firestore
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("offers").doc();
    String docId = docRef.id;
    await docRef.set({
      'offerId': docId,
      'jobId': job['jobId'],
      "clientId": job['clientId'],
      //"jobStatus":job['status'],
      "lawyerId": FirebaseAuth.instance.currentUser!.uid,
      'offerAmount': offerAmount,
      'offerTimestamp': Timestamp.now(),
      "status": "pending",
      "offerMessage": offerMsg
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Offer submitted for ${job["title"]}: \$${offerAmount}'),
      ),
    );
  }

  Widget _buildGridView(){
    return ListView.builder(
      itemCount: filteredDocuments.length,
      itemBuilder: (context, index) {
        var job = filteredDocuments[index]['jobDetails']
        as Map<String, dynamic>;
        var client = filteredDocuments[index]['clientDetails']
        as Map<String, dynamic>;

        final check = CheckAlreadyServiceBuy();

        return FutureBuilder(
            future: check.checkAlreadyJobBuy(
                job['clientId'], job['jobId']),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 15),
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
                            color: Colors.grey[
                            100], // Placeholder for title shimmer
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 14,
                            color: Colors.grey[
                            300], // Placeholder for description shimmer
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                height: 14,
                                color: Colors.grey[
                                300], // Placeholder for location shimmer
                              ),
                              Container(
                                width: 50,
                                height: 16,
                                color: Colors.grey[
                                300], // Placeholder for price shimmer
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 40,
                            color: Colors.grey[
                            300], // Placeholder for button shimmer
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
              Map<String, dynamic> offer = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25, vertical: 15),
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
                      Container(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        client['name'] ?? '??',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SeeClientProfile(
                                                            client:
                                                            client)));
                                          },
                                          child: Text(
                                            "View Profile",
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 12,
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                                decorationColor:
                                                primaryColor),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: yellowColor,
                                        ),
                                        Text(
                                          client['rating'].toString() ?? '0.0',
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                            CacheImageCircle(url: client['url'])
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      SeeMoreTextCustom(
                        text: job["title"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SeeMoreTextCustom(
                        text: job["description"],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: primaryColor),
                              const SizedBox(width: 5),
                              Container(
                                  constraints:
                                  BoxConstraints(maxWidth: 200),
                                  child: SeeMoreTextCustom(
                                      text: job["location"],
                                      style: const TextStyle(
                                          fontSize: 14)))
                            ],
                          ),
                          Text(
                            "\$${job["price"]}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (offer.isEmpty)
                        Center(
                          child: InkWell(
                            onTap: () {
                              // Show the request dialog and await its completion
                              _showOfferDialog(context, job);

                              // Navigate to BottomNavigationbarClient after the dialog is handled
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal:
                                  12), // Matches ButtonStyle padding
                              decoration: BoxDecoration(
                                color:
                                primaryColor, // Replace with your color
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Give Offer',
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Matches ButtonStyle foregroundColor
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (offer['status'] == 'rejected')
                        Center(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            decoration: BoxDecoration(
                              color: redColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Rejected',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (offer['status'] == 'reproposal')
                          Center(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                color: yellowColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Reproposal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else if (offer['status'] == 'active')
                            Center(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'Active',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else if (offer['status'] == 'cancelled')
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: redColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancelled',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else if (offer['status'] == 'pending')
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Offered',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
