import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/lawyer_screens/create_service_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/general_provider.dart';
import '../../provider/myprofile_controller.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  // final List<String >categoryList=[];
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<MyProfileProvider>(context);
    final List<dynamic> selectedCategories =
        profileProvider.profileData['lawyerProfile']['expertise'] ?? [];

    final generalProvider = Provider.of<GeneralProvider>(context);
    final filteredCategories = generalProvider.categoriesMap.entries
        .where((entry) => selectedCategories.contains(entry.value['name']))
        .toList();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
            child: Row(
              children: [
                InkWell(
                  child: const Icon(CupertinoIcons.clear),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: screenWidth * 0.05,
                ),
                const Text(
                  "Which Service do you sell?",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  final String url = category.value['url'];
                  final String name = category.value['name'];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateServiceDetailScreen(
                                    categoryName: name,
                                    categoryUrl: url,
                                  )));
                    },
                    child: ListTile(
                      leading: Container(
                        height:
                            35, // Increase the size to make the circular image more visible
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          // Clip the image in a circular shape
                          borderRadius: BorderRadius.circular(
                              17.5), // Half of the width/height to make it circular
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit
                                .cover, // This will make sure the image covers the entire circular area
                          ),
                        ),
                      ),
                      title: Text(name),
                      trailing: const Icon(CupertinoIcons.forward),
                    ),
                  );
                }),
          )
        ],
      ),
    ));
  }
}
