import 'package:flutter/material.dart';

class ReviewUpdateScreen extends StatelessWidget {
  final int reviewId;

  const ReviewUpdateScreen({super.key, required this.reviewId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 여기에서 reviewId에 맞는 데이터를 로드하고 수정할 수 있는 UI를 구성합니다.
            Text('Updating review with ID: $reviewId'),
            // 예를 들어, 제목, 내용, 점수를 수정할 수 있는 입력 필드 추가
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Detail'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Score'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 수정된 내용을 저장하는 로직 추가
                Navigator.pop(context); // 화면을 닫고 이전 화면으로 돌아가기
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
