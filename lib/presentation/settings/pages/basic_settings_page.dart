import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BasicSettingsPage extends StatefulWidget {
  const BasicSettingsPage({super.key});

  @override
  _BasicSettingsPageState createState() => _BasicSettingsPageState();
}

class _BasicSettingsPageState extends State<BasicSettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _profileImageUrl;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  File? _profileImageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500)
        ? 500
        : screenWidth; // Assuming 500 is the max width for content

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth, // Set the content width
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: _dateOfBirth != null
                            ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                            : 'Tap to select date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _profileImageFile != null
                    ? Image.file(_profileImageFile!)
                    : ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Upload Profile Picture'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
