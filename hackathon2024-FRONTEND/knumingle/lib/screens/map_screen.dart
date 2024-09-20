import 'package:flutter/material.dart';
import 'package:knumingle/components/underbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController; // GoogleMap 컨트롤러
  Location location = Location(); // 현재 위치를 가져오기 위한 Location 인스턴스

  // 초기 위치 설정
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(35.888836, 128.6102997),
    zoom: 15,
  );

  // 현재 위치로 카메라 이동하는 함수
  Future<void> goToCurrentLocation() async {
    // 위치 서비스가 활성화되어 있는지 확인
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // 서비스가 꺼져 있으면 종료
      }
    }

    // 권한 확인
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // 권한이 없으면 종료
      }
    }

    // 현재 위치 가져오기
    LocationData currentLocation = await location.getLocation();

    // 카메라를 현재 위치로 이동
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            ),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Map', style: TextStyle(fontFamily: 'ggsansBold')),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
        ],
      ),
      bottomNavigationBar: UnderBar(parentContext: context),
    );
  }
}
