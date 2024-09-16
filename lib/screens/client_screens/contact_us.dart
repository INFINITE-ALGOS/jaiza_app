import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitForm() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      final message = _messageController.text.trim();

      try {
        // Add the data to the "complain" collection
        await _firestore.collection('complain').add({
          'message': message,
          'createdOn': FieldValue.serverTimestamp(), // Store the timestamp of submission
        });

        // Clear the form after submission
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message sent successfully!')),
        );
      } catch (error) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Container(
                  child: Text("We’d love to hear from you! Whether you have a question about our "
                      "services, need assistance, or just want to share feedback, feel free to reach"
                      " out to us.",style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),),
                ),
                SizedBox(height: 30,),
                _buildTextField(
                  controller: _messageController,
                  label: 'Message',
                  hintText: 'Enter your message',
                  maxLines: 5,
                ),
                SizedBox(height:50),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 60,
                    width: 150,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 30,right: 30), // Padding to make it look like a button
                    decoration: BoxDecoration(
                      color: primaryColor, // Use the primary color from the theme
                      borderRadius: BorderRadius.circular(30.0), // Rounded corners
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white, // Text color for contrast
                        fontWeight: FontWeight.w500, // Slightly bolder text
                        fontSize: 16, // Font size for better readability
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }
}