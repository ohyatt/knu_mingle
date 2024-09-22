import 'package:flutter/material.dart';
import 'package:knumingle/components/underbar.dart';
import 'package:knumingle/constants/url.dart';
import 'package:knumingle/screens/myaccount_screen.dart';
import 'reusedmarketregister_screen.dart';
import 'reusedmarketdetail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReusedMarketPage extends StatefulWidget {
  const ReusedMarketPage({super.key});

  @override
  _ReusedMarketPageState createState() => _ReusedMarketPageState();
}

class _ReusedMarketPageState extends State<ReusedMarketPage> {
  List<Map<String, dynamic>> items = [];
  List<String> nations = []; // Nation 목록을 저장할 리스트
  String? selectedNation = 'All';
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMarketItems(); // 데이터 가져오기
    _fetchNations(); // Nation 목록 가져오기
  }

  Future<void> _fetchMarketItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print('No token found.');
      return;
    }

    final url = '${ApiAddress}/market'; // API URL
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        items = responseData.map((item) {
          return {
            'id': item['id'].toString(),
            'title': item['title'],
            'author':
                '${item['user']['first_name']} ${item['user']['last_name']}',
            'nation': item['user']['nation'].replaceAll('_', ' '),
            'status': item['status']
          };
        }).toList();
      });
    } else {
      print('Error fetching market items: ${response.statusCode}');
    }
  }

  Future<void> _fetchNations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print('No token found.');
      return;
    }

    final url = '${ApiAddress}/lists/nations'; // API URL for nations
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Token 추가
      },
    );

    if (response.statusCode == 200) {
      // API 응답이 문자열 리스트인 경우
      final List<dynamic> responseData = jsonDecode(response.body);
      print(responseData);

      setState(() {
        nations = List<String>.from(responseData); // 문자열 리스트로 변환
        nations.insert(0, 'All'); // "All" 옵션 추가
      });

      print(nations);
    } else {
      print('Error fetching nations: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = items.where((item) {
      final isNationMatch =
          selectedNation == 'All' || item['nation'] == selectedNation;
      final isSearchMatch =
          item['title']?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false;
      return isNationMatch && isSearchMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Market', style: TextStyle(fontFamily: 'ggsansBold')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색 및 My Account 버튼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontFamily: 'ggsansBold'),
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
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

            // Nation 드롭다운 및 Register 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('Nation'),
                    value: selectedNation,
                    items: nations.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          constraints: const BoxConstraints(
                              maxWidth: 150), // Set maxWidth
                          child: Text(
                            value,
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis for overflow
                            maxLines: 1, // Limit to one line
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedNation = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ReusedMarketRegisterScreen(),
                      ),
                    ).then((shouldRefresh) {
                      if (shouldRefresh == true) {
                        setState(() {
                          _fetchMarketItems();
                        });
                      }
                    });
                  },
                  child: const Text('Register',
                      style: TextStyle(fontFamily: 'ggsansBold')),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 게시판 헤더
            Row(
              children: const [
                Expanded(
                  flex: 1,
                  child: Text(
                    'No.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'ggsansBold'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'ggsansBold'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status', // 새 Status 열 추가
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'ggsansBold'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Author',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'ggsansBold'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Nation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'ggsansBold'),
                  ),
                ),
              ],
            ),
            const Divider(),

            // 게시판 목록 (리스트뷰)
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          'No reviews available',
                          style: TextStyle(
                            fontFamily: 'ggsansBold',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReusedMarketDetailScreen(
                                  itemId: filteredItems[index]['id']!,
                                ),
                              ),
                            ).then((shouldRefresh) {
                              if (shouldRefresh == true) {
                                setState(() {
                                  _fetchMarketItems();
                                });
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    filteredItems[index]['id'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: 'ggsansBold'),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    filteredItems[index]['title'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: 'ggsansBold'),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    filteredItems[index]['status'] ??
                                        '', // Status 추가
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: 'ggsansBold'),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    filteredItems[index]['author'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: 'ggsansBold'),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    filteredItems[index]['nation'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: 'ggsansBold'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: UnderBar(parentContext: context),
    );
  }
}
