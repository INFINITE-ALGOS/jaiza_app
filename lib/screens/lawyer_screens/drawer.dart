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
          const UserAccountsDrawerHeader(
            accountName: Padding(
              padding: EdgeInsets.only(top: 30,left: 10),
              child: Text("Name"),
            ),
            accountEmail: Padding(
              padding: EdgeInsets.only(left: 10),
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
            leading: const Icon(Icons.account_box),
            title: const Text("Profile"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.play_circle),
            title: const Text("Add Free Subcription"),
            onTap: (){},
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
            leading: const Icon(Icons.delete),
            title: const Text("Delete Account"),
            onTap: (){},
          ),
        ],
      ),
    );

  }
}
