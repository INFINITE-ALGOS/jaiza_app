import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import '../../controllers/my_jobs_check_contoller.dart';
import 'jobs_status/active_jobs/view_search_job_detail_screen.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final MyJobsCheckController _myJobsCheckController=MyJobsCheckController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _myJobsCheckController.fetchJobsAndOffers(context, ['searching'],['pending']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No jobs found."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final job = snapshot.data![index]['jobDetails'];
               final List<Map<String,dynamic>> offersList=snapshot.data![index]['offers'];
                return SearchingJobCard(
                  job: job,
                  onViewDetails: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewJobDetailsScreen(job: job,offers: offersList,),
                      ),
                    );
                  },
                  onDelete: () async {
                    await _myJobsCheckController.deleteJob(job['jobId'], );
                    setState(() {

                    });
                   // Refresh the list after deletion
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class SearchingJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const SearchingJobCard({super.key,
    required this.job,
    required this.onViewDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(

        border: Border.all(color: blueColor)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              job['description'] as String,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Price: ${job['price']}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  "Duration: ${job['duration']}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onViewDetails,
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: (){
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: const Text('Confirm Deletion'),
    content: const Text('Are you sure you want to delete this job posting?'),
    actions: [
    TextButton(
    onPressed: () {
    Navigator.of(context).pop(); // Close the dialog
    },
    child: const Text('Cancel'),
    ),
    TextButton(
    onPressed: () {
        onDelete();
      Navigator.of(context).pop();
      // Close the dialog
    // Perform the delete action
    },
    child: const Text('Delete', style: TextStyle(color: Colors.red)),
    ),
    ],
    );
    },
    );},
                  child: const Icon(Icons.delete,color: Colors.red,),
    )],
            ),
          ],
        ),
      ),
    );
  }
}
