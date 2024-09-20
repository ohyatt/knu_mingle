import 'package:flutter/material.dart';
import 'package:knumingle/screens/reusedmarket_screen.dart';
import 'package:knumingle/screens/map_screen.dart';
import 'package:knumingle/screens/review_screen.dart';

class UnderBar extends StatefulWidget {
  final BuildContext parentContext;
  const UnderBar({Key? key, required this.parentContext}) : super(key: key);

  @override
  _UnderBarState createState() => _UnderBarState();
}

class _UnderBarState extends State<UnderBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _setCurrentIndex();
  }

  void _setCurrentIndex() {
    String currentRoute =
        ModalRoute.of(widget.parentContext)?.settings.name ?? '';
    switch (currentRoute) {
      case '/review':
        _currentIndex = 0;
        break;
      case '/reusedmarket':
        _currentIndex = 1;
        break;
      case '/map':
        _currentIndex = 2;
        break;
      default:
        _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.red, // 선택된 아이템의 색상
      unselectedItemColor: Colors.grey, // 선택되지 않은 아이템의 색상
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });

        String currentRoute =
            ModalRoute.of(widget.parentContext)!.settings.name ?? '';

        switch (index) {
          case 0:
            if (currentRoute != '/review') {
              Navigator.pushReplacement(
                widget.parentContext,
                MaterialPageRoute(
                  builder: (context) => ReviewPage(),
                  settings: const RouteSettings(name: '/review'),
                ),
              );
            }
            break;
          case 1:
            if (currentRoute != '/reusedmarket') {
              Navigator.pushReplacement(
                widget.parentContext,
                MaterialPageRoute(
                  builder: (context) => const ReusedMarketPage(),
                  settings: const RouteSettings(name: '/reusedmarket'),
                ),
              );
            }
            break;
          case 2:
            if (currentRoute != '/map') {
              Navigator.pushReplacement(
                widget.parentContext,
                MaterialPageRoute(
                  builder: (context) => const MapPage(),
                  settings: const RouteSettings(name: '/map'),
                ),
              );
            }
            break;
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.preview,
            color:
                _currentIndex == 0 ? Colors.red : Colors.grey, // 리뷰 페이지일 때 빨간색
          ),
          label: 'Review',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            color: _currentIndex == 1
                ? Colors.red
                : Colors.grey, // Reused Market 페이지일 때 빨간색
          ),
          label: 'Market',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map,
            color:
                _currentIndex == 2 ? Colors.red : Colors.grey, // Map 페이지일 때 빨간색
          ),
          label: 'Map',
        ),
      ],
    );
  }
}
