import 'package:flutter/material.dart';
import 'package:flutter_application_1/history_page.dart';
import 'package:flutter_application_1/settings_page.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'main.dart';
import 'profile_page.dart';

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
  }

  List<Widget> get _pages => [
    _buildHomeContent(),
    const HistoryPage(),
    const ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/jeans bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A2E44),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildClockCard(),
                const SizedBox(height: 20),
                _buildActivityCard(),
                const SizedBox(height: 20),
                _buildRecentLogsSection(),
              ],
            ),
          ),
        ),
        _buildProgressSection(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 25, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1A2E44),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Welcome, Intern!",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
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

  Widget _buildClockCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Text(_dateString.toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2E44), letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Text(_timeString,
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Poppins')),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _handleClockAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isClockedIn ? const Color(0xFFFF2D2D) : const Color(0xFFC05E12),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF1A2E44), width: 1),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fingerprint, color: Colors.white),
                const SizedBox(width: 10),
                Text(_isClockedIn ? "CLOCK OUT" : "CLOCK IN",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text("Biometrics verification", style: TextStyle(color: Color.fromARGB(255, 58, 58, 58), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2E44))),
          const SizedBox(height: 15),
          _activityRow("Clock In:", _clockInTime),
          const SizedBox(height: 10),
          _activityRow("Clock Out:", _clockOutTime),
        ],
      ),
    );
  }

  Widget _activityRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF1A2E44))),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRecentLogsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Text("Recent Logs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2E44))),
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
                          Text(log.date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              children: [
                                const TextSpan(text: "IN: ", style: TextStyle(color: Colors.black)),
                                TextSpan(text: log.clockIn, style: TextStyle(color: _getInColor(log.clockIn))),
                                const TextSpan(text: " | OUT: ", style: TextStyle(color: Colors.black)),
                                TextSpan(text: log.clockOut, style: TextStyle(color: _getOutColor(log.clockOut))),
                              ],
                            ),
                          ),
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
    double progressValue = requiredHours > 0 ? (completedHours / requiredHours) : 0.0;
    int percentage = (progressValue * 100).toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 4, 51), borderRadius: BorderRadius.circular(15)),
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

  void _handleClockAction() {
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

  Color _getInColor(String time) {
    if (time == "--:--" || time.isEmpty) return Colors.black;
    try {
      List<String> parts = time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      if (hour > 8 || (hour == 8 && minute > 30)) return Colors.red;
    } catch (e) { return Colors.black; }
    return const Color.fromARGB(255, 132, 212, 2);
  }

  Color _getOutColor(String time) {
    if (time == "--:--" || time.isEmpty) return Colors.black;
    try {
      List<String> parts = time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      if (hour < 17 || (hour == 17 && minute < 30)) return Colors.red;
    } catch (e) { return Colors.black; }
    return const Color.fromARGB(255, 132, 212, 2);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 20), Text("Success")]),
        content: const Text("Your attendance has been recorded successfully!"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK", style: TextStyle(color: Color(0xFF1A2E44)))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}