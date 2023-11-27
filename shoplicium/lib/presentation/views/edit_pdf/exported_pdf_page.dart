import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../utils/constants/app_colors.dart';
import 'edit_pdf_page.dart';

class ExportedPdfPage extends StatefulWidget {
  const ExportedPdfPage({super.key, required this.exportedFilePath});
  final String exportedFilePath;

  @override
  State<ExportedPdfPage> createState() => _ExportedPdfPageState();
}

class _ExportedPdfPageState extends State<ExportedPdfPage> {
  final _pdfController = PdfViewerController();
  final PdfFunctions _pdfFunctions = PdfFunctions();

  PdfDocument? document;
  Uint8List? fileBytes;

  @override
  void initState() {
    super.initState();

    _loadPdfBytes();
  }

  @override
  void dispose() {
    super.dispose();
    document?.dispose();
  }

  Future<void> _loadPdfBytes() async {
    try {
      var bytes = await _pdfFunctions.readBytesFromFilePath(widget.exportedFilePath);
      if (bytes != null) {
        setState(() {
          fileBytes = Uint8List.fromList(bytes);
          document = PdfDocument(inputBytes: bytes);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.green1,
        title: const Text(
          'Exported Document',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: fileBytes == null
          ? const Center(child: Text('Loading pdf data'))
          : SfPdfViewer.memory(
        fileBytes!,
        controller: _pdfController,
      ),
    );
  }
}
