import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:law_education_app/conts.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  TextEditingController _userInput =TextEditingController();

  static const apiKey = "AIzaSyAFKs4sxxYdBU6_svVLZdUSbddiitUr0uk";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async{
    final message = _userInput.text;

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);


    setState(() {
      _messages.add(Message(isUser: false, message: response.text?? "", date: DateTime.now()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: ListView.builder(itemCount:_messages.length,itemBuilder: (context,index){
                    final message = _messages[index];
                    return Messages(isUser: message.isUser, message: message.message, date: DateFormat('HH:mm').format(message.date));
                  })
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
                          style: TextStyle(color: blackColor),
                          controller: _userInput,
                          decoration: InputDecoration(
                            labelText: 'Enter Your Message',
                            labelStyle: TextStyle(color: primaryColor), // Set label text color to primaryColor
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor), // Primary color for enabled border
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2.0), // Primary color for focused border
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                      ),
                    ),
                    Spacer(),
                    IconButton(
                        padding: EdgeInsets.all(12),
                        iconSize: 30,
                        onPressed: (){
                          sendMessage();
                          _userInput.clear();
                        },
                        icon: Icon(Icons.send,color: primaryColor,))
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}

class Message{
  final bool isUser;
  final String message;
  final DateTime date;

  Message({ required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {

  final bool isUser;
  final String message;
  final String date;

  const Messages(
      {
        super.key,
        required this.isUser,
        required this.message,
        required this.date
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
          left: isUser ? 100:10,
          right: isUser ? 10: 100
      ),
      decoration: BoxDecoration(
          color: isUser ? primaryColor : lightGreyColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: isUser ? Radius.circular(10): Radius.zero,
              topRight: Radius.circular(10),
              bottomRight: isUser ? Radius.zero : Radius.circular(10)
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16,color: isUser ? Colors.white: Colors.black),
          ),
          Text(
            date,
            style: TextStyle(fontSize: 10,color: isUser ? Colors.white: Colors.black,),
          )
        ],
      ),
    );
  }
}