import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/custom_alert_dialog.dart'; // Import the custom alert dialog component
import '../../../../conts.dart';
import '../../see_lawyer_profile.dart';

// Define a StarRating widget
class StarRating extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  StarRating({
    Key? key,
    this.initialRating = 0.0,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color: index < _rating ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
            widget.onRatingChanged(_rating);
          },
        );
      }),
    );
  }
}

class AcceptBookingScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final Map<String, dynamic> offer;

  const AcceptBookingScreen({super.key, required this.job, required this.offer});

  @override
  _AcceptBookingScreenState createState() => _AcceptBookingScreenState();
}

class _AcceptBookingScreenState extends State<AcceptBookingScreen> {
  double _rating = 3.0; // Default rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Handle back action
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
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service List
              InkWell(
                onTap: () {},
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(
                                widget.job['title'] ?? '??',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),maxLines: 1,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                '${widget.job['status'] ?? ''}'.toUpperCase(),
                                style: TextStyle(color: whiteColor, fontSize: 9),
                              ),
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
                                Text(widget.job['duration'] ?? '', style: TextStyle()),
                              ],
                            ),
                            Text(
                              'PKR ${widget.offer['offerDetails']['offerAmount'] ?? ''}',
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
                                Row(
                                  children: [
                                    Text(
                                      widget.offer['lawyerDetails']['name'] ?? '??',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 20,),
                                    InkWell(
                                        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeLawyerProfile(lawyer: widget.offer['lawyerDetails'])));},
                                        child: Text("View Profile",style: TextStyle(color: primaryColor,fontSize: 12,decoration: TextDecoration.underline,decorationColor: primaryColor),))

                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: yellowColor),
                                    Text(widget.offer['lawyerDetails']['rating'] ?? '0.0', style: TextStyle()),
                                  ],
                                ),
                              ],
                            ),
                            CacheImageCircle(url: widget.offer['lawyerDetails']['url']),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Rating Section
              Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(color: lightGreyColor, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Rating',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            '$_rating',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    StarRating(
                      initialRating: _rating,
                      onRatingChanged: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                  ],
                ),
              ),

              Container(
                margin:EdgeInsets.all(15.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(color: lightGreyColor,width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drop a Review',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextField(
                      decoration: InputDecoration(hintText: "Write a review",border: InputBorder.none),
                    ),
                    SizedBox(height: 5.0),

                  ],
                ),
              ),

              SizedBox(height: 16.0),
              Text(
                'Job Summary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              OrderSummaryRow(label: 'Subtotal', amount: 'PKR ${widget.offer['offerDetails']['offerAmount']}'),
              OrderSummaryRow(label: 'Est. Tax', amount: 'PKR 0.0'),
              Divider(),
              OrderSummaryRow(label: 'Total', amount: 'PKR ${widget.offer['offerDetails']['offerAmount']}', isTotal: true),

              SizedBox(height: 20), // Replace Spacer with SizedBox
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
                  onPressed: ()async {
                    EasyLoading.show(status: "PLease wait");
                  await  FirebaseFirestore.instance.collection('jobs').doc(widget.job['jobId']).update({'status':'completed'});
                  await  FirebaseFirestore.instance.collection('offers').doc(widget.offer['offerDetails']['offerId']).update({'status':'completed'});
                    EasyLoading.dismiss();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigationbarClient(selectedIndex: 3)),  (Route<dynamic> route) => false,);
                    // Handle complete booking action
                  },
                  child: Text(
                    'Complete Booking',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}

class OrderSummaryRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;

  const OrderSummaryRow({
    Key? key,
    required this.label,
    required this.amount,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: isTotal ? 18.0 : 14.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: isTotal ? 18.0 : 14.0, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
