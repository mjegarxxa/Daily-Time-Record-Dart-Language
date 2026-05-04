import 'package:flutter/material.dart';
import 'dart:io'; // Required for File
import 'package:image_picker/image_picker.dart'; // Add this to pubspec.yaml

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variable to hold the selected image file
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Denim Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/jeans bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // --- TOP PROFILE CARD ---
                  _buildHeaderCard(),
                  const SizedBox(height: 15),

                  // --- ABOUT SECTION ---
                  _buildAboutSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1A2E44).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // --- FUNCTIONAL PROFILE PICTURE SECTION ---
          GestureDetector(
            onTap: _pickImage, // Calls the image picker logic
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: const Color(0xFF1A2E44).withOpacity(0.1),
                  // If an image is picked, show it; otherwise show placeholder icon
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 80, color: Colors.grey)
                      : null,
                ),
                // Camera Icon Overlay as seen in image_0171d8.png
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A2E44),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Name of Intern",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Program/Course", style: TextStyle(fontSize: 18)),
                  Text("School", style: TextStyle(fontSize: 18)),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_note, size: 40, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "About",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.edit_note, size: 30),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Short Description",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),
          _profileInfoRow("Age:", ""),
          _profileInfoRow("Birthday:", ""),
          _profileInfoRow("Department:", ""),
          _profileInfoRow("Date Started:", ""),
          _profileInfoRow("OJT Hours:", ""),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _profileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}