import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/provider/general_provider.dart';
import 'package:law_education_app/screens/client_screens/create_job_detail_screen.dart';
import 'package:provider/provider.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
 // final List<String >categoryList=[];
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
        final categoryProvider=Provider.of<GeneralProvider>(context);
    return SafeArea(child: Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40,right: 20,left: 20),
            child: Row(
              children: [
                GestureDetector(
                    child: const Icon(CupertinoIcons.clear),
                onTap: (){Navigator.of(context).pop();},),
                SizedBox(width: screenWidth*0.05,),
                const Text("Which Service do you want?",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
              ],
            ),

          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: categoryProvider.categoriesMap.length,
                itemBuilder: (context, index) {
                  String key=categoryProvider.categoriesMap.keys.elementAt(index);
                  Map<String,dynamic> category=categoryProvider.categoriesMap[key];
                  final String url = category['url'];
                  final String name = category['name'];
                  return InkWell(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateJobDetailScreen(categoryName: name,categoryUrl:url,)));},
                    child:  ListTile(
                    leading:  Container(
                    height: 35, // Increase the size to make the circular image more visible
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect( // Clip the image in a circular shape
                      borderRadius: BorderRadius.circular(17.5), // Half of the width/height to make it circular
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover, // This will make sure the image covers the entire circular area
                      ),
                    ),
                  ),

                  title: Text(name),
                  trailing: const Icon(CupertinoIcons.forward),
                  )
                  );
                }),
          )
        ],
      ),
    ));
  }
}
