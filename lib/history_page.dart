import 'package:flutter/material.dart';
import 'theme_manager.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          body: Stack(
            children: [
              // 1. Base Background Image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/jeans bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 2. Dynamic Overlay (Darkens or Lightens the background)
              Container(
                color: isDark
                    ? Colors.black.withOpacity(0.85) // Darker for Dark Mode
                    : const Color.fromARGB(
                        255,
                        224,
                        224,
                        224,
                      ).withOpacity(0.8), // Original light
              ),

              // 3. Content
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "YOUR HISTORY",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AnotherShabby',
                        // Changes title color based on mode
                        color: isDark ? Colors.white : const Color(0xFF1A2E44),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          // Pass isDark to your card builder if it needs internal color changes
                          return _buildWeeklyExpansionCard(index + 1, isDark);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklyExpansionCard(int weekNumber, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        // Background color: Dark grey if dark mode, white if light mode
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : const Color(0xFF1A2E44).withOpacity(0.2),
        ),
      ),
      child: Theme(
        // Ensures the ExpansionTile doesn't show a weird divider color
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
          unselectedWidgetColor: isDark ? Colors.white70 : Colors.black54,
        ),
        child: ExpansionTile(
          // Icon color: White in dark mode, Dark Blue in light mode
          iconColor: isDark ? Colors.white : const Color(0xFF1A2E44),
          collapsedIconColor: isDark ? Colors.white70 : const Color(0xFF1A2E44),
          title: Center(
            child: Text(
              "WEEK $weekNumber",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                // Text color: White in dark mode, Black in light mode
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              // Pass isDark to the table if it also needs color updates
              child: _buildAttendanceTable(weekNumber, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceTable(int weekNumber, bool isDark) {
    DateTime startMonday = DateTime(
      2026,
      5,
      4,
    ).add(Duration(days: (weekNumber - 1) * 7));

    // Dynamic colors for the table borders
    Color borderColor = isDark ? Colors.white24 : Colors.blue.shade100;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Table(
        border: TableBorder.all(color: borderColor, width: 0.5),
        columnWidths: const {
          0: FlexColumnWidth(2.5),
          1: FlexColumnWidth(2.0),
          2: FlexColumnWidth(2.0),
          3: FlexColumnWidth(2.5),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              // Keep it dark navy in light mode, but maybe a lighter slate in dark mode
              color: isDark ? const Color(0xFF2C3E50) : const Color(0xFF1A2E44),
            ),
            children: [
              _TableCellText("DATE", isHeader: true, isDark: isDark),
              _TableCellText("TIME IN", isHeader: true, isDark: isDark),
              _TableCellText("TIME OUT", isHeader: true, isDark: isDark),
              _TableCellText("TIME RENDERED", isHeader: true, isDark: isDark),
            ],
          ),
          ...List.generate(5, (index) {
            DateTime currentRowDate = startMonday.add(Duration(days: index));
            String formattedDate = _formatDate(currentRowDate);

            return TableRow(
              children: [
                _TableCellText(formattedDate, isDark: isDark),
                _TableCellText("", isDark: isDark),
                _TableCellText("", isDark: isDark),
                _TableCellText("", isDark: isDark),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}

class _TableCellText extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isDark; // Add this

  const _TableCellText(this.text, {this.isHeader = false, required this.isDark}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isHeader ? 11 : 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          // If it's a header, text is always white. 
          // If not, it's white in dark mode and black in light mode.
          color: isHeader ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        ),
      ),
    );
  }
}
