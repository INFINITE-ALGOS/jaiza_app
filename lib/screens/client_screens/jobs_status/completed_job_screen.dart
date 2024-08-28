import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';

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
                    return const ListTile(title: Text('No offers available'));
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
  final Map<String, dynamic> offer;

  const JobCard({super.key,
    required this.job,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Details Container
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title'] as String? ?? 'No Title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue[900]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    job['description'] as String? ?? 'No Description',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Price: ${offer['offerDetails']?['offerAmount'] ?? 'Not Available'}",
                    style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Duration: ${job['duration'] ?? 'Not Available'}",
                    style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Lawyer Details Container
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lawyer: ${offer['lawyerDetails']?['name'] ?? 'Unknown'}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[900]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Message: ${offer['offerDetails']?['offerMessage'] ?? 'No Message'}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Experience: ${offer['lawyerDetails']?['experience']?.toString() ?? '0.0'} years",
                    style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Jobs Completed: ${offer['lawyerDetails']?['jobsCompleted']?.toString() ?? '0'}",
                    style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            const Text("Rate the lawyer",style: TextStyle(color: blueColor),)
          ],
        ),
      ),
    );
  }

}
