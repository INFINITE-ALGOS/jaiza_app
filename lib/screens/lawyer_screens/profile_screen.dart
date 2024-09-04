import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/myprofile_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_provider.dart';
import 'edit_profile_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreenLawyer extends StatefulWidget {
  const ProfileScreenLawyer({super.key});

  @override
  State<ProfileScreenLawyer> createState() => _ProfileScreenLawyerState();
}

class _ProfileScreenLawyerState extends State<ProfileScreenLawyer> {
  late MyProfileController _profileController;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _profileController = MyProfileController();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    _profileData = await _profileController.getProfileData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final profileImage = _profileData?['url'] ?? 'https://www.pngitem.com/pimgs/m/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png';

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
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(profileImage),
                      ),
                      InkWell(
                        onTap: () {
                          //ImageUploadService.pickImage(context);
                        },
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: primaryColor,
                          child: const Icon(
                            Icons.add_sharp,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _profileData?['email'] ?? 'Email not available',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
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
                    const SizedBox(height: 30),
                    Text(
                      'Other Information',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      child: Text(
                        "Name: ${_profileData?['name'] ?? ""}",
                        style: const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      child: Text(
                        'Phone: ${_profileData?['phone'] ?? ""}',
                        style: const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      child: Text(
                        'Rating: ${_profileData?['rating'] ?? ""}',
                        style: const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        child: const Text('Edit Info'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Log out",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Are you sure you want to logout?',
                      style: TextStyle(fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel', style: TextStyle(color: whiteColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text('Logout', style: TextStyle(color: whiteColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
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
