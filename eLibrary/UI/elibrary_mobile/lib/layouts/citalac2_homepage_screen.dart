import 'package:elibrary_mobile/screens/homepage_screen.dart';
import 'package:elibrary_mobile/screens/knjige_list_screen.dart';
import 'package:elibrary_mobile/screens/pocetna_knjiga_pretraga_screen.dart';
import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomepageScreen(),
    PocetnaKnjigaPretragaScreen(),
    KnjigeListScreen(),
    PocetnaKnjigaPretragaScreen(),
    KnjigeListScreen(),
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Pretraga"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Pozajmice"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu), label: "Moj eLibrary"),
        ],
      ),
    );
  }
}
