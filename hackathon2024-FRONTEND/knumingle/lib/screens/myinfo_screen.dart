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

  bool isEditable = false; // 필드의 입력 가능 여부를 제어하는 변수
  bool isUpdateEnabled = false; // Update 버튼 활성화 여부

  // 모든 입력란이 채워졌는지 확인하는 함수
  void checkIfAllFieldsFilled() {
    setState(() {
      // 모든 필드가 비어있지 않으면 Update 버튼을 활성화
      isUpdateEnabled = firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          nationController.text.isNotEmpty &&
          emailController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    // 입력 필드 값이 변경될 때마다 확인
    firstNameController.addListener(checkIfAllFieldsFilled);
    lastNameController.addListener(checkIfAllFieldsFilled);
    nationController.addListener(checkIfAllFieldsFilled);
    emailController.addListener(checkIfAllFieldsFilled);
  }

  @override
  void dispose() {
    // 리스너 해제
    firstNameController.dispose();
    lastNameController.dispose();
    nationController.dispose();
    emailController.dispose();
    super.dispose();
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
                // Edit 버튼 클릭 시 입력 가능 여부를 토글
                isEditable = !isEditable;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // 버튼 배경색 검은색
            ),
            child: const Text(
              'Edit', // 항상 Edit 버튼만 표시
              style: TextStyle(
                color: Colors.white, // 글자색은 하얀색
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
              enabled: false, // Email 필드는 항상 비활성화 상태
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              enabled: isEditable, // Edit 모드에서만 활성화
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
              enabled: isEditable, // Edit 모드에서만 활성화
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(fontFamily: 'ggsansBold'),
              controller: nationController,
              decoration: const InputDecoration(
                labelText: 'Nation',
                border: OutlineInputBorder(),
              ),
              enabled: isEditable, // Edit 모드에서만 활성화
            ),
            const Spacer(), // 아래쪽 버튼을 맨 밑으로 내림
            ElevatedButton(
              onPressed: isUpdateEnabled
                  ? () {
                      // Update 버튼 액션: 입력된 값으로 계정 정보 업데이트 로직 추가
                    }
                  : null, // 모든 필드가 채워져 있지 않으면 버튼 비활성화
              style: ElevatedButton.styleFrom(
                backgroundColor: isUpdateEnabled
                    ? Colors.blue
                    : Colors.grey, // 활성화 여부에 따른 색상 변화
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
