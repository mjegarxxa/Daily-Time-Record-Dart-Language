import 'package:flutter/material.dart';
import 'export_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Toggle states
  bool _notificationsOn = true;
  bool _darkModeOn = false;

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
                    // --- ACCOUNT SETTINGS ---
                    _buildSectionTitle("Account Settings"),
                    _buildTextOption("Change Password"),
                    _buildSwitchOption("Notifications", _notificationsOn, (
                      val,
                    ) {
                      setState(() => _notificationsOn = val);
                    }),

                    const SizedBox(height: 25),

                    // --- INTERNSHIP SPECIFICS ---
                    _buildSectionTitle("Internship Specifics"),
                    _buildTextOption("Edit OJT Hours"),
                    _buildTextOption("Notify Admin (End of OJT hours)"),

                    const SizedBox(height: 25),

                    // --- APP PREFERENCES ---
                    _buildSectionTitle("App Preferences"),
                    _buildSwitchOption("Dark Mode", _darkModeOn, (val) {
                      setState(() => _darkModeOn = val);
                    }),
                    _buildTextOption(
                      "Export Data",
                      onTap: () {
                        ExportService.exportAttendanceToPdf();
                      },
                    ),

                    const SizedBox(
                      height: 40,
                    ), // Bottom padding inside the card
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Bold Headers
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

  // Helper for Text-only Rows
  Widget _buildTextOption(String title, {VoidCallback? onTap}) {
    return ListTile(
      // Using ListTile is cleaner for alignment
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      onTap: onTap, // This triggers the export
    );
  }

  // Helper for Toggle/Switch Rows
  Widget _buildSwitchOption(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1A2E44), // Matching your navy theme
          ),
        ],
      ),
    );
  }
}
