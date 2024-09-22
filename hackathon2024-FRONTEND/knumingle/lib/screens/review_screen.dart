import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knumingle/components/underbar.dart';
import 'package:knumingle/constants/url.dart';
import 'package:knumingle/screens/myaccount_screen.dart';
import 'package:knumingle/screens/reviewregister_screen.dart';
import 'package:knumingle/screens/reviewupdate_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import your update screen
import 'package:http/http.dart' as http;

class ReviewPage extends StatefulWidget {
  ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int? _selectedRating;
  List<Map<String, dynamic>> reviews = [];
  List<Map<String, dynamic>> filteredReviews = [];
  final TextEditingController searchController = TextEditingController();
  String? selectedOption; // 초기값을 null로 설정
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    selectedOption = 'All'; // 기본 옵션을 'All'로 설정
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      setState(() {
        print('No token found.');
      });
      return;
    }

    final url = '${ApiAddress}/review'; // API URL
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      final List<dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      setState(() {
        reviews = responseData.map((item) {
          return {
            'id': item['id'],
            'title': item['title'],
            'nation': item['userInfoDto']['nation'],
            'author':
                '${item['userInfoDto']['first_name']} ${item['userInfoDto']['last_name']}',
            'category': item['keyword'], // Assuming this maps to the category
            'score': item['reaction'], // Assuming this maps to the score
            'detail': item['content'],
            'date': item['createdAt'],
            'images': List<String>.from(
                item['imageUrl']), // 이미지 URL 리스트를 List<String>으로 변환
            'likes': 0,
            'dislikes': 0,
            'liked': false,
            'disliked': false,
            'userId': item['userInfoDto']['id']
          };
        }).toList();
        filteredReviews = reviews; // 초기 상태에서 필터링된 리뷰도 동일하게 설정
      });
    } else {
      setState(() {
        print('Error fetching reviews: ${response.statusCode}');
      });
    }
  }

  Future<void> _deleteReview(String reviewId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedUserId =
        prefs.getString('userId'); // 로컬 스토리지에서 userId 가져오기

    if (storedUserId == userId) {
      final url = '${ApiAddress}/review/$reviewId'; // DELETE 요청할 URL

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${prefs.getString('token')}', // 토큰 추가
        },
      );

      if (response.statusCode == 200) {
        // 성공적으로 삭제되었을 때
        _showSuccessDialog();
      } else {
        _showErrorDialog('Failed to delete review: ${response.statusCode}');
      }
    } else {
      _showErrorDialog('You cannot delete this review.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Review deleted successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 닫기
                _fetchReviews(); // 새로고침
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
                Navigator.of(context).pop(); // 닫기
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void filterReviews(String query) {
    List<Map<String, dynamic>> filtered = reviews;

    // Category filtering
    if (selectedOption != null && selectedOption != 'All') {
      filtered = filtered.where((review) {
        return review['category'] == selectedOption;
      }).toList();
    }

    // Search filter
    if (query.isNotEmpty) {
      filtered = filtered.where((review) {
        final titleLower = review['title'].toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    }

    // Score filtering based on _selectedRating
    if (_selectedRating != null) {
      filtered = filtered.where((review) {
        if (_selectedRating == 1) {
          return review['score'] == 'GOOD';
        } else if (_selectedRating == 2) {
          return review['score'] == 'SOSO';
        } else if (_selectedRating == 3) {
          return review['score'] == 'BAD';
        }
        return true;
      }).toList();
    }

    setState(() {
      filteredReviews = filtered;
    });
  }

  // 추가적인 UI 구현이 필요할 수 있습니다.

  void toggleLike(int index) {
    setState(() {
      if (filteredReviews[index]['liked']) {
        filteredReviews[index]['liked'] = false;
        filteredReviews[index]['likes']--;
      } else {
        filteredReviews[index]['liked'] = true;
        filteredReviews[index]['likes']++;
        filteredReviews[index]['disliked'] = false;
        filteredReviews[index]['dislikes'] =
            filteredReviews[index]['dislikes'] > 0
                ? filteredReviews[index]['dislikes'] - 1
                : 0;
      }
    });
  }

  void toggleDislike(int index) {
    setState(() {
      if (filteredReviews[index]['disliked']) {
        filteredReviews[index]['disliked'] = false;
        filteredReviews[index]['dislikes']--;
      } else {
        filteredReviews[index]['disliked'] = true;
        filteredReviews[index]['dislikes']++;
        filteredReviews[index]['liked'] = false;
        filteredReviews[index]['likes'] = filteredReviews[index]['likes'] > 0
            ? filteredReviews[index]['likes'] - 1
            : 0;
      }
    });
  }

  void sortReviews() {
    setState(() {
      if (selectedSort == 'Date') {
        filteredReviews.sort((a, b) => a['date'].compareTo(b['date']));
      } else if (selectedSort == 'Likes') {
        filteredReviews.sort((a, b) => b['likes'].compareTo(a['likes']));
      }
    });
  }

  String _formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime); // 원하는 형식으로 변경
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Review', style: TextStyle(fontFamily: 'ggsansBold')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar and My Account button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontFamily: 'ggsansBold'),
                      controller: searchController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Search',
                      ),
                      onChanged: (query) {
                        filterReviews(query);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAccountPage(),
                        ),
                      );
                    },
                    child: const Text('My Account',
                        style: TextStyle(fontFamily: 'ggsansBold')),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dropdowns for options and sorting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: const Text('Category'),
                      value: selectedOption,
                      items: <String>[
                        'All', // 'All' added here
                        'Dormitory',
                        'Facility',
                        'Foods',
                        'Courses',
                        'Tips',
                        'Ects'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
                          filterReviews(searchController.text); // Apply filter
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      hint: const Text('Sort by'),
                      value: selectedSort,
                      items: <String>['Date', 'Likes'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSort = newValue;
                          sortReviews();
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReviewRegisterScreen(),
                        ),
                      );
                    },
                    child: const Text('Register',
                        style: TextStyle(fontFamily: 'ggsansBold')),
                  ),
                ],
              ),
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
                            if (_selectedRating == 1) {
                              _selectedRating = null; // 이미 선택된 경우 취소
                            } else {
                              _selectedRating = 1; // Good 선택
                            }
                            filterReviews(searchController
                                .text); // Apply the score filter
                          });
                        },
                      ),
                      const Text('GOOD',
                          style: TextStyle(fontFamily: 'ggsansBold')),
                    ],
                  ),

                  // So So 선택
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.sentiment_neutral, // 중립적인 얼굴 아이콘
                          color: _selectedRating == 2
                              ? Colors.orange
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_selectedRating == 2) {
                              _selectedRating = null; // 이미 선택된 경우 취소
                            } else {
                              _selectedRating = 2; // So So 선택
                            }
                            filterReviews(searchController
                                .text); // Apply the score filter
                          });
                        },
                      ),
                      const Text('SOSO',
                          style: TextStyle(fontFamily: 'ggsansBold')),
                    ],
                  ),

                  // Bad 선택
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.sentiment_very_dissatisfied, // 찡그린 얼굴 아이콘
                          color:
                              _selectedRating == 3 ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_selectedRating == 3) {
                              _selectedRating = null; // 이미 선택된 경우 취소
                            } else {
                              _selectedRating = 3; // Bad 선택
                            }
                            filterReviews(searchController
                                .text); // Apply the score filter
                          });
                        },
                      ),
                      const Text('BAD',
                          style: TextStyle(fontFamily: 'ggsansBold')),
                    ],
                  ),
                ],
              ),
              // Review cards
              if (filteredReviews.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0), // 위쪽에 16px 여백 추가
                    child: Text(
                      'No reviews available',
                      style: TextStyle(
                        fontFamily: 'ggsansBold',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey, // 글자 색을 회색으로 설정
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  itemCount: filteredReviews.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final review = filteredReviews[index];

                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // Modal을 전체 화면으로 만듦
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              initialChildSize:
                                  0.7, // 모달이 열렸을 때 기본 크기 (화면의 70%)
                              minChildSize: 0.5, // 모달 최소 크기
                              maxChildSize: 0.9, // 모달 최대 크기
                              expand: false,
                              builder: (BuildContext context,
                                  ScrollController scrollController) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    controller: scrollController, // 스크롤 컨트롤러 추가
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 모달에서의 제목
                                        Text(
                                          review['title'],
                                          style: const TextStyle(
                                            fontFamily: 'ggsansBold',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // 모달에서의 국가, 작성자, 카테고리
                                        Text('Nation: ${review['nation']}',
                                            style: TextStyle(
                                                fontFamily: 'ggsansBold')),
                                        Text('Author: ${review['author']}',
                                            style: TextStyle(
                                                fontFamily: 'ggsansBold')),
                                        Text('Category: ${review['category']}',
                                            style: TextStyle(
                                                fontFamily: 'ggsansBold')),
                                        Text(
                                            'Date: ${_formatDate(review['date'])}',
                                            style: TextStyle(
                                                fontFamily: 'ggsansBold')),
                                        const SizedBox(height: 8),
                                        // 모달에서의 평점 (아이콘 포함)
                                        Row(
                                          children: [
                                            Icon(
                                              review['score'] == 'GOOD'
                                                  ? Icons
                                                      .sentiment_very_satisfied
                                                  : review['score'] == 'SOSO'
                                                      ? Icons.sentiment_neutral
                                                      : Icons
                                                          .sentiment_very_dissatisfied,
                                              color: review['score'] == 'GOOD'
                                                  ? Colors.green
                                                  : review['score'] == 'SOSO'
                                                      ? Colors.orange
                                                      : Colors.red,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              review['score'].toString(),
                                              style: TextStyle(
                                                color: review['score'] == 'GOOD'
                                                    ? Colors.green
                                                    : review['score'] == 'SOSO'
                                                        ? Colors.orange
                                                        : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // 모달에서의 상세 정보
                                        Text(
                                          '${review['detail']}',
                                          style: TextStyle(
                                              fontFamily: 'ggsansBold'),
                                        ),
                                        const SizedBox(height: 12),
                                        // 모달에서 이미지 슬라이더
                                        SizedBox(
                                          height: 150,
                                          child: PageView.builder(
                                            itemCount: review['images'].length,
                                            itemBuilder: (context, imageIndex) {
                                              return Image.asset(
                                                review['images'][imageIndex],
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // 모달에서 좋아요/싫어요 버튼
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.thumb_up,
                                                color: review['liked']
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                toggleLike(index);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            Text(review['likes'].toString()),
                                            const SizedBox(width: 16),
                                            IconButton(
                                              icon: Icon(
                                                Icons.thumb_down,
                                                color: review['disliked']
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                toggleDislike(index);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            Text(review['dislikes'].toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and action buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Title
                                  Expanded(
                                    child: Text(
                                      review['title'],
                                      style: const TextStyle(
                                        fontFamily: 'ggsansBold',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Edit and Delete buttons
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          final String? userId =
                                              prefs.getString(
                                                  'userId'); // 사용자 ID 가져오기
                                          print(userId);
                                          print(review['userId']);
                                          if (userId ==
                                              review['userId'].toString()) {
                                            // 사용자 ID가 일치하는 경우 ReviewUpdateScreen으로 이동
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewUpdateScreen(
                                                  reviewId: review['id'],
                                                  // 필요한 다른 리뷰 데이터도 전달
                                                ),
                                              ),
                                            ).then((shouldRefesh) {
                                              if (shouldRefesh == true) {
                                                setState(() {
                                                  _fetchReviews();
                                                });
                                              }
                                            });
                                          } else {
                                            // 권한이 없다는 모달 표시
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Permission Denied'),
                                                  content: const Text(
                                                      'Permission Denied'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // 다이얼로그 닫기
                                                      },
                                                      child: const Text('확인'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          final String? userId =
                                              prefs.getString(
                                                  'userId'); // 사용자 ID 가져오기

                                          if (userId ==
                                              review['userId'].toString()) {
                                            // 사용자 ID가 일치하는 경우 삭제 함수 호출
                                            _deleteReview(
                                              review['id']
                                                  .toString(), // ID를 String으로 변환
                                              userId!, // userId를 String으로 변환
                                            );
                                          } else {
                                            // 권한이 없다는 모달 표시
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Permission Denied'),
                                                  content: const Text(
                                                      'Permission Denied.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // 다이얼로그 닫기
                                                      },
                                                      child: const Text('확인'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Nation, Author, and Category
                              Text(
                                'Nation: ${review['nation']}',
                                style: TextStyle(fontFamily: 'ggsansBold'),
                              ),
                              Text('Author: ${review['author']}',
                                  style: TextStyle(fontFamily: 'ggsansBold')),
                              Text('Category: ${review['category']}',
                                  style: TextStyle(fontFamily: 'ggsansBold')),
                              Text('Date: ${_formatDate(review['date'])}',
                                  style: TextStyle(fontFamily: 'ggsansBold')),
                              const SizedBox(height: 8),
                              // Score
                              Row(
                                children: [
                                  Icon(
                                    review['score'] == 'GOOD'
                                        ? Icons.sentiment_very_satisfied
                                        : review['score'] == 'SOSO'
                                            ? Icons.sentiment_neutral
                                            : Icons.sentiment_very_dissatisfied,
                                    color: review['score'] == 'GOOD'
                                        ? Colors.green
                                        : review['score'] == 'SOSO'
                                            ? Colors.orange
                                            : Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    review['score'].toString(),
                                    style: TextStyle(
                                      color: review['score'] == 'GOOD'
                                          ? Colors.green
                                          : review['score'] == 'SOSO'
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Detail
                              Text(
                                '${review['detail']}',
                                style: TextStyle(fontFamily: 'ggsansBold'),
                                maxLines: 5, // 최대 5줄까지 표시
                                overflow:
                                    TextOverflow.ellipsis, // 5줄 이상일 경우 ... 표시
                              ),
                              const SizedBox(height: 12),
                              // Image slider with image count in the top-right corner
                              SizedBox(
                                height: 150,
                                child: Stack(
                                  children: [
                                    PageView.builder(
                                      itemCount: review['images'].length,
                                      itemBuilder: (context, imageIndex) {
                                        return Image.asset(
                                          review['images'][imageIndex],
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${review['images'].length} images',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Like/Dislike buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: review['liked']
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    onPressed: () => toggleLike(index),
                                  ),
                                  Text(review['likes'].toString()),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: Icon(
                                      Icons.thumb_down,
                                      color: review['disliked']
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () => toggleDislike(index),
                                  ),
                                  Text(review['dislikes'].toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: UnderBar(parentContext: context),
    );
  }
}
