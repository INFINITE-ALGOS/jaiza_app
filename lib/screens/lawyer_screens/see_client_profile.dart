import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/check_already_service_buy.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';
import 'package:law_education_app/widgets/see_more_text.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../conts.dart';
import '../../utils/custom_snackbar.dart';
import '../../widgets/custom_scaffold_messanger.dart';

class SeeClientProfile extends StatefulWidget {
  final Map<String, dynamic> client;

  const SeeClientProfile({super.key, required this.client});

  @override
  State<SeeClientProfile> createState() => _SeeClientProfileState();
}

class _SeeClientProfileState extends State<SeeClientProfile> {
  bool alreadyGet = false; // Initially, the "About" section is selected

  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<MyProfileProvider>(context)
        .profileData['lawyerProfile']['expertise'];
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.client['url'],
                placeholder: (context, url) =>
                    CupertinoActivityIndicator(), // Loading widget
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 25, top: 20),
                      child: Text(
                        widget.client['name'],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.topRight,
                      padding:
                          const EdgeInsets.only(left: 10, top: 15, right: 20),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: primaryColor, // Background color
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SeeJobs(
                                        client: widget.client,
                                        categoryList: categoryList)));
                          },
                          child:  Center(
                            child: Text(
                              AppLocalizations.of(context)!.book,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                // Cases, Experience, and Rating Columns...
              ],
            ),
            const SizedBox(height: 20),
            // Display section based on the selection

            _buildAboutSection(widget.client),
          ],
        ),
      ),
    );
  }

  // About section widget
  Widget _buildAboutSection(Map<String, dynamic> client) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.information,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow(AppLocalizations.of(context)!.phoneNo, client['phone']),
          _buildInfoRow(AppLocalizations.of(context)!.email, client['email']),
          _buildInfoRow(AppLocalizations.of(context)!.address, client['address']),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper function to build a row of information
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display expertise as a list
}

class SeeJobs extends StatefulWidget {
  final Map<String, dynamic> client;
  final List<dynamic> categoryList;
  const SeeJobs({super.key, required this.client, required this.categoryList});

  @override
  State<SeeJobs> createState() => _SeeJobsState();
}

class _SeeJobsState extends State<SeeJobs> {
  //bool alreadyGet=false;
  final TextEditingController requestController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController customDurationController =
      TextEditingController();

  Future<List<Map<String, dynamic>>> getJobsofTHatClient() async {
    try {
      QuerySnapshot getServiceSnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('clientId', isEqualTo: widget.client['id'])
          .where('status', isEqualTo: 'pending')
          .where('category', whereIn: widget.categoryList)
          .get();
      print(
          '${getServiceSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList()} ooooooooooooooo');

      return getServiceSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      CustomScaffoldSnackbar.showSnackbar(context, e.toString(),
          backgroundColor: redColor);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getJobsofTHatClient(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            6, // You can set this to any placeholder number during loading
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 2), // Use shimmer border color
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.grey[300], // Placeholder color
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width:
                                                100, // Placeholder width for title
                                            height: 20,
                                            color: Colors.grey[
                                                300], // Placeholder shimmer color
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300]!,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            padding: EdgeInsets.all(5),
                                            width:
                                                50, // Placeholder width for status
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width:
                                                    100, // Placeholder width for location
                                                height: 15,
                                                color: Colors.grey[
                                                    300], // Placeholder shimmer color
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width:
                                                80, // Placeholder width for price
                                            height: 15,
                                            color: Colors.grey[
                                                300], // Placeholder shimmer color
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noJobsFound));
            } else {
              List<Map<String, dynamic>> jobs = snapshot.data!;
              return Column(
                children: [
                  SizedBox(height: 50),
                  Expanded(
                    child: ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        final check = CheckAlreadyServiceBuy();

                        return FutureBuilder(
                          future: check.checkAlreadyJobBuy(
                              widget.client['id'], job['jobId']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: Center(
                                      child:
                                          CircularProgressIndicator()), // Loading indicator
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.location_on,
                                                size: 16, color: primaryColor),
                                            const SizedBox(width: 5),
                                            Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 200),
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
                                    const SizedBox(height: 10),
                                    if (offer.isEmpty)
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            _showRequestDialog(context, job);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(context)!.requestJob,
                                                style: TextStyle(
                                                  color: Colors.white,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!.rejected,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!.reproposal,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!.active,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!.cancelled,
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
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
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
                backgroundColor: whiteColor,
                title: Text(
                  'Request Job for ${service["title"]}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: requestController,
                      decoration:  InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterYourOfferDetails),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration:  InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterYourOfferedPrice),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:  Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final requestDetails = requestController.text;
                      final priceDetails = priceController.text;

                      if (requestDetails.isNotEmpty &&
                          priceDetails.isNotEmpty) {
                        _submitRequest(service, requestDetails, priceDetails);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationLawyer(selectedIndex: 3)),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        CustomSnackbar.showError(
                            context: context,
                            title: AppLocalizations.of(context)!.errorSendingRequest,
                            message: AppLocalizations.of(context)!.pleaseFillAllTheFields);
                      }
                    },
                    child:  Text(AppLocalizations.of(context)!.submit,
                        style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submitRequest(
    Map<String, dynamic> job,
    String requestDetails,
    String priceDetails,
  ) async {
    // Add request to Firestore
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("offers").doc();
    String docId = docRef.id;
    await docRef.set({
      'offerId': docId,
      //'duration':duration,
      'jobId': job['jobId'],
      //'serviceTitle': service['title'],
      'offerMessage': requestDetails,
      'lawyerId': FirebaseAuth.instance.currentUser!.uid,
      'clientId': job['clientId'],
      'offerTimestamp': Timestamp.now(),
      'status': "pending",
      'offerAmount': priceDetails
      // "type":"service"
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request submitted for ${job["title"]}: $requestDetails'),
      ),
    );
  }
}
