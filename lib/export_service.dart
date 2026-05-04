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
                pw.Text("DTR ATTENDANCE REPORT", 
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                  headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1A2E44)),
                  headers: ['DATE', 'TIME IN', 'TIME OUT', 'TOTAL'],
                  data: [
                    ['May 4, 2026', '08:00 AM', '05:00 PM', '9 hrs'],
                    ['May 5, 2026', '08:05 AM', '05:00 PM', '8.9 hrs'],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // This is the line that usually causes the async suspension if not awaited correctly
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