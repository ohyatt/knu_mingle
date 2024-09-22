import 'package:flutter/material.dart';
import 'package:knumingle/constants/url.dart';
import 'package:knumingle/screens/login_screen.dart'; // main.dart 파일을 import
import 'package:knumingle/screens/myinfo_screen.dart'; // My Info 화면 import
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 추가
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지 추가
import 'dart:convert'; // JSON 처리용

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account',
            style: TextStyle(fontFamily: 'ggsansBold')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로로 가운데 정렬
          crossAxisAlignment: CrossAxisAlignment.stretch, // 버튼을 가로로 늘림
          children: [
            ElevatedButton(
              onPressed: () {
                // My Information 버튼 액션
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyInfoPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0), // 세로 길이를 늘림
                backgroundColor: Colors.grey[200], // 배경색을 약간 밝은 회색으로
              ),
              child: const Text(
                'My Information',
                style: TextStyle(
                  fontFamily: 'ggsansBold',
                  color: Colors.black, // 검은색 글자
                ),
              ),
            ),
            const SizedBox(height: 16), // 버튼 간 간격
            ElevatedButton(
              onPressed: () {
                // Logout 버튼 액션: 로그아웃 확인 모달
                _showLogoutConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20.0), // 세로 길이
                backgroundColor: Colors.black, // 버튼 배경을 검은색으로 설정
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'ggsansBold',
                  color: Colors.white, // 하얀색 글자
                ),
              ),
            ),
            const SizedBox(height: 16), // 버튼 간 간격
            ElevatedButton(
              onPressed: () {
                // Delete Account 버튼 액션: 계정 삭제 확인 모달
                _showDeleteAccountConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20.0), // 세로 길이
                backgroundColor: Colors.red, // 버튼 배경을 빨간색으로 설정
              ),
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  fontFamily: 'ggsansBold',
                  color: Colors.white, // 하얀색 글자
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // OK 버튼 클릭 시 로컬 스토리지에서 삭제
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('userId');
                await prefs.remove('token');

                // 로그인 화면으로 이동
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false, // 이전 화면을 모두 제거
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account Confirmation'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('token');

                if (token != null) {
                  // DELETE 요청 보내기
                  final response = await http.put(
                    Uri.parse('$ApiAddress/auth'), // API URL
                    headers: {
                      'Authorization': 'Bearer $token',
                    },
                  );

                  if (response.statusCode == 200) {
                    // 계정 삭제 성공
                    await prefs.remove('userId');
                    await prefs.remove('token');

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false, // 이전 화면을 모두 제거
                    );
                  } else {
                    print(response.statusCode);
                    // 계정 삭제 실패 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to delete account.')),
                    );
                  }
                } else {
                  // 토큰이 없을 경우 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No valid session found.')),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
