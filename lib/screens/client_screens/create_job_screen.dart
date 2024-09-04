import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/provider/get_categories_provider.dart';
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
        final categoryProvider=Provider.of<CategoriesProvider>(context);
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
                const Text("Which Service do you want?",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
              ],
            ),

          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: categoryProvider.categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateJobDetailScreen(categoryName: categoryProvider.categoriesList[index],)));},
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
