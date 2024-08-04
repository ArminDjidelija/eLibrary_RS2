import 'package:advanced_datatable/datatable.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:elibrary_mobile/layouts/base_mobile_screen.dart';
import 'package:elibrary_mobile/models/biblioteka_knjiga.dart';
import 'package:elibrary_mobile/models/ciljna_grupa.dart';
import 'package:elibrary_mobile/models/jezik.dart';
import 'package:elibrary_mobile/models/kanton.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/knjiga_autor.dart';
import 'package:elibrary_mobile/models/knjiga_ciljna_grupa.dart';
import 'package:elibrary_mobile/models/knjiga_vrsta_sadrzaja.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/providers/biblioteka_knjiga_provider.dart';
import 'package:elibrary_mobile/providers/jezici_provider.dart';
import 'package:elibrary_mobile/providers/kanton_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_autori_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_ciljna_grupa_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_vrste_sadrzaja_provider.dart';
import 'package:elibrary_mobile/providers/korisnik_sacuvana_knjiga_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class KnjigaScreen extends StatefulWidget {
  Knjiga knjiga;
  KnjigaScreen({super.key, required this.knjiga});

  @override
  State<KnjigaScreen> createState() => _KnjigaScreenState();
}

class _KnjigaScreenState extends State<KnjigaScreen>
    with SingleTickerProviderStateMixin {
  late KnjigaProvider knjigaProvider;
  late BibliotekaKnjigaProvider bibliotekaKnjigaProvider;
  late PozajmiceProvider pozajmicaProvider;
  late KnjigaAutoriProvider knjigaAutoriProvider;
  late KnjigaVrsteSadrzajaProvider knjigaVrsteSadrzajaProvider;
  late JezikProvider jezikProvider;
  late KnjigaCiljnaGrupaProvider knjigaCiljnaGrupaProvider;
  late KantonProvider kantonProvider;
  late KorisnikSacuvanaKnjigaProvider korisnikSacuvanaKnjigaProvider;
  late TabController _tabController;

  SearchResult<Knjiga>? knjigeResult;
  SearchResult<Pozajmica>? pozajmiceResult;
  SearchResult<KnjigaAutor>? knjigAutorResult;
  SearchResult<KnjigaVrstaSadrzaja>? knjigaVrstaSadrzajaResult;
  SearchResult<KnjigaCiljnaGrupa>? knjigaCiljneGrupeResult;
  SearchResult<BibliotekaKnjiga>? bibliotekaKnjigaResult;
  List<Kanton> kantoni = [];
  // SearchResult<Pozajmica>? pozajmiceResult;

  List<Knjiga> knjigaList = [];
  List<Pozajmica> pozajmicaList = [];
  Jezik? jezik;

  @override
  void initState() {
    super.initState();

    knjigaProvider = context.read<KnjigaProvider>();
    pozajmicaProvider = context.read<PozajmiceProvider>();
    knjigaAutoriProvider = context.read<KnjigaAutoriProvider>();
    knjigaVrsteSadrzajaProvider = context.read<KnjigaVrsteSadrzajaProvider>();
    jezikProvider = context.read<JezikProvider>();
    knjigaCiljnaGrupaProvider = context.read<KnjigaCiljnaGrupaProvider>();
    bibliotekaKnjigaProvider = context.read<BibliotekaKnjigaProvider>();
    korisnikSacuvanaKnjigaProvider =
        context.read<KorisnikSacuvanaKnjigaProvider>();
    kantonProvider = context.read<KantonProvider>();

    _tabController = TabController(length: 2, vsync: this);
    _initForm();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future _initForm() async {
    var kantonSearch = await kantonProvider.get(retrieveAll: true);
    if (kantonSearch != null) {
      kantoni = kantonSearch.resultList;
    }
    knjigeResult = await knjigaProvider.get(page: 1, pageSize: 10);

    pozajmiceResult = await pozajmicaProvider.get(
        retrieveAll: true,
        includeTables: "BibliotekaKnjiga",
        filter: {'vraceno': true});

    knjigAutorResult = await knjigaAutoriProvider.get(
        retrieveAll: true,
        filter: {'knjigaId': widget.knjiga.knjigaId},
        includeTables: 'Autor');

    knjigaVrstaSadrzajaResult = await knjigaVrsteSadrzajaProvider.get(
        retrieveAll: true,
        filter: {'knjigaId': widget.knjiga.knjigaId},
        includeTables: 'VrstaSadrzaja');

    jezik = await jezikProvider.getById(widget.knjiga.jezikId!);

    knjigaCiljneGrupeResult = await knjigaCiljnaGrupaProvider.get(
        retrieveAll: true,
        includeTables: 'CiljnaGrupa',
        filter: {'knjigaId': widget.knjiga.knjigaId});

    bibliotekaKnjigaResult = await bibliotekaKnjigaProvider.get(
        retrieveAll: true,
        includeTables: 'Biblioteka,Knjiga',
        filter: {'knjigaId': widget.knjiga.knjigaId});

    knjigaList = knjigeResult!.resultList;
    pozajmicaList = pozajmiceResult!.resultList;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: () {
              _addSacuvanaKnjiga(widget.knjiga.knjigaId!);
            },
            child: Icon(Icons.bookmark_outline),
          ),
        ),
      ),
      body: _buildPage(),
    );
  }

  Widget _buildAppBarHeader() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pretraži eLibrary',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 45.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality here
              },
            ),
          ),
        ],
      ),
    ));
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
                _buildKnjiga(),
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
              children: [_buildKnjigaTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKnjiga() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 180,
          height: 250,
          child: widget.knjiga?.slika != null
              ? imageFromString(widget.knjiga!.slika!)
              : Center(child: Text("Nema slike!")),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.knjiga?.naslov ?? 'Nema naslova!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              knjigAutorResult == null
                  ? const Text("Nema autora")
                  : Text(
                      knjigAutorResult!.resultList
                          .map((ka) => '${ka.autor!.ime} ${ka.autor!.prezime}')
                          .join(', '),
                      style: TextStyle(fontSize: 16),
                    ),
              knjigaVrstaSadrzajaResult == null
                  ? const Text("Nema vrsti sadrzaja")
                  : Text(
                      "Vrste: ${knjigaVrstaSadrzajaResult!.resultList.map((ka) => '${ka.vrstaSadrzaja!.naziv}').join(', ')}",
                      style: TextStyle(fontSize: 16),
                    ),
              jezik == null
                  ? const Text("Nema jezika")
                  : Text("Jezik: ${jezik?.naziv}"),
              Text("Isbn: ${widget.knjiga!.isbn}"),
              Text("Godina izdanja: ${widget.knjiga!.godinaIzdanja}"),
              // Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKnjigaTab() {
    return Align(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Detalji"),
              Tab(
                text: "Fondovi",
              )
            ],
          ),
          AutoScaleTabBarView(
            controller: _tabController,
            children: [
              _buildDetalji(),

              _buildFondovi(),

              // Placeholder(),
            ],
          )
        ],
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

  Widget _buildFondovi() {
    if (bibliotekaKnjigaResult?.resultList != null) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(8.0),
        children: bibliotekaKnjigaResult!.resultList
            .map((e) => _buildBibliotekaCard(
                  title: e.biblioteka!.naziv!,
                  city: e.biblioteka!.kantonId!,
                  address: e.biblioteka!.adresa,
                  availability: e.trenutnoDostupno,
                ))
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

  Widget _buildBibliotekaCard({
    required String title,
    required int city,
    required String? address,
    required int? availability,
  }) {
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
              child: Text(
                'Ustanova: ${title}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // SizedBox(height: 8.0),
            // Text(
            //   title,
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 8.0),
            kantoni.isNotEmpty
                ? _buildInfoRow(
                    'Kanton',
                    kantoni
                        .where((element) => element.kantonId == city)
                        .first
                        .naziv!)
                : Container(),
            address != null ? _buildInfoRow('Adresa', address) : Container(),
            _buildInfoRow('Dostupno pozajmica', availability.toString()),
            SizedBox(height: 8.0),
            Row(
              children: [
                availability != null && availability > 0
                    ? ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.blue),
                        ),
                        child: Text(
                          'Rezerviši knjigu na 24h',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.help_outline),
                    onPressed: () {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.info,
                          text:
                              "Nakon rezervisanja knjige, ista će Vas čekati u biblioteci 24h ukoliko Vam odobre rezervaciju.",
                          title: "Informacija");
                    }),
              ],
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDetalji() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(
                          color: Colors.black,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      columnWidths: const <int, TableColumnWidth>{
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth()
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Naslov"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget.knjiga!.naslov.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Autori"),
                          ),
                          knjigAutorResult == null
                              ? const Text("Nema autora")
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(knjigAutorResult!.resultList
                                      .map((ka) =>
                                          '${ka.autor!.ime} ${ka.autor!.prezime}')
                                      .join(', ')),
                                )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Vrste sadržaja"),
                          ),
                          knjigaVrstaSadrzajaResult == null
                              ? const Text("Nema vrsti sadrzaja")
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(knjigaVrstaSadrzajaResult!
                                      .resultList
                                      .map((ka) => '${ka.vrstaSadrzaja!.naziv}')
                                      .join(', ')),
                                )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Ciljne grupe"),
                          ),
                          knjigaCiljneGrupeResult == null
                              ? const Text("Nema ciljnih grupa")
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(knjigaCiljneGrupeResult!
                                      .resultList
                                      .map((ka) => '${ka.ciljnaGrupa!.naziv}')
                                      .join(', ')),
                                )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("ISBN"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget.knjiga!.isbn.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Godina izdanja"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child:
                                Text(widget.knjiga!.godinaIzdanja.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Broj izdanja"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget.knjiga!.brojIzdanja.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Broj stranica"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget.knjiga!.brojStranica.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Jezik"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: jezik == null
                                ? const Text("")
                                : Text(jezik!.naziv.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Uvez"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: widget.knjiga?.uvez == null
                                ? const Text("")
                                : Text(widget!.knjiga.uvez!.naziv.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Izdavac"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: widget.knjiga?.izdavac == null
                                ? const Text("")
                                : Text(
                                    widget.knjiga!.izdavac!.naziv.toString()),
                          )
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _emptyDetalji() {
    return Center(child: Text('Nema dostupnih biblioteka'));
  }

  Future _addSacuvanaKnjiga(int knjigaId) async {
    await korisnikSacuvanaKnjigaProvider
        .insert({'citalacId': 1, 'knjigaId': knjigaId});
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Uspješno dodata knjiga");
  }
}
