import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knumingle/screens/review_screen.dart';

class ReviewRegisterScreen extends StatefulWidget {
  const ReviewRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ReviewRegisterScreen> createState() => _ReviewRegisterScreenState();
}

class _ReviewRegisterScreenState extends State<ReviewRegisterScreen> {
  String? _selectedCategory;
  String? _title;
  int? _selectedRating;
  String _description = '';
  List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

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

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  bool _isFormValid() {
    return _selectedCategory != null &&
        _title != null &&
        _selectedRating != null &&
        _description.isNotEmpty;
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Registration'),
          content: const Text('Are you sure you want to register this review?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 닫기
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 닫기
                _showSuccessDialog(context); // 성공 모달 표시
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Successfully uploaded the review!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReviewPage()), // ReviewPage로 이동
                );
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
      appBar: AppBar(title: const Text('Review Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: const [
                'Dorm',
                'Building',
                'Food',
                'Courses',
                'Life hack',
                'etc',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category',
              ),
            ),
            const SizedBox(height: 16),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Good 선택
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sentiment_very_satisfied, // 웃는 얼굴 아이콘
                        color:
                            _selectedRating == 1 ? Colors.green : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedRating = 1;
                        });
                      },
                    ),
                    const Text('Good'),
                  ],
                ),

                // So So 선택
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sentiment_neutral, // 중립적인 얼굴 아이콘
                        color:
                            _selectedRating == 2 ? Colors.orange : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedRating = 2;
                        });
                      },
                    ),
                    const Text('So So'),
                  ],
                ),

                // Bad 선택
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sentiment_very_dissatisfied, // 찡그린 얼굴 아이콘
                        color: _selectedRating == 3 ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedRating = 3;
                        });
                      },
                    ),
                    const Text('Bad'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
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
            ElevatedButton(
              onPressed: _addImages,
              child: const Text('Add Images'),
            ),
            const SizedBox(height: 16),
            _images.isNotEmpty
                ? SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            // 이미지 표시
                            Image.file(
                              File(_images[index].path),
                              fit: BoxFit.cover,
                              width: double.infinity, // 이미지 크기를 화면에 맞춤
                            ),
                            // 이미지 삭제 버튼 (오른쪽 상단)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                            // 이미지 개수 표시 (왼쪽 하단)
                            Positioned(
                              left: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${index + 1} / ${_images.length} images', // 몇 번째 이미지인지 표시
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : const Text('No images added.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isFormValid()
                  ? () => _showConfirmationDialog(context)
                  : null, // 유효성 검사
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
