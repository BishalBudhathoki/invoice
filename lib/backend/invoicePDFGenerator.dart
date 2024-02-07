import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class InvoicePdfGenerator {
  Future<List<String>> generatePdfs(Map<String, dynamic> processedData, {bool showTax = true}) async {
    List<String> generatedPdfPaths = [];

    try {
      final clients = processedData['clients'] as List<dynamic>? ?? [];

      for (var clientData in clients) {
        if (clientData is! Map<String, dynamic>) {
          print('Warning: Invalid client data format');
          continue;
        }

        final pdf = pw.Document();

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4.copyWith(
                marginLeft: 15,
                marginRight: 15,
                marginTop: 35,
                marginBottom: 25),
            build: (pw.Context context) => [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildInvoiceHeader(clientData),
                  pw.SizedBox(height: 24),
                  pw.SizedBox(height: 1, child: pw.Divider(color: PdfColors.black)),
                  pw.SizedBox(height: 24),
                  _buildBillingInfo(clientData),
                  pw.SizedBox(height: 24),
                  _buildInvoiceDetails(clientData),
                  pw.SizedBox(height: 24),
                  _buildInvoiceTotal(clientData, showTax),
                ],
              ),
            ],
          ),
        );

        final safeClientName = _getSafeString(clientData['clientName'])
            .replaceAll(' ', '_')
            .replaceAll(RegExp(r'[^\w\s-]'), '');
        final fileName =
            'Invoice_${_getSafeString(clientData['invoiceNumber'])}_${safeClientName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final output = await getTemporaryDirectory();
        final file = File('${output.path}/$fileName');
        await file.writeAsBytes(await pdf.save());
        generatedPdfPaths.add(file.path);
      }
    } catch (e) {
      print('Error generating PDFs: $e');
    }

    return generatedPdfPaths;
  }

  String _getSafeString(dynamic value) {
    if (value == null) return 'N/A';
    if (value is String) return value;
    return value.toString();
  }

  pw.Widget _buildInvoiceHeader(Map<String, dynamic> clientData) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INVOICE', style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Invoice Number: ${_getSafeString(clientData['invoiceNumber'])}'),
            pw.Text('Invoice Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Your Company Name', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text('123 Your Street'),
            pw.Text('Your City, State ZIP'),
            pw.Text('Phone: (123) 456-7890'),
            pw.Text('Email: your@email.com'),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildBillingInfo(Map<String, dynamic> clientData) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Bill To:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(_getSafeString(clientData['clientName'])),
              pw.Text(_getSafeString(clientData['billingAddress'])),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Ship To:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(_getSafeString(clientData['clientName'])),
              pw.Text(_getSafeString(clientData['shippingAddress'])),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildInvoiceDetails(Map<String, dynamic> clientData) {
    final items = clientData['items'] as List<dynamic>? ?? [];
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableHeader('Date'),
            _buildTableHeader('Description'),
            _buildTableHeader('Hours'),
            _buildTableHeader('Rate'),
            _buildTableHeader('Amount'),
          ],
        ),
        ...items.map<pw.TableRow>((item) {
          if (item is! Map<String, dynamic>) {
            print('Warning: Invalid item format');
            return pw.TableRow(children: List.filled(5, pw.Container()));
          }
          return pw.TableRow(
            children: [
              _buildTableCell(_getSafeString(item['date'])),
              _buildTableCell('${_getSafeString(item['day'])} ${_getSafeString(item['itemName'])}'),
              _buildTableCell(_getSafeString(item['hours'])),
              _buildTableCell('\$${_getSafeString(item['rate'])}'),
              _buildTableCell('\$${_getSafeString(item['amount'])}'),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildInvoiceTotal(Map<String, dynamic> clientData, bool showTax) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          _buildTotalRow('Subtotal', _getSafeDouble(clientData['subtotal'])),
          if (showTax) _buildTotalRow('Tax (5%)', _getSafeDouble(clientData['tax'])),
          pw.Divider(color: PdfColors.black),
          _buildTotalRow('Total', _getSafeDouble(clientData['total']), isBold: true),
        ],
      ),
    );
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _buildTableCell(String text) {
    return pw.Container(
      padding: pw.EdgeInsets.all(5),
      child: pw.Text(text),
    );
  }

  pw.Widget _buildTotalRow(String label, double amount, {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(
          '\$${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
        ),
      ],
    );
  }

  double _getSafeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}