import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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

          Container(
            color: const Color.fromARGB(255, 224, 224, 224).withOpacity(0.8),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "YOUR HISTORY",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AnotherShabby',
                    color: Color(0xFF1A2E44),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return _buildWeeklyExpansionCard(index + 1);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyExpansionCard(int weekNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF1A2E44).withOpacity(0.2)),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF1A2E44),
          title: Center(
            child: Text(
              "WEEK $weekNumber",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              // FIX: Passing the weekNumber here
              child: _buildAttendanceTable(weekNumber),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceTable(int weekNumber) {
    DateTime startMonday = DateTime(2026, 5, 4).add(Duration(days: (weekNumber - 1) * 7));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.blue.shade100, width: 0.5),
        columnWidths: const {
          0: FlexColumnWidth(2.5),
          1: FlexColumnWidth(2.0),
          2: FlexColumnWidth(2.0),
          3: FlexColumnWidth(2.5),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFF1A2E44)), // Dark Navy Header
            children: const [
              _TableCellText("DATE", isHeader: true),
              _TableCellText("TIME IN", isHeader: true),
              _TableCellText("TIME OUT", isHeader: true),
              _TableCellText("TIME RENDERED", isHeader: true),
            ],
          ),
          ...List.generate(5, (index) {
            DateTime currentRowDate = startMonday.add(Duration(days: index));
            String formattedDate = _formatDate(currentRowDate);

            return TableRow(
              children: [
                _TableCellText(formattedDate),
                const _TableCellText(""),
                const _TableCellText(""),
                const _TableCellText(""),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}

class _TableCellText extends StatelessWidget {
  final String text;
  final bool isHeader;
  const _TableCellText(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isHeader ? 11 : 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          // FIX: Header text is now WHITE, data text is BLACK
          color: isHeader ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}