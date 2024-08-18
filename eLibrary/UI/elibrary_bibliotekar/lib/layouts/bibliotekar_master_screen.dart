import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/uloga.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/biblioteke_provider.dart';
import 'package:elibrary_bibliotekar/screens/autori_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_knjige_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_uposleni_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/biblioteke_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/citaoci_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/clanarine_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/izdavaci_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/knjige_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/korisnici_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/korisnik_profile_screen.dart';
import 'package:elibrary_bibliotekar/screens/obavijesti_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/pozajmice_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/rezervacije_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/tip_clanarine_biblioteka_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/upiti_list_screen.dart';
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
              width: 250,
              color: Colors.blue,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              title: const Text(
                                "Nazad",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
                                    builder: (context) =>
                                        const KnjigeListScreen()));
                              },
                            ),
                            if (AuthProvider.korisnikUloge!.any((x) =>
                                x.uloga?.naziv == "Bibliotekar" ||
                                x.uloga?.naziv == "Menadzer"))
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
                                          const BibliotekaKnjigeListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!.any((x) =>
                                x.uloga?.naziv == "Bibliotekar" ||
                                x.uloga?.naziv == "Menadzer"))
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
                                      builder: (context) =>
                                          const AutoriListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!.any((x) =>
                                x.uloga?.naziv == "Bibliotekar" ||
                                x.uloga?.naziv == "Menadzer"))
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
                                      builder: (context) =>
                                          const IzdavaciListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!
                                .any((x) => x.uloga?.naziv == "Menadzer"))
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
                                          const TipClanarineBibliotekaListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!
                                .any((x) => x.uloga?.naziv == "Menadzer"))
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
                                      builder: (context) =>
                                          const ClanarineListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!
                                .any((x) => x.uloga?.naziv == "Menadzer"))
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
                                      builder: (context) =>
                                          const UplateListScreen()));
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
                                    builder: (context) =>
                                        const CitaociListScreen()));
                              },
                            ),
                            if (AuthProvider.korisnikUloge!.any((x) =>
                                x.uloga?.naziv == "Bibliotekar" ||
                                x.uloga?.naziv == "Menadzer"))
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
                                      builder: (context) =>
                                          const PozajmiceListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!.any((x) =>
                                x.uloga?.naziv == "Bibliotekar" ||
                                x.uloga?.naziv == "Menadzer"))
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
                                      builder: (context) =>
                                          const RezervacijeListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!
                                .any((x) => x.uloga?.naziv == "Administrator"))
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
                                      builder: (context) =>
                                          const BibliotekeListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!
                                .any((x) => x.uloga?.naziv == "Administrator"))
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
                                      builder: (context) =>
                                          const KorisniciListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!.any((x) =>
                                x.uloga?.naziv == "Bibliotekar" ||
                                x.uloga?.naziv == "Menadzer"))
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
                                      builder: (context) =>
                                          const ObavijestiListScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!
                                .any((x) => x.uloga?.naziv == "Menadzer"))
                              ListTile(
                                leading: const Icon(
                                  Icons.work,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Uposleni",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const BibliotekaUposleniListScreen()));
                                },
                              ),
                            ListTile(
                              leading: const Icon(
                                Icons.person_4,
                                color: Colors.white,
                              ),
                              title: const Text(
                                "Korisnički profil",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        KorisnikProfileScreen()));
                              },
                            ),
                            if (AuthProvider.korisnikUloge!
                                .any((x) => x.uloga?.naziv == "Menadzer"))
                              ListTile(
                                leading: const Icon(
                                  Icons.house,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Moja biblioteka",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () async {
                                  var biblioteka =
                                      await getById(AuthProvider.bibliotekaId!);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          BibliotekaDetailsScreen(
                                            biblioteka: biblioteka,
                                          )));
                                },
                              ),
                            if (AuthProvider.korisnikUloge!
                                .any((x) => x.uloga?.naziv == "Administrator"))
                              ListTile(
                                leading: const Icon(
                                  Icons.question_answer,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Upiti",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UpitiListScreen()));
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  Future<Biblioteka> getById(int id) async {
    var provider = new BibliotekeProvider();
    var biblioteka = provider.getById(id);
    return biblioteka;
  }
}
