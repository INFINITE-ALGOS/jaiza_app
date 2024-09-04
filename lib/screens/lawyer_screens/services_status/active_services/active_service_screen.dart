import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/my_services_check_controller.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/view_active_job_detail_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';

import '../../../../controllers/my_jobs_check_contoller.dart';
import '../../../../conts.dart';
import '../../../../widgets/custom_alert_dialog.dart';
import 'view_service_active_detail_screen.dart';


class ActiveServiceScreenLawyer extends StatefulWidget {
  const ActiveServiceScreenLawyer({super.key});

  @override
  State<ActiveServiceScreenLawyer> createState() => _ActiveServiceScreenLawyerState();
}

class _ActiveServiceScreenLawyerState extends State<ActiveServiceScreenLawyer> {
  late MyServicesCheckController _myServiceCheckController;

  @override
  void initState() {
    super.initState();
    _myServiceCheckController = MyServicesCheckController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("My Jobs")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([_myServiceCheckController.fetchServicesAndRequests(
              context, ['active'], ['active','pending','reproposal']),_myServiceCheckController.fetchOffers(['active','pending','reproposal'])]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Service Available"));
            } else {
              final combinedData=snapshot.data![0]  as List<Map<String, dynamic>>; ;
              final offersData=snapshot.data![1]  as List<Map<String, dynamic>>; ;
              combinedData.addAll(offersData);
            //  print('${snapshot.data![1] }');
              return ListView.builder(
                itemCount: combinedData.length,
                  itemBuilder: (context, index) {
                    final itemData = combinedData[index];
                    final isService = itemData.containsKey('serviceDetails');

                    if(isService){
                      final serviceData = itemData;
                      final service = serviceData['serviceDetails'] as Map<String, dynamic>;
                      final requests = serviceData['requests'] as List<Map<String,dynamic>>?;
                      return ServiceCard(service: service, onViewDetails: (){}, onDelete: (){}, requests: requests);

                    }
                    else{
                      final Map<String, dynamic> jobDetails = itemData['jobDetails'];
                      final Map<String, dynamic> clientDetails=itemData['clientDetails'];
                      final Map<String, dynamic> offerDetails=itemData['offerDetails'];
                      return OfferJobCard(clientDetails: clientDetails, jobDetails: jobDetails, offerDetails: offerDetails);
                    }
                  }
              );
            }
          },
        ),
      ),
    );
  }
}
class OfferJobCard extends StatelessWidget {
  final Map<String, dynamic> jobDetails;
  final Map<String, dynamic> clientDetails;
  final Map<String, dynamic> offerDetails;


  const OfferJobCard({
    super.key,
    required this.clientDetails,
    required this.jobDetails,
    required this.offerDetails
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            jobDetails['title'] ?? '??',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              '${offerDetails['status'] ?? ''}'.toUpperCase(),
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
                                jobDetails['duration'] ?? '',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Text(
                            'PKR ${offerDetails['offerAmount'] ?? ''}',
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
                          clientDetails['name'] ?? '??',
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
                              clientDetails['rating'] ?? '0.0',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      ]),
                      InkWell(onTap: () {}, child: CircleAvatar())
                    ],
                  ),
                ),
               SizedBox(height: 20,),
               offerDetails['status']=='reproposal'? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        final offerController=TextEditingController();

      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Give Offer for ${jobDetails["title"]}'),
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
                 FirebaseFirestore.instance.collection('offers').doc(offerDetails['offerId']).update(
                     {'status':'pending',
                     'offerAmount':offerAmount});
                 Navigator.pushAndRemoveUntil(
                   context,
                   MaterialPageRoute(builder: (context) =>BottomNavigationLawyer(selectedIndex: 3)), // New screen to navigate to
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
                            FirebaseFirestore.instance.collection('offers').doc(offerDetails['offerId']).update({'status':"rejected"});
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) =>BottomNavigationLawyer(selectedIndex: 3)), // New screen to navigate to
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


class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final List<Map<String,dynamic>>? requests;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const ServiceCard({super.key,
    required this.service,
    required this.onViewDetails,
    required this.onDelete,
    required this.requests
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewServiceActiveDetailScreen(service: service, requests: requests)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: lightGreyColor,width: 2),
              borderRadius: BorderRadius.circular(18),
            ),
            child:Column(
              children: [
                Container(
                  child: Column(
                    children: [Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(service['title']?? '??',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(6)
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text('${service['status']??''}'.toUpperCase(),style: TextStyle(color: whiteColor,fontSize: 9),),
                        )
                      ],
                    ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            //  Icon(Icons.star,color: yellowColor,),
                              Text(service['location']?? '',style: TextStyle(),),
                            ],
                          ),
                          Text('PKR ${service['price']?? ''}',style: TextStyle(color: greyColor),)
                        ],
                      )],
                  ),
                ),

              ],
            )
        ),
      ),
    );
  }
}


