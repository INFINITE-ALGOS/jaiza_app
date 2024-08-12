import 'package:flutter/material.dart';

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
          UserAccountsDrawerHeader(
            accountName: Padding(
              padding: const EdgeInsets.only(top: 30,left: 10),
              child: Text("Name"),
            ),
            accountEmail: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("person@gmail.com"),
            ),
            decoration: BoxDecoration(
                color: Color(0xFF2196f3)
            ),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text("Profile"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.play_circle),
            title: Text("Add Free Subcription"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("App Info"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: (){},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star_rate_outlined),
            title: Text("Rate Our App"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.health_and_safety),
            title: Text("Terms of use & privacy statement"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("About"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text("Contact us"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Delete Account"),
            onTap: (){},
          ),
        ],
      ),
    );

  }
}
