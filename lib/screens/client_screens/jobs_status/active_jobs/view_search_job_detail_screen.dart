import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/models/create_job_model.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/active_jobs/view_offers_onmyjob_screen.dart';
import 'package:law_education_app/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';
import '../../../../provider/general_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewJobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final List<Map<String, dynamic>>? offers;

  const ViewJobDetailsScreen({
    super.key,
    required this.job,
    required this.offers,
  });

  @override
  _ViewJobDetailsScreenState createState() => _ViewJobDetailsScreenState();
}

class _ViewJobDetailsScreenState extends State<ViewJobDetailsScreen> {
  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    final Timestamp? createdOnTimestamp = widget.job['createdOn'] as Timestamp?;
    final DateTime createdOn = createdOnTimestamp?.toDate() ?? DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(createdOn);

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.jobDetails),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditJobDetailScreen(job: widget.job),
                ),
              ).then((_) {
                setState(() {
                  isEditable = true;
                });
              });
            },
            child: const Icon(
              Icons.edit,
              color: whiteColor,
            ),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: AppLocalizations.of(context)!.deleteMyJob,
                    content: AppLocalizations.of(context)!.areYouSureYouWantToDeleteThisJobPosting,
                    onConfirm: () {
                      FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(widget.job['jobId'])
                          .update({'status': 'deleted'});
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationbarClient(selectedIndex: 3),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Title", widget.job['title'] ?? 'N/A'),
              const Divider(),
              _buildDetailRow("Description", widget.job['description'] ?? 'N/A'),
              const Divider(),
              _buildDetailRow("Created On", formattedDate),
              const Divider(),
              _buildDetailRow("Price", 'PKR ${widget.job['price'] ?? 'N/A'}'),
              const Divider(),
              _buildDetailRow("Duration", widget.job['duration'] ?? 'N/A'),
              const Divider(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewOffersOnMyJobScreen(job: widget.job, offers: widget.offers),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:  Text(
                    AppLocalizations.of(context)!.viewOffers,
                    style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class EditJobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const EditJobDetailScreen({
    super.key,
    required this.job,
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

    if (durationOptions.contains(widget.job['duration'])) {
      selectedDuration = widget.job['duration'];
    } else {
      selectedDuration = durationOptions.first; // Default value
    }

    customDurationController.text = widget.job['duration'];
    category = widget.job['category'];
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> categoriesOptions = Provider.of<GeneralProvider>(context).categoriesNameList;
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
             Text(
             AppLocalizations.of(context)!.editJobDetails,
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
                  title:  AppLocalizations.of(context)!.category,
                  hintText: AppLocalizations.of(context)!.selectCategory,
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
                  title:  AppLocalizations.of(context)!.serviceTitle,
                  controller: titleController,
                  hintText:  AppLocalizations.of(context)!.enterTitle,
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildTextField(
                  title:  AppLocalizations.of(context)!.description,
                  controller: descriptionController,
                  hintText: AppLocalizations.of(context)!.enterDescription,
                  maxLines: null,
                  height: screenHeight * 0.2,
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildTextField(
                  title:  AppLocalizations.of(context)!.location,
                  controller: locationController,
                  hintText:  AppLocalizations.of(context)!.enterLocation,
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildTextField(
                  title:  AppLocalizations.of(context)!.price,
                  controller: priceController,
                  hintText:  AppLocalizations.of(context)!.enterPrice,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildDropdownField(
                  title:  AppLocalizations.of(context)!.duration,
                  hintText:  AppLocalizations.of(context)!.selectDuration,
                  value: selectedDuration,
                  items: durationOptions,
                  onChanged: (value) {
                    setState(() {
                      selectedDuration = value;
                      if (selectedDuration != "Custom") {
                        customDurationController.clear();
                      }
                    });
                  },
                ),
                if (selectedDuration == "Custom") ...[
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    title:  AppLocalizations.of(context)!.customDuration,
                    controller: customDurationController,
                    hintText:  AppLocalizations.of(context)!.enterCustomDuration,
                  ),
                ],
                SizedBox(height: screenHeight * 0.05),
                InkWell(
                  onTap: () {
                    if (key.currentState!.validate()) {
                      EasyLoading.show(status:  AppLocalizations.of(context)!.pleaseWait);
                      String duration = selectedDuration == "Custom"
                          ? customDurationController.text.trim()
                          : selectedDuration ?? "";
                      final CreateJobModel createJobModel = CreateJobModel(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        price: priceController.text.trim(),
                        location: locationController.text.trim(),
                        duration: duration,
                        category: category ?? widget.job['category'],
                        createdOn: widget.job['createdOn'],
                        status: widget.job['status'],
                        jobId: widget.job['jobId'],
                        clientId: widget.job['clientId'],
                      );
                      FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(widget.job['jobId'])
                          .update(createJobModel.toMap())
                          .then((_) {
                        EasyLoading.dismiss();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationbarClient(selectedIndex: 3),
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
                    child:  Text(
                      AppLocalizations.of(context)!.done,
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
