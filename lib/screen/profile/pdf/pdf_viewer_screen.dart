import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:myutils/data/network/model/output/contract_output.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends BaseStatelessScreenV2 {
  final DataPdf? data;
  static const String route = '/pdf_viewer';

  const PdfViewerScreen({super.key, this.data});

  @override
  String? get title => data?.name ?? '';

  @override
  Widget buildBody(BuildContext pageContext) {
    return PDFViewerPage(url: data?.file ?? '');
  }
}

class PDFViewerPage extends StatefulWidget {
  final String url;

  const PDFViewerPage({super.key, required this.url});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    try {
      final fileExtension = path.extension(widget.url).toLowerCase();
      if (fileExtension != '.pdf') {
        throw Exception('Unsupported file type. Only PDF files are supported.');
      }

      final response = await http.get(Uri.parse(widget.url));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/document.pdf');

      await file.writeAsBytes(bytes, flush: true);
      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'error.noInformation'.tr();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
          child: Text(
        error!,
      ));
    }

    if (localPath == null) {
      return const Center(child: Text('No PDF available'));
    }

    return PDFView(
      filePath: localPath!,
      enableSwipe: true,
      autoSpacing: false,
      pageFling: true,
      onError: (error) {
        print('Error while loading PDF: $error');
        setState(() {
          this.error = 'Error while loading PDF: $error';
        });
      },
    );
  }
}
