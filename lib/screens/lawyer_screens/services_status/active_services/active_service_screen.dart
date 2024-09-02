import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/my_services_check_controller.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/view_active_job_detail_screen.dart';

import '../../../../controllers/my_jobs_check_contoller.dart';
import '../../../../conts.dart';
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _myServiceCheckController.fetchServicesAndRequests(
              context, ['active'], ['active','pending']),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final serviceData = snapshot.data![index];
                    final service = serviceData['serviceDetails'] as Map<String, dynamic>;
                    final requests = serviceData['requests'] as List<Map<String,dynamic>>?;
                    return ServiceCard(service: service, onViewDetails: (){}, onDelete: (){}, requests: requests);

                  }
              );
            }
          },
        ),
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
                      children: [
                        Text(service['title']?? '??',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                        Spacer(),
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


