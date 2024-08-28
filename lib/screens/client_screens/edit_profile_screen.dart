import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/myprofile_controller.dart';
import 'package:law_education_app/models/client_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final MyProfileController _myProfileController = MyProfileController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  void initstate(){
   super.initState();
   _fetchProfileData();
  }

  Future<void> _fetchProfileData()
  async {
    Map<String,dynamic>? _profileData = await _myProfileController.getProfileData();
    if(_profileData!=null)
    {
      _nameController.text=_profileData['name']??'';
      _phoneController.text=_profileData['phone']??'';
      _ratingController.text=_profileData['rating']??'';
    }
  }

  Future<void> _updateProfile()
  async {
    ClientModel updatedData =ClientModel(
        name: _nameController.text,
        email: '',
        phone: _phoneController.text,
        isActive: true,
        createdOn: DateTime.now(),
        rating: _ratingController.text,
        isVerified: false,
        type: '',
        url: '');
    _myProfileController.updateProfileDataClient(updatedData);
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
