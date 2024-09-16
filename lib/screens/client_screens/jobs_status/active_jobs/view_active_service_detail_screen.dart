import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/cancel_requestbooking_screen.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/complete_jobbooking_screen.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/cancel_jobbooking_screen.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/complete_requestbooking_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/services_status/cancelled_service_screen.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/custom_alert_dialog.dart';

import '../../../../conts.dart';

class ViewActiveServiceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> requestDetails;
  final Map<String, dynamic> serviceDetails;
  final Map<String, dynamic> lawyerDetails;

  const ViewActiveServiceDetailScreen({super.key, required this.requestDetails, required this.lawyerDetails,required this.serviceDetails});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  title: Text('#524587'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Handle phone call action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service List
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: lightGreyColor,width: 2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child:Column(
                      children: [
                        Container(
                          child: Column(
                            children: [Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    constraints: BoxConstraints(maxWidth: 200),

                                    child: Text(requestDetails['requestMessage']?? '??',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),)),
                               // Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Text('${requestDetails['status']??''}'.toUpperCase(),style: TextStyle(color: whiteColor,fontSize: 9),),
                                )
                              ],
                            ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //  Icon(Icons.star,color: yellowColor,),
                                      Text(requestDetails['duration']?? '',style: TextStyle(),),
                                    ],
                                  ),
                                  Text('PKR ${requestDetails['requestAmount']?? ''}',style: TextStyle(color: greyColor),)
                                ],
                              )],
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  children: [Text(lawyerDetails['name']?? '??',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.star,color: yellowColor,),
                                        Text(lawyerDetails['rating']?? '0.0',style: TextStyle(),),
                                      ],
                                    ),
                                  ]                ),
                              CacheImageCircle(url: lawyerDetails['url'])
                            ],
                          ),
                        ),

                      ],
                    )
                ),
              ),
              SizedBox(height: 16.0),
        
              // Cancellation Policy
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Cancellation Policy\n\nIf you cancel less than 24 hours before your booking, you may be charged a cancellation fee up to the full amount of the services booked.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
        
              SizedBox(height: 16.0),
        
              // Order Summary
              Text(
                'Job Summary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              OrderSummaryRow(label: 'Subtotal', amount: 'PKR ${requestDetails['requestAmount']}'),
              OrderSummaryRow(label: 'Est. Tax', amount: 'PKR 0.0'),
              Divider(),
              OrderSummaryRow(label: 'Total', amount: 'PKR ${requestDetails['requestAmount']}', isTotal: true),
        SizedBox(height: 30,),
             // Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: primaryColor),
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CompleteRequestBookingScreen(requestDetails: requestDetails,lawyerDetails: lawyerDetails,serviceDetails: serviceDetails,)));
                  },
                  child: Text(
                    'Complete Booking',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              // Cancel Booking Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: redColor),
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CancelRequestBookingScreen(requestDetails: requestDetails, lawyerDetails: lawyerDetails, serviceDetails: serviceDetails)));
                  },
                  child: Text(
                    'Cancel Booking',
                    style: TextStyle(color: redColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for Service Item
class ServiceItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;

  ServiceItem({required this.title, required this.subtitle, required this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        price,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }
}

// Widget for Order Summary Row
class OrderSummaryRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;

  OrderSummaryRow({required this.label, required this.amount, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

