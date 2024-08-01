import 'package:elibrary_mobile/layouts/persistent_bottom_bar_scaffold.dart';
import 'package:elibrary_mobile/screens/homepage_screen.dart';
import 'package:elibrary_mobile/screens/knjige_list_screen.dart';
import 'package:elibrary_mobile/screens/pocetna_knjiga_pretraga_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();
  final _tab4navigatorKey = GlobalKey<NavigatorState>();
  final _tab5navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: HomepageScreen(),
          icon: Icons.home,
          title: 'Početna',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: PocetnaKnjigaPretragaScreen(),
          icon: Icons.search,
          title: 'Pretraga',
          navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab: PocetnaKnjigaPretragaScreen(),
          icon: Icons.calendar_month,
          title: 'Pozajmice',
          navigatorkey: _tab3navigatorKey,
        ),
        PersistentTabItem(
          tab: PocetnaKnjigaPretragaScreen(),
          icon: Icons.person,
          title: 'Profil',
          navigatorkey: _tab4navigatorKey,
        ),
        PersistentTabItem(
          tab: PocetnaKnjigaPretragaScreen(),
          icon: Icons.menu,
          title: 'Moj eLibrary',
          navigatorkey: _tab5navigatorKey,
        ),
      ],
    );
  }
}
