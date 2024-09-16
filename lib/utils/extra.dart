// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:law_education_app/conts.dart';
// import 'package:law_education_app/screens/auth/signup_screen.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:law_education_app/conts.dart';
// import 'package:law_education_app/screens/auth/signup_screen.dart';
//
// class UserLawyerProfileCollectionScreen extends StatefulWidget {
//   final Map<String, dynamic> basicInfo;
//   final File imageFile;
//
//   UserLawyerProfileCollectionScreen({super.key, required this.basicInfo, required this.imageFile});
//
//   @override
//   State<UserLawyerProfileCollectionScreen> createState() => _UserLawyerProfileCollectionScreenState();
// }
//
// class _UserLawyerProfileCollectionScreenState extends State<UserLawyerProfileCollectionScreen> {
//   final TextEditingController bioController = TextEditingController();
//   final TextEditingController experinceController = TextEditingController();
//   final TextEditingController designationController = TextEditingController();
//   final List<Map<String, TextEditingController>> portfolios = [];
//
//   final List<String> expertiseTypes = ['Criminal', 'Real Estate', 'Corporate', 'Family', 'Personal Injury', 'Immigration'];
//   final List<String> experience = ['1', '2', '3', '4', '5', '5+', '10+'];
//   String? selectedExpertise;
//   String? selectedExperience;
//
//   void addPortfolio() {
//     setState(() {
//       portfolios.add({
//         'title': TextEditingController(),
//         'description': TextEditingController(),
//         'url': TextEditingController(),
//         'date': TextEditingController(),
//       });
//     });
//   }
//
//   void removePortfolio(int index) {
//     setState(() {
//       portfolios.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.2,
//               color: primaryColor,
//               width: double.infinity,
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.8,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(40),
//                   topLeft: Radius.circular(40),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20),
//                       Center(
//                         child: Text(
//                           "Please complete your profile",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       CustomTextField(
//                         title: "Bio",
//                         fieldTitle: "Please Enter your Bio",
//                         controller: bioController,
//                         maxLines: 3,
//                       ),
//                       CustomTextField(
//                         title: "Designation",
//                         fieldTitle: "Please Enter your Designation",
//                         controller: designationController,
//                         maxLines: 1,
//                       ),
//                       SizedBox(height: 15),
//                       _buildDropdown(
//                         title: "Experience",
//                         value: selectedExperience,
//                         items: experience,
//                         onChanged: (value) => setState(() => selectedExperience = value),
//                       ),
//                       _buildDropdown(
//                         title: "Expertise Type",
//                         value: selectedExpertise,
//                         items: expertiseTypes,
//                         onChanged: (value) => setState(() => selectedExpertise = value),
//                       ),
//                       SizedBox(height: 15),
//                       Divider(thickness: 1.5, color: Colors.black),
//                       SizedBox(height: 15),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Portfolio',
//                             style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.add),
//                             onPressed: addPortfolio,
//                           ),
//                         ],
//                       ),
//                       ...portfolios.asMap().entries.map((entry) {
//                         int index = entry.key;
//                         var portfolio = entry.value;
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomTextField(
//                               title: "Title",
//                               fieldTitle: "Please Enter your Title",
//                               controller: portfolio['title']!,
//                               maxLines: 1,
//                             ),
//                             CustomTextField(
//                               title: "Description",
//                               fieldTitle: "Please Enter your Description",
//                               controller: portfolio['description']!,
//                               maxLines: 3,
//                             ),
//                             CustomTextField(
//                               title: "URL",
//                               fieldTitle: "Please Enter the URL of your portfolio",
//                               controller: portfolio['url']!,
//                               maxLines: 1,
//                             ),
//                             CustomTextField(
//                               title: "Date",
//                               fieldTitle: "Please Enter the date",
//                               controller: portfolio['date']!,
//                               maxLines: 1,
//                             ),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: IconButton(
//                                 icon: Icon(Icons.remove, color: Colors.red),
//                                 onPressed: () => removePortfolio(index),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdown({
//     required String title,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.only(left: 22, right: 20, bottom: 10),
//           child: Text(
//             title,
//             style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 15),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: InputDecorator(
//             decoration: InputDecoration(
//               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.black, width: 1),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: value,
//                 hint: Text('Select $title'),
//                 items: items.map((String type) {
//                   return DropdownMenuItem<String>(
//                     value: type,
//                     child: Text(type, style: TextStyle(fontWeight: FontWeight.w400)),
//                   );
//                 }).toList(),
//                 onChanged: onChanged,
//                 isExpanded: true,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// class CustomTextField extends StatelessWidget {
//   final String title;
//   final String fieldTitle;
//   final TextEditingController controller;
//   final int maxLines;
//   CustomTextField({
//     super.key,
//     required this.title,
//     required this.fieldTitle,
//     required this.controller,
//     required this.maxLines,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(left: 20),
//           alignment: Alignment.centerLeft,
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: blackColor),
//           ),
//           child: TextFormField(
//             keyboardType: TextInputType.text,
//             controller: controller,
//             maxLines: maxLines,
//             textAlignVertical: TextAlignVertical.center,
//             //  obscureText: title == AppLocalizations.of(context)!.password ? _obscureText : false,
//             decoration: InputDecoration(
//               hintText: fieldTitle,
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }