import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Ensure this path is correct and contains required definitions

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> locations = [
    'Agartala',
    'Agra',
    'Ahmedabad',
    'Ajmer',
    'Akola',
    'Alappuzha',
  ];

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenHeight = mediaQuery.size.height;
    var screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            const SizedBox(height: 20), // Add spacing at the top if needed
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back when tapped
                  },
                  child: CircleAvatar(
                    radius: 20, // Adjust size as needed
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(CupertinoIcons.back, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between avatar and text field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for location & service",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add spacing between widgets
            const Divider(
              indent: 0,
              endIndent: 0,
              thickness: 2,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.black),
                    title: Text(locations[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
