import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/penal.dart';
import 'package:elibrary_mobile/providers/penali_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PenaliCitalacScreen extends StatefulWidget {
  const PenaliCitalacScreen({super.key});

  @override
  State<PenaliCitalacScreen> createState() => _PenaliCitalacScreenState();
}

class _PenaliCitalacScreenState extends State<PenaliCitalacScreen> {
  late PenaliProvider penaliProvider;
  List<Penal> trenutniPenali = [];
  List<Penal> prijasnjiPenali = [];

  int page = 1;

  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;

  bool isLoadMoreRunning = false;
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    penaliProvider = context.read<PenaliProvider>();

    _firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);

    _initForm();
  }

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      prijasnjiPenali = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    var prijasnjiPenaliResult = await penaliProvider.get(
        page: page,
        pageSize: 10,
        orderBy: 'PenalId',
        sortDirection: 'descending',
        filter: {'placeno': true},
        includeTables: 'Uplata');

    prijasnjiPenali = prijasnjiPenaliResult.resultList;
    total = prijasnjiPenaliResult.count;

    setState(() {
      isFirstLoadRunning = false;
      total = prijasnjiPenaliResult!.count;
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

      var prijasnjiPenaliResult = await penaliProvider.get(
          page: page,
          pageSize: 10,
          orderBy: 'PenalId',
          sortDirection: 'descending',
          filter: {'placeno': true},
          includeTables: 'Uplata');

      if (prijasnjiPenaliResult!.resultList.isNotEmpty) {
        prijasnjiPenali.addAll(prijasnjiPenaliResult!.resultList);
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
    var penaliResult = await penaliProvider.get(
        retrieveAll: true,
        includeTables: 'Pozajmica',
        filter: {'placeno': false});
    trenutniPenali = penaliResult.resultList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          // color: Colors.blue,
          // margin: EdgeInsets.only(bottom: 5),
          height: 75,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: const Row(
            children: [
              Text(
                "Penali",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      body: _buildPage(),
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
              "Trenutni penali",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildTrenutniPenali(),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              "Historija penala",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildPrijasnjePenale()
        ],
      ),
    );
  }

  Widget _buildTrenutniPenali() {
    if (trenutniPenali.isNotEmpty) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: trenutniPenali
            .map((e) => _buildTrenutniPenalCard(penal: e))
            .toList(),
      );
    } else {
      return Container(
        height: 50,
        child: Center(
          child: Text("Nema penala za platiti"),
        ),
      );
    }
  }

  Widget _buildTrenutniPenalCard({required Penal penal}) {
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
              child: FutureBuilder<Biblioteka>(
                future: getBibliotekaByPenal(penal.penalId!),
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
                      'Biblioteka: ${snapshot.data!.naziv}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return Text(
                      'Nema biblioteke',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            ),
            _buildInfoRow('Razlog', penal.opis.toString()),
            _buildInfoRow('Iznos', penal.iznos.toString()),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.blue)),
                onPressed: () {},
                child: Text(
                  "Plati",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
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

  Widget _buildPrijasnjePenale() {
    return isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            physics:
                NeverScrollableScrollPhysics(), // Disable ListView scrolling
            shrinkWrap: true, // Ensure ListView occupies only necessary space
            itemCount: prijasnjiPenali.length + 1,
            controller: scrollController,
            itemBuilder: (_, index) {
              if (index == prijasnjiPenali.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    hasNextPage
                        ? 'Učitavanje...'
                        : total != 0
                            ? 'Pregledali ste sve penale!'
                            : 'Nema više penala',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              } else {
                return _buildPrijasnjiPenalCard(penal: prijasnjiPenali[index]);
              }
            },
          );
  }

  Widget _buildPrijasnjiPenalCard({required Penal penal}) {
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
              child: FutureBuilder<Biblioteka>(
                future: getBibliotekaByPenal(penal.penalId!),
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
                      'Biblioteka: ${snapshot.data!.naziv}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return Text(
                      'Nema biblioteke',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            ),
            // FutureBuilder<Biblioteka>(
            //   future: getBiblioteka(pozajmica!.bibliotekaKnjiga!.bibliotekaId!),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Text(
            //         'Loading...',
            //         // style: TextStyle(color: Colors.white),
            //       );
            //     } else if (snapshot.hasError) {
            //       return Text(
            //         'Greška sa učitavanjem',
            //         // style: TextStyle(color: Colors.white),
            //       );
            //     } else if (snapshot.hasData) {
            //       return _buildInfoRow(
            //           'Ustanova', snapshot.data!.naziv.toString());
            //     } else {
            //       return Text(
            //         'Nema biblioteke',
            //         // style: TextStyle(color: Colors.white),
            //       );
            //     }
            //   },
            // ),
            // SizedBox(height: 8.0),
            _buildInfoRow('Opis', penal.opis!),
            _buildInfoRow('Iznos', penal.iznos.toString()),
          ],
        ),
      ),
    );
  }

  Future<Biblioteka> getBibliotekaByPenal(int penalId) async {
    var penal = await penaliProvider.getById(penalId);
    var biblioteka = await penaliProvider.getBibliotekaByPenal(penalId);
    if (biblioteka != null) {
      return biblioteka;
    }
    var novaBiblioteka = Biblioteka();
    novaBiblioteka.naziv = "Nema biblioteke";
    return novaBiblioteka;
  }
}
