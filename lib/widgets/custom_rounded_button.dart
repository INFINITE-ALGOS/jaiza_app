import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
class CustomClickRoundedButton extends StatefulWidget {
  String text;
  VoidCallback onPress;
  CustomClickRoundedButton({required this.text,required this.onPress});
  @override
  State<CustomClickRoundedButton> createState() => _CustomClickRoundedButtonState();
}
class _CustomClickRoundedButtonState extends State<CustomClickRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
      width: MediaQuery.of(context).size.width * 0.95, // Makes the button responsive
      height: MediaQuery.of(context).size.height * 0.07 ,
      child: InkWell(
        onTap: widget.onPress,
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor, // Button color
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          alignment: Alignment.center,
          child: Text(widget.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color
            ),
          ),
        ),
      ),
    );
  }
}