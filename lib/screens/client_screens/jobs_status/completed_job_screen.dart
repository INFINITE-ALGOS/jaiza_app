import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/lawyer_profile.dart';

import '../../../controllers/my_jobs_check_contoller.dart';


class CompletedJobsScreen extends StatefulWidget {
  const CompletedJobsScreen({super.key});

  @override
  State<CompletedJobsScreen> createState() => _CompletedJobsScreenState();
}

class _CompletedJobsScreenState extends State<CompletedJobsScreen> {
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
          future: _myJobsCheckController.fetchJobsAndOffers(context, ['completed'], ['completed']),
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
                  final offers = jobData['offers'] as List<dynamic>?;
                  if (offers == null || offers.isEmpty) {
                    return Center(
                      child: const Text('No offers available'),
                    );
                  }

                  final offer = offers[0] as Map<String, dynamic>;

                  return JobCard(
                    job: jobs,
                    offer: offer,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}







class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final Map<String,dynamic> offer;

  const JobCard({super.key,
    required this.job,
    required this.offer
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    InkWell(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeLawyerProfile()));
                        },
                        child: CircleAvatar())
                  ],
                ),
              ),

            ],
          )
           
      ),
    );
  }
}
