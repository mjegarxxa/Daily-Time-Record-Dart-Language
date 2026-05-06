import 'package:flutter/material.dart';
import 'dart:io'; 
import 'package:image_picker/image_picker.dart'; 
// Make sure this import is correct based on where your notifier is located
import 'theme_manager.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _courseController;
  late TextEditingController _schoolController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "Mark Joshua E. Garcia");
    _courseController = TextEditingController(text: "BS Information Systems");
    _schoolController = TextEditingController(text: "One Cainta College");
    _descriptionController = TextEditingController(text: "Short Description");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    _schoolController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Background Image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/jeans bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Dark Overlay for Dark Mode
              Container(
                color: isDark 
                    ? Colors.black.withOpacity(0.8) 
                    : Colors.transparent,
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      _buildHeaderCard(isDark),
                      const SizedBox(height: 15),
                      _buildAboutSection(isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subTextColor = isDark ? Colors.white70 : Colors.black87;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]!.withOpacity(0.9) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFF1A2E44).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: isDark ? Colors.white10 : const Color(0xFF1A2E44).withOpacity(0.1),
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 80, color: Colors.grey)
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.orange[800] : const Color(0xFF1A2E44), 
                    shape: BoxShape.circle
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          
          _isEditing
              ? TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                  decoration: InputDecoration(
                    border: InputBorder.none, 
                    hintText: "Enter Name",
                    hintStyle: TextStyle(color: subTextColor),
                  ),
                )
              : Text(
                  _nameController.text,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                ),

          const SizedBox(height: 10),

          _isEditing
              ? Column(
                  children: [
                    TextField(
                      controller: _courseController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: "Course", 
                        labelStyle: TextStyle(color: subTextColor),
                        isDense: true
                      ),
                    ),
                    TextField(
                      controller: _schoolController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: "School", 
                        labelStyle: TextStyle(color: subTextColor),
                        isDense: true
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text(_courseController.text, style: TextStyle(fontSize: 16, color: subTextColor)),
                    Text(_schoolController.text, style: TextStyle(fontSize: 16, color: subTextColor)),
                  ],
                ),
          
          const SizedBox(height: 10),

          IconButton(
            icon: Icon(_isEditing ? Icons.check_circle : Icons.edit),
            iconSize: 30,
            color: _isEditing ? Colors.green : (isDark ? Colors.orange[800] : const Color(0xFF1A2E44)),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isDark) {
    Color textColor = isDark ? Colors.white : Colors.black;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]!.withOpacity(0.95) : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 20),
          Center(
            child: _isEditing
                ? TextField(
                    controller: _descriptionController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    decoration: const InputDecoration(hintText: "Short Description"),
                  )
                : Text(
                    _descriptionController.text,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
          ),
          const SizedBox(height: 30),
          _profileInfoRow("Age:", "22", isDark),
          _profileInfoRow("Birthday:", "March 6, 2004", isDark),
          _profileInfoRow("Department:", "IT Department", isDark),
          _profileInfoRow("Date Started:", "February 2026", isDark),
          _profileInfoRow("OJT Hours:", "500 Hours", isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _profileInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w500, 
              color: isDark ? Colors.white70 : Colors.black
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value, 
            style: TextStyle(
              fontSize: 18, 
              color: isDark ? Colors.white : Colors.black87
            )
          ),
        ],
      ),
    );
  }
}