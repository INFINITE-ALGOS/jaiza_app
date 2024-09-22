import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/profile_screen(lawyer).dart';
import 'package:provider/provider.dart';
import '../../conts.dart';
import '../../widgets/cache_image_circle.dart';

class CustomDrawerLawyer extends StatefulWidget {
  const CustomDrawerLawyer({super.key});

  @override
  State<CustomDrawerLawyer> createState() => _CustomDrawerLawyerState();
}

class _CustomDrawerLawyerState extends State<CustomDrawerLawyer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Consumer<MyProfileProvider>(
            builder: (context, profileProvider, child) {
              final profileData = profileProvider.profileData;
              return UserAccountsDrawerHeader(
                accountName: Padding(
                  padding: EdgeInsets.only(top: 30, left: 10),
                  child: Text(profileData['name'] ?? "Loading..."),
                ),
                accountEmail: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(profileData['email'] ?? "Loading..."),
                ),
                decoration: BoxDecoration(color: primaryColor),
                currentAccountPicture: CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        primaryColor, // Set a background color if image is null
                    child: CacheImageCircle(
                      url: profileData['url'],
                      radius: 70,
                      borderRadius: 35,
                    )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text("Profile"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreenLawyer()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("App Info"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star_rate_outlined),
            title: const Text("Rate Our App"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text("Terms of use & privacy statement"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("About"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text("Contact us"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route route) => false);
            },
          ),
        ],
      ),
    );
  }
}
