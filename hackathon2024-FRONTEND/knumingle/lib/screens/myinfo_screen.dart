import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knumingle/constants/url.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  String? selectedNation;
  String? selectedFaculty;
  bool isEditable = false;
  bool isUpdateEnabled = false;

  List<String> nations = [];
  List<String> faculties = [];

  // 모든 입력란이 채워졌는지 확인하는 함수
  void checkIfAllFieldsFilled() {
    setState(() {
      isUpdateEnabled = firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          selectedNation != null &&
          selectedFaculty != null;
    });
  }

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(checkIfAllFieldsFilled);
    lastNameController.addListener(checkIfAllFieldsFilled);
    _fetchUserInfo(); // 사용자 정보 가져오기
    _fetchNations(); // 국가 목록 가져오기
    _fetchFaculties(); // 학부 목록 가져오기
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print('No token found.');
      return;
    }

    final url = '${ApiAddress}/mypage'; // 사용자 정보 API URL
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = jsonDecode(response.body);
      setState(() {
        emailController.text = data['email'];
        firstNameController.text = data['first_name'];
        lastNameController.text = data['last_name'];
        selectedNation = data['nation'];
        selectedFaculty = data['faculty'];
      });
    } else {
      print('Error fetching user info: ${response.statusCode}');
    }
  }

  Future<void> _fetchNations() async {
    final url = '${ApiAddress}/lists/nations'; // 국가 목록 API URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        nations = List<String>.from(data);
      });
    } else {
      print('Error fetching nations: ${response.statusCode}');
    }
  }

  Future<void> _fetchFaculties() async {
    final url = '${ApiAddress}/lists/faculties'; // 학부 목록 API URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        faculties = List<String>.from(data);
      });
    } else {
      print('Error fetching faculties: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Information',
            style: TextStyle(fontFamily: 'ggsansBold')),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditable = !isEditable;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'ggsansBold',
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              enabled: isEditable,
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
              enabled: isEditable,
            ),
            const SizedBox(height: 16),

            // Nation 드롭다운
            DropdownButtonFormField<String>(
              value: selectedNation,
              items: nations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: isEditable
                  ? (String? newValue) {
                      setState(() {
                        selectedNation = newValue;
                        checkIfAllFieldsFilled();
                      });
                    }
                  : null,
              decoration: const InputDecoration(
                labelText: 'Nation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Faculty 드롭다운
            DropdownButtonFormField<String>(
              value: selectedFaculty,
              items: faculties.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: isEditable
                  ? (String? newValue) {
                      setState(() {
                        selectedFaculty = newValue;
                        checkIfAllFieldsFilled();
                      });
                    }
                  : null,
              decoration: const InputDecoration(
                labelText: 'Faculty',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isUpdateEnabled
                  ? () {
                      // Update 버튼 액션: 입력된 값으로 계정 정보 업데이트 로직 추가
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isUpdateEnabled ? Colors.blue : Colors.grey,
              ),
              child: const Text(
                'Update',
                style: TextStyle(fontFamily: 'ggsansBold'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
