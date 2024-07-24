import 'package:elibrary_bibliotekar/screens/clanarine_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/knjige_list_screen.dart';
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
                        leading: Icon(
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
