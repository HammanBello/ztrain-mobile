import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer_null_safe/flutter_full_pdf_viewer.dart';

class PdfViewScreen extends StatelessWidget {
  final String path;
  const PdfViewScreen({Key key, this.path,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  PDFViewerScaffold(path: path,); //Text("path of pdf: $path");
  }
}