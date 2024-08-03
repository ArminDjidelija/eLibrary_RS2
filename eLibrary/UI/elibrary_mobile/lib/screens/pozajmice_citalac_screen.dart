import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/rezervacija.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/providers/biblioteka_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/rezervacije_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

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

    _firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);

    _initForm();
  }

  void _firstLoad() async {
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
        filter: {'vraceno': true},
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
          filter: {'vraceno': true},
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
        filter: {'vraceno': false},
        retrieveAll: true,
        includeTables: 'BibliotekaKnjiga');
  }

  Future _getPrijasnjePozajmice() async {
    prijasnjePozajmiceResult = await pozajmiceProvider.get(
        filter: {'vraceno': true},
        retrieveAll: true,
        includeTables: 'BibliotekaKnjiga');
  }

  Future _getTrenutneRezervacije() async {
    trenutneRezervacije = await rezervacijeProvider.get(
        filter: {'ponistena': false},
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              "Trenutne pozajmice",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildTrenutnePozajmice(),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              "Trenutne rezervacije",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildTrenutneRezervacije(),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black, // Boja bordera
                  width: 2.0, // Širina bordera
                ),
              ),
            ),
            margin: EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Text(
              "Historija pozajmica",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildPrijasnjePozajmice(),
        ],
      ),
    );
  }

  Widget _buildTrenutnePozajmice() {
    if (trenutnePozajmice?.resultList != null) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: trenutnePozajmice!.resultList
            .map((e) => _buildTrenutnaPozajmicaCard(pozajmica: e))
            .toList(),
      );
    } else {
      return Container(
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
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: trenutneRezervacije!.resultList
            .map((e) => _buildTrenutnaRezervacijaCard(rezervacija: e))
            .toList(),
      );
    } else {
      return Container(
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
            physics:
                NeverScrollableScrollPhysics(), // Disable ListView scrolling
            shrinkWrap: true, // Ensure ListView occupies only necessary space

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
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<Knjiga>(
                future: getKnjiga(pozajmica!.bibliotekaKnjiga!.knjigaId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Greška sa učitavanjem',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      'Knjiga: ${snapshot.data!.naslov}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return Text(
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
                  return Text(
                    'Loading...',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Greška sa učitavanjem',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasData) {
                  return _buildInfoRow(
                      'Ustanova', snapshot.data!.naziv.toString());
                } else {
                  return Text(
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
                'Vratiti do',
                formatDateTimeToLocal(
                    pozajmica.preporuceniDatumVracanja.toString())),
          ],
        ),
      ),
    );
  }

  Widget _buildTrenutnaRezervacijaCard({required Rezervacija rezervacija}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<Knjiga>(
                future: getKnjiga(rezervacija!.bibliotekaKnjiga!.knjigaId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Greška sa učitavanjem',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      'Knjiga: ${snapshot.data!.naslov}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return Text(
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
                  return Text(
                    'Loading...',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Greška sa učitavanjem',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasData) {
                  return _buildInfoRow(
                      'Ustanova', snapshot.data!.naziv.toString());
                } else {
                  return Text(
                    'Nema biblioteke',
                    // style: TextStyle(color: Colors.white),
                  );
                }
              },
            ),
            // SizedBox(height: 8.0),
            _buildInfoRow('Datum kreiranja',
                formatDateTimeToLocal(rezervacija.datumKreiranja.toString())),
            rezervacija.odobreno == null
                ? _buildInfoRow('Odobrena?', "Ne još")
                : rezervacija.odobreno == true
                    ? _buildInfoRow('Odobrena?', "Da")
                    : _buildInfoRow('Odobrena?', "Ne")
            // _buildInfoRow(
            //     'Vratiti do',
            //     formatDateTimeToLocal(
            //         pozajmica.preporuceniDatumVracanja.toString())),
          ],
        ),
      ),
    );
  }

  Widget _buildPrijasnjaPozajmicaCard({required Pozajmica pozajmica}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              color: Colors.blue,
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<Knjiga>(
                future: getKnjiga(pozajmica!.bibliotekaKnjiga!.knjigaId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Greška sa učitavanjem',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      'Knjiga: ${snapshot.data!.naslov}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return Text(
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
                  return Text(
                    'Loading...',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Greška sa učitavanjem',
                    // style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasData) {
                  return _buildInfoRow(
                      'Ustanova', snapshot.data!.naziv.toString());
                } else {
                  return Text(
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
                'Vratiti do',
                formatDateTimeToLocal(
                    pozajmica.preporuceniDatumVracanja.toString())),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
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
