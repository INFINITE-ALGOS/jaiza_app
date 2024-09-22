import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/lawyer_screens/alljobs_realtedto_category.dart';
import 'package:provider/provider.dart';
import '../../conts.dart';
import '../../provider/general_provider.dart';

class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  var allJobs = [];
  var filteredJobs = []; // Holds filtered clients based on search
  TextEditingController searchController = TextEditingController();
  bool hasResults = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterJobs();
    });
  }

  void filterJobs() {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      filteredJobs = allJobs.where((job) {
        final name = job.value['name'].toLowerCase();
        // Check if name contains the search term
        bool nameMatches = name.contains(searchTerm);

        return nameMatches;
      }).toList();

      hasResults = filteredJobs.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final generalProvider = Provider.of<GeneralProvider>(context);
    final profileProvider = Provider.of<MyProfileProvider>(context);

    final List<dynamic> selectedCategories =
        profileProvider.profileData['lawyerProfile']['expertise'] ?? [];
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    // Holds all clients data
    // Filter categories based on selectedCategories
    final filteredCategories = generalProvider.categoriesMap.entries
        .where((entry) => selectedCategories.contains(entry.value['name']))
        .toList();
    allJobs = filteredCategories;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.075,
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search by name...",
                        border: InputBorder.none,
                        icon:
                            const Icon(CupertinoIcons.search, color: greyColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Expanded(
              child: (() {
                if (filteredJobs.isEmpty && hasResults) {
                  filteredJobs = allJobs;
                  return _buildGridView(); // Show grid if there are results and the filtered list is empty
                } else if (!hasResults) {
                  return Center(
                      child: Text(
                          "No matching results found")); // Show message if no results found
                } else {
                  return _buildGridView(); // Handle the default case
                }
              })(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      itemCount: filteredJobs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
      ),
      itemBuilder: (BuildContext context, index) {
        final category = filteredJobs[index];
        final String url = category.value['url'];
        final String name = category.value['name'];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllJobsRelatedToCategory(
                    name: name,
                    url: url,
                  ),
                ),
              );
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: screenHeight * 0.12,
                    width: screenWidth * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: lightGreyColor,
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      url,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
