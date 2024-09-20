import 'package:flutter/material.dart';
import 'package:knumingle/components/underbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Map'),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.50508097213444, 126.95493073306663),
            zoom: 18,
          ),
        ),
      ),
      bottomNavigationBar: UnderBar(parentContext: context),
    );
  }
}
