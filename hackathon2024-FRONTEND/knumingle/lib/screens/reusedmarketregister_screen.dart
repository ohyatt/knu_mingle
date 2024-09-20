import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stuff Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title 입력 필드
            TextField(
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
              child: const Text('Add Images'),
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
              onPressed: _isFormValid()
                  ? () {
                      // 등록 로직 추가 가능
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form Submitted')),
                      );
                    }
                  : null, // 폼 유효성 검사
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
