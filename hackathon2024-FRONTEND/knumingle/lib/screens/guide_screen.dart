import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:knumingle/components/underbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guide Screen',
      home: GuideScreen(),
    );
  }
}

class GuideScreen extends StatelessWidget {
  final List<String> guides = [
    'Foreign Student Guidebook Russian',
    'Foreign Student Guidebook Vietnamese',
    'Foreign Student Guidebook Spanish',
    'Foreign Student Guidebook English',
    'Foreign Student Guidebook Japanese',
    'Foreign Student Guidebook in Chinese',
    'Foreign Student Guidebook Korean',
  ];

  final List<String> pdfFiles = [
    'assets/files/1.pdf',
    'assets/files/2.pdf',
    'assets/files/3.pdf',
    'assets/files/4.pdf',
    'assets/files/5.pdf',
    'assets/files/6.pdf',
    'assets/files/7.pdf',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Guide', style: TextStyle(fontFamily: 'ggsansBold')),
      ),
      body: Column(
        children: [
          // 상단 문구
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'The Global First Step of Studying Abroad in South Korea',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: guides.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 20, thickness: 1), // 구분선 추가
              itemBuilder: (context, index) {
                return ListTile(
                  title: Center(
                    // 중앙 정렬
                    child: Text(
                      guides[index],
                      style: TextStyle(fontFamily: 'ggsansBold'),
                    ),
                  ),
                  onTap: () async {
                    print(pdfFiles[index]); // 파일 경로 출력
                    PDFDocument doc =
                        await PDFDocument.fromAsset(pdfFiles[index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewerPage(document: doc),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: UnderBar(parentContext: context),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final PDFDocument document;

  PDFViewerPage({required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFViewer(
        document: document,
        showIndicator: true,
      ),
      bottomNavigationBar: null, // 필요하면 이 부분 수정 가능
    );
  }
}
