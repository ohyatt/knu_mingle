import 'package:flutter/material.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nationController,
              decoration: const InputDecoration(
                labelText: 'Nation',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(), // 아래쪽 버튼을 맨 밑으로 내림
            ElevatedButton(
              onPressed: () {
                // Update 버튼 액션: 업데이트 로직 추가
                // 예: 입력된 값으로 계정 정보 업데이트
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
