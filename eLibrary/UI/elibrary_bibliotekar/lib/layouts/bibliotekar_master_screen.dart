import 'package:elibrary_bibliotekar/screens/autori_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_knjige_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/biblioteke_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/citaoci_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/clanarine_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/izdavaci_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/knjige_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/korisnici_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/obavijesti_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/pozajmice_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/rezervacije_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/tip_clanarine_biblioteka_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/uplate_list_screen.dart';
import 'package:flutter/material.dart';

class BibliotekarMasterScreen extends StatefulWidget {
  BibliotekarMasterScreen(this.title, this.child, {super.key});
  String title;
  Widget child;

  @override
  State<BibliotekarMasterScreen> createState() =>
      _BibliotekarMasterScreenState();
}

class _BibliotekarMasterScreenState extends State<BibliotekarMasterScreen> {
  bool _drawerOpen = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkScreenWidth();
  }

  void _checkScreenWidth() {
    if (MediaQuery.of(context).size.width < 500) {
      setState(() {
        _drawerOpen = false;
      });
    }
  }

  void _toggleDrawer() {
    setState(() {
      _drawerOpen = !_drawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkScreenWidth();

    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: _drawerOpen ? 250 : 0,
            color: Colors.blue,
            child: _drawerOpen
                ? Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Nazad",
                          style: TextStyle(
                            color: Colors.white, // Promijenite boju teksta
                            fontSize: 18, // Promijenite veličinu teksta
                            fontWeight:
                                FontWeight.bold, // Promijenite stil fonta
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.book_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Knjige",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => KnjigeListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.menu_book,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Biblioteka knjige",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  BibliotekaKnjigeListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person_4_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Autori",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AutoriListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.apartment,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Izdavači",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IzdavaciListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.card_membership_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Tipovi članarina",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  TipClanarineBibliotekaListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.credit_card,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Članarine",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ClanarineListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.attach_money_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Uplate",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UplateListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person_2_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Čitaoci",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CitaociListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.loyalty_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Pozajmice",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PozajmiceListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.lock_clock_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Rezervacije",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RezervacijeListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.apartment,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Biblioteke",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BibliotekeListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Korisnici",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => KorisniciListScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Obavijesti",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ObavijestiListScreen()));
                        },
                      ),
                    ],
                  )
                : null,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(_drawerOpen ? Icons.close : Icons.menu),
                      onPressed: _toggleDrawer,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
