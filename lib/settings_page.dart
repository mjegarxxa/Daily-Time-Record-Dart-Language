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
    // Listen to Dark Mode changes to update this page's colors
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
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      // Card turns dark grey in dark mode
                      color: isDark 
                          ? Colors.grey[900]!.withOpacity(0.9) 
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isDark 
                            ? Colors.white10 
                            : const Color(0xFF1A2E44).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Account Settings", isDark),
                        _buildTextOption("Change Password", isDark),
                        
                        _buildSwitchOption(
                          "Notifications", 
                          isNotificationsNotifier,
                          isDark,
                        ),

                        const SizedBox(height: 25),

                        _buildSectionTitle("Internship Specifics", isDark),
                        _buildTextOption("Edit OJT Hours", isDark),
                        _buildTextOption("Notify Admin (End of OJT hours)", isDark),

                        const SizedBox(height: 25),

                        _buildSectionTitle("App Preferences", isDark),
                        
                        _buildSwitchOption(
                          "Dark Mode", 
                          isDarkModeNotifier,
                          isDark,
                        ),
                        
                        _buildTextOption(
                          "Export Data",
                          isDark,
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
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          // White in dark mode, black in light mode
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextOption(String title, bool isDark, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16, 
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchOption(String title, ValueNotifier<bool> notifier, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16, 
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: notifier,
            builder: (context, currentValue, child) {
              return Switch(
                value: currentValue,
                activeColor: const Color(0xFFC05E12),
                // Track color for better visibility in dark mode
                activeTrackColor: const Color(0xFFC05E12).withOpacity(0.5),
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