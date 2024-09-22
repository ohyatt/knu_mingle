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
  final TextEditingController passwordController = TextEditingController();

  String? selectedNation;
  String? selectedFaculty;
  String? selectedGender; // 기본 성별 설정
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
          selectedFaculty != null &&
          passwordController.text.isNotEmpty; // 비밀번호 확인
    });
  }

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(checkIfAllFieldsFilled);
    lastNameController.addListener(checkIfAllFieldsFilled);
    passwordController.addListener(checkIfAllFieldsFilled);
    _fetchUserInfo(); // 사용자 정보 가져오기
    _fetchNations(); // 국가 목록 가져오기
    _fetchFaculties(); // 학부 목록 가져오기
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose(); // 비밀번호 컨트롤러 해제
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

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        emailController.text = data['email'];
        firstNameController.text = data['first_name'];
        lastNameController.text = data['last_name'];
        selectedNation = data['nation'].replaceAll('_', ' ');
        selectedFaculty = data['faculty'].replaceAll('_', ' ');
        selectedGender = data['gender'];
      });
    } else {
      print('Error fetching user info: ${response.statusCode}');
    }
  }

  Future<void> _updateUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? userId = prefs.getString('userId'); // userId 가져오기

    if (token == null || userId == null) {
      print('No token or userId found.');
      return;
    }

    final url = '${ApiAddress}/mypage'; // 사용자 정보 업데이트 API URL

    // 요청 본문 준비
    final requestBody = {
      'id': userId.toString(), // id 추가
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'gender': selectedGender,
      'email': emailController.text,
      'password': passwordController.text,
      'nation': selectedNation!.replaceAll(' ', '_'), // _로 변환
      'faculty': selectedFaculty!.replaceAll(' ', '_'), // _로 변환
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      // 성공적인 업데이트 후 모달로 알림
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('User information updated successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      _fetchUserInfo(); // 최신 정보 가져오기
    } else {
      // 실패 처리
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error updating user info: ${response.statusCode}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
              style: TextStyle(color: Colors.white, fontFamily: 'ggsansBold'),
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

            // 비밀번호 입력란
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // 비밀번호 숨기기
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
            Flexible(
              child: DropdownButtonFormField<String>(
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
                // maxHeight 설정
                isExpanded: true,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),

            // 성별 드롭다운
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: const [
                DropdownMenuItem(value: 'MALE', child: Text('MALE')),
                DropdownMenuItem(value: 'FEMALE', child: Text('FEMALE')),
              ],
              onChanged: isEditable
                  ? (String? newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    }
                  : null,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isUpdateEnabled
                  ? _updateUserInfo // 호출할 함수로 변경
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
