import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/myprofile_controller.dart';

import '../lawyer_screens/edit_profile_screen.dart';

class ProfileScreenClient extends StatefulWidget {
  const ProfileScreenClient({super.key});

  @override
  State<ProfileScreenClient> createState() => _ProfileScreenClientState();
}

class _ProfileScreenClientState extends State<ProfileScreenClient> {

  late MyProfileController _myProfileController ;
  Map<String,dynamic>? _profileData;

  @override
  void initState(){
    super.initState();
    _myProfileController = MyProfileController();
      _fetchProfileData();
  }
  Future<void> _fetchProfileData()
  async {
    _profileData=await _myProfileController.getProfileData();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://example.com/profile.jpg'),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ),
                            );
                            // Refresh profile data after returning from EditProfileScreen
                            _fetchProfileData();
                          },
                          child: Text('Edit Info'),
                          style: ElevatedButton.styleFrom(
                            //primary: Colors.blue,
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
  }
}