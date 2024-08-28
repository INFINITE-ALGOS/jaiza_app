import 'package:flutter/material.dart';

import '../../../controllers/my_jobs_check_contoller.dart';

class  CancelledJobsScreen extends StatefulWidget {
  final MyJobsCheckController _myJobsCheckController=MyJobsCheckController();

  CancelledJobsScreen({super.key});
  @override
  State<CancelledJobsScreen> createState() => _CancelledJobsScreenState();
}

class _CancelledJobsScreenState extends State<CancelledJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("My Jobs")),
      body:
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(future: widget._myJobsCheckController.fetchJobsAndOffers(context, ['cancelled'], ['cancelled']), builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError){
            return Center(child: Text("Error ${snapshot.error.toString()}"),);
          }
          if(snapshot.data==null || snapshot.data!.isEmpty){
            return const Center(child: Text("Empty"),);
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final jobs = snapshot.data![index]['jobDetails'];
                return JobCard(
                    job: jobs,
                    onViewDetails: () {


                      //  myJobsCheckController.fetchOffersData(job['jobId'], context);
                    },
                    onDelete: () { widget._myJobsCheckController.deleteJob(jobs['jobId']);
                    setState(() {

                    });
                    }
                );
              },
            );
          }
        }),


      ),
    );
  }
}


class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const JobCard({super.key,
    required this.job,
    required this.onViewDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              job['description'] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              "Price: ${job['price']}",
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onViewDetails,
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
                InkWell(
                  onTap: onDelete,
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
