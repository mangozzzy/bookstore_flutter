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

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Books(),
          DetailedSearch(),
          ProfilePage(),    // 프로필 페이지
        ],
      ),
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
