import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/create_service_detail_screen.dart';

import '../../conts.dart';
class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
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
                    child: Icon(CupertinoIcons.clear)),
                SizedBox(width: screenWidth*0.05,),
                Text("Which Service do you want?",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
              ],
            ),

          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateServiceDetailScreen()));},
                    child: ListTile(
                      leading: CircleAvatar(),
                      title: Text("Category Name"),
                      trailing: Icon(CupertinoIcons.forward),
                    ),
                  );
                }),
          )
        ],
      ),
    ));
  }
}
