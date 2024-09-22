import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:law_education_app/controllers/create_service_controller.dart';
import 'package:law_education_app/conts.dart';

import '../../utils/validateor.dart';

class CreateServiceDetailScreen extends StatefulWidget {
  final String categoryName;
  final String categoryUrl;

  const CreateServiceDetailScreen(
      {super.key, required this.categoryName, required this.categoryUrl});

  @override
  State<CreateServiceDetailScreen> createState() =>
      _CreateServiceDetailScreenState();
}

class _CreateServiceDetailScreenState extends State<CreateServiceDetailScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final key = GlobalKey<FormState>();
  double screenHeight = 0;
  double screenWidth = 0;
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
                SizedBox(
                  height: 50,
                ),

                ListTile(
                  leading: Container(
                    height:
                        50, // Increase the size to make the circular image more visible
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      // Clip the image in a circular shape
                      borderRadius: BorderRadius.circular(
                          25), // Half of the width/height to make it circular
                      child: CachedNetworkImage(
                        imageUrl: widget.categoryUrl,
                        fit: BoxFit
                            .cover, // This will make sure the image covers the entire circular area
                      ),
                    ),
                  ),
                  title: Text(
                    widget.categoryName,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
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
                          controller: titleController,
                          validator: (value) =>
                              FieldValidators().validateField(value, "title"),
                          decoration: const InputDecoration(
                              hintText: "Enter Title",
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),

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
                          validator: (value) => FieldValidators()
                              .validateField(value, "description"),
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: "Enter Description",
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),

                //LOCATION
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
                          controller: locationController,
                          validator: (value) => FieldValidators()
                              .validateField(value, "location"),
                          decoration: const InputDecoration(
                              hintText: "Enter Location",
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),

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
                          validator: (value) =>
                              FieldValidators().validateField(value, "price"),
                          keyboardType: TextInputType.number,
                          controller: priceController,
                          decoration: const InputDecoration(
                              hintText: "Enter Price",
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),

                ElevatedButton(
                    onPressed: () {
                      if (key.currentState!.validate()) {
                        CreateServiceController().createServiceMethod(
                            title: titleController.text.trim(),
                            description: descriptionController.text.trim(),
                            price: priceController.text.trim(),
                            location: locationController.text.trim(),
                            category: widget.categoryName,
                            context: context);
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    child: const Text(
                      "Done",
                      style: TextStyle(color: whiteColor),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
