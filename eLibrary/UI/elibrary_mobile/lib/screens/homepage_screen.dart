import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:elibrary_mobile/layouts/base_mobile_screen.dart';
import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/knjiga_autor.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/providers/citaoci_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_autori_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_vrste_sadrzaja_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/screens/knjiga_screen.dart';
import 'package:elibrary_mobile/screens/napredna_pretraga_knjige_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late KnjigaProvider knjigaProvider;
  late PozajmiceProvider pozajmicaProvider;
  late KnjigaAutoriProvider knjigaAutoriProvider;
  late CitaociProvider citaociProvider;

  SearchResult<Knjiga>? knjigeResult;
  SearchResult<Pozajmica>? pozajmiceResult;

  List<Knjiga> knjigaList = [];
  List<Pozajmica> pozajmicaList = [];

  @override
  void initState() {
    super.initState();

    knjigaProvider = context.read<KnjigaProvider>();
    pozajmicaProvider = context.read<PozajmiceProvider>();
    knjigaAutoriProvider = context.read<KnjigaAutoriProvider>();
    citaociProvider = context.read<CitaociProvider>();

    _initForm();
  }

  Future _initForm() async {
    var knjige = await citaociProvider.getRecommended();
    // knjigeResult = await knjigaProvider.get(
    //     page: 1, pageSize: 10, includeTables: 'Izdavac,Jezik,Uvez');
    pozajmiceResult = await pozajmicaProvider.get(
        retrieveAll: true,
        includeTables: "BibliotekaKnjiga",
        orderBy: 'PreporuceniDatumVracanja',
        sortDirection: 'Ascending',
        filter: {'vraceno': false, 'citalacId': AuthProvider.citalacId});

    // knjigaList = knjigeResult!.resultList;
    knjigaList = knjige;
    pozajmicaList = pozajmiceResult!.resultList;

    setState(() {});
  }

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

  TextEditingController _naslovEditingController = TextEditingController();

  Widget _buildAppBarHeader() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _naslovEditingController,
              decoration: InputDecoration(
                hintText: 'Pretraži eLibrary',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NaprednaPretragaKnjiga(
                        vrstaGradeId: 0,
                        naslov: _naslovEditingController.text,
                      )));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Preporučene knjige",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                _buildPreporuceneKnjige(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vaše pozajmice",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                _buildTrenutnePozajmice()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreporuceneKnjige() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: knjigaList
            .map((e) => InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => KnjigaScreen(
                            knjiga: e,
                          )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  margin: EdgeInsets.all(8),
                  width: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 8),
                      Container(
                        width: 240,
                        height: 260,
                        child: imageFromString(e.slika!),
                      ),
                      Text(
                        e.naslov!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      FutureBuilder<List<String>>(
                        future: _getAutoriKnjiga(e.knjigaId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data found'));
                          } else {
                            final data = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                data.join(", "),
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )))
            .toList(),
      ),
    );
  }

  Widget _buildTrenutnePozajmice() {
    return Container(
      width: double
          .infinity, // This will make the container take the full width of the screen
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          // decoration: BoxDecoration(
          //     border: Border(
          //   top: BorderSide(color: Colors.black),
          // )),
          child: Column(
            children: pozajmicaList
                .map((e) => Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Colors.black),
                      )),
                      child: Row(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<Knjiga>(
                                  future:
                                      _getKnjiga(e.bibliotekaKnjiga!.knjigaId!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return Center(
                                          child: Text('Nema naslova'));
                                    } else {
                                      final data = snapshot.data!;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          "${data.naslov},",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                FutureBuilder<List<String>>(
                                  future: _getAutoriKnjiga(
                                      e.bibliotekaKnjiga!.knjigaId!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(child: Text('Nema autora'));
                                    } else {
                                      final data = snapshot.data!;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          data.join(", "),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Flexible(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FutureBuilder<int?>(
                                    future: _calculateDaysLeft(
                                        e.preporuceniDatumVracanja!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData) {
                                        return Center(
                                            child: Text(
                                          'Nema podataka',
                                          textAlign: TextAlign.right,
                                        ));
                                      } else {
                                        final daysLeft = snapshot.data!;
                                        if (daysLeft > 0) {
                                          return Text('Još $daysLeft dana',
                                              textAlign: TextAlign.right);
                                        } else {
                                          return Text('Vratite knjigu!',
                                              textAlign: TextAlign.right);
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<List<String>> _getAutoriKnjiga(int id) async {
    var knjigaAutori = await knjigaAutoriProvider
        .get(filter: {'knjigaId': id}, includeTables: 'Autor');
    var lista = knjigaAutori.resultList;
    var autori =
        lista.map((e) => "${e.autor!.ime} ${e.autor!.prezime}").toList();
    return autori;
  }

  Future<Knjiga> _getKnjiga(int id) async {
    var knjiga = await knjigaProvider.getById(id);
    return knjiga;
  }

  // Function to calculate days left
  Future<int?> _calculateDaysLeft(String dateStr) async {
    try {
      // Parse the ISO 8601 date string into a DateTime object
      final date = DateTime.parse(dateStr);
      final currentDate = DateTime.now();

      // Calculate the difference in days
      final difference = date.difference(currentDate).inDays;
      return difference;
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }
}
