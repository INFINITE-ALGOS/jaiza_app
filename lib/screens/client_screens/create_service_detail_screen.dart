import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
class CreateServiceDetailScreen extends StatefulWidget {
  const CreateServiceDetailScreen({super.key});

  @override
  State<CreateServiceDetailScreen> createState() => _CreateServiceDetailScreenState();
}

class _CreateServiceDetailScreenState extends State<CreateServiceDetailScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
                onTap: (){Navigator.pop(context);},
                child: Icon(CupertinoIcons.back)),
            SizedBox(width: screenWidth*0.05,),
            Text("Which Service do you want?",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
        
            children: [
              ListTile(
                leading: CircleAvatar(),
                title: Text("Category"),
              ),
              SizedBox(height: screenHeight*0.05,),
              // TITLE
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Service Title",style: TextStyle(fontWeight: FontWeight.w600),),
        
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: blackColor)),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Title",
                          border:InputBorder.none
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.05,),
        
              // DESCRIPTION
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Description",style: TextStyle(fontWeight: FontWeight.w600),),
        
                    Container(
                      height: screenHeight*0.2,
                      margin: EdgeInsets.only(top: 12),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: blackColor)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter Description",
                            border:InputBorder.none
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.05,),
        
              //LOCATION
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Location",style: TextStyle(fontWeight: FontWeight.w600),),
        
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: blackColor)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter Location",
                            border:InputBorder.none
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.05,),
        
              // PRICE
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Price",style: TextStyle(fontWeight: FontWeight.w600),),
        
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: blackColor)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter Price",
                            border:InputBorder.none
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.05,),

              ElevatedButton(onPressed: (){}, child: Text("Done"))
            ],
          ),
        ),
      ),
    );
  }
}
