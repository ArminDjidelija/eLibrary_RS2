import 'package:elibrary_mobile/main.dart';
import 'package:elibrary_mobile/screens/citaoci_list_screen.dart';
import 'package:elibrary_mobile/screens/knjige_list_screen.dart';
import 'package:elibrary_mobile/screens/pocetna_knjiga_pretraga_screen.dart';
import 'package:elibrary_mobile/screens/nova_pozajmica_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CitalacMasterScreen extends StatefulWidget {
  CitalacMasterScreen(this.title, this.child, {super.key});
  String title;
  Widget child;

  @override
  State<CitalacMasterScreen> createState() => _CitalacMasterScreenState();
}

class _CitalacMasterScreenState extends State<CitalacMasterScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> body = [
    KnjigeListScreen(),
    PocetnaKnjigaPretragaScreen(),
    Icon(Icons.aspect_ratio),
    Icon(Icons.scale),
    Icon(Icons.r_mobiledata),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: body),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          _onItemTapped(newIndex);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Početna',
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Pretraga',
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Pozajmice',
            icon: Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profil',
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Moj eLibrary',
            icon: Icon(
              Icons.book,
              color: Colors.black,
            ),
          ),
        ],
        selectedItemColor: Colors.black,
      ),
    );
  }
}
