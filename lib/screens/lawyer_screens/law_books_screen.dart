// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../conts.dart';
//
// class LawBooksLawyer extends StatefulWidget {
//   const LawBooksLawyer({super.key});
//
//   @override
//   State<LawBooksLawyer> createState() => _LawBooksLawyerState();
// }
//
// class _LawBooksLawyerState extends State<LawBooksLawyer> {
//   List<Map<String, dynamic>> allDocuments=[];
//   List<Map<String, dynamic>> filteredDocuments=[];
//   bool hasResult=true;
//   double screenHeight = 0;
//   double screenWidth = 0;
//   TextEditingController searchController = TextEditingController();
//
//   void filterDocuments() {
//     String searchTerm = searchController.text.toLowerCase();
//
//     setState(() {
//       filteredDocuments = allDocuments.where((document) {
//         final title = document['jobDetails']['title'].toLowerCase();
//         final titleMatches = title.contains(searchTerm);
//
//         final description = document['jobDetails']['description'].toLowerCase();
//         final descriptionMatches = description.contains(searchTerm);
//         return titleMatches || descriptionMatches;
//       }).toList();
//       if(filteredDocuments.isEmpty){
//         hasResult=false;
//       }
//     });
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     searchController.addListener(() {
//       filterDocuments();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     return  SafeArea(
//       child: Scaffold(
//         body:Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
//               child: Container(
//                 width: screenWidth,
//                 height: screenHeight * 0.075,
//                 margin: const EdgeInsets.symmetric(vertical: 15),
//                 decoration: BoxDecoration(
//                   color: lightGreyColor,
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18),
//                   child: Center(
//                     child: TextField(
//                       controller: searchController,
//                       decoration: InputDecoration(
//                         hintText: "Search by title or description ...",
//                         border: InputBorder.none,
//                         icon: const Icon(CupertinoIcons.search, color: greyColor),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: GridView.builder(itemCount: 10,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (BuildContext context,index){
//                 return Padding(
//                   padding:
//                   const EdgeInsets.only(top: 15, right: 15),
//                   child: Container(
//                     child: Column(
//                       children: [
//
//                         Container(
//                           height: screenHeight * 0.12,
//                           width: screenWidth * 0.24,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                               BorderRadius.circular(10),
//                               border: Border.all(
//                                   color: lightGreyColor,
//                                   width: 1)),
//                           child: const Center(
//                             child: Icon(
//                                 Icons.miscellaneous_services),
//                           ),
//                         ),
//                         const Text(
//                           "Law books",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ) ,
//       ),
//     );
//   }
// }
