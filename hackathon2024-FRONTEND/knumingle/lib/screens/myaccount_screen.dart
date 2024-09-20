import 'package:flutter/material.dart';
import 'package:knumingle/screens/login_screen.dart'; // main.dart 파일을 import
import 'myinfo_screen.dart'; // My Info 화면 import

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
                // Logout 버튼 액션: 메인으로 돌아가기
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false, // 이전 화면을 모두 제거
                );
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
                // Delete Account 버튼 액션
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
}
