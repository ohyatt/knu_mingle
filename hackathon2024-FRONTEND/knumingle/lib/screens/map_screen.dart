import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:knumingle/components/underbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:knumingle/constants/url.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController; // GoogleMap 컨트롤러
  Location location = Location(); // 현재 위치를 가져오기 위한 Location 인스턴스
  List<Map<String, dynamic>> _locations = [];

  // 초기 위치 설정
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(35.888836, 128.6102997),
    zoom: 12,
  );

  // 마커를 저장할 변수
  final Set<Marker> _markers = {};

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
  void initState() {
    super.initState();
    _fetchLocations(); // API에서 위치 데이터 가져오기
  }

  // API에서 위치 데이터를 가져오는 함수
  Future<void> _fetchLocations() async {
    final response = await http.get(Uri.parse('${ApiAddress}/maps'));

    if (response.statusCode == 200) {
      // 성공적으로 데이터 받아오기
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _locations = data.map((item) => item as Map<String, dynamic>).toList();
        _addMarkers(); // 마커 추가
      });
      print(data);
    } else {
      // 에러 처리
      throw Exception('Failed to load locations');
    }
  }

  // 위치 데이터를 기반으로 마커 추가
  void _addMarkers() {
    for (var location in _locations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location['id'].toString()), // 고유 ID 사용
          position: LatLng(location['latitude'], location['longitude']),
          infoWindow: InfoWindow(
            title: location['name'],
            snippet: location['address'], // 필요에 따라 다른 정보를 추가
          ),
          onTap: () {
            _showMarkerInfo(context, location);
          },
        ),
      );
    }
  }

  // 마커 정보를 보여주는 함수
  void _showMarkerInfo(BuildContext context, Map<String, dynamic> location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(location['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address: ${location['address']}'),
              Text('Type: ${location['sector']}'),
              Text('Phone Number: ${location['phoneNumber']}'),
              Text('Language: ${location['language']}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 정보 모달을 보여주는 함수
  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information'),
          content: Text(
            "This map provides a lot of information.\n"
            "It introduces hospitals, restaurants, and good facilities.\n"
            "Press the marker to check out various information and visit!",
          ),
          actions: [
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('en'), // 앱의 언어를 영어로 설정
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map', style: TextStyle(fontFamily: 'ggsansBold')),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => _showInfoModal(context),
            ),
          ],
        ),
        body: Stack(
          children: [
            // 빨간색 배경을 가진 Container
            Container(
              color: Colors.red,
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                markers: _markers,
              ),
            ),
          ],
        ),
        bottomNavigationBar: UnderBar(parentContext: context),
      ),
    );
  }
}
