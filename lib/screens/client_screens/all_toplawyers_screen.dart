
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../conts.dart';
class AllTopLawyersScreens extends StatefulWidget {
  const AllTopLawyersScreens({super.key});

  @override
  State<AllTopLawyersScreens> createState() => _AllTopLawyersScreensState();
}

class _AllTopLawyersScreensState extends State<AllTopLawyersScreens> {
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
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.search,
                          color: greyColor,
                        ),
                        SizedBox(
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
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,),
                    itemBuilder: (context, index) {
                      return Padding(
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
                              Text(
                                "Name",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
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
