import 'package:flutter/material.dart';
import 'theme_manager.dart'; // This connects to your new file
import 'register_page.dart';
import 'home_page.dart';
import 'forgot_password_page.dart';

void main() {
  runApp(const InternTrackApp());
}

class InternTrackApp extends StatelessWidget {
  const InternTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. This "Listens" to the theme_manager.dart
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // 2. This tells the app which colors to use
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF1A2E44),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          home: const LoginPage(),
        );
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. We use the notifier here to change specific UI colors (like text)
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        Color primaryColor = isDark ? Colors.white : const Color(0xFF1A2E44);

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

              // Adaptive Overlay (Darker in Dark Mode)
              Container(
                color: isDark 
                    ? Colors.black.withOpacity(0.7) 
                    : const Color.fromARGB(255, 224, 224, 224).withOpacity(0.6),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 90),

                      // Logo Section
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 3.0),
                        ),
                        child: ClipOval(
                          child: Container(
                            color: isDark ? Colors.grey[900] : Colors.white,
                            child: Image.asset(
                              'assets/InternTrack Logo.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      Text(
                        'InternTrack',
                        style: TextStyle(
                          fontFamily: 'AnotherShabby',
                          fontSize: 50,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 40),

                      _buildTextField(context, 'Username', Icons.person_outline, isDark),
                      const SizedBox(height: 15),
                      _buildTextField(context, 'Password', Icons.lock_outline, isDark, isPassword: true),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage())),
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC05E12),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())),
                              child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? Colors.grey[800] : const Color(0xFF34495E),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                              child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 20)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                      Text('Location must be enabled to clock in/out.', style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 40),
                      Text('Exclusive only for RRJ interns.', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('© 2026', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(BuildContext context, String hint, IconData icon, bool isDark, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: isDark ? Colors.grey[400] : Colors.grey),
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey),
        filled: true,
        fillColor: isDark ? Colors.black54 : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}