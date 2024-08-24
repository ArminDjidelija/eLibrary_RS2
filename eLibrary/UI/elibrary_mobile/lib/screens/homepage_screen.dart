import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/providers/citaoci_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_autori_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/screens/knjiga_screen.dart';
import 'package:elibrary_mobile/screens/napredna_pretraga_knjige_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
    try {
      var knjige = await citaociProvider.getRecommended();
      pozajmiceResult = await pozajmicaProvider.get(
          retrieveAll: true,
          includeTables: "BibliotekaKnjiga",
          orderBy: 'PreporuceniDatumVracanja',
          sortDirection: 'Ascending',
          filter: {'vraceno': false, 'citalacId': AuthProvider.citalacId});

      knjigaList = knjige;
      pozajmicaList = pozajmiceResult!.resultList;
    } on Exception catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Greška",
          text: e.toString());
    }

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

  final TextEditingController _naslovEditingController =
      TextEditingController();

  Widget _buildAppBarHeader() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _naslovEditingController,
              decoration: const InputDecoration(
                hintText: 'Pretraži eLibrary',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
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
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
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
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
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
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  margin: const EdgeInsets.all(8),
                  width: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 240,
                        height: 260,
                        child: imageFromString(e.slika!),
                      ),
                      Text(
                        e.naslov!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      FutureBuilder<List<String>>(
                        future: _getAutoriKnjiga(e.knjigaId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('Nema podataka'));
                          } else {
                            final data = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                data.join(", "),
                                style: const TextStyle(fontSize: 14),
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
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: pozajmicaList.map((e) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3, // Adjust flex to control the width ratio
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<Knjiga>(
                            future: _getKnjiga(e.bibliotekaKnjiga!.knjigaId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return const Center(
                                    child: Text('Nema naslova'));
                              } else {
                                final data = snapshot.data!;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    "${data.naslov},",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            },
                          ),
                          FutureBuilder<List<String>>(
                            future:
                                _getAutoriKnjiga(e.bibliotekaKnjiga!.knjigaId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(child: Text('Nema autora'));
                              } else {
                                final data = snapshot.data!;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    data.join(", "),
                                    style: const TextStyle(
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
                  ),
                  Expanded(
                    flex: 2, // Adjust flex to control the width ratio
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FutureBuilder<int?>(
                            future:
                                _calculateDaysLeft(e.preporuceniDatumVracanja!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData) {
                                return const Center(
                                    child: Text('Nema podataka',
                                        textAlign: TextAlign.right));
                              } else {
                                final daysLeft = snapshot.data!;
                                if (daysLeft > 0) {
                                  return Text('Još $daysLeft dana',
                                      textAlign: TextAlign.right);
                                } else {
                                  return const Text('Vratite knjigu!',
                                      textAlign: TextAlign.right);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget _buildTrenutnePozajmice() {
  //   return Container(
  //     width: double.infinity,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.vertical,
  //       child: Container(
  //         child: Column(
  //           children: pozajmicaList
  //               .map((e) => Container(
  //                     decoration: const BoxDecoration(
  //                         border: Border(
  //                       top: BorderSide(color: Colors.black),
  //                     )),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               FutureBuilder<Knjiga>(
  //                                 future:
  //                                     _getKnjiga(e.bibliotekaKnjiga!.knjigaId!),
  //                                 builder: (context, snapshot) {
  //                                   if (snapshot.connectionState ==
  //                                       ConnectionState.waiting) {
  //                                     return const Center(
  //                                         child: CircularProgressIndicator());
  //                                   } else if (snapshot.hasError) {
  //                                     return Center(
  //                                         child:
  //                                             Text('Error: ${snapshot.error}'));
  //                                   } else if (!snapshot.hasData ||
  //                                       snapshot.data == null) {
  //                                     return const Center(
  //                                         child: Text('Nema naslova'));
  //                                   } else {
  //                                     final data = snapshot.data!;
  //                                     return Padding(
  //                                       padding:
  //                                           const EdgeInsets.only(bottom: 8.0),
  //                                       child: Text(
  //                                         "${data.naslov},",
  //                                         style: const TextStyle(
  //                                             fontSize: 18,
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                     );
  //                                   }
  //                                 },
  //                               ),
  //                               FutureBuilder<List<String>>(
  //                                 future: _getAutoriKnjiga(
  //                                     e.bibliotekaKnjiga!.knjigaId!),
  //                                 builder: (context, snapshot) {
  //                                   if (snapshot.connectionState ==
  //                                       ConnectionState.waiting) {
  //                                     return const Center(
  //                                         child: CircularProgressIndicator());
  //                                   } else if (snapshot.hasError) {
  //                                     return Center(
  //                                         child:
  //                                             Text('Error: ${snapshot.error}'));
  //                                   } else if (!snapshot.hasData ||
  //                                       snapshot.data!.isEmpty) {
  //                                     return const Center(
  //                                         child: Text('Nema autora'));
  //                                   } else {
  //                                     final data = snapshot.data!;
  //                                     return Padding(
  //                                       padding:
  //                                           const EdgeInsets.only(bottom: 8.0),
  //                                       child: Text(
  //                                         data.join(", "),
  //                                         style: const TextStyle(
  //                                             fontSize: 18,
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                     );
  //                                   }
  //                                 },
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         const Spacer(),
  //                         Flexible(
  //                           child: Container(
  //                             alignment: Alignment.centerRight,
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.end,
  //                               children: [
  //                                 FutureBuilder<int?>(
  //                                   future: _calculateDaysLeft(
  //                                       e.preporuceniDatumVracanja!),
  //                                   builder: (context, snapshot) {
  //                                     if (snapshot.connectionState ==
  //                                         ConnectionState.waiting) {
  //                                       return const Center(
  //                                           child: CircularProgressIndicator());
  //                                     } else if (snapshot.hasError) {
  //                                       return Center(
  //                                           child: Text(
  //                                               'Error: ${snapshot.error}'));
  //                                     } else if (!snapshot.hasData) {
  //                                       return const Center(
  //                                           child: Text(
  //                                         'Nema podataka',
  //                                         textAlign: TextAlign.right,
  //                                       ));
  //                                     } else {
  //                                       final daysLeft = snapshot.data!;
  //                                       if (daysLeft > 0) {
  //                                         return Text('Još $daysLeft dana',
  //                                             textAlign: TextAlign.right);
  //                                       } else {
  //                                         return const Text('Vratite knjigu!',
  //                                             textAlign: TextAlign.right);
  //                                       }
  //                                     }
  //                                   },
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ))
  //               .toList(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<List<String>> _getAutoriKnjiga(int id) async {
    try {
      var knjigaAutori = await knjigaAutoriProvider
          .get(filter: {'knjigaId': id}, includeTables: 'Autor');
      var lista = knjigaAutori.resultList;
      var autori =
          lista.map((e) => "${e.autor!.ime} ${e.autor!.prezime}").toList();
      return autori;
    } on Exception catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Greška",
          text: e.toString());
      return [];
    }
  }

  Future<Knjiga> _getKnjiga(int id) async {
    var knjiga = await knjigaProvider.getById(id);
    return knjiga;
  }

  Future<int?> _calculateDaysLeft(String dateStr) async {
    try {
      final date = DateTime.parse(dateStr);
      final currentDate = DateTime.now();

      final difference = date.difference(currentDate).inDays;
      return difference;
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }
}
