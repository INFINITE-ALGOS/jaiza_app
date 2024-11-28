import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/see_lawyer_profile.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/see_more_text.dart';
import '../../../controllers/my_jobs_check_contoller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancelledJobsScreen extends StatefulWidget {
  const CancelledJobsScreen({super.key});

  @override
  State<CancelledJobsScreen> createState() => _CancelledJobsScreenState();
}

class _CancelledJobsScreenState extends State<CancelledJobsScreen> {
  late MyJobsCheckController _myJobsCheckController;

  @override
  void initState() {
    super.initState();
    _myJobsCheckController = MyJobsCheckController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            _myJobsCheckController.fetchJobsAndOffers(context,
                ['pending', 'deleted', 'completed', 'active'], ['cancelled']),
            _myJobsCheckController.fetchRequests(['cancelled'])
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                      AppLocalizations.of(context)!.noCancelledJobsAvailable));
            } else {
              final combinedList =
                  snapshot.data![0] as List<Map<String, dynamic>>; // Jobs data
              final servicesList = snapshot.data![1]
                  as List<Map<String, dynamic>>; // Services data
              combinedList.addAll(servicesList);

              // Use cancelledOffersWidgets to hold all cancelled jobs and services
              List<Widget> cancelledOffersWidgets = [];

              for (var itemData in combinedList) {
                // Check if the item is a job or a service
                final isJob = itemData.containsKey('jobDetails');

                if (isJob) {
                  final jobs = itemData['jobDetails'] as Map<String, dynamic>;
                  final offers =
                      itemData['offers'] as List<Map<String, dynamic>>?;

                  if (offers != null && offers.isNotEmpty) {
                    for (var offer in offers) {
                      cancelledOffersWidgets.add(
                        JobCard(
                          job: jobs,
                          offer: offer,
                        ),
                      );
                    }
                  }
                } else {
                  final requestData = itemData;
                  cancelledOffersWidgets.add(
                    ServiceCard(
                      requestDetails: requestData['requestDetails'],
                      serviceDetails: requestData['serviceDetails'],
                      lawyerDetails: requestData['lawyerDetails'],
                    ),
                  );
                }
              }

              // Return ListView with all cancelled offers
              return cancelledOffersWidgets.isNotEmpty
                  ? ListView(
                      children: cancelledOffersWidgets,
                    )
                  : Center(
                      child:
                          Text(AppLocalizations.of(context)!.noCancelledJobs),
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
  final Map<String, dynamic> offer;

  const JobCard({
    super.key,
    required this.job,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(color: lightGreyColor, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: SeeMoreTextCustom(
                    text: job['title'] ?? '??',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '${offer['offerDetails']['status'] ?? ''}'.toUpperCase(),
                    style: const TextStyle(color: whiteColor, fontSize: 9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job['duration'] ?? '',
                  style: const TextStyle(),
                ),
                Text(
                  'PKR ${offer['offerDetails']['offerAmount'] ?? ''}',
                  style: TextStyle(color: greyColor),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          offer['lawyerDetails']['name'] ?? '??',
                          style: const TextStyle(
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
                                      builder: (context) => SeeLawyerProfile(
                                          lawyer: offer['lawyerDetails'])));
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, color: yellowColor),
                        Text(
                          offer['lawyerDetails']['rating'] ?? '0.0',
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
                CacheImageCircle(url: offer['lawyerDetails']['url'])
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> requestDetails;
  final Map<String, dynamic> serviceDetails;
  final Map<String, dynamic> lawyerDetails;

  const ServiceCard({
    super.key,
    required this.requestDetails,
    required this.serviceDetails,
    required this.lawyerDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(color: lightGreyColor, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: SeeMoreTextCustom(
                    text: requestDetails['requestMessage'] ?? '??',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '${requestDetails['status'] ?? ''}'.toUpperCase(),
                    style: const TextStyle(color: whiteColor, fontSize: 9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  requestDetails['duration'] ?? '',
                  style: const TextStyle(),
                ),
                Text(
                  'PKR ${requestDetails['requestAmount'] ?? ''}',
                  style: TextStyle(color: greyColor),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          lawyerDetails['name'] ?? '??',
                          style: const TextStyle(
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
                                      builder: (context) => SeeLawyerProfile(
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, color: yellowColor),
                        Text(
                          lawyerDetails['rating'] ?? '0.0',
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
                CacheImageCircle(url: lawyerDetails['url'])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
