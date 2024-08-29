import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/view_active_job_detail_screen.dart';

import '../../../../controllers/my_jobs_check_contoller.dart';
import '../../../../conts.dart';
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _myJobsCheckController.fetchJobsAndOffers(
              context, ['searching','active'], ['accepted','pending']),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final jobData = snapshot.data![index];
                    final jobs = jobData['jobDetails'] as Map<String, dynamic>;
                    final offers = jobData['offers'] as List<Map<String,dynamic>>?;

                    // Check if offers is not null and has at least one item
                    if (offers != null && offers.isNotEmpty ) {
                      // Safely access the first offer
                      final firstOffer = offers[0] as Map<String, dynamic>;
                      final offerStatus = firstOffer['offerDetails']['status'];

                      // Check if offerStatus is 'accepted'
                      if (offerStatus == 'accepted') {
                        return ActiveJobCard(
                          job: jobs,
                          offer: firstOffer,
                        );
                      }
                    }

                    // If conditions are not met, display a message or alternative widget
                    return SearchingJobCard(
                      job: jobs,
                      offers:offers,
                      onViewDetails: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewJobDetailsScreen(job: jobs,offers: offers,),
                          ),
                        );
                      },
                      onDelete: () async {
                        await _myJobsCheckController.deleteJob(jobs['jobId'], );
                        setState(() {

                        });
                        // Refresh the list after deletion
                      },
                    );
                  }
              );
            }
          },
        ),
      ),
    );
  }
}

class ActiveJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final Map<String, dynamic> offer;

  const ActiveJobCard({super.key,
    required this.job,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewActiveJobDetailScreen(job: job,offer: offer,)));
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
                        Text(job['title']?? '??',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              color: blueColor,
                              borderRadius: BorderRadius.circular(6)
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text('${job['status']??''}'.toUpperCase(),style: TextStyle(color: whiteColor,fontSize: 9),),
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
                              Text(job['duration']?? '',style: TextStyle(),),
                            ],
                          ),
                          Text('PKR ${offer['offerDetails']['offerAmount']?? ''}',style: TextStyle(color: greyColor),)
                        ],
                      )],
                  ),
                ),
                Divider(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [Text(offer['lawyerDetails']['name']?? '??',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(Icons.star,color: yellowColor,),
                              Text(offer['lawyerDetails']['rating']?? '0.0',style: TextStyle(),),
                            ],
                          ),
                      ]                ),
                      CircleAvatar()
                    ],
                  ),
                ),

              ],
            )
        ),
      ),
    );
  }

  void _showCancelledDialog(
    BuildContext context,
  ) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelled the Job'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
                hintText: 'Enter the valid reason of cancellation'),
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
                final requestDetails = controller.text;
                if (requestDetails.isNotEmpty) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
class SearchingJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final List<Map<String,dynamic>>? offers;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const SearchingJobCard({super.key,
    required this.job,
    required this.onViewDetails,
    required this.onDelete,
    required this.offers
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewJobDetailsScreen(job: job, offers: offers)));
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
                        Text(job['title']?? '??',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(6)
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text('${job['status']??''}'.toUpperCase(),style: TextStyle(color: whiteColor,fontSize: 9),),
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
                              Text(job['duration']?? '',style: TextStyle(),),
                            ],
                          ),
                          Text('PKR ${job['price']?? ''}',style: TextStyle(color: greyColor),)
                        ],
                      )],
                  ),
                ),

              ],
            )
        ),
      ),
    );;
  }
}


