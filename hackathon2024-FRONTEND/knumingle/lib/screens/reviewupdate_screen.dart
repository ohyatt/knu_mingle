import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewUpdateScreen extends StatefulWidget {
  final int reviewId;

  const ReviewUpdateScreen({super.key, required this.reviewId});

  @override
  _ReviewUpdateScreenState createState() => _ReviewUpdateScreenState();
}

class _ReviewUpdateScreenState extends State<ReviewUpdateScreen> {
  String? _selectedCategory;
  String? _title;
  int? _selectedRating;
  String _description = '';
  List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Review',
            style: TextStyle(fontFamily: 'ggsansBold')),
      ),
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
              style: const TextStyle(fontFamily: 'ggsansBold'),
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
                    const Text('Good',
                        style: TextStyle(fontFamily: 'ggsansBold')),
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
                    const Text('So So',
                        style: TextStyle(fontFamily: 'ggsansBold')),
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
                    const Text('Bad',
                        style: TextStyle(fontFamily: 'ggsansBold')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
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
              child: const Text('Add Images',
                  style: TextStyle(fontFamily: 'ggsansBold')),
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
                              width: double.infinity,
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
                                  '${index + 1} / ${_images.length} images',
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
              onPressed: () {
                // 수정된 내용을 저장하는 로직 추가
                Navigator.pop(context); // 화면을 닫고 이전 화면으로 돌아가기
              },
              child: const Text('Update',
                  style: TextStyle(fontFamily: 'ggsansBold')),
            ),
          ],
        ),
      ),
    );
  }

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
}
