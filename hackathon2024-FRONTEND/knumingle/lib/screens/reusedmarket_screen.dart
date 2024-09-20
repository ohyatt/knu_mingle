import 'package:flutter/material.dart';
import 'package:knumingle/components/underbar.dart';
import 'package:knumingle/screens/myaccount_screen.dart';
import 'reusedmarketregister_screen.dart'; // ReusedMarketRegisterScreen을 불러옴
import 'reusedmarketdetail_screen.dart'; // ReusedMarketDetailScreen을 불러옴

class ReusedMarketPage extends StatefulWidget {
  const ReusedMarketPage({super.key});

  @override
  _ReusedMarketPageState createState() => _ReusedMarketPageState();
}

class _ReusedMarketPageState extends State<ReusedMarketPage> {
  // 게시판 아이템 데이터
  final List<Map<String, String>> items = [
    {
      'id': '1',
      'title': 'Used Bicycle for Sale',
      'author': 'John Doe',
      'nation': 'USA'
    },
    {
      'id': '2',
      'title': 'Second-hand Laptop',
      'author': 'Jane Smith',
      'nation': 'Canada'
    },
    {
      'id': '3',
      'title': 'Furniture Giveaway',
      'author': 'Alex Johnson',
      'nation': 'UK'
    },
    {
      'id': '4',
      'title': 'Old Textbooks',
      'author': 'Chris Lee',
      'nation': 'South Korea'
    },
    {
      'id': '5',
      'title': 'Affordable Guitar',
      'author': 'Emma Williams',
      'nation': 'Australia'
    },
  ];

  String? selectedNation;

  @override
  Widget build(BuildContext context) {
    // 선택된 Nation에 따라 필터링된 아이템을 보여줌
    List<Map<String, String>> filteredItems = selectedNation == null
        ? items
        : items.where((item) => item['nation'] == selectedNation).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Market'),
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // My Account 버튼 클릭 시 동작
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

            // Nation 드롭다운 및 Register 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('Nation'),
                    value: selectedNation,
                    items: <String>[
                      'USA',
                      'Canada',
                      'UK',
                      'South Korea',
                      'Australia'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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
                    // Register 버튼 클릭 시 ReusedMarketRegisterScreen으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ReusedMarketRegisterScreen(),
                      ),
                    );
                  },
                  child: const Text('Register'),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Author',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Nation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),

            // 게시판 목록 (리스트뷰)
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // 해당 게시물 클릭 시 ReusedMarketDetailScreen으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReusedMarketDetailScreen(
                            itemId: filteredItems[index]['id']!,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(filteredItems[index]['id'] ?? ''),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(filteredItems[index]['title'] ?? ''),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(filteredItems[index]['author'] ?? ''),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(filteredItems[index]['nation'] ?? ''),
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
