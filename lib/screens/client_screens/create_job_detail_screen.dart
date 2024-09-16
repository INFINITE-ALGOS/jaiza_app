import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/create_job_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/utils/validateor.dart';

class CreateJobDetailScreen extends StatefulWidget {
  final String categoryName;
  final String categoryUrl;

  const CreateJobDetailScreen({super.key, required this.categoryName,required this.categoryUrl});

  @override
  State<CreateJobDetailScreen> createState() => _CreateJobDetailScreenState();
}

class _CreateJobDetailScreenState extends State<CreateJobDetailScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController customDurationController = TextEditingController();
final key=GlobalKey<FormState>();
  double screenHeight = 0;
  double screenWidth = 0;

  String? selectedDuration;
  List<String> durationOptions = [
    "1 day",
    "1 week",
    "1 month",
    "1 year",
    "Custom"
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Form(
        key: key,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(height: 50,),
                ListTile(
                  leading:  Container(
                    height: 50, // Increase the size to make the circular image more visible
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect( // Clip the image in a circular shape
                      borderRadius: BorderRadius.circular(25), // Half of the width/height to make it circular
                      child: CachedNetworkImage(
                        imageUrl: widget.categoryUrl,
                        fit: BoxFit.cover, // This will make sure the image covers the entire circular area
                      ),
                    ),
                  ),
                  title: Text(widget.categoryName,style: TextStyle(fontSize: 20),),
                ),
                SizedBox(height: screenHeight * 0.05),
                // TITLE
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Service Title",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: blackColor)),
                        child: TextFormField(
                          validator: (value)=>FieldValidators().validateField(value, "title"),
                          controller: titleController,
                          decoration: const InputDecoration(
                              hintText: "Enter Title", border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // DESCRIPTION
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        height: screenHeight * 0.2,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: blackColor)),
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: null,
                          validator: (value)=>FieldValidators().validateField(value, "description"),

                          decoration: const InputDecoration(
                              hintText: "Enter Description",
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // LOCATION
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Location",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: blackColor)),
                        child: TextFormField(
                          validator: (value)=>FieldValidators().validateField(value, "location"),

                          controller: locationController,
                          decoration: const InputDecoration(
                              hintText: "Enter Location",
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // PRICE
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Price",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: blackColor)),
                        child: TextFormField(
                          validator: (value)=>FieldValidators().validateField(value, "price"),

                          keyboardType: TextInputType.number,
                          controller: priceController,
                          decoration: const InputDecoration(
                              hintText: "Enter Price", border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // DURATION
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Duration",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: blackColor)),
                        child: DropdownButtonFormField<String>(
                          dropdownColor: whiteColor,
                          value: selectedDuration,
                          items: durationOptions.map((String duration) {
                            return DropdownMenuItem<String>(
                              value: duration,
                              child: Text(duration),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDuration = newValue;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Select Duration",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a duration';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (selectedDuration == "Custom") ...[
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: blackColor)),
                          child: TextFormField(
                            controller: customDurationController,
                            decoration: const InputDecoration(
                              hintText: "Enter Custom Duration",
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              return FieldValidators().validateField(value, "Custom Duration");
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                ElevatedButton(
                    onPressed: () {
                      if(key.currentState!.validate()){
                        String duration = selectedDuration == "Custom"
                            ? customDurationController.text.trim()
                            : selectedDuration!;
                        final CreateJobController create =CreateJobController();
                        create.createJobMethod(
                            title: titleController.text.trim(),
                            description: descriptionController.text.trim(),
                            price: priceController.text.trim(),
                            location: locationController.text.trim(),
                            duration: duration,
                            category: widget.categoryName,
                            context: context);

                      }                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),child: const Text("Done",style: TextStyle(color: whiteColor),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
