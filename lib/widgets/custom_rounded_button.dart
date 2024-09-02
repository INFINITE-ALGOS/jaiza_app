import 'package:flutter/material.dart';
class CustomClickRoundedButton extends StatefulWidget {
  double height;
  double width;
  String text;
  VoidCallback onPress;
  CustomClickRoundedButton({required this.text,required this.onPress,this.width=0.95,this.height=0.07});
  @override
  State<CustomClickRoundedButton> createState() => _CustomClickRoundedButtonState();
}
class _CustomClickRoundedButtonState extends State<CustomClickRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: MediaQuery.of(context).size.width * widget.width, // Makes the button responsive
      height: MediaQuery.of(context).size.height * widget.height ,
      child: InkWell(
        onTap: widget.onPress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue, // Button color
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