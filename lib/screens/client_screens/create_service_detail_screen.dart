import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/create_service_controller.dart';
import 'package:law_education_app/conts.dart';
class CreateServiceDetailScreen extends StatefulWidget {
  final String categoryName;
  const CreateServiceDetailScreen({super.key,required this.categoryName});

  @override
  State<CreateServiceDetailScreen> createState() => _CreateServiceDetailScreenState();
}

class _CreateServiceDetailScreenState extends State<CreateServiceDetailScreen> {
  final TextEditingController titleController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController locationController=TextEditingController();
  final TextEditingController priceController=TextEditingController();



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
            Text("Add A New Service",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)
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
                title: Text(widget.categoryName),
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
                        controller: titleController,
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
                        controller: descriptionController,
                        maxLines: null,
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
                        controller: locationController,
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
                        controller: priceController,
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

              ElevatedButton(onPressed: (){
                CreateServiceController().createServiceMethod(title: titleController.text.trim(), description: descriptionController.text.trim(), price: priceController.text.trim(), location: locationController.text.trim(), category: widget.categoryName, context: context);
              }, child: Text("Done"))
            ],
          ),
        ),
      ),
    );
  }
}
