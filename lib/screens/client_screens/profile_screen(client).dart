import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/client_screens/edit_profile_screen_client.dart';
import 'package:provider/provider.dart';

import '../lawyer_screens/edit_profile_lawyer_screen.dart';

class ProfileScreenClient extends StatefulWidget {
  const ProfileScreenClient({super.key});

  @override
  State<ProfileScreenClient> createState() => _ProfileScreenClientState();
}

class _ProfileScreenClientState extends State<ProfileScreenClient> {

  @override
  Widget build(BuildContext context) {
    //final _profileData=Provider.of<MyProfileProvider>(context).profileData;

    return Consumer<MyProfileProvider>(builder: (context,profileProvider,child){
      final _profileData=profileProvider.profileData;
      return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: primaryColor,
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200], // Set a background color if image is null
                      child: _profileData['url'] == null || _profileData['url'] == ''
                          ? Icon(Icons.person, size: 50) // Default icon if no image
                          : ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'lib/assets/person.png', // Placeholder image while loading
                          image: _profileData['url'], // Network image URL
                          fit: BoxFit.cover,
                          width: 100, // Ensure width matches the CircleAvatar radius * 2
                          height: 100, // Ensure height matches the CircleAvatar radius * 2
                        ),
                      ),
                    ),


                    SizedBox(height: 10),
                    Text(
                      _profileData?['email'] ?? 'Email not available',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Other Information',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                        child: Text(
                          "Name: ${_profileData?['name'] ?? ""}",
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                        child: Text(
                          'Phone: ${_profileData?['phone'] ?? ""}',
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                        child: Text(
                          'Rating: ${_profileData?['rating'] ?? ""}',
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                        child: Text(
                          'Address: ${_profileData?['address'] ?? ""}',
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreenClient(profileData: _profileData,),
                              ),
                            );
                            // Refresh profile data after returning from EditProfileScreen
                            // _fetchProfileData();
                          },
                          child: Text('Edit Info',style: TextStyle(color: whiteColor),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}