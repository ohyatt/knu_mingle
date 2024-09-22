import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:knumingle/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

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
  void initState() {
    super.initState();
    _fetchReviewData(); // 리뷰 데이터 가져오기
  }

  Future<void> _fetchReviewData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = '${ApiAddress}/review/${widget.reviewId}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> reviewData = json.decode(response.body);
        print(reviewData);

        // Reaction 값 변환 (GOOD -> 1, SOSO -> 2, BAD -> 3)
        int rating;
        if (reviewData['reaction'] == 'GOOD') {
          rating = 1;
        } else if (reviewData['reaction'] == 'SOSO') {
          rating = 2;
        } else if (reviewData['reaction'] == 'BAD') {
          rating = 3;
        } else {
          rating = 0; // 만약 예상치 못한 값이 있으면 기본값 설정
        }

        // imageUrl을 List<XFile>로 파싱
        List<XFile> images = [];
        if (reviewData['imageUrl'] != null) {
          images = List<XFile>.from(
            (reviewData['imageUrl'] as List)
                .map((imagePath) => XFile(imagePath)),
          );
        }

        setState(() {
          _selectedCategory =
              reviewData['keyword']; // 'keword' -> 'keyword' 오타 수정
          _title = reviewData['title'];
          _selectedRating = rating; // 변환된 rating 값 설정
          _description = reviewData['content'];
          _images = images; // 파싱된 images 리스트 설정
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load review data.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  Future<void> _updateReview() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = '${ApiAddress}/review/${widget.reviewId}';

    // reaction 값을 변환
    String reaction;
    if (_selectedRating == 1) {
      reaction = 'GOOD';
    } else if (_selectedRating == 2) {
      reaction = 'SOSO';
    } else if (_selectedRating == 3) {
      reaction = 'BAD';
    } else {
      reaction = 'UNKNOWN'; // 기본값
    }

    // 이미지 경로를 string 리스트로 변환
    List<String> imageUrls = _images.map((image) => image.path).toList();

    // request body
    final Map<String, dynamic> requestBody = {
      "keyword": _selectedCategory ?? 'Unknown',
      "title": _title ?? 'No Title',
      "content": _description,
      "reaction": reaction,
      "images": imageUrls
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        _showModal(
          'Success',
          'Review updated successfully.',
          true, // 성공 시 true로 처리
        );
      } else {
        print(response.statusCode);
        _showModal(
          'Failed',
          'Failed to update review. Please try again later.',
          false, // 실패 시 false로 처리
        );
      }
    } catch (e) {
      _showModal(
        'Error',
        'An error occurred. Please try again later.',
        false, // 에러 발생 시 false로 처리
      );
    }
  }

  void _showModal(String title, String message, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
                if (success) {
                  // 성공 시 전 페이지로 돌아가고 새로고침
                  Navigator.pop(context, true); // 성공 시 새로고침 전달
                }
              },
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
                'Dormitory',
                'Facility',
                'Foods',
                'Courses',
                'Tips',
                'Ects'
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Title',
                hintText: _title, // 기존 제목 표시
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sentiment_very_satisfied,
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
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sentiment_neutral,
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
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sentiment_very_dissatisfied,
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Description (max 1000 characters)',
                hintText: _description, // 기존 설명 표시
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
                            Image.file(
                              File(_images[index].path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
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
              onPressed: _updateReview, // 업데이트 버튼 눌렀을 때 _updateReview 호출
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
