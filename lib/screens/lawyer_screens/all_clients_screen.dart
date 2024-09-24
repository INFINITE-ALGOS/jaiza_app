import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/provider/get_clients_provider.dart';
import 'package:law_education_app/screens/lawyer_screens/see_client_profile.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../conts.dart';

class AllClientsScreen extends StatefulWidget {
  const AllClientsScreen({super.key});

  @override
  State<AllClientsScreen> createState() => _AllClientsScreenState();
}

class _AllClientsScreenState extends State<AllClientsScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allClients = []; // Holds all clients data
  List<Map<String, dynamic>> filteredClients =
      []; // Holds filtered clients based on search
  bool hasResults = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterClients();
    });
  }

  // Filter clients based on search text
  void filterClients() {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      filteredClients = allClients.where((client) {
        final name = client['name'].toLowerCase();
        // Check if name contains the search term
        bool nameMatches = name.contains(searchTerm);

        return nameMatches;
      }).toList();

      hasResults = filteredClients.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Search bar
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
                        hintText: AppLocalizations.of(context)!.searchByName,
                        border: InputBorder.none,
                        icon:
                            const Icon(CupertinoIcons.search, color: greyColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future:
                    Provider.of<GetClientsProvider>(context).getAllClients(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingShimmer();
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(child: Text("No Clients Found"));
                  } else {
                    allClients = snapshot.data!;
                    if (filteredClients.isEmpty && hasResults) {
                      filteredClients =
                          allClients; // Show all clients if no search term is applied
                    }
                    if (!hasResults) {
                      return Center(child: Text("No matching results found"));
                    }
                    return _buildGridView();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return GridView.builder(
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300]!,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  height: 10.0,
                  width: screenWidth * 0.2,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      itemCount: filteredClients.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final client = filteredClients[index];
        final name = client['name'];
        final url = client['url'];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SeeClientProfile(client: client)));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.12,
                    width: screenWidth * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: lightGreyColor, width: 1),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      height: 100,
                      width: double.infinity,
                      imageUrl: url,
                      placeholder: (context, url) =>
                          CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 6),
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
