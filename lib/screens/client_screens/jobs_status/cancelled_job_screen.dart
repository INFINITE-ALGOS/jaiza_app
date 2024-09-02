import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/lawyer_profile.dart';
import '../../../controllers/my_jobs_check_contoller.dart';

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
      // appBar: AppBar(title: Text("My Jobs")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _myJobsCheckController.fetchJobsAndOffers(
            context,
            ['pending', 'active', 'completed'],
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
              return const Center(child: Text("No Jobs Available"));
            }
            else {
              // Create a list to store all cancelled offers
              List<Widget> cancelledOffersWidgets = [];

              // Iterate through each job
              for (var jobData in snapshot.data!) {
                final jobs = jobData['jobDetails'] as Map<String, dynamic>;
                final offers = jobData['offers'] as List<dynamic>?;

                // Check if there are offers and they are not empty
                if (offers != null && offers.isNotEmpty) {
                  for (var offer in offers) {
                    cancelledOffersWidgets.add(
                      JobCard(
                        job: jobs,
                        offer: offer as Map<String, dynamic>,
                      ),
                    );
                  }
                  return ListView(
                    children: cancelledOffersWidgets,
                  );
                }
              }
              return Center(child: Text('No cancelled jobs'),);


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
              children: [
                Text(
                  job['title'] ?? '??',
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
                    '${offer['offerDetails']['status'] ?? ''}'.toUpperCase(),
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
                  job['duration'] ?? '',
                  style: TextStyle(),
                ),
                Text(
                  'PKR ${offer['offerDetails']['offerAmount'] ?? ''}',
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
                      offer['lawyerDetails']['name'] ?? '??',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: yellowColor),
                        Text(
                          offer['lawyerDetails']['rating'] ?? '0.0',
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
