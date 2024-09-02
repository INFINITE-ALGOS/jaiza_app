import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/my_services_check_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/lawyer_profile.dart';
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
      // appBar: AppBar(title: Text("My Jobs")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _myServiceCheckController.fetchServicesAndRequests(
            context,
            ['active', 'deleted'],
            ['cancelled'],
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Services Available"));
            }
            else {
              // Create a list to store all cancelled offers
              List<Widget> completedRequestsWidgets = [];

              // Iterate through each job
              for (var serviceData in snapshot.data!) {
                final service = serviceData['serviceDetails'] as Map<String, dynamic>;
                final requests = serviceData['requests'] as List<dynamic>?;

                // Check if there are offers and they are not empty
                if (requests != null && requests.isNotEmpty) {
                  for (var request in requests) {
                    completedRequestsWidgets.add(
                      JobCard(
                        service: service,
                        request: request as Map<String, dynamic>,
                      ),
                    );
                  }
                  return ListView(
                    children: completedRequestsWidgets,
                  );
                }
              }
              return Center(child: Text('No cancelled services'),);


            }
          },
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
    final Map<String,dynamic> requestDetails=request['requestDetails'];
    final Map<String,dynamic> clientDetails=request['clientDetails'];
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
              children: [
                Text(
                  requestDetails['requestMessage'] ?? '??',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeeLawyerProfile(),
                      ),
                    );
                  },
                  child: CircleAvatar(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
