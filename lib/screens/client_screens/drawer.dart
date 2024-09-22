import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/profile_screen(client).dart';
import 'package:law_education_app/widgets/cache_image_circle.dart';
import 'package:provider/provider.dart';

import '../../provider/myprofile_controller.dart';
import '../../conts.dart';
import '../auth/login_screen.dart';

class CustomDrawerClient extends StatefulWidget {
  const CustomDrawerClient({super.key});

  @override
  State<CustomDrawerClient> createState() => _CustomDrawerClientState();
}

class _CustomDrawerClientState extends State<CustomDrawerClient> {


  // Future<void> _fetchProfileData() async {
  //   _profileData = await _profileController.getProfileData();
  //   print("Fetched Profile Data: $_profileData");
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final profileData=Provider.of<MyProfileProvider>(context).profileData;
    return Drawer(
      clipBehavior: Clip.hardEdge,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Padding(
              padding: EdgeInsets.only(top: 30,left: 10),
              child: Text(profileData['name']??"Loading..."),
            ),
            accountEmail: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(profileData['email']??"Loading..."),
            ),
            decoration: BoxDecoration(
                color: primaryColor
            ),
            currentAccountPicture: CircleAvatar(
              radius: 50,
              backgroundColor:primaryColor, // Set a background color if image is null
              child: CacheImageCircle(url: profileData['url'],radius: 70,borderRadius: 35,)
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text("Profile"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreenClient()));
            },
          ),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("App Info"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: (){},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star_rate_outlined),
            title: const Text("Rate Our App"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text("Terms of use & privacy statement"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("About"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text("Contact us"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: () async{
             await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (Route route)=>false);

            },
          ),
        ],
      ),
    );

  }
}
