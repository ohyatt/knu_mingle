import 'package:flutter/material.dart';
import 'package:knumingle/components/underbar.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Map'),
      ),
      body: Center(
        child: const Text('Map Page'),
      ),
      bottomNavigationBar: UnderBar(parentContext: context),
    );
  }
}
