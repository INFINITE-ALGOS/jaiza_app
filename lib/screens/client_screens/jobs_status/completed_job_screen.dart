import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/see_lawyer_profile.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/see_more_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            _myJobsCheckController
                .fetchJobsAndOffers(context, ['completed'], ['completed']),
            _myJobsCheckController.fetchRequests(['completed'])
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return  Center(child: Text(AppLocalizations.of(context)!.noJobsAvailable));
            } else {
              final combinedList =
                  snapshot.data![0] as List<Map<String, dynamic>>; // Jobs data
              final servicesList = snapshot.data![1]
                  as List<Map<String, dynamic>>; // Services data
              combinedList.addAll(servicesList);
              return combinedList.isNotEmpty
                  ? ListView.builder(
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
                          if (offers == null || offers.isEmpty) {
                            return Center(
                              child:  Text(AppLocalizations.of(context)!.noJobsAvailable),
                            );
                          }

                          final offer = offers[0] as Map<String, dynamic>;

                          return JobCard(
                            job: jobs,
                            offer: offer,
                          );
                        } else {
                          final requestData = itemData;
                          return ServiceCard(
                              requestDetails: requestData['requestDetails'],
                              serviceDetails: requestData['serviceDetails'],
                              lawyerDetails: requestData['lawyerDetails']);
                        }
                      },
                    )
                  : Center(
                      child: Text(AppLocalizations.of(context)!.noCancelledJobsAvailable,
                    ));
            }
          },
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final Map<String, dynamic> offer;

  const JobCard({super.key, required this.job, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            child: SeeMoreTextCustom(
                              text: job['title'] ?? '??',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            )),
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                offer['lawyerDetails']['name'] ?? '??',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SeeLawyerProfile(
                                                    lawyer: offer[
                                                        'lawyerDetails'])));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.viewProfile,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        decorationColor: primaryColor),
                                  ))
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
                                offer['lawyerDetails']['rating'] ?? '0.0',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ]),
                    CacheImageCircle(url: offer['lawyerDetails']['url'])
                  ],
                ),
              ),
            ],
          )),
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
    return Padding(
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
                            child: SeeMoreTextCustom(
                              text: requestDetails['requestMessage'] ?? '??',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            )),
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
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SeeLawyerProfile(
                                                    lawyer: lawyerDetails)));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.viewProfile,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        decorationColor: primaryColor),
                                  ))
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
                    CacheImageCircle(url: lawyerDetails['url'])
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
