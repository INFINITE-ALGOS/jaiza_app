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
      backgroundColor: const Color(0xFFe6f2fe),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(left: 20),
                child: const CircleAvatar(
                  radius: 20,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.55),
              Container(
                child: const Icon(
                  Icons.notifications_none,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                child: const Icon(
                  Icons.messenger_outline,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  "Criminal Lawyers",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                width: 35, // Width of the container
                height: 30, // Height of the container
                decoration: BoxDecoration(
                  color: Colors.blue, // Background color of the container
                  borderRadius: BorderRadius.circular(25), // Make it circular
                ),
                child: const Center(
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
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                        padding: const EdgeInsets.only(left: 20,top: 20),
                        child: const Text(
                          "Rikita Sharma",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: const Text(
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
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color:
                          Colors.blue, // Background color of the container
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
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
          const SizedBox(
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
                      child: const Center(
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
                    padding: const EdgeInsets.only(left: 30),
                    child: const Text('Cases',style: TextStyle(
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
                      child: const Center(
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
                    padding: const EdgeInsets.only(left: 30),
                    child: const Text('Experience',style: TextStyle(
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
                      child: const Center(
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
                    padding: const EdgeInsets.only(left: 30),
                    child: const Text('Rating',style: TextStyle(
                      color: Colors.blue,
                    ),),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              const SizedBox(width: 30,),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color:
                      Colors.blue, // Background color of the container
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
                  )),
              const SizedBox(width: 30,),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color:
                      Colors.white, // Background color of the container
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
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






