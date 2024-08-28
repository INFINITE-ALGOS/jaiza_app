import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/lawyer_screens/create_service_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/get_categories_provider.dart';
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
    final categoryProvider=Provider.of<CategoriesProvider>(context);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40,right: 20,left: 20),
            child: Row(
              children: [
                GestureDetector(
                    child: const Icon(CupertinoIcons.clear)),
                SizedBox(width: screenWidth*0.05,),
                const Text("Which Service do you sell?",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
              ],
            ),

          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: categoryProvider.categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateServiceDetailScreen(categoryName: categoryProvider.categoriesList[index],)));},
                    child: ListTile(
                      leading: const CircleAvatar(),
                      title: Text(categoryProvider.categoriesList[index]),
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
