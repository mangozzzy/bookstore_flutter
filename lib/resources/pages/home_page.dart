import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/books_widget.dart';
import 'package:flutter_app/resources/widgets/detailed_search_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'profile_page.dart';

class HomePage extends NyStatefulWidget {
  static RouteView path = ("/home", (_) => HomePage());
  
  HomePage({super.key}) : super(child: () => _HomePageState());
}

class _HomePageState extends NyPage<HomePage> {
  int _selectedIndex = 0;

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return Books();
      case 1:
        return DetailedSearch();
      case 2:
        return ProfilePage();
      default:
        return Books();
    }
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '도서몰',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '고급검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내정보',
          ),
        ],
      ),
    );
  }
}
