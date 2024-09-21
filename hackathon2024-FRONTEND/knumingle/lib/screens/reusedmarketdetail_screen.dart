import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:knumingle/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReusedMarketDetailScreen extends StatefulWidget {
  final String itemId;

  const ReusedMarketDetailScreen({super.key, required this.itemId});

  @override
  State<ReusedMarketDetailScreen> createState() =>
      _ReusedMarketDetailScreenState();
}

class _ReusedMarketDetailScreenState extends State<ReusedMarketDetailScreen> {
  String? _title;
  String? _preferredPaymentMethod;
  String _description = '';
  List<XFile> _images = [];
  List<String> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isEditMode = false;
  String? _currentUserId;
  String? userId;
  String _status = 'NONE'; // Default status

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
    _fetchMarketDetails();
  }

  Future<void> _fetchCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString('userId');
  }

  Future<void> _fetchMarketDetails() async {
    final url = '${ApiAddress}/market/${widget.itemId}';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _title = data['title'];
        _preferredPaymentMethod = data['method'];
        _description = data['content'];

        if (data['imageUrl'] != null) {
          _images = data['imageUrl'].map<XFile>((url) => XFile(url)).toList();
        }
        userId = data['userInfoDto']['id'].toString();
        _status = data['status'] ?? 'NONE'; // Initialize the status
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch market details.')),
      );
    }
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

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
    }
  }

  bool _isFormValid() {
    return _title != null &&
        _preferredPaymentMethod != null &&
        _description.isNotEmpty;
  }

  void _toggleStatus(String? newStatus) {
    if (_currentUserId == null || _currentUserId != userId) {
      _showPermissionDeniedDialog();
    } else {
      setState(() {
        _status = newStatus ?? _status;
      });
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Permission Denied.'),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMarket() async {
    final url = '${ApiAddress}/market/${widget.itemId}';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Deleted'),
            content: const Text('Market deleted successfully.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to delete market.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CommentsModal(marketId: widget.itemId); // 모달에 marketId를 전달
      },
    );
  }

  void _updateMarketDetails() async {
    final url = '${ApiAddress}/market/${widget.itemId}';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Prepare images data
    final List<Map<String, dynamic>> imagesData = _images.map((image) {
      return {
        'imageUrl': image.path, // Assuming the image URL is the file path
        'imageId': 0, // Set a default value, you can customize this if needed
      };
    }).toList();

    // Prepare request body
    final Map<String, dynamic> requestBody = {
      'title': _title ?? '',
      'content': _description,
      'method': _preferredPaymentMethod ?? '',
      'status': _status,
      'images': []
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Market details updated successfully.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show failure dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to update market details.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle any error that may occur during the request
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An unexpected error occurred.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail', style: TextStyle(fontFamily: 'ggsansBold')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
              enabled: _isEditMode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
              controller: TextEditingController(text: _title),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(fontFamily: 'ggsansBold'),
                    onChanged: (value) {
                      setState(() {
                        _preferredPaymentMethod = value;
                      });
                    },
                    enabled: _isEditMode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Preferred Payment Method',
                    ),
                    controller:
                        TextEditingController(text: _preferredPaymentMethod),
                  ),
                ),
                const SizedBox(width: 7),
                // Dropdown for status selection
                DropdownButton<String>(
                  value: _status,
                  items: const [
                    DropdownMenuItem(value: 'BOOKED', child: Text('BOOKED')),
                    DropdownMenuItem(
                        value: 'COMPLETED', child: Text('COMPLETED')),
                    DropdownMenuItem(value: 'NONE', child: Text('NONE')),
                  ],
                  onChanged: _isEditMode
                      ? (value) => _toggleStatus(value)
                      : null, // 비활성화 조건 추가
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
              enabled: _isEditMode,
              maxLines: 12,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description (max 1000 characters)',
              ),
              controller: TextEditingController(text: _description),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showCommentsModal, // 모달 열기
              child: const Text('Comment',
                  style: TextStyle(fontFamily: 'ggsansBold')),
            ),
            if (!_isEditMode)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_comments[index]),
                  );
                },
              ),
            const SizedBox(height: 20),
            if (_isEditMode)
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
                            Image.file(File(_images[index].path),
                                fit: BoxFit.cover),
                            if (_isEditMode)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              child: Text(_isEditMode ? 'Edit Mode Off' : 'Edit Mode On',
                  style: const TextStyle(fontFamily: 'ggsansBold')),
            ),
            const SizedBox(height: 16),
            if (_isEditMode)
              ElevatedButton(
                onPressed: _updateMarketDetails,
                child: const Text('Update',
                    style: TextStyle(fontFamily: 'ggsansBold')),
              ),
            ElevatedButton(
              onPressed: _deleteMarket,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red), // Set the button color to red
              child: const Text('Delete',
                  style: TextStyle(color: Colors.white)), // White text color
            ),
          ],
        ),
      ),
    );
  }
}

class CommentsModal extends StatefulWidget {
  final String marketId;

  const CommentsModal({required this.marketId});

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  List<Map<String, dynamic>> _comments = [];
  final TextEditingController _newCommentController = TextEditingController();
  bool _isPrivate = false; // 비밀 댓글 여부 설정

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = '${ApiAddress}/comments/${widget.marketId}';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _comments = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch comments.')),
      );
    }
  }

  Future<void> _submitComment() async {
    if (_newCommentController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = '${ApiAddress}/comments/${widget.marketId}';

      final requestBody = {
        'content': _newCommentController.text,
        'public': !_isPrivate, // 체크박스 상태에 따라 비밀 댓글 여부 설정
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          setState(() {
            _comments.add({
              'content': _newCommentController.text,
              'first_name': 'You',
              'createdAt': DateTime.now().toString(),
            });
            _newCommentController.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to post comment.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text('Comments', style: TextStyle(fontFamily: 'ggsansBold')),
          const Divider(),
          // 댓글 리스트 표시
          Expanded(
            child: _comments.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return ListTile(
                        title: Text(comment['content']),
                        subtitle: Text(
                            '${comment['first_name']} - ${comment['createdAt']}'),
                      );
                    },
                  )
                : const Center(child: Text('No comments yet.')),
          ),
          const Divider(),
          // 댓글 입력란 및 비밀 댓글 체크박스
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newCommentController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your comment',
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isPrivate,
                          onChanged: (value) {
                            setState(() {
                              _isPrivate = value ?? false;
                            });
                          },
                        ),
                        const Text('Private', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _submitComment,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
