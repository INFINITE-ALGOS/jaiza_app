import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/myprofile_controller.dart';
import 'package:law_education_app/models/lawyer_model.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final MyProfileController _profileController = MyProfileController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    Map<String, dynamic>? profileData = await _profileController.getProfileData();
    if (profileData != null) {
      _nameController.text = profileData['name'] ?? '';
      _phoneController.text = profileData['phone'] ?? '';
      _ratingController.text = profileData['rating'] ?? '';
    }
  }

  Future<void> _updateProfile() async {
    LawyerModel updatedData = LawyerModel(
      name: _nameController.text,
      email: '',
      phone: _phoneController.text,
      isActive: true,
      type: '',
      createdOn: DateTime.now(),
      rating: _ratingController.text,
      isVerified: false,
      url: '',
      experience: ''
    );
    await _profileController.updateProfileDataLawyer(updatedData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(labelText: 'Rating'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
              style: ElevatedButton.styleFrom(
                //primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}