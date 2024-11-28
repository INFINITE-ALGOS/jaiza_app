import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/see_lawyer_profile.dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:law_education_app/widgets/custom_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../conts.dart';

class ViewOffersOnMyJobScreen extends StatelessWidget {
  final Map<String, dynamic> job;
  final List<Map<String, dynamic>>? offers;
  const ViewOffersOnMyJobScreen(
      {super.key, required this.job, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.offers),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: offers!.isNotEmpty
            ? ListView.builder(
                itemCount: offers!.length,
                itemBuilder: (context, index) {
                  if (offers![index]['offerDetails']['status'] == 'pending') {
                    return OfferCard(
                        offer: offers![index]['offerDetails'],
                        lawyer: offers![index]['lawyerDetails']);
                  } else {
                    return ReproposalOfferCard(
                        offer: offers![index]['offerDetails'],
                        lawyer: offers![index]['lawyerDetails']);
                  }
                })
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.noOffersGivenByLawyer,
                ),
              ),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;
  final Map<String, dynamic> lawyer;

  const OfferCard({super.key, required this.offer, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    //  final navigation=Provider.of<NavigationService>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor), // Example color
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.white, // Example color
            margin: const EdgeInsets.only(bottom: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                (lawyer['name'] ?? '').toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
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
                                                    lawyer: lawyer)));
                                  },
                                  child: Text(
                                   AppLocalizations.of(context)!.viewProfile,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        decorationColor: primaryColor),
                                  ))
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lawyer['location'] ?? 'No Location',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      const Spacer(),
                      CacheImageCircle(url: lawyer['url'])
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Rating: ${lawyer['rating']}'),
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
                 TextSpan(
                  text: AppLocalizations.of(context)!.messageColon,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: offer['offerMessage'],
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                 TextSpan(
                  text: AppLocalizations.of(context)!.offerPriceColon,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: offer['offerAmount'],
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
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                            title: '',
                            content:
                            AppLocalizations.of(context)!.areYouSureYouWantToAcceptTheOffer,
                            onConfirm: () {
                              FirebaseFirestore.instance
                                  .collection('offers')
                                  .doc(offer['offerId'])
                                  .update({'status': "active"});
                              FirebaseFirestore.instance
                                  .collection('jobs')
                                  .doc(offer['jobId'])
                                  .update({'status': "active"});
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavigationbarClient(
                                            selectedIndex:
                                                3)), // New screen to navigate to
                                (Route<dynamic> route) =>
                                    false, // Predicate to determine which routes to remove
                              );
                            },
                            onCancel: () {
                              Navigator.of(context).pop();
                            });
                      });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.green, // Example color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Text(
                    AppLocalizations.of(context)!.accept,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                            title: '',
                            content: AppLocalizations.of(context)!.areYouSureYouWantToRejectTheOffer,
                            onConfirm: () {
                              FirebaseFirestore.instance
                                  .collection('offers')
                                  .doc(offer['offerId'])
                                  .update({'status': "rejected"});
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavigationbarClient(
                                            selectedIndex:
                                                3)), // New screen to navigate to
                                (Route<dynamic> route) =>
                                    false, // Predicate to determine which routes to remove
                              );
                            },
                            onCancel: () {
                              Navigator.of(context).pop();
                            });
                      });
                  // Handle Reject action
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red, // Example color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Text(
                    AppLocalizations.of(context)!.reject,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                            title: '',
                            content:
                            AppLocalizations.of(context)!.areYouSureYouWantToReproposeTheOffer,
                            onConfirm: () {
                              FirebaseFirestore.instance
                                  .collection('offers')
                                  .doc(offer['offerId'])
                                  .update({'status': "reproposal"});
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavigationbarClient(
                                            selectedIndex:
                                                3)), // New screen to navigate to
                                (Route<dynamic> route) =>
                                    false, // Predicate to determine which routes to remove
                              );
                            },
                            onCancel: () {
                              Navigator.of(context).pop();
                            });
                      });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.orange, // Example color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Text(
                   AppLocalizations.of(context)!.reproposal ,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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

class ReproposalOfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;
  final Map<String, dynamic> lawyer;

  const ReproposalOfferCard(
      {super.key, required this.offer, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    //  final navigation=Provider.of<NavigationService>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor), // Example color
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.white, // Example color
            margin: const EdgeInsets.only(bottom: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                (lawyer['name'] ?? '').toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
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
                                                    lawyer: lawyer)));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.viewProfile,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        decorationColor: primaryColor),
                                  ))
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lawyer['location'] ?? 'No Location',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      const Spacer(),
                      CacheImageCircle(url: lawyer['url'])
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Rating: ${lawyer['rating'] ?? '0.0'}'),
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
                 TextSpan(
                  text:  AppLocalizations.of(context)!.messageColon,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: offer['offerMessage'],
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                 TextSpan(
                  text: AppLocalizations.of(context)!.offerPriceColon ,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: offer['offerAmount'],
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              AppLocalizations.of(context)!.reproposal,
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
