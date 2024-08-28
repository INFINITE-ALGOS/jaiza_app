import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/models/create_job_model.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/view_offers_onmyjob_screen.dart';
import 'package:law_education_app/utils/manage_keyboard.dart';
import 'package:provider/provider.dart';

import '../../../../provider/get_categories_provider.dart';

class ViewJobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final List<Map<String, dynamic>>? offers;

  const ViewJobDetailsScreen(
      {super.key, required this.job, required this.offers});

  @override
  State<ViewJobDetailsScreen> createState() => _ViewJobDetailsScreenState();
}

class _ViewJobDetailsScreenState extends State<ViewJobDetailsScreen> {
  bool isEditable = false;
  @override
  Widget build(BuildContext context) {
    final DateTime createdOn = (widget.job['createdOn'] as Timestamp).toDate();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(createdOn);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditJobDetailScreen(job: widget.job,)));
              setState(() {
                isEditable=true;
              });
            },
              child: const Icon(
            Icons.edit,
            color: blueColor,
          )),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(widget.job['title']),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Container(
                    //   padding: EdgeInsets.only(top: 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(widget.job['description']),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //   padding: EdgeInsets.only(top: 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Created On",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(formattedDate),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //   padding: EdgeInsets.only(top: 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(widget.job['price']),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //   padding: EdgeInsets.only(top: 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Duration",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(widget.job['duration']),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: InkWell(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewOffersOnMyJobScreen(job: widget.job, offers: widget.offers)));},
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            color: blueColor),
                        child: const Text(
                          "View Offers",
                          style: TextStyle(
                              color: whiteColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class EditJobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;
   EditJobDetailScreen({super.key,required this.job});

  @override
  State<EditJobDetailScreen> createState() => _EditJobDetailScreenState();
}

class _EditJobDetailScreenState extends State<EditJobDetailScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController customDurationController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;
final key=GlobalKey<FormState>();
  List<String> durationOptions = [
    "1 day",
    "1 week",
    "1 month",
    "1 year",
    "Custom"
  ];
   String? selectedDuration;
   String? category;

  String? _notEmptyValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
  @override
  void initState() {
    super.initState();
    titleController.text = widget.job['title'];
    descriptionController.text = widget.job['description'];
    locationController.text = widget.job['location'];
    priceController.text = widget.job['price'];

    // Ensure that duration is valid and exists in durationOptions
    if (durationOptions.contains(widget.job['duration'])) {
      selectedDuration = widget.job['duration'];
    } else {
      selectedDuration = durationOptions.first; // Or some default value
    }

    customDurationController.text = widget.job['duration'];
    category = widget.job['category'];
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> categoriesOptions = Provider.of<CategoriesProvider>(context).categoriesList;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Replace with your desired background color

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
              "Edit Job Details",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            )
          ],
        ),
        elevation: 0,
       // backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: key,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: blackColor)),
                        child: DropdownButtonFormField<dynamic>(
                          value: category,
                          items: categoriesOptions.map((dynamic category) {
                            return DropdownMenuItem<dynamic>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),

                          onChanged: (dynamic newValue) {
                            setState(() {
                              category = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.job['duration'],
                          ),
                        ),
                      ),

                    ],
                  ),
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
                          validator: (value) => _notEmptyValidator(value, "Title"),
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
                          validator: (value) => _notEmptyValidator(value, "Description"),

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
                          validator: (value) => _notEmptyValidator(value, "Location"),

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
                          validator: (value) => _notEmptyValidator(value, "Price"),

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
                          border: Border.all(color: blackColor),
                        ),
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
                              if (selectedDuration != "Custom") {
                                customDurationController.clear(); // Clear custom input if not using "Custom" option
                              }
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
                            validator: (value)=>_notEmptyValidator(value, 'Duration'),
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

                InkWell(
                    onTap: () {
                      KeyboardUtil().hideKeyboard(context);
                    if(key.currentState!.validate()){
                      EasyLoading.show(status: "Please wait");
                      String duration = selectedDuration == "Custom"
                          ? customDurationController.text.trim()
                          : selectedDuration?? "";
                      final CreateJobModel createJobModel=CreateJobModel(title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          price: priceController.text.trim(),
                          location: locationController.text.trim(),
                          duration: duration,
                          category: category?? widget.job['category'],
                          createdOn: widget.job['createdOn'],
                          status: widget.job['jobStatus'],
                          jobId: widget.job['jobId'],
                          clientId: widget.job['clientId']
                      );
                      FirebaseFirestore.instance.collection('jobs').doc(widget.job['jobId']).update(createJobModel.toMap());
                      EasyLoading.dismiss();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) =>   BottomNavigationbarClient(selectedIndex: 3,)),
                            (Route<dynamic> route) => false,
                      );

                    }  },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: blueColor),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            color: whiteColor, fontWeight: FontWeight.w600),
                      ),
                    )),
                const SizedBox(height: 40,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

