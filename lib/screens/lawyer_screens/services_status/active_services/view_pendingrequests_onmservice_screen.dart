import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';


class ViewPendingRequestsOnMyServiceScreen extends StatelessWidget {
  final Map<String,dynamic> ? service;
  final List<Map<String, dynamic>>? pendingRequests;
  const ViewPendingRequestsOnMyServiceScreen({super.key, required this.service,required this.pendingRequests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pending Requests"),
      backgroundColor: Colors.transparent,),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: pendingRequests!.isNotEmpty? ListView.builder(itemCount:pendingRequests!.length ,itemBuilder: (context,index){
          return OfferCard(request: pendingRequests![index]['requestDetails'], client: pendingRequests![index]['clientDetails']);
        }): const Center(child: Text("No Requests Given By Clients"),),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final Map<String, dynamic> client;

  const OfferCard({super.key, required this.request, required this.client});

  @override
  Widget build(BuildContext context) {
  //  final navigation=Provider.of<NavigationService>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue), // Example color
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.white, // Example color
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                (client['name'] ?? '').toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                child: const Text(
                                  'View Profile',
                                  style: TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
                                ),
                                onTap: () {
                                  // Handle "View Profile" tap
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            client['location'] ?? 'No Location',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue, // Example color
                        child: Icon(CupertinoIcons.chat_bubble, color: Colors.white),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Rating: ${client['rating'] ?? "No rating"}'),
                    //   const SizedBox(width: 20),
                    //   Text('Orders Completed: ${client['ordersCompleted'] ?? '0'}'),
                     ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Message: ",
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: request['requestMessage'],
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Request Price: ",
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: request['requestAmount'],
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                 // FirebaseFirestore.instance.collection('offers').doc(request['offerId']).update({'status':"active"});
                  FirebaseFirestore.instance.collection('requests').doc(request['requestId']).update({'status':"active"});
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>BottomNavigationLawyer(selectedIndex: 3)), // New screen to navigate to
                        (Route<dynamic> route) => false, // Predicate to determine which routes to remove
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.green, // Example color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  FirebaseFirestore.instance.collection('requests').doc(request['requestId']).update({'status':"rejected"});
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>BottomNavigationLawyer(selectedIndex: 3)), // New screen to navigate to
                        (Route<dynamic> route) => false, // Predicate to determine which routes to remove
                  );

                  // Handle Reject action
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red, // Example color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  FirebaseFirestore.instance.collection('requests').doc(request['requestId']).update({'status':"reproposal"});

                  // Handle Reproposal action
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.orange, // Example color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Reproposal',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
