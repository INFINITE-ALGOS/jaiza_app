import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/check_already_service_buy.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/widgets/custom_scaffold_messanger.dart';
import 'package:law_education_app/widgets/see_more_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/custom_snackbar.dart';
import 'bottom_nav.dart';

class SeeLawyerProfile extends StatefulWidget {
  final Map<String, dynamic> lawyer;
  const SeeLawyerProfile({super.key, required this.lawyer});

  @override
  State<SeeLawyerProfile> createState() => _SeeLawyerProfileState();
}

class _SeeLawyerProfileState extends State<SeeLawyerProfile> {
  String selectedSection = "about";
  bool alreadyGet=false;// Initially, the "About" section is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
               
                borderRadius: BorderRadius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.lawyer['url'],
                placeholder: (context, url) =>
                    CupertinoActivityIndicator(), // Loading widget
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 25, top: 20),
                      child: Text(
                        widget.lawyer['name'],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(
                          left: 10, top: 15, right: 20),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: primaryColor, // Background color
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeServices(lawyer: widget.lawyer)));},
                          child: const Center(
                            child: Text(
                              "Book",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                // Cases, Experience, and Rating Columns...
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSection = "about";
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: selectedSection == "about"
                            ? greyColor // Selected color for "About"
                            : primaryColor, // Normal color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "About",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSection = "portfolio";
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: selectedSection == "portfolio"
                            ? greyColor // Selected color for "Portfolio"
                            : primaryColor, // Normal color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Portfolio",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display section based on the selection
            if (selectedSection == "about")
              _buildAboutSection(widget.lawyer),
            if (selectedSection == "portfolio")
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "No Portfolio created by lawyer.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // About section widget
  Widget _buildAboutSection(Map<String, dynamic> lawyer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow('Phone', lawyer['phone']),
          _buildInfoRow('Email', lawyer['email']),
          _buildInfoRow('Address', lawyer['address']),
          const SizedBox(height: 20),
          const Text(
            'More Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow('Bio', lawyer['lawyerProfile']['bio']),
          _buildInfoRow('Designation', lawyer['lawyerProfile']['designation']),
          _buildExpertiseList(lawyer['lawyerProfile']['expertise']),
        ],
      ),
    );
  }

  // Helper function to build a row of information
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display expertise as a list
  Widget _buildExpertiseList(List<dynamic> expertise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expertise:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        for (var skill in expertise)
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Text(
              '- $skill',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}
class SeeServices extends StatefulWidget {
  final Map<String,dynamic> lawyer;
  const SeeServices({super.key,required this.lawyer});

  @override
  State<SeeServices> createState() => _SeeServicesState();
}

class _SeeServicesState extends State<SeeServices> {
  //bool alreadyGet=false;
  final TextEditingController requestController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController customDurationController = TextEditingController();
  String? selectedDuration;
  List<String> durationOptions = [
    "1 day",
    "1 week",
    "1 month",
    "1 year",
    "Custom"
  ];
  Future<List<Map<String,dynamic>>> getServicesofThatLawyer()async{
    try{
     QuerySnapshot getServiceSnapshot=await FirebaseFirestore.instance.collection('services').where('lawyerId',isEqualTo: widget.lawyer['id']).where('status',isEqualTo: 'active').get();
     return getServiceSnapshot.docs.map((doc)=>doc.data() as Map<String,dynamic>).toList();
    }
        catch(e){
      CustomScaffoldSnackbar.showSnackbar(context, e.toString(),backgroundColor: redColor);
      return [];
        }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: getServicesofThatLawyer(), builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: 6, // You can set this to any placeholder number during loading
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!, width: 2), // Use shimmer border color
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.grey[300], // Placeholder color
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100, // Placeholder width for title
                                        height: 20,
                                        color: Colors.grey[300], // Placeholder shimmer color
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300]!,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        width: 50, // Placeholder width for status
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 100, // Placeholder width for location
                                            height: 15,
                                            color: Colors.grey[300], // Placeholder shimmer color
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 80, // Placeholder width for price
                                        height: 15,
                                        color: Colors.grey[300], // Placeholder shimmer color
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text("No Services Found"));
        }
        else{
          List<Map<String,dynamic>> services =snapshot.data!;
          return Column(
            children: [
              SizedBox(height: 50),
              Expanded(
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final check = CheckAlreadyServiceBuy();

                    return FutureBuilder(
                      future: check.checkAlreadyService(widget.lawyer['id'], service['serviceId']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Center(child: CircularProgressIndicator()), // Loading indicator
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if(snapshot.data!=null){
                            Map<String,dynamic> offer=snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SeeMoreTextCustom(
                                    text:  service["title"],
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  SeeMoreTextCustom(
                                    text:   service["description"],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.location_on, size: 16, color: primaryColor),
                                          const SizedBox(width: 5),
                                          Container(constraints: BoxConstraints(maxWidth: 200),child: SeeMoreTextCustom(text:  service["location"], style: const TextStyle(fontSize: 14))),
                                        ],
                                      ),
                                      Text(
                                        "\$${service["price"]}",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  if(offer.isEmpty)
                                    Center(
                                      child: InkWell(
                                        onTap: () {
                                          _showRequestDialog(context, service);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Request Service',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  else if (offer['status']=='pending')
                                    Center(
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Requested',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  else if (offer['status']=='rejected')
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: redColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Rejected',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (offer['status']=='reproposal')
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: yellowColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Reproposal',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      else if (offer['status']=='active')
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Active',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        else if (offer['status']=='cancelled')
                                            Center(
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                                decoration: BoxDecoration(
                                                  color: redColor,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Cancelled',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )

                                ],
                              ),
                            ),
                          );
                        }
                        else{
                          return Text('data');
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );

        }
      }),
    );
  }
  void _showRequestDialog(BuildContext context, Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                backgroundColor: whiteColor,
                title: Text('Request Service for ${service["title"]}',maxLines: 4,overflow: TextOverflow.ellipsis,),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: requestController,
                      decoration: const InputDecoration(
                          hintText: 'Enter your request details'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration: const InputDecoration(
                          hintText: 'Enter your offered price'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Duration",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black),
                            ),
                            child: DropdownButton<String>(
                              value: selectedDuration,
                              items: durationOptions.map((String duration) {
                                return DropdownMenuItem<String>(
                                  value: duration,
                                  child: Text(duration),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDuration = newValue;
                                });
                              },
                              hint: const Text("Select Duration"),
                              underline: SizedBox(), // Remove underline
                            ),
                          ),
                          if (selectedDuration == "Custom") ...[
                            SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black),
                              ),
                              child: TextFormField(
                                controller: customDurationController,
                                decoration: const InputDecoration(
                                    hintText: "Enter Custom Duration",
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel',style: TextStyle(color: primaryColor),),
                  ),
                  TextButton(
                    onPressed: () {
                      String duration = selectedDuration == "Custom"
                          ? customDurationController.text.trim()
                          : selectedDuration!;
                      final requestDetails = requestController.text;
                      final priceDetails = priceController.text;

                      if (requestDetails.isNotEmpty && priceDetails.isNotEmpty && duration.isNotEmpty) {
                        _submitRequest(service, requestDetails, priceDetails,duration);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationbarClient(selectedIndex: 3)),
                              (Route<dynamic> route) => false,
                        );
                      }
                      else{
                        CustomSnackbar.showError(context: context, title: "Error sending request", message: "PLease fill all the fields");
                      }
                    },
                    child: const Text('Submit',style: TextStyle(color: primaryColor)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submitRequest(Map<String, dynamic> service, String requestDetails,String priceDetails,String duration) async {
    // Add request to Firestore
    DocumentReference docRef = FirebaseFirestore.instance.collection("requests").doc();
    String docId = docRef.id;
    await docRef.set({
      'requestId':docId,
      'duration':duration,
      'serviceId': service['serviceId'],
      //'serviceTitle': service['title'],
      'requestMessage': requestDetails,
      'clientId':FirebaseAuth.instance.currentUser!.uid,
      'lawyerId':service['lawyerId'],
      'requestTimestamp': Timestamp.now(),
      'status':"pending",
      'requestAmount':priceDetails
      // "type":"service"
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request submitted for ${service["title"]}: $requestDetails'),
      ),
    );
  }

}

