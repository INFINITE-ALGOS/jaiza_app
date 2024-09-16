// BUSINESS SETUP, DOCUMENTATION, DISPUTE, CONSULTATNT, LEGAL ADVICE,LEGAL INFORMATION, LEGAL AIDS, TRAFFIC LAWS ETC

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/all_services_reltedto_category_screen.dart';
import 'package:provider/provider.dart';
import '../../conts.dart';
import '../../provider/general_provider.dart';
class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({super.key});

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Map<String,dynamic> categoriesMap= {};
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
   final generalProvider= Provider.of<GeneralProvider>(context);
  categoriesMap=  generalProvider.categoriesMap;

    return SafeArea(
      child: Scaffold(
        body:Column(
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
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        color: greyColor,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Search",
                        style:
                        TextStyle(color: Colors.black.withOpacity(0.6)),
                      )
                    ],
                  ),
                ),
              ),
            ),
         categoriesMap.isNotEmpty?   Expanded(
              child: GridView.builder(itemCount:categoriesMap .length,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (BuildContext context,index){
                String key = categoriesMap.keys.elementAt(index);
                Map<String, dynamic> category = categoriesMap[key];
                final String url=category['url'];
                final String name=category['name'];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AllServicesRelatedToCategory(categoryName: name,url: url,)));
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 15, right: 15),
                    child: Container(
                      child: Column(
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
                              //shape: BoxShape.circle, // Makes the container circular
                            ),
                            clipBehavior: Clip.hardEdge, // Ensures the image is clipped to the circular border
                              child: CachedNetworkImage(height: 100,width: double.infinity,imageUrl: url,
                                placeholder: (context, url) => CupertinoActivityIndicator(),  // Loading widget
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,// Fallback when image not found
                              )                          ),
                          Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ) : Expanded(
           child: GridView.builder(itemCount:8,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (BuildContext context,index){

             return Padding(
               padding:
               const EdgeInsets.only(top: 15, right: 15),
               child: Container(
                 child: Column(
                   children: [

                     Container(
                         height: screenHeight * 0.12,
                         width: screenWidth * 0.28,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20),
                           border: Border.all(
                             color: Colors.grey[300]!,
                             width: 1,
                           ),
                           //shape: BoxShape.circle, // Makes the container circular
                         ),
                         clipBehavior: Clip.hardEdge, // Ensures the image is clipped to the circular border
                           ),

                   ],
                 ),
               ),
             );
           }),
         ),
          ],
        ) ,
      ),
    );
  }
}
