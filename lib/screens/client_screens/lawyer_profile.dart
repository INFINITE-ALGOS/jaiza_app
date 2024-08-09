import 'package:flutter/material.dart';
class LawyerProfile extends StatefulWidget {
  const LawyerProfile({super.key});
  @override
  State<LawyerProfile> createState() => _LawyerProfileState();
}
class _LawyerProfileState extends State<LawyerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe6f2fe),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  radius: 20,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.55),
              Container(
                child: Icon(
                  Icons.notifications_none,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                child: Icon(
                  Icons.messenger_outline,
                  size: 30,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.87,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Criminal Lawyers",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: 35, // Width of the container
                height: 30, // Height of the container
                decoration: BoxDecoration(
                  color: Colors.blue, // Background color of the container
                  borderRadius: BorderRadius.circular(25), // Make it circular
                ),
                child: Center(
                  child: Text(
                    '25+', // Text inside the container
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 13, // Font size
                      fontWeight: FontWeight.bold, // Text weight
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            //child here
          ),
          Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20,top: 20),
                        child: Text(
                          "Rikita Sharma",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          "Criminal Lawyer",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                  Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(left: 10, top: 15),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color:
                          Colors.blue, // Background color of the container
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Book",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      width: 35, // Width of the container
                      height: 30, // Height of the container
                      decoration: BoxDecoration(
                        color: Colors.blue, // Background color of the container
                        borderRadius: BorderRadius.circular(25), // Make it circular
                      ),
                      child: Center(
                        child: Text(
                          '25+', // Text inside the container
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 13, // Font size
                            fontWeight: FontWeight.bold, // Text weight
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    child: Text('Cases',style: TextStyle(
                      color: Colors.blue,
                    ),),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      width: 35, // Width of the container
                      height: 30, // Height of the container
                      decoration: BoxDecoration(
                        color: Colors.blue, // Background color of the container
                        borderRadius: BorderRadius.circular(25), // Make it circular
                      ),
                      child: Center(
                        child: Text(
                          '12+', // Text inside the container
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 13, // Font size
                            fontWeight: FontWeight.bold, // Text weight
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    child: Text('Experience',style: TextStyle(
                      color: Colors.blue,
                    ),),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      width: 35, // Width of the container
                      height: 30, // Height of the container
                      decoration: BoxDecoration(
                        color: Colors.blue, // Background color of the container
                        borderRadius: BorderRadius.circular(25), // Make it circular
                      ),
                      child: Center(
                        child: Text(
                          '7.6', // Text inside the container
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 13, // Font size
                            fontWeight: FontWeight.bold, // Text weight
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    child: Text('Rating',style: TextStyle(
                      color: Colors.blue,
                    ),),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              SizedBox(width: 30,),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color:
                      Colors.blue, // Background color of the container
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "About",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )),
              SizedBox(width: 30,),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10, top: 20),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color:
                      Colors.white, // Background color of the container
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Portfolio",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}






