import 'package:flutter/material.dart';
import 'package:knumingle/components/underbar.dart';
import 'package:knumingle/screens/myaccount_screen.dart';
import 'package:knumingle/screens/reviewregister_screen.dart';
import 'package:knumingle/screens/reviewupdate_screen.dart'; // Import your update screen

class ReviewPage extends StatefulWidget {
  ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final List<Map<String, dynamic>> reviews = [
    {
      'id': 1,
      'title': 'Great Laptop',
      'nation': 'USA',
      'author': 'John Doe',
      'category': 'Electronics',
      'score': 4.5,
      'detail': 'This laptop has great performance and battery life.',
      'date': '2024-09-20',
      'images': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150/0000FF',
      ],
      'likes': 0,
      'dislikes': 0,
      'liked': false,
      'disliked': false,
    },
    {
      'id': 2,
      'title': 'Comfortable Chair',
      'nation': 'Canada',
      'author': 'Jane Smith',
      'category': 'Furniture',
      'score': 4.0,
      'detail': 'The chair is very comfortable for long hours of sitting.',
      'date': '2024-09-19',
      'images': [
        'https://via.placeholder.com/150/FF0000',
        'https://via.placeholder.com/150/00FF00',
      ],
      'likes': 0,
      'dislikes': 0,
      'liked': false,
      'disliked': false,
    },
    {
      'id': 3,
      'title': 'Excellent Phone',
      'nation': 'UK',
      'author': 'Alex Johnson',
      'category': 'Electronics',
      'score': 5.0,
      'detail': 'This phone has an amazing camera and fast performance.',
      'date': '2024-09-18',
      'images': [
        'https://via.placeholder.com/150/FFFF00',
        'https://via.placeholder.com/150/000000',
      ],
      'likes': 0,
      'dislikes': 0,
      'liked': false,
      'disliked': false,
    },
  ];

  List<Map<String, dynamic>> filteredReviews = [];
  final TextEditingController searchController = TextEditingController();
  String? selectedOption;
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    filteredReviews = reviews;
  }

  void filterReviews(String query) {
    final List<Map<String, dynamic>> filtered = reviews.where((review) {
      final titleLower = review['title'].toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredReviews = filtered;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Review'),
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
                    child: const Text('My Account'),
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
                        'Dorm',
                        'Building',
                        'Food',
                        'Courses',
                        'Life hack',
                        'etc',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
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
                    child: const Text('Register'),
                  ),
                ],
              ),

              // Review cards
              ListView.builder(
                itemCount: filteredReviews.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final review = filteredReviews[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Title
                              Expanded(
                                child: Text(
                                  review['title'],
                                  style: const TextStyle(
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
                                    onPressed: () {
                                      // Navigate to the review update screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReviewUpdateScreen(
                                            reviewId: review['id'],
                                            // Pass other review data if needed
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      // Delete action
                                      setState(() {
                                        filteredReviews.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Nation, Author, and Category
                          Text('Nation: ${review['nation']}'),
                          Text('Author: ${review['author']}'),
                          Text('Category: ${review['category']}'),
                          Text('Date: ${review['date']}'),
                          const SizedBox(height: 8),
                          // Score
                          Row(
                            children: [
                              const Text('Score: '),
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Text(review['score'].toString()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Detail
                          Text('Detail: ${review['detail']}'),
                          const SizedBox(height: 12),
                          // Image slider
                          SizedBox(
                            height: 150,
                            child: PageView.builder(
                              itemCount: review['images'].length,
                              itemBuilder: (context, imageIndex) {
                                return Image.network(
                                  review['images'][imageIndex],
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // 좋아요/싫어요 버튼
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
