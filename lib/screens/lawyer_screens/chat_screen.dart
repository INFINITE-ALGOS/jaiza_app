import 'package:flutter/material.dart';
class ChatScreenLawyer extends StatefulWidget {
  const ChatScreenLawyer({super.key});

  @override
  State<ChatScreenLawyer> createState() => _ChatScreenLawyerState();
}

class _ChatScreenLawyerState extends State<ChatScreenLawyer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(itemCount: 10,itemBuilder: (context,index){
          return Container(
          );
        }),

      ),
    );
  }
}
