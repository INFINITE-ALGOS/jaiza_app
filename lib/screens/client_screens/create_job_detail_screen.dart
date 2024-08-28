import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/create_job_controller.dart';
import 'package:law_education_app/conts.dart';

class CreateJobDetailScreen extends StatefulWidget {
  final String categoryName;
  const CreateJobDetailScreen({super.key, required this.categoryName});

  @override
  State<CreateJobDetailScreen> createState() => _CreateJobDetailScreenState();
}

class _CreateJobDetailScreenState extends State<CreateJobDetailScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController customDurationController = TextEditingController();

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(CupertinoIcons.back)),
            SizedBox(width: screenWidth * 0.07),
            const Text(
              "Add a New Job",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            )
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
                leading: const CircleAvatar(),
                title: Text(widget.categoryName),
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
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              ElevatedButton(
                  onPressed: () {
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
                  },
                  child: const Text("Done"))
            ],
          ),
        ),
      ),
    );
  }
}
