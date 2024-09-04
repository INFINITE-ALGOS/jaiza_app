import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/models/create_job_model.dart';
import 'package:law_education_app/models/create_service_model.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/view_offers_onmyjob_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';
import 'package:law_education_app/screens/lawyer_screens/services_status/active_services/view_activerequests_onmy_service_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/services_status/active_services/view_pendingrequests_onmservice_screen.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';
import 'package:law_education_app/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../provider/get_categories_provider.dart';
import '../../../lawyer_screens/services_status/active_services/view_service_active_detail_screen.dart';

class ViewServiceActiveDetailScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final List<Map<String, dynamic>>? requests;

  const ViewServiceActiveDetailScreen({
    super.key,
    required this.service,
    required this.requests,
  });

  @override
  State<ViewServiceActiveDetailScreen> createState() => _ViewJobDetailsScreenState();
}

class _ViewJobDetailsScreenState extends State<ViewServiceActiveDetailScreen> {
  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    final DateTime createdOn = (widget.service['createdOn'] as Timestamp).toDate();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(createdOn);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Details"),
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditJobDetailScreen(service: widget.service),
                ),
              ).then((_) {
                setState(() {
                  isEditable = true;
                });
              });
            },
            child: const Icon(
              Icons.edit,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: 'Delete my Service',
                    content: 'Are you sure you want to delete your service?',
                    onConfirm: () {
                      // First, check if there are any active requests
                      if (widget.requests != null) {
                        bool hasActiveRequest = widget.requests!.any((request) => request['requestDetails']['status'] == 'active');

                        if (hasActiveRequest) {
                          Navigator.of(context).pop();
                          // If there's at least one active request, show an error and return
                          CustomSnackbar.showError(
                            context: context,
                            title: "Unable to Delete the Service",
                            message: "Please first complete the active request or cancel it.",
                          );
                          return; // Exit the function to prevent further execution
                        }
                      }

                      // No active requests found, proceed with the deletion
                      FirebaseFirestore.instance.collection('services').doc(widget.service['serviceId']).update({'status': 'deleted'});

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationLawyer(selectedIndex: 3),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },

                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            },
            child: const Icon(
              Icons.delete,
              color: redColor,
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35),
            _buildDetailContainer("Title", widget.service['title']),
            const SizedBox(height: 20),
            _buildDetailContainer("Description", widget.service['description']),
            const SizedBox(height: 20),
            _buildDetailContainer("Created On", formattedDate),
            const SizedBox(height: 20),
            _buildDetailContainer("Price", widget.service['price']),
            // const SizedBox(height: 20),
            // _buildDetailContainer("Duration", widget.job['duration']),
             const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
    List<Map<String,dynamic>> activeRequests=[];
    if(widget.requests!=null && widget.requests!.isNotEmpty){
    for(var pendingRequest in widget.requests!){
    if(pendingRequest['requestDetails']['status']=='active'){
    activeRequests.add(pendingRequest);}}}
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewActiverequestsOnmyServiceScreen(service: widget.service, activeRequests: activeRequests),
      ),
    );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: primaryColor,
                  ),
                  child: const Text(
                    "View Active Requests",
                    style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: InkWell(
                onTap: () {
                  List<Map<String,dynamic>> pendingRequests=[];
                 if(widget.requests!=null && widget.requests!.isNotEmpty){
                   for(var pendingRequest in widget.requests!){
                     if(pendingRequest['requestDetails']['status']=='pending'||pendingRequest['requestDetails']['status']=='reproposal'){
                       pendingRequests.add(pendingRequest);
                     }
                   }
                 }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPendingRequestsOnMyServiceScreen(service: widget.service, pendingRequests: pendingRequests),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: primaryColor,
                  ),
                  child: const Text(
                    "View Pending Requests",
                    style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContainer(String title, String content) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
class EditJobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const EditJobDetailScreen({
    super.key,
    required this.service,
  });

  @override
  State<EditJobDetailScreen> createState() => _EditJobDetailScreenState();
}

class _EditJobDetailScreenState extends State<EditJobDetailScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController customDurationController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  double screenHeight = 0;
  double screenWidth = 0;



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
    titleController.text = widget.service['title'];
    descriptionController.text = widget.service['description'];
    locationController.text = widget.service['location'];
    priceController.text = widget.service['price'];
    category = widget.service['category'];
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> categoriesOptions = Provider.of<CategoriesProvider>(context).categoriesList;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(CupertinoIcons.back),
            ),
            SizedBox(width: screenWidth * 0.07),
            const Text(
              "Edit Service Details",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Form(
        key: key,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                _buildDropdownField(
                  title: "Category",
                  hintText: "Select Category",
                  value: category,
                  items: categoriesOptions,
                  onChanged: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildTextField(
                  title: "Service Title",
                  controller: titleController,
                  hintText: "Enter Title",
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildTextField(
                  title: "Description",
                  controller: descriptionController,
                  hintText: "Enter Description",
                  maxLines: null,
                  height: screenHeight * 0.2,
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildTextField(
                  title: "Location",
                  controller: locationController,
                  hintText: "Enter Location",
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildTextField(
                  title: "Price",
                  controller: priceController,
                  hintText: "Enter Price",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: screenHeight * 0.05),
                InkWell(
                  onTap: () {
                    if (key.currentState!.validate()) {
                      EasyLoading.show(status: "Please wait");
                      final CreateServiceModel createServiceModel = CreateServiceModel(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        price: priceController.text.trim(),
                        location: locationController.text.trim(),
                        category: category ?? widget.service['category'],
                        createdOn: widget.service['createdOn'],
                        status: widget.service['status'],
                        serviceId: widget.service['serviceId'],
                        lawyerId: widget.service['lawyerId'],
                      );
                      FirebaseFirestore.instance
                          .collection('services')
                          .doc(widget.service['serviceId'])
                          .update(createServiceModel.toMap())
                          .then((_) {
                        EasyLoading.dismiss();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationLawyer(selectedIndex: 3),
                          ),
                              (Route<dynamic> route) => false,
                        );
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      color: primaryColor,
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String title,
    required String hintText,
    required String? value,
    required List<dynamic> items,
    required ValueChanged<dynamic> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: blackColor),
          ),
          child: DropdownButtonFormField<dynamic>(
            value: value,
            items: items.map((dynamic item) {
              return DropdownMenuItem<dynamic>(
                value: item,
                child: Text(item.toString()),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a $title';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String title,
    required TextEditingController controller,
    required String hintText,
    int? maxLines,
    double? height,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Container(
          height: height,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: blackColor),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            validator: (value) => _notEmptyValidator(value, title),
          ),
        ),
      ],
    );
  }
}
