import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/rezervacija.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/biblioteka_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/produzenje_pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/rezervacije_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class PozajmiceCitalacScreen extends StatefulWidget {
  const PozajmiceCitalacScreen({super.key});

  @override
  State<PozajmiceCitalacScreen> createState() => _PozajmiceCitalacScreenState();
}

class _PozajmiceCitalacScreenState extends State<PozajmiceCitalacScreen> {
  late PozajmiceProvider pozajmiceProvider;
  late RezervacijeProvider rezervacijeProvider;
  late KnjigaProvider knjigaProvider;
  late BibliotekaProvider bibliotekaProvider;
  late ProduzenjePozajmiceProvider produzenjePozajmiceProvider;

  SearchResult<Pozajmica>? trenutnePozajmice;
  SearchResult<Pozajmica>? prijasnjePozajmiceResult;
  List<Pozajmica> prijasnjePozajmice = [];

  SearchResult<Rezervacija>? trenutneRezervacije;

  int page = 1;

  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;

  bool isLoadMoreRunning = false;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    pozajmiceProvider = context.read<PozajmiceProvider>();
    rezervacijeProvider = context.read<RezervacijeProvider>();
    knjigaProvider = context.read<KnjigaProvider>();
    bibliotekaProvider = context.read<BibliotekaProvider>();
    produzenjePozajmiceProvider = context.read<ProduzenjePozajmiceProvider>();

    _firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);

    _initForm();
  }

  Future _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      prijasnjePozajmice = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    prijasnjePozajmiceResult = await pozajmiceProvider.get(
        page: page,
        pageSize: 10,
        orderBy: 'StvarniDatumVracanja',
        sortDirection: 'descending',
        filter: {'vraceno': true, 'citalacId': AuthProvider.citalacId},
        includeTables: 'BibliotekaKnjiga');

    if (prijasnjePozajmiceResult != null) {
      prijasnjePozajmice = prijasnjePozajmiceResult!.resultList;
      total = prijasnjePozajmiceResult!.count;
    }

    setState(() {
      isFirstLoadRunning = false;
      total = prijasnjePozajmiceResult!.count;
      if (10 * page > total) {
        hasNextPage = false;
      }
    });
  }

  void _loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 300) {
      setState(() {
        isLoadMoreRunning = true;
      });
      if (!hasNextPage) {
        return;
      }
      page += 1;

      prijasnjePozajmiceResult = await pozajmiceProvider.get(
          page: page,
          pageSize: 10,
          orderBy: 'StvarniDatumVracanja',
          sortDirection: 'descending',
          filter: {'vraceno': true, 'citalacId': AuthProvider.citalacId},
          includeTables: 'BibliotekaKnjiga');

      if (prijasnjePozajmiceResult!.resultList.isNotEmpty) {
        prijasnjePozajmice.addAll(prijasnjePozajmiceResult!.resultList);
      } else {
        setState(() {
          hasNextPage = false;
        });
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  Future _initForm() async {
    await _getPrijasnjePozajmice();
    await _getTrenutnePozajmice();
    await _getTrenutneRezervacije();
    setState(() {});
  }

  Future _getTrenutnePozajmice() async {
    trenutnePozajmice = await pozajmiceProvider.get(
        filter: {'vraceno': false, 'citalacId': AuthProvider.citalacId},
        retrieveAll: true,
        includeTables: 'BibliotekaKnjiga,ProduzenjePozajmicas');
  }

  Future _getPrijasnjePozajmice() async {
    prijasnjePozajmiceResult = await pozajmiceProvider.get(
        filter: {'vraceno': true, 'citalacId': AuthProvider.citalacId},
        retrieveAll: true,
        orderBy: 'StvarniDatumVracanja',
        sortDirection: 'Descending',
        includeTables: 'BibliotekaKnjiga');
  }

  Future _getTrenutneRezervacije() async {
    trenutneRezervacije = await rezervacijeProvider.get(
        filter: {'ponistena': false, 'citalacId': AuthProvider.citalacId},
        retrieveAll: true,
        includeTables: 'BibliotekaKnjiga');
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

  Widget _buildAppBarHeader() {
    return Container(
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
              "Pozajmice",
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
    return CustomScrollView(
      controller: scrollController, // Attach your scroll controller here
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, top: 5),
            child: const Text(
              "Trenutne pozajmice",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildTrenutnePozajmice(),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(height: 20),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, top: 5, right: 10),
            child: const Text(
              "Trenutne rezervacije",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildTrenutneRezervacije(),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(height: 20),
        ),
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
            margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: const Text(
              "Historija pozajmica",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == prijasnjePozajmice.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      hasNextPage
                          ? 'Učitavanje...'
                          : total != 0
                              ? 'Pregledali ste sve pozajmice!'
                              : 'Nema više pozajmica',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              } else {
                return _buildPrijasnjaPozajmicaCard(
                    pozajmica: prijasnjePozajmice[index]);
              }
            },
            childCount: prijasnjePozajmice.length + 1,
          ),
        ),
      ],
    );
  }

  // Widget _buildPage() {
  //   return CustomScrollView(
  //     controller: scrollController, // Attach your scroll controller here
  //     slivers: [
  //       SliverToBoxAdapter(
  //         child: Container(
  //           alignment: Alignment.centerLeft,
  //           margin: const EdgeInsets.only(left: 10, top: 5),
  //           child: const Text(
  //             "Trenutne pozajmice",
  //             style: TextStyle(fontSize: 24),
  //           ),
  //         ),
  //       ),
  //       SliverToBoxAdapter(
  //         child: _buildTrenutnePozajmice(),
  //       ),
  //       SliverToBoxAdapter(
  //         child: const SizedBox(height: 20),
  //       ),
  //       SliverToBoxAdapter(
  //         child: Container(
  //           decoration: const BoxDecoration(
  //             border: Border(
  //               top: BorderSide(
  //                 color: Colors.black,
  //                 width: 2.0,
  //               ),
  //             ),
  //           ),
  //           alignment: Alignment.centerLeft,
  //           margin: const EdgeInsets.only(left: 10, top: 5, right: 10),
  //           child: const Text(
  //             "Trenutne rezervacije",
  //             style: TextStyle(fontSize: 24),
  //           ),
  //         ),
  //       ),
  //       SliverToBoxAdapter(
  //         child: _buildTrenutneRezervacije(),
  //       ),
  //       SliverToBoxAdapter(
  //         child: const SizedBox(height: 20),
  //       ),
  //       SliverToBoxAdapter(
  //         child: Container(
  //           alignment: Alignment.centerLeft,
  //           decoration: const BoxDecoration(
  //             border: Border(
  //               top: BorderSide(
  //                 color: Colors.black,
  //                 width: 2.0,
  //               ),
  //             ),
  //           ),
  //           margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
  //           child: const Text(
  //             "Historija pozajmica",
  //             style: TextStyle(fontSize: 24),
  //           ),
  //         ),
  //       ),
  //       SliverList(
  //         delegate: SliverChildBuilderDelegate(
  //           (context, index) {
  //             if (index == prijasnjePozajmice.length) {
  //               return Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Center(
  //                   child: Text(
  //                     hasNextPage
  //                         ? 'Učitavanje...'
  //                         : total != 0
  //                             ? 'Pregledali ste sve pozajmice!'
  //                             : 'Nema više pozajmica',
  //                     style: const TextStyle(fontSize: 16),
  //                   ),
  //                 ),
  //               );
  //             } else {
  //               return _buildPrijasnjaPozajmicaCard(
  //                   pozajmica: prijasnjePozajmice[index]);
  //             }
  //           },
  //           childCount: prijasnjePozajmice.length + 1,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildPage() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           alignment: Alignment.centerLeft,
  //           margin: const EdgeInsets.only(left: 10, top: 5),
  //           child: const Text(
  //             "Trenutne pozajmice",
  //             style: TextStyle(fontSize: 24),
  //           ),
  //         ),
  //         _buildTrenutnePozajmice(),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         Container(
  //           decoration: const BoxDecoration(
  //             border: Border(
  //               top: BorderSide(
  //                 color: Colors.black,
  //                 width: 2.0,
  //               ),
  //             ),
  //           ),
  //           alignment: Alignment.centerLeft,
  //           margin: const EdgeInsets.only(left: 10, top: 5, right: 10),
  //           child: const Text(
  //             "Trenutne rezervacije",
  //             style: TextStyle(fontSize: 24),
  //           ),
  //         ),
  //         _buildTrenutneRezervacije(),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         Container(
  //           alignment: Alignment.centerLeft,
  //           decoration: const BoxDecoration(
  //             border: Border(
  //               top: BorderSide(
  //                 color: Colors.black,
  //                 width: 2.0,
  //               ),
  //             ),
  //           ),
  //           margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
  //           child: const Text(
  //             "Historija pozajmica",
  //             style: TextStyle(fontSize: 24),
  //           ),
  //         ),
  //         _buildPrijasnjePozajmice()
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTrenutnePozajmice() {
    if (trenutnePozajmice?.resultList != null) {
      return ListView(
        //scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: trenutnePozajmice!.resultList
            .map((e) => _buildTrenutnaPozajmicaCard(pozajmica: e))
            .toList(),
      );
    } else {
      return const SizedBox(
        height: 50,
        child: Center(
          child: Text("Nema podataka"),
        ),
      );
    }
  }

  Widget _buildTrenutneRezervacije() {
    if (trenutneRezervacije?.resultList != null) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: trenutneRezervacije!.resultList
            .map((e) => _buildTrenutnaRezervacijaCard(rezervacija: e))
            .toList(),
      );
    } else {
      return const SizedBox(
        height: 50,
        child: Center(
          child: Text("Nema podataka"),
        ),
      );
    }
  }

  Widget _buildPrijasnjePozajmice() {
    return isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: prijasnjePozajmice.length + 1,
            controller: scrollController,
            itemBuilder: (_, index) {
              if (index == prijasnjePozajmice.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      hasNextPage
                          ? 'Učitavanje...'
                          : total != 0
                              ? 'Pregledali ste sve pozajmice!'
                              : 'Nema više pozajmica',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              } else {
                return _buildPrijasnjaPozajmicaCard(
                    pozajmica: prijasnjePozajmice[index]);
              }
            },
          );
  }

  Widget _buildTrenutnaPozajmicaCard({required Pozajmica pozajmica}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Knjiga>(
                future: getKnjiga(pozajmica!.bibliotekaKnjiga!.knjigaId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Greška sa učitavanjem',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      'Knjiga: ${snapshot.data!.naslov}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return const Text(
                      'Nema knjige',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            ),
            FutureBuilder<Biblioteka>(
              future: getBiblioteka(pozajmica!.bibliotekaKnjiga!.bibliotekaId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    'Greška sa učitavanjem',
                  );
                } else if (snapshot.hasData) {
                  return _buildInfoRow(
                      'Ustanova', snapshot.data!.naziv.toString());
                } else {
                  return const Text(
                    'Nema biblioteke',
                  );
                }
              },
            ),
            _buildInfoRow('Preuzeto',
                formatDateTimeToLocal(pozajmica.datumPreuzimanja.toString())),
            _buildInfoRow(
                'Vratiti do',
                formatDateTimeToLocal(
                    pozajmica.preporuceniDatumVracanja.toString())),
            if (pozajmica.produzenjePozajmicas!
                    .where((element) => element.odobreno == null)
                    .isEmpty ||
                pozajmica.produzenjePozajmicas!.isEmpty &&
                    pozajmica.moguceProduziti == true)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: const Text(
                    "Produzi",
                    textAlign: TextAlign.end,
                  ),
                  onPressed: () => {_showExtendLoanDialog(context, pozajmica)},
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _showExtendLoanDialog(
      BuildContext context, Pozajmica pozajmica) async {
    final TextEditingController _daysController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Produži pozajmicu'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Unesite broj dana za produženje pozajmice:'),
                TextField(
                  controller: _daysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Broj dana',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Potvrdi'),
              onPressed: () {
                int? brojDana = int.tryParse(_daysController.text);
                if (brojDana != null && brojDana > 0) {
                  try {
                    produziPozajmicu(brojDana, pozajmica.pozajmicaId!);
                    Navigator.of(context).pop();
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: e.toString());
                  }
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Molimo unesite validan broj dana')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future produziPozajmicu(int brojDana, int id) async {
    try {
      await produzenjePozajmiceProvider
          .insert({'produzenje': brojDana, 'pozajmicaId': id});
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Uspješno kreiran zahtjev");
      await _getTrenutnePozajmice();

      setState(() {});
    } on Exception catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.toString());
    }
  }

  Widget _buildTrenutnaRezervacijaCard({required Rezervacija rezervacija}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Knjiga>(
                future: getKnjiga(rezervacija!.bibliotekaKnjiga!.knjigaId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Greška sa učitavanjem',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      'Knjiga: ${snapshot.data!.naslov}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return const Text(
                      'Nema knjige',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            ),
            FutureBuilder<Biblioteka>(
              future:
                  getBiblioteka(rezervacija!.bibliotekaKnjiga!.bibliotekaId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    'Greška sa učitavanjem',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasData) {
                  return _buildInfoRow(
                      'Ustanova', snapshot.data!.naziv.toString());
                } else {
                  return const Text(
                    'Nema biblioteke',
                    // style: TextStyle(color: Colors.white),
                  );
                }
              },
            ),
            // SizedBox(height: 8.0),
            _buildInfoRow('Datum kreiranja',
                formatDateTimeToLocal(rezervacija.datumKreiranja.toString())),
            rezervacija.state == "Odobrena"
                ? _buildInfoRow('Odobrena?', "Da")
                : rezervacija.state == "Ponistena"
                    ? _buildInfoRow('Poništena?', "Da")
                    : _buildInfoRow('Odobrena?', "Ne još"),
            if (rezervacija.state == "Kreirana" ||
                rezervacija.state == "Obnovljena")
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: const Text(
                    "Poništi",
                    textAlign: TextAlign.end,
                  ),
                  onPressed: () => {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: "Jeste li sigurni?",
                        text: "Želite li poništiti rezervaciju?",
                        confirmBtnText: "Da",
                        cancelBtnText: "Ne",
                        onConfirmBtnTap: () => {
                              ponistiRezervaciju(rezervacija.rezervacijaId!),
                              Navigator.pop(context)
                            },
                        onCancelBtnTap: () => {Navigator.pop(context)})
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  Future ponistiRezervaciju(int id) async {
    try {
      await rezervacijeProvider.ponisti(id);
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Uspješno poništena rezervacija");
      await _getTrenutneRezervacije();

      setState(() {});
    } on Exception catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.toString());
    }
  }

  Widget _buildPrijasnjaPozajmicaCard({required Pozajmica pozajmica}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Knjiga>(
                future: getKnjiga(pozajmica!.bibliotekaKnjiga!.knjigaId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Greška sa učitavanjem',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      'Knjiga: ${snapshot.data!.naslov}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return const Text(
                      'Nema knjige',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            ),
            FutureBuilder<Biblioteka>(
              future: getBiblioteka(pozajmica!.bibliotekaKnjiga!.bibliotekaId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    'Greška sa učitavanjem',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasData) {
                  return _buildInfoRow(
                      'Ustanova', snapshot.data!.naziv.toString());
                } else {
                  return const Text(
                    'Nema biblioteke',
                    // style: TextStyle(color: Colors.white),
                  );
                }
              },
            ),
            // SizedBox(height: 8.0),
            _buildInfoRow('Preuzeto',
                formatDateTimeToLocal(pozajmica.datumPreuzimanja.toString())),
            _buildInfoRow(
                'Vraćeno ',
                formatDateTimeToLocal(
                    pozajmica.stvarniDatumVracanja.toString())),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Future<Knjiga> getKnjiga(int knjigaId) async {
    var knjiga = await knjigaProvider.getById(knjigaId);
    return knjiga;
  }

  Future<Biblioteka> getBiblioteka(int bibliotekaId) async {
    var biblioteka = await bibliotekaProvider.getById(bibliotekaId);
    return biblioteka;
  }
}
