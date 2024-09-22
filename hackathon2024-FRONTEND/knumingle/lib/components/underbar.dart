import 'package:flutter/material.dart';
import 'package:knumingle/screens/reusedmarket_screen.dart';
import 'package:knumingle/screens/map_screen.dart';
import 'package:knumingle/screens/review_screen.dart';
import 'package:knumingle/screens/guide_screen.dart'; // Import your Guide Book screen

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
      case '/guidebook': // Add case for Guide Book
        _currentIndex = 3;
        break;
      default:
        _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
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
          case 3: // Handle Guide Book
            if (currentRoute != '/guide') {
              Navigator.pushReplacement(
                widget.parentContext,
                MaterialPageRoute(
                  builder: (context) => GuideScreen(), // Your Guide Book page
                  settings: const RouteSettings(name: '/guidebook'),
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
            color: _currentIndex == 0 ? Colors.red : Colors.grey,
          ),
          label: 'Review',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart,
            color: _currentIndex == 1 ? Colors.red : Colors.grey,
          ),
          label: 'Market',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map,
            color: _currentIndex == 2 ? Colors.red : Colors.grey,
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book, // Icon for Guide Book
            color: _currentIndex == 3 ? Colors.red : Colors.grey,
          ),
          label: 'Guide Book', // Label for Guide Book
        ),
      ],
    );
  }
}
