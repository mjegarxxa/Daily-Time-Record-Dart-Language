import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static Future<void> exportAttendanceToPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("YOUR ATTENDANCE REPORT FOR WEEK 1",
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 50),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                  headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1A2E44)),
                  headers: ['DATE', 'TIME IN', 'TIME OUT', 'TOTAL'],
                  data: [
                    ['May 4, 2026', '08:30 AM', '05:46 PM', '8.16 HRS'],
                    ['May 5, 2026', '08:54 AM', '06:21 PM', '8.27 HRS'],
                    ['May 6, 2026', '08:21 AM', '05:32 PM', '8.11 HRS'],
                    ['May 7, 2026', '08:28 AM', '05:56 PM', '8.28 HRS'],
                    ['May 8, 2026', '08:42 AM', '05:36 PM', '7.54 HRS'],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    try {
      await Printing.sharePdf(
        bytes: await pdf.save(), 
        filename: 'attendance_history.pdf'
      );
    } catch (e) {
      print("Export Error: $e");
    }
  }
}