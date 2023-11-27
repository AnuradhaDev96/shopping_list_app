import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../utils/constants/app_colors.dart';
import 'exported_pdf_page.dart';

class EditPdfPage extends StatefulWidget {
  const EditPdfPage({super.key});

  @override
  State<EditPdfPage> createState() => _EditPdfPageState();
}

class _EditPdfPageState extends State<EditPdfPage> {
  final _pdfController = PdfViewerController();
  final PdfFunctions _pdfFunctions = PdfFunctions();
  final String assetFileName = 'assets/pdf/Cover_letter.pdf';

  PdfDocument? document;
  Uint8List? fileBytes;
  bool isDocumentEdited = false;

  @override
  void initState() {
    super.initState();

    _loadPdfBytes();
  }

  Future<void> _loadPdfBytes() async {
    try {
      var bytes = await _pdfFunctions.readDocumentData(assetFileName);
      setState(() {
        fileBytes = Uint8List.fromList(bytes);
        document = PdfDocument(inputBytes: bytes);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addAcceptedText() async {
    if (document != null) {
      const int pageIndex = 0;
      final PdfPage page = document!.pages[pageIndex];

      // final PdfTextElement textElement = PdfTextElement(
      //   text: 'Document Accepted',
      //   font: PdfStandardFont(PdfFontFamily.helvetica, 20),
      //   brush: PdfSolidBrush(PdfColor(237, 16, 16)),  // Adjust the coordinates as needed
      // );
      var pageSize = page.size;
      page.graphics.drawString(
        'Document Accepted',
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(237, 16, 16)),
        bounds: Rect.fromLTWH(pageSize.width - 200, page.size.height - 100, 200, 50),
      );

      var newBytes = await document!.save();

      setState(() {
        fileBytes = Uint8List.fromList(newBytes);
        document = PdfDocument(inputBytes: newBytes);
        isDocumentEdited = true;
      });
    }
  }

  Future<void> addSignature() async {
    if (document != null) {
      const int pageIndex = 0;
      final PdfPage page = document!.pages[pageIndex];

      var imageBytes = await _pdfFunctions.readDocumentData('assets/pdf/signature_sample.png');
      final PdfBitmap image = PdfBitmap(Uint8List.fromList(imageBytes));

      var pageSize = page.size;
      page.graphics.drawImage(
        image,
        Rect.fromLTWH(pageSize.width - 220, page.size.height - 160, 200, 50),
      );

      var newBytes = await document!.save();

      setState(() {
        fileBytes = Uint8List.fromList(newBytes);
        document = PdfDocument(inputBytes: newBytes);
        isDocumentEdited = true;
      });
    }
  }

  Future<void> exportAndViewPdf() async {
    if (document != null) {
      const String exportedPath = 'exported_pdf.pdf';
      await _pdfFunctions.saveFileToEmptyFile(await document!.save(), exportedPath).then(
            (value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExportedPdfPage(exportedFilePath: exportedPath)),
        ),
      );
      // await File(exportedPath).writeAsBytes(await document!.save()).
    }
  }

  @override
  void dispose() {
    super.dispose();
    document?.dispose();
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
        backgroundColor: AppColors.darkBlue2,
        title: const Text(
          'PDF Editor',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          if (isDocumentEdited)
            IconButton(
              onPressed: () {
                exportAndViewPdf();
              },
              icon: const Icon(Icons.ios_share_rounded, color: Colors.white, size: 20),
            )
        ],
      ),
      // body: SfPdfViewer.asset('assets/pdf/Cover_letter.pdf',controller: _pdfController,),
      body: fileBytes == null
          ? const Center(child: Text('Loading pdf data'))
          : SfPdfViewer.memory(
              fileBytes!,
              controller: _pdfController,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              addSignature();
            },
            child: const Text("Add Signature PNG", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              addAcceptedText();
            },
            child: const Text("Add Accepted Text", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class PdfFunctions {
  // Read pdf data
  Future<List<int>> readDocumentData(String fileName) async {
    final ByteData data = await rootBundle.load(fileName);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<List<int>?> readBytesFromFilePath(String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$fileName');

    if (await file.exists()) {
      return await file.readAsBytes();
    }

    return null;
  }

  // Read PDF and save data to local
  Future<void> readPDF(String fileName) async {
    //Load the PDF document
    final PdfDocument document = PdfDocument(inputBytes: await readDocumentData(fileName));

    //Get the pages count
    int count = document.pages.count;

    //Create the PDF standard font
    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);

    for (int i = 1; i <= count; i++) {
      //Draw text to the page
      document.pages[i - 1].graphics
          .drawString('Page $i of $count', font, bounds: const Rect.fromLTWH(20, 20, 0, 0), brush: PdfBrushes.red);
    }

    //Save the document.
    List<int> bytes = await document.save();
    // Dispose the document.
    document.dispose();

    //Save the file and launch/download.
    saveAndLaunchFile(bytes, 'output.pdf');
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$fileName');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/$fileName');
  }

  Future<void> saveFileToEmptyFile(List<int> bytes, String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$fileName');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
  }
}
