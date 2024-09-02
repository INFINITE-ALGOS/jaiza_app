// CRIMINAL,CCIVIL,PUBLIC INTEREST,IMIGRATION,PROPERTY,

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/lawyer_profile.dart';

import '../../conts.dart';
class AllClientsScreen extends StatefulWidget {
  const AllClientsScreen({super.key});

  @override
  State<AllClientsScreen> createState() => _AllClientsScreenState();
}

class _AllClientsScreenState extends State<AllClientsScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.03, right: 20, left: 20),
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.075,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.search,
                          color: greyColor,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Search",
                          style:
                          TextStyle(color: Colors.black.withOpacity(0.6)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: 10,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SeeLawyerProfile()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20, top: 15),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Placeholder(
                                  fallbackHeight: screenHeight * 0.10,
                                  fallbackWidth: screenWidth * 0.1,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                                const Text(
                                  "client Name",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
