import 'package:flutter/material.dart';

class ReusedMarketDetailScreen extends StatelessWidget {
  final String itemId;

  const ReusedMarketDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    // 실제로는 itemId를 사용하여 해당 아이템의 상세 정보를 로드해야 합니다.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item ID: $itemId', style: const TextStyle(fontSize: 18)),
            // 여기에서 실제 아이템의 상세 정보를 표시하는 UI를 추가합니다.
            // 예를 들어, 제목, 작성자, 국가 등의 정보를 로드하여 보여줌.
            const SizedBox(height: 20),
            const Text('Details of the item will be shown here.'),
            // 추가적으로 수정, 삭제 버튼 등을 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
