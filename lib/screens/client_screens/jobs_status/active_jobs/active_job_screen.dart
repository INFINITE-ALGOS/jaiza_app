import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/view_active_job_detail_screen.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/view_active_service_detail_screen.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/see_more_text.dart';

import '../../../../controllers/my_jobs_check_contoller.dart';
import '../../../../conts.dart';
import '../../../../widgets/custom_alert_dialog.dart';
import '../../see_lawyer_profile.dart';
import 'view_search_job_detail_screen.dart';

class ActiveJobsScreen extends StatefulWidget {
  const ActiveJobsScreen({super.key});

  @override
  State<ActiveJobsScreen> createState() => _ActiveJobsScreenState();
}

class _ActiveJobsScreenState extends State<ActiveJobsScreen> {
  late MyJobsCheckController _myJobsCheckController;

  @override
  void initState() {
    super.initState();
    _myJobsCheckController = MyJobsCheckController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("My Jobs")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            _myJobsCheckController.fetchJobsAndOffers(
              context,
              ['pending', 'active'],
              ['active', 'pending','reproposal'],
            ),
            _myJobsCheckController.fetchRequests(['active', 'pending','reproposal'])
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Jobs Available"));
            } else {

              final combinedList =
                  snapshot.data![0] as List<Map<String, dynamic>>; // Jobs data
              final servicesList = snapshot.data![1]
                  as List<Map<String, dynamic>>; // Services data
              combinedList.addAll(servicesList);

              return combinedList.isNotEmpty? ListView.builder(
                  itemCount: combinedList.length,
                  itemBuilder: (context, index) {
                    final itemData = combinedList[index];

                    // Check if the item is a job or a service
                    final isJob = itemData.containsKey('jobDetails');

                    if (isJob) {
                      final jobs =
                          itemData['jobDetails'] as Map<String, dynamic>;
                      final offers =
                          itemData['offers'] as List<Map<String, dynamic>>?;

                      // Check if offers is not null and has at least one item
                      if (offers != null && offers.isNotEmpty) {
                        // Safely access the first offer
                        final firstOffer = offers[0] as Map<String, dynamic>;
                        final offerStatus =
                            firstOffer['offerDetails']['status'];

                        // Check if offerStatus is 'accepted'
                        if (offerStatus == 'active') {
                          return ActiveJobCard(
                            job: jobs,
                            offer: firstOffer,
                          );
                        }
                      }
                      // If conditions are not met, display a message or alternative widget
                      return SearchingJobCard(
                        job: jobs,
                        offers: offers,
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewJobDetailsScreen(
                                job: jobs,
                                offers: offers,
                              ),
                            ),
                          );
                        },
                        onDelete: () async {
                          await _myJobsCheckController.deleteJob(
                            jobs['jobId'],
                          );
                          setState(() {});
                          // Refresh the list after deletion
                        },
                      );
                    } else {
                      final requestData = itemData;
                      return ServiceCard(
                          requestDetails: requestData['requestDetails'],
                          serviceDetails: requestData['serviceDetails'],
                          lawyerDetails: requestData['lawyerDetails']);
                    }
                  }) : Center(child: Text('No Active Jobs'),);
            }
          },
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> requestDetails;
  final Map<String, dynamic> serviceDetails;
  final Map<String, dynamic> lawyerDetails;

  const ServiceCard(
      {super.key,
      required this.requestDetails,
      required this.serviceDetails,
      required this.lawyerDetails});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        requestDetails['status'] == 'active'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewActiveServiceDetailScreen(
                          requestDetails: requestDetails,
                          serviceDetails: serviceDetails,
                          lawyerDetails: lawyerDetails,
                        )))
            : null;
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: lightGreyColor, width: 2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: SeeMoreTextCustom(text:requestDetails['requestMessage'] ?? '??',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              '${requestDetails['status'] ?? ''}'.toUpperCase(),
                              style: TextStyle(color: whiteColor, fontSize: 9),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //  Icon(Icons.star,color: yellowColor,),
                              Text(
                                requestDetails['duration'] ?? '',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Text(
                            'PKR ${requestDetails['requestAmount'] ?? ''}',
                            style: TextStyle(color: greyColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
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
                              lawyerDetails['name'] ?? '??',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),SizedBox(width: 8,),
                            InkWell(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeLawyerProfile(lawyer: lawyerDetails)));},
                                child: Text("View Profile",style: TextStyle(color: primaryColor,fontSize: 12,decoration: TextDecoration.underline,decorationColor: primaryColor),))

                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: yellowColor,
                            ),
                            Text(
                              lawyerDetails['rating'] ?? '0.0',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      ]),
                      InkWell(onTap: () {}, child:CacheImageCircle(url: lawyerDetails['url']))
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                requestDetails['status']=='reproposal'? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        final offerController=TextEditingController();

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Give Offer for ${requestDetails["requestMessage"]}'),
                                content: Container(
                                  height: 150,
                                  child: TextField(
                                    controller: offerController,
                                    decoration: const InputDecoration(hintText: 'Enter your offer'),
                                    keyboardType: TextInputType.number,
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
                                      if (offerAmount.isNotEmpty && offerController.text.isNotEmpty) {
                                        FirebaseFirestore.instance.collection('requests').doc(requestDetails['requestId']).update(
                                            {'status':'pending',
                                            'requestAmount':offerAmount});
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) =>BottomNavigationbarClient(selectedIndex: 3)), // New screen to navigate to
                                              (Route<dynamic> route) => false, // Predicate to determine which routes to remove
                                        );
                                      }
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ],
                              );});},

                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.green, // Example color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Reoffer',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {

                        showDialog(context: context, builder: (context){
                          return CustomAlertDialog(title: 'Are you sure you want to reject reproposal', content: '', onConfirm: (){
                            FirebaseFirestore.instance.collection('requests').doc(requestDetails['requestId']).update({'status':"rejected"});
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) =>BottomNavigationbarClient(selectedIndex: 3)), // New screen to navigate to
                                  (Route<dynamic> route) => false, // Predicate to determine which routes to remove
                            );

                          }, onCancel: (){Navigator.of(context).pop();});
                        });                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red, // Example color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ):SizedBox(),

              ],
            )),
      ),
    );
  }
}

class ActiveJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final Map<String, dynamic> offer;

  const ActiveJobCard({
    super.key,
    required this.job,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewActiveJobDetailScreen(
                      job: job,
                      offer: offer,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: lightGreyColor, width: 2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            job['title'] ?? '??',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              '${job['status'] ?? ''}'.toUpperCase(),
                              style: TextStyle(color: whiteColor, fontSize: 9),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //  Icon(Icons.star,color: yellowColor,),
                              Text(
                                job['duration'] ?? '',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Text(
                            'PKR ${offer['offerDetails']['offerAmount'] ?? ''}',
                            style: TextStyle(color: greyColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        Text(
                          offer['lawyerDetails']['name'] ?? '??',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: yellowColor,
                            ),
                            Text(
                              offer['lawyerDetails']['rating'] ?? '0.0',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      ]),
                      InkWell(onTap: () {}, child: CircleAvatar())
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class SearchingJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final List<Map<String, dynamic>>? offers;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const SearchingJobCard(
      {super.key,
      required this.job,
      required this.onViewDetails,
      required this.onDelete,
      required this.offers});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewJobDetailsScreen(job: job, offers: offers)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: lightGreyColor, width: 2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: Text(
                              job['title'] ?? '??',maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              '${job['status'] ?? ''}'.toUpperCase(),
                              style: TextStyle(color: whiteColor, fontSize: 9),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //  Icon(Icons.star,color: yellowColor,),
                              Text(
                                job['duration'] ?? '',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Text(
                            'PKR ${job['price'] ?? ''}',
                            style: TextStyle(color: greyColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
