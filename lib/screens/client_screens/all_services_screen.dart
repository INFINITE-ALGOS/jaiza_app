// BUSINESS SETUP, DOCUMENTATION, DISPUTE, CONSULTATNT, LEGAL ADVICE,LEGAL INFORMATION, LEGAL AIDS, TRAFFIC LAWS ETC

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/all_services_reltedto_category_screen.dart';
import 'package:provider/provider.dart';
import '../../conts.dart';
import '../../provider/get_categories_provider.dart';
class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({super.key});

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
   final categoryProvider= Provider.of<CategoriesProvider>(context);

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
            Expanded(
              child: GridView.builder(itemCount: categoryProvider.categoriesList.length,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (BuildContext context,index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AllServicesRelatedToCategory(categoryName: categoryProvider.categoriesList[index])));
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 15, right: 15),
                    child: Container(
                      child: Column(
                        children: [

                          Container(
                            height: screenHeight * 0.12,
                            width: screenWidth * 0.24,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10),
                                border: Border.all(
                                    color: lightGreyColor,
                                    width: 1)),
                            child: const Center(
                              child: Icon(
                                  Icons.miscellaneous_services),
                            ),
                          ),
                          Text(
                            categoryProvider.categoriesList[index],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
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
