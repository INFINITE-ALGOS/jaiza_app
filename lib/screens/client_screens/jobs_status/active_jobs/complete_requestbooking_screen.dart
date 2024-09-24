import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/custom_alert_dialog.dart'; // Import the custom alert dialog component
import '../../../../conts.dart';
import '../../see_lawyer_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class CompleteRequestBookingScreen extends StatefulWidget {
  final Map<String, dynamic> requestDetails;
  final Map<String, dynamic> serviceDetails;
  final Map<String, dynamic> lawyerDetails;

  const CompleteRequestBookingScreen(
      {super.key,
      required this.requestDetails,
      required this.lawyerDetails,
      required this.serviceDetails});

  @override
  _CompleteRequestBookingScreenState createState() =>
      _CompleteRequestBookingScreenState();
}

class _CompleteRequestBookingScreenState
    extends State<CompleteRequestBookingScreen> {
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
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service List
              Padding(
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
                          Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: Text(
                              widget.requestDetails['requestMessage'] ?? '??',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
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
                              '${widget.requestDetails['status'] ?? ''}'
                                  .toUpperCase(),
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
                              Text(widget.requestDetails['duration'] ?? '',
                                  style: TextStyle()),
                            ],
                          ),
                          Text(
                            'PKR ${widget.requestDetails['requestAmount'] ?? ''}',
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
                                    widget.lawyerDetails['name'] ?? '??',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SeeLawyerProfile(
                                                        lawyer: widget
                                                            .lawyerDetails)));
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.viewProfile,
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: primaryColor),
                                      ))
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: yellowColor),
                                  Text(widget.lawyerDetails['rating'] ?? '0.0',
                                      style: TextStyle()),
                                ],
                              ),
                            ],
                          ),
                          CacheImageCircle(url: widget.lawyerDetails['url']),
                        ],
                      ),
                    ],
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
                          AppLocalizations.of(context)!.yourRating,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
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
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(color: lightGreyColor, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dropAReview,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextField(
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.writeAReview, border: InputBorder.none),
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              ),

              SizedBox(height: 16.0),
              Text(
                AppLocalizations.of(context)!.jobSummary,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              OrderSummaryRow(
                  label: AppLocalizations.of(context)!.subtotal,
                  amount: 'PKR ${widget.requestDetails['requestAmount']}'),
              OrderSummaryRow(label: AppLocalizations.of(context)!.estTax, amount: 'PKR 0.0'),
              Divider(),
              OrderSummaryRow(
                  label: AppLocalizations.of(context)!.total,
                  amount: 'PKR ${widget.requestDetails['requestAmount']}',
                  isTotal: true),

              SizedBox(height: 20), // Replace Spacer with SizedBox
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: primaryColor),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    EasyLoading.show(status: AppLocalizations.of(context)!.pleaseWait);
                    await FirebaseFirestore.instance
                        .collection('requests')
                        .doc(widget.requestDetails['requestId'])
                        .update({'status': 'completed'});
                    EasyLoading.dismiss();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomNavigationbarClient(selectedIndex: 3)),
                      (Route<dynamic> route) => false,
                    );
                    // Handle complete booking action
                  },
                  child: Text(
                    AppLocalizations.of(context)!.completeBooking,
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
            style: TextStyle(
                fontSize: isTotal ? 18.0 : 14.0,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            amount,
            style: TextStyle(
                fontSize: isTotal ? 18.0 : 14.0,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
