import 'package:flutter/material.dart';
import 'package:flutter_application_1/history_page.dart';
import 'package:flutter_application_1/settings_page.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart'; // Add this
import 'main.dart';
import 'profile_page.dart';
import 'theme_manager.dart'; // Add this

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class AttendanceLog {
  final String date;
  final String clockIn;
  final String clockOut;

  AttendanceLog({
    required this.date,
    required this.clockIn,
    required this.clockOut,
  });
}

class _HomePageState extends State<HomePage> {
  // --- GEOFENCING SETTINGS ---
  static const double officeLat = 14.5954; // Replace with RRJ Office Lat
  static const double officeLng = 121.1005; // Replace with RRJ Office Lng
  static const double radiusMeters = 30.0;

  String _timeString = "";
  late Timer _timer;
  String _clockInTime = "--:--";
  String _clockOutTime = "--:--";
  bool _isClockedIn = false;
  String _lastLogDate = "";
  List<AttendanceLog> _recentLogs = [];
  String _dateString = "";
  int requiredHours = 500;
  double completedHours = 0.0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _dateString = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
    _checkAndResetDailyLogs();
    _requestLocationPermission(); // Request permission on startup
  }

  // Check and ask for location permission
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  List<Widget> get _pages => [
        _buildHomeContent(),
        const HistoryPage(),
        const ProfilePage(),
        const SettingsPage(),
      ];

  @override
  Widget build(BuildContext context) {
    // Listen to Dark Mode Changes
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          body: Stack(
            children: [
              // 1. Background Image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/jeans bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 2. Adaptive Overlay
              Container(
                color: isDark 
                  ? Colors.black.withOpacity(0.8) 
                  : Colors.transparent,
              ),
              _pages[_selectedIndex],
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
            selectedItemColor: isDark ? const Color(0xFFC05E12) : const Color(0xFF1A2E44),
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
            ],
          ),
        );
      },
    );
  }

  // --- REPLACED _handleClockAction with Geofencing logic ---
  Future<void> _handleClockAction() async {
    // Show loading indicator while checking GPS
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      print("Current Location: ${position.latitude}, ${position.longitude}");

      double distance = Geolocator.distanceBetween(
        position.latitude, position.longitude, officeLat, officeLng);

      if (distance <= radiusMeters) {
        // SUCCESS: Within Geofence
        setState(() {
          if (!_isClockedIn) {
            _clockInTime = _timeString;
            _isClockedIn = true;
          } else {
            _clockOutTime = _timeString;
            _isClockedIn = false;
            _calculateSessionHours(_clockInTime, _clockOutTime);
            _recentLogs.insert(0, AttendanceLog(
              date: DateFormat('MMM dd, yyyy').format(DateTime.now()),
              clockIn: _clockInTime,
              clockOut: _clockOutTime,
            ));
            _showSuccessDialog();
          }
        });
      } else {
        // FAILURE: Outside Geofence
        _showErrorDialog("Out of Range", "You are ${(distance - radiusMeters).toInt()}m away from the RRJ office.");
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog("Location Error", "Could not verify your location. Please enable GPS.");
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  Widget _buildHomeContent() {
    bool isDark = isDarkModeNotifier.value;
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildClockCard(isDark),
                const SizedBox(height: 20),
                _buildActivityCard(isDark),
                const SizedBox(height: 20),
                _buildRecentLogsSection(isDark),
              ],
            ),
          ),
        ),
        _buildProgressSection(),
      ],
    );
  }

  Widget _buildClockCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(_dateString.toUpperCase(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2E44))),
          Text(_timeString,
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _handleClockAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isClockedIn ? const Color(0xFFFF2D2D) : const Color(0xFFC05E12),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: Text(_isClockedIn ? "CLOCK OUT" : "CLOCK IN", style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  // ... (Include rest of your existing logic: _updateTime, _calculateSessionHours, etc.)
  
  void _updateTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = DateFormat('HH:mm:ss').format(now);
        _dateString = DateFormat('MMMM dd, yyyy').format(now);
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime.toLocal());
  }

  void _calculateSessionHours(String start, String end) {
    try {
      DateFormat format = DateFormat("HH:mm:ss");
      DateTime startTime = format.parse(start);
      DateTime endTime = format.parse(end);
      Duration difference = endTime.difference(startTime);
      setState(() {
        completedHours += difference.inMinutes / 60.0;
      });
    } catch (e) {
      debugPrint("Error calculating hours: $e");
    }
  }

  void _checkAndResetDailyLogs() {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (_lastLogDate != today) {
      setState(() {
        _clockInTime = "--:--";
        _clockOutTime = "--:--";
        _isClockedIn = false;
        _lastLogDate = today;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 20), Text("Success")]),
        content: const Text("Your attendance has been recorded successfully!"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildHeader() {
    // We check the notifier directly here for the header
    bool isDark = isDarkModeNotifier.value; 
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 25, left: 20, right: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A121E) : const Color(0xFF1A2E44),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 35, backgroundColor: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Welcome, Intern!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text("Mark Joshua E. Garcia", style: TextStyle(color: Colors.white, fontSize: 16)),
                Text("BSIS - One Cainta College", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent, size: 28),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]?.withOpacity(0.9) : Colors.white.withOpacity(0.9), 
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Activity", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2E44))),
          const SizedBox(height: 15),
          _activityRow("Clock In:", _clockInTime, isDark),
          const SizedBox(height: 10),
          _activityRow("Clock Out:", _clockOutTime, isDark),
        ],
      ),
    );
  }

  // Updated this to accept isDark too
  Widget _activityRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : const Color(0xFF1A2E44))),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
      ],
    );
  }

  Widget _buildRecentLogsSection(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]?.withOpacity(0.9) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text("Recent Logs", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A2E44))),
          const Divider(height: 10),
          _recentLogs.isEmpty
              ? const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text("No logs recorded today", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentLogs.length > 3 ? 3 : _recentLogs.length,
                  itemBuilder: (context, index) {
                    final log = _recentLogs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(log.date, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.black)),
                          // ... rest of your log logic
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    bool isDark = isDarkModeNotifier.value;
    double progressValue = requiredHours > 0 ? (completedHours / requiredHours) : 0.0;
    int percentage = (progressValue * 100).toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : const Color.fromARGB(255, 0, 4, 51), 
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Internship Progress", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              Text("${completedHours.toInt()} / $requiredHours hrs ($percentage%)", style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC05E12)),
            ),
          ),
        ],
      ),
    );
  }
}