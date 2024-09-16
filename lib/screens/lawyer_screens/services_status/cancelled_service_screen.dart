import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/my_services_check_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/see_lawyer_profile.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/see_more_text.dart';
import '../../../controllers/my_jobs_check_contoller.dart';

class CancelledServiceScreen extends StatefulWidget {
  const CancelledServiceScreen({super.key});

  @override
  State<CancelledServiceScreen> createState() => _CancelledServiceScreenState();
}

class _CancelledServiceScreenState extends State<CancelledServiceScreen> {
  late MyServicesCheckController _myServiceCheckController;

  @override
  void initState() {
    super.initState();
    _myServiceCheckController = MyServicesCheckController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            _myServiceCheckController.fetchServicesAndRequests(
              context,
              ['active', 'deleted'],
              ['cancelled'],
            ),
            _myServiceCheckController.fetchOffers(['cancelled']),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Services Available"));
            } else {
              final combinedData = snapshot.data![0] as List<Map<String, dynamic>>;
              final offersData = snapshot.data![1] as List<Map<String, dynamic>>;
              combinedData.addAll(offersData);

              // Create a list to store all cancelled services and offers
              List<Widget> cancelledRequestsWidgets = [];

              // Iterate through each service or offer
              for (var serviceData in combinedData) {
                final isService = serviceData.containsKey('serviceDetails');
                if (isService) {
                  final service = serviceData['serviceDetails'] as Map<String, dynamic>;
                  final requests = serviceData['requests'] as List<dynamic>?;

                  // Check if there are requests and they are not empty
                  if (requests != null && requests.isNotEmpty) {
                    for (var request in requests) {
                      cancelledRequestsWidgets.add(
                        JobCard(
                          service: service,
                          request: request as Map<String, dynamic>,
                        ),
                      );
                    }
                  }
                } else {
                  final Map<String, dynamic> jobDetails = serviceData['jobDetails'];
                  final Map<String, dynamic> clientDetails = serviceData['clientDetails'];
                  final Map<String, dynamic> offerDetails = serviceData['offerDetails'];
                  cancelledRequestsWidgets.add(
                    OfferJobCard(
                      clientDetails: clientDetails,
                      jobDetails: jobDetails,
                      offerDetails: offerDetails,
                    ),
                  );
                }
              }

              return cancelledRequestsWidgets.isNotEmpty
                  ? ListView(
                children: cancelledRequestsWidgets,
              )
                  : Center(
                child: Text("No cancelled services"),
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
    required this.offerDetails,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add navigation or other logic here if needed
      },
      child: Padding(
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
                children: [
                  Text(
                    jobDetails['title'] ?? '??',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '${offerDetails['status'] ?? ''}'.toUpperCase(),
                      style: TextStyle(color: whiteColor, fontSize: 9),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    jobDetails['duration'] ?? '',
                    style: TextStyle(),
                  ),
                  Text(
                    'PKR ${offerDetails['offerAmount'] ?? ''}',
                    style: TextStyle(color: greyColor),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientDetails['name'] ?? '??',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.star, color: yellowColor),
                          Text(
                            clientDetails['rating'] ?? '0.0',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {


                    },
                    child: CircleAvatar(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final Map<String, dynamic> request;

  const JobCard({
    super.key,
    required this.service,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> requestDetails = request['requestDetails'];
    final Map<String, dynamic> clientDetails = request['clientDetails'];
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
                  child: SeeMoreTextCustom(text:  requestDetails['requestMessage'] ?? '??',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '${requestDetails['status'] ?? ''}'.toUpperCase(),
                    style: TextStyle(color: whiteColor, fontSize: 9),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  requestDetails['duration'] ?? '',
                  style: TextStyle(),
                ),
                Text(
                  'PKR ${requestDetails['requestAmount'] ?? ''}',
                  style: TextStyle(color: greyColor),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientDetails['name'] ?? '??',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: yellowColor),
                        Text(
                          clientDetails['rating'] ?? '0.0',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
               CacheImageCircle(url: clientDetails['url']),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
