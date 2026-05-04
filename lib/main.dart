import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Denim Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/jeans bg.jpg',
                ), // Ensure this is in your assets
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Dark Overlay for readability (80% opacity logic)
          Container(
            color: const Color.fromARGB(255, 224, 224, 224).withOpacity(0.6),
          ),

          // 3. Login UI
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 90),

                  // Logo Placeholder
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1A2E44),
                        width: 3.0, // Thickness of the border
                      ),
                    ),
                    child: ClipOval(
                      child: Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/InternTrack Logo.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const Text(
                    'InternTrack',
                    style: TextStyle(
                      fontFamily:
                          'AnotherShabby', // You can add a custom font here later
                      fontSize: 50,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF1A2E44), // Dark Navy
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Username Field
                  _buildTextField(hint: 'Username', icon: Icons.person_outline),

                  const SizedBox(height: 15),

                  // Password Field
                  _buildTextField(
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigates to the new Forgot Password screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Color(0xFF1A2E44),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFC05E12,
                            ), // Your Terracotta Orange
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Navigates to HomePage and removes the Login page from the stack
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF34495E),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Location must be enabled to clock in/out.',
                    style: TextStyle(
                      color: Color(0xFF1A2E44),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Exclusive only for RRJ interns.',
                    style: TextStyle(
                      color: Color(0xFF1A2E44),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    '© 2026',
                    style: TextStyle(
                      color: Color(0xFF1A2E44),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build clean text fields
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(fontFamily: 'Poppins'), // Input text font
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Poppins'), // Placeholder font
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}
