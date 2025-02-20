// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:law_education_app/conts.dart';
//
// import '../auth/login_screen.dart';
//
// class ProfileScreenLawyer extends StatefulWidget {
//   const ProfileScreenLawyer({super.key});
//
//   @override
//   State<ProfileScreenLawyer> createState() => _ProfileScreenLawyerState();
// }
//
// class _ProfileScreenLawyerState extends State<ProfileScreenLawyer> {
//   void logoutAction(){
//     showModalBottomSheet(context: context, builder: (BuildContext context){
//       return Container(
//         padding: const EdgeInsets.all(16.0),
//         height: MediaQuery.of(context).size.height*0.35,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Center(child: Text("Log out",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),)
//             ,const SizedBox(height: 20,),
//             const Text(
//               'Are you sure you want to logout?',
//               style: TextStyle(fontSize: 15.0),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: (){
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel',style: TextStyle(color: whiteColor),),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//               ),
//             ),
//             ElevatedButton(
//
//               onPressed: (){
//                 FirebaseAuth.instance.signOut();
//                 Navigator.pushAndRemoveUntil(context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                       (Route<dynamic> route) => false,);              },
//               child: const Text('Logout',style: TextStyle(color: whiteColor)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//               ),
//             ),
//           ],
//         ),
//
//       );
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     var screenHeight = mediaQuery.size.height;
//     var screenWidth = mediaQuery.size.width;
//     var profileImageSize = screenHeight * 0.15;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//           child: Column(
//             children: [
//               SizedBox(height: screenHeight * 0.05),
//               CircleAvatar(
//                 radius: profileImageSize / 2,
//                 backgroundImage: const NetworkImage(
//                     'https://via.placeholder.com/150'), // Placeholder image URL
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               Text(
//                 'Your Name',
//                 style: TextStyle(
//                   fontSize: screenHeight * 0.03,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.01),
//               Text(
//                 'yourgmail@gmail.com',
//                 style: TextStyle(
//                   fontSize: screenHeight * 0.02,
//                   color: Colors.grey,
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               Container(
//                 width: screenWidth*0.5,
//                 height: screenHeight*0.05,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: primaryColor,width: 2)
//                 ),
//                 child: const Center(child:Text("Edit Profile",style: TextStyle(color: primaryColor,fontWeight: FontWeight.w600),
//                 ),),),
//               SizedBox(height: screenHeight * 0.04),
//               buildProfileOption(
//                   screenHeight, screenWidth, Icons.person_add, 'Register as a Partner'),
//               buildProfileOption(
//                   screenHeight, screenWidth, Icons.book, 'My Booking'),
//               buildProfileOption(
//                   screenHeight, screenWidth, Icons.help, 'Help Center'),
//               buildProfileOption(
//                   screenHeight, screenWidth, Icons.share, 'Share & Earn'),
//               buildProfileOption(
//                   screenHeight, screenWidth, Icons.star, 'Rate us'),
//               buildProfileOption(
//                   screenHeight, screenWidth, Icons.question_answer, 'FAQ\'s'),
//               buildProfileOption(
//                   screenHeight, screenWidth, Icons.privacy_tip, 'Privacy Policy'),
//               GestureDetector(
//                 onTap: logoutAction,
//                 child: buildProfileOption(
//                     screenHeight, screenWidth, Icons.logout, 'Logout'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildProfileOption(double screenHeight, double screenWidth, IconData icon, String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//       child: Column(
//         children: [
//           Row(
//               children: [ Icon(icon, size: screenHeight * 0.04, color: blackColor),
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: screenHeight * 0.02),
//                 ),
//                 const Spacer(),
//                 Icon(Icons.arrow_forward_ios, size: screenHeight * 0.03),
//               ]),
//
//           const Divider()
//         ],
//       ),
//     );
//   }
// }
