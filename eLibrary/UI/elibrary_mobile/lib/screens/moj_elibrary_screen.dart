import 'package:elibrary_mobile/screens/citalac_profil_screen.dart';
import 'package:elibrary_mobile/screens/obavijesti_list_screen.dart';
import 'package:elibrary_mobile/screens/penali_citalac_screen.dart';
import 'package:elibrary_mobile/screens/prijavi_gresku_citalac_screen.dart';
import 'package:elibrary_mobile/screens/sacuvane_knjige_citalac_screen.dart';
import 'package:flutter/material.dart';

class MojElibraryScreen extends StatefulWidget {
  const MojElibraryScreen({super.key});

  @override
  State<MojElibraryScreen> createState() => _MojElibraryScreenState();
}

class _MojElibraryScreenState extends State<MojElibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBarHeader(),
        Expanded(
          child: _buildPage(),
        ),
      ],
    );
  }

  Widget _buildAppBarHeader() {
    return Container(
      // color: Colors.blue,
      // margin: EdgeInsets.only(bottom: 5),
      height: 75,
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: const Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Moj eLibrary",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _baseMojSettingsRow(
              "Profil", Icons.euro, const CitalacProfilScreen()),
          _baseMojSettingsRow(
              "Penali", Icons.money_outlined, PenaliCitalacScreen()),
          _baseMojSettingsRow("Sačuvane knjige", Icons.bookmark_outline,
              const SacuvaneKnjigeCitalacScreen()),
          _baseMojSettingsRow("Obavijesti", Icons.notifications_outlined,
              const ObavijestiScreen()),
          _baseMojSettingsRow(
              "Prijavi grešku", Icons.error, const GreskaCitalacScreen()),
        ],
      ),
    );
  }

  Widget _baseMojSettingsRow(String naslov, IconData ikonica, Widget next) {
    return InkWell(
      onTap: () => {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => next))
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(ikonica),
              const SizedBox(
                width: 8,
              ),
              Text(
                naslov,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
