import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:knumingle/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReusedMarketRegisterScreen extends StatefulWidget {
  const ReusedMarketRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ReusedMarketRegisterScreen> createState() =>
      _ReusedMarketRegisterScreenState();
}

class _ReusedMarketRegisterScreenState
    extends State<ReusedMarketRegisterScreen> {
  String? _title;
  String? _preferredPaymentMethod;
  String _description = '';
  List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  // 이미지 추가 함수
  Future<void> _addImages() async {
    if (_images.length < 10) {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          if (_images.length + selectedImages.length <= 10) {
            _images.addAll(selectedImages);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('You can only add up to 10 images.')),
            );
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only add up to 10 images.')),
      );
    }
  }

  // 이미지 삭제 함수
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  bool _isFormValid() {
    return _title != null &&
        _preferredPaymentMethod != null &&
        _description.isNotEmpty;
  }

  // 등록 함수
  Future<void> _registerMarket() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      _showErrorDialog('No token found. Please log in again.');
      return;
    }

    final url = '${ApiAddress}/market'; // API 주소를 추가하세요

    // 이미지 경로 리스트 생성
    List<String> imagePaths = _images.map((image) => image.path).toList();

    final body = jsonEncode({
      'title': _title,
      'content': _description,
      'method': _preferredPaymentMethod,
      'images': [],
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 토큰 추가
      },
      body: body,
    );

    if (response.statusCode == 201) {
      _showSuccessDialog('Successfully registered.');
    } else {
      print(response.statusCode);
      _showErrorDialog('Failed to register. Please try again.');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
                Navigator.pop(context); // 이전 화면으로 돌아가기
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Stuff Register',
              style: TextStyle(fontFamily: 'ggsansBold'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title 입력 필드
            TextField(
              style: TextStyle(fontFamily: 'ggsansBold'),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),

            // Preferred Payment Method 입력 필드 (텍스트 필드로 변경)
            TextField(
              style: TextStyle(fontFamily: 'ggsansBold'),
              onChanged: (value) {
                setState(() {
                  _preferredPaymentMethod = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Preferred Payment Method',
              ),
            ),
            const SizedBox(height: 16),

            // Description 텍스트 영역
            TextField(
              style: TextStyle(fontFamily: 'ggsansBold'),
              maxLength: 1000,
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
              maxLines: 12,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description (max 1000 characters)',
              ),
            ),
            const SizedBox(height: 16),

            // 이미지 추가 버튼
            ElevatedButton(
              onPressed: _addImages,
              child: const Text('Add Images',
                  style: TextStyle(fontFamily: 'ggsansBold')),
            ),
            const SizedBox(height: 16),

            // 이미지 슬라이드 뷰
            _images.isNotEmpty
                ? SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.file(File(_images[index].path),
                                fit: BoxFit.cover),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : const Text('No images added.'),
            const SizedBox(height: 16),

            // Register 버튼
            ElevatedButton(
              onPressed: _isFormValid() ? _registerMarket : null, // 유효성 검사 후 등록
              child: const Text('Register',
                  style: TextStyle(fontFamily: 'ggsansBold')),
            ),
          ],
        ),
      ),
    );
  }
}
