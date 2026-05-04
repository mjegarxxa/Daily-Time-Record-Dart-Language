import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend body behind appBar to keep the background seamless
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2E44)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // 1. Denim Background
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
          
          // 2. Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),

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
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'InternTrack',
                    style: TextStyle(
                      fontFamily:
                          'AnotherShabby', // You can add a custom font here later
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF1A2E44), // Dark Navy
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Forgot your password?",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2E44),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. The White "Card" Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(5), // Square-ish look from photo
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Enter a new password below to change your old password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2E44),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // New Password Field
                        _buildPasswordField("New Password", _newPasswordController),
                        const SizedBox(height: 15),

                        // Confirm Password Field
                        _buildPasswordField("Confirm Password", _confirmPasswordController),
                        const SizedBox(height: 20),

                        // Reset Password Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your password update logic here
                              _showSuccessSnackBar(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF455A64), // Dark blue-grey
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            child: const Text(
                              "Reset Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildPasswordField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black87, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password updated successfully!")),
    );
    Navigator.pop(context); // Go back to login
  }
}