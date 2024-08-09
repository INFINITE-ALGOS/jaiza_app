import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/all_lawyers_screens.dart';
import 'package:law_education_app/screens/client_screens/all_services_screen.dart';
import 'package:law_education_app/screens/client_screens/all_toplawyers_screen.dart';

import '../../conts.dart';
import 'jobs_status/active_job_screen.dart';
import 'law_books_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      color: greyColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          "Current Location",
                          style: TextStyle(fontSize: 12, color: greyColor),
                        ),
                        Text(
                          "New York city",
                          style: TextStyle(fontSize: 12, color: blackColor),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(CupertinoIcons.bell)
                  ],
                ),
              ),
            ),
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
            //SizedBox(height: screenHeight*0.01,),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Placeholder(
                fallbackHeight: screenHeight * 0.23,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),

            //SERVICES WIDGET
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Active Jobs",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveScreen()));
                          },
                          child: Text(
                            "View all >>",
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.3,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(top: 15, right: 15,bottom: 20),
                              child: Container(
                              //  margin: EdgeInsets.symmetric(horizontal: 0.01),
                                height: MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.89,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFf1f1f2),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.only(left: 10, top: 15),
                                              child: Text(
                                                "#542456",
                                                style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Text(
                                                "Home Cleaner",
                                                style: TextStyle(
                                                    fontSize: 17, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Text(
                                                "21 sep 21,03:00 - 04:30 PM ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                                alignment: Alignment.topRight,
                                                padding: EdgeInsets.only(left: 10, top: 15),
                                                child: Container(
                                                  height: 30,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .blue, // Background color of the container
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Accepted",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: whiteColor),
                                                    ),
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: Text(
                                                "\$ 149",
                                                style: TextStyle(
                                                    fontSize: 17, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 15),
                                      child: Divider(
                                        thickness: 1.5,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Levi Ray",
                                                style: TextStyle(
                                                    fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "4.9 192 rating",
                                                style:
                                                TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 100,
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(left: 20),
                                          child: CircleAvatar(
                                            radius: 20, // Radius of the circle
                                            //  backgroundImage: NetworkImage('https://example.com/your-image.jpg'), // Replace with your image URL
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.01,
              color: lightGreyColor,
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "services",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AllServicesScreen()));
                          },
                          child: Text(
                            "View all >>",
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(top: 15, right: 15),
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.12,
                                      width: screenWidth * 0.24,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                              color: lightGreyColor,
                                              width: 1)),
                                      child: Center(
                                        child: Icon(
                                            Icons.miscellaneous_services),
                                      ),
                                    ),
                                    Text(
                                      "Services",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.01,
              color: lightGreyColor,
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            //LAWEYSRS SCREEN
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.005, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Lawyers",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AllLawyersScreens()));
                          },
                          child: Text(
                            "View all >>",
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.25,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(right: 25, top: 15),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Placeholder(
                                      fallbackHeight: screenHeight * 0.12,
                                      fallbackWidth: screenWidth * 0.2,
                                    ),
                                    SizedBox(height: screenHeight*0.02,),
                                        Text(
                                          "Criminal",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.01,
              color: lightGreyColor,
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Law Books",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LawBooks()));
                          },
                          child: Text(
                            "View all >>",
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(top: 15, right: 15),
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.12,
                                      width: screenWidth * 0.24,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                              color: lightGreyColor,
                                              width: 1)),
                                      child: Center(
                                        child: Icon(
                                            Icons.miscellaneous_services),
                                      ),
                                    ),
                                    Text(
                                      "books name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
