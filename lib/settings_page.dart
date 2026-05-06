import 'package:flutter/material.dart';
import 'export_service.dart';
import 'theme_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
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

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF1A2E44).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Account Settings"),
                    _buildTextOption("Change Password"),
                    
                    // Passing the Notification Notifier here
                    _buildSwitchOption(
                      "Notifications", 
                      isNotificationsNotifier
                    ),

                    const SizedBox(height: 25),

                    _buildSectionTitle("Internship Specifics"),
                    _buildTextOption("Edit OJT Hours"),
                    _buildTextOption("Notify Admin (End of OJT hours)"),

                    const SizedBox(height: 25),

                    _buildSectionTitle("App Preferences"),
                    
                    // Passing the Dark Mode Notifier here
                    _buildSwitchOption(
                      "Dark Mode", 
                      isDarkModeNotifier
                    ),
                    
                    _buildTextOption(
                      "Export Data",
                      onTap: () {
                        ExportService.exportAttendanceToPdf();
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextOption(String title, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      onTap: onTap,
    );
  }

  // UPDATED: Now accepts a specific ValueNotifier<bool>
  Widget _buildSwitchOption(String title, ValueNotifier<bool> notifier) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: notifier,
            builder: (context, currentValue, child) {
              return Switch(
                value: currentValue,
                activeColor: const Color(0xFFC05E12), // Matching your theme
                onChanged: (bool newValue) {
                  notifier.value = newValue;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}