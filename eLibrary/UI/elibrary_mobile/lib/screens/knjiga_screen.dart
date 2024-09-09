import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:elibrary_mobile/models/biblioteka_knjiga.dart';
import 'package:elibrary_mobile/models/jezik.dart';
import 'package:elibrary_mobile/models/kanton.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/knjiga_autor.dart';
import 'package:elibrary_mobile/models/knjiga_ciljna_grupa.dart';
import 'package:elibrary_mobile/models/knjiga_vrsta_sadrzaja.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/biblioteka_knjiga_provider.dart';
import 'package:elibrary_mobile/providers/citalac_knjiga_log_provider.dart';
import 'package:elibrary_mobile/providers/jezici_provider.dart';
import 'package:elibrary_mobile/providers/kanton_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_autori_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_ciljna_grupa_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_vrste_sadrzaja_provider.dart';
import 'package:elibrary_mobile/providers/korisnik_sacuvana_knjiga_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/rezervacije_provider.dart';
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
  late CitalacKnjigaLogProvider citalacKnjigaLogProvider;
  late RezervacijeProvider rezervacijeProvider;

  SearchResult<Knjiga>? knjigeResult;
  SearchResult<Pozajmica>? pozajmiceResult;
  SearchResult<KnjigaAutor>? knjigAutorResult;
  SearchResult<KnjigaVrstaSadrzaja>? knjigaVrstaSadrzajaResult;
  SearchResult<KnjigaCiljnaGrupa>? knjigaCiljneGrupeResult;
  SearchResult<BibliotekaKnjiga>? bibliotekaKnjigaResult;
  List<Kanton> kantoni = [];

  List<Knjiga> knjigaList = [];
  List<Pozajmica> pozajmicaList = [];
  Jezik? jezik;
  int? korisnikSacuvanaKnjigaId;
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
    citalacKnjigaLogProvider = context.read<CitalacKnjigaLogProvider>();
    rezervacijeProvider = context.read<RezervacijeProvider>();

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
    await _getSacuvanaKnjiga();
    try {
      await citalacKnjigaLogProvider.insert({
        'citalacId': AuthProvider.citalacId,
        'knjigaId': widget.knjiga.knjigaId
      });
    } on Exception catch (e) {}

    setState(() {});
  }

  Future _getSacuvanaKnjiga() async {
    var sacuvanaKnjigaResult = await korisnikSacuvanaKnjigaProvider.get(
        filter: {
          'citalacId': AuthProvider.citalacId,
          'knjigaId': widget.knjiga.knjigaId
        });
    if (sacuvanaKnjigaResult.resultList.isNotEmpty) {
      setState(() {
        korisnikSacuvanaKnjigaId =
            sacuvanaKnjigaResult.resultList.first.korisnikSacuvanaKnjigaId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: () async {
              if (korisnikSacuvanaKnjigaId == null) {
                await _addSacuvanaKnjiga(widget.knjiga.knjigaId!);
              } else {
                await _removeSacuvanaKnjiga(korisnikSacuvanaKnjigaId!);
              }
            },
            child: Icon(korisnikSacuvanaKnjigaId == null
                ? Icons.bookmark_outline
                : Icons.bookmark),
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
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
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
              icon: const Icon(Icons.search),
              onPressed: () {},
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
              borderRadius: const BorderRadius.all(Radius.circular(15)),
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
              borderRadius: const BorderRadius.all(Radius.circular(15)),
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
              : Center(child: Image.asset('assets/images/empty.png')),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.knjiga?.naslov ?? 'Nema naslova!',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              knjigAutorResult == null
                  ? const Text("Nema autora")
                  : Text(
                      knjigAutorResult!.resultList
                          .map((ka) => '${ka.autor!.ime} ${ka.autor!.prezime}')
                          .join(', '),
                      style: const TextStyle(fontSize: 16),
                    ),
              knjigaVrstaSadrzajaResult == null
                  ? const Text("Nema vrsti sadrzaja")
                  : Text(
                      "Vrste: ${knjigaVrstaSadrzajaResult!.resultList.map((ka) => '${ka.vrstaSadrzaja!.naziv}').join(', ')}",
                      style: const TextStyle(fontSize: 16),
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
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFondovi() {
    if (bibliotekaKnjigaResult?.resultList != null) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: bibliotekaKnjigaResult!.resultList
            .map((e) => _buildBibliotekaCard(
                title: e.biblioteka!.naziv!,
                city: e.biblioteka!.kantonId!,
                address: e.biblioteka!.adresa,
                availability: e.trenutnoDostupno,
                id: e.bibliotekaKnjigaId!))
            .toList(),
      );
    } else {
      return Container(
        height: 50,
        child: const Center(
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
    required int id,
  }) {
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
              child: Text(
                'Ustanova: ${title}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8.0),
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
            const SizedBox(height: 8.0),
            Row(
              children: [
                availability != null && availability > 0
                    ? ElevatedButton(
                        onPressed: () {
                          _rezervisiKnjigu(id!);
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.blue),
                        ),
                        child: const Text(
                          'Rezerviši knjigu',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
                const Spacer(),
                IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.info,
                          text:
                              "Nakon rezervisanja knjige, ista će Vas čekati u biblioteci ukoliko Vam odobre rezervaciju.",
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDetalji() {
    return Padding(
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
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _buildTableRow(
                          "Naslov", widget.knjiga!.naslov.toString()),
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
                                child: Text(knjigaCiljneGrupeResult!.resultList
                                    .map((ka) => '${ka.ciljnaGrupa!.naziv}')
                                    .join(', ')),
                              )
                      ]),
                      _buildTableRow("ISBN", widget.knjiga.isbn.toString()),
                      _buildTableRow("Godina izdanja",
                          widget.knjiga.godinaIzdanja.toString()),
                      _buildTableRow(
                          "Broj izdanja", widget.knjiga.brojIzdanja.toString()),
                      _buildTableRow("Broj stranica",
                          widget.knjiga.brojStranica.toString()),
                      _buildTableRow(
                          "Jezik", jezik == null ? "" : jezik!.naziv),
                      _buildTableRow(
                          "Uvez",
                          widget.knjiga.uvez == null
                              ? ""
                              : widget.knjiga.uvez!.naziv),
                      _buildTableRow(
                          "Izdavac",
                          widget.knjiga.izdavac == null
                              ? ""
                              : widget.knjiga.izdavac!.naziv),
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
    );
  }

  TableRow _buildTableRow(String? label, String? value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(5),
        child: Text(label ?? ""),
      ),
      Padding(
        padding: const EdgeInsets.all(5),
        child: Text(value ?? ""),
      ),
    ]);
  }

  Future _rezervisiKnjigu(int id) async {
    try {
      await rezervacijeProvider.insert(
          {'citalacId': AuthProvider.citalacId, 'bibliotekaKnjigaId': id});
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Uspješno kreirana rezervacija");
    } on Exception catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.toString());
    }
  }

  Widget _emptyDetalji() {
    return const Center(child: Text('Nema dostupnih biblioteka'));
  }

  Future _removeSacuvanaKnjiga(int id) async {
    try {
      await korisnikSacuvanaKnjigaProvider.delete(id);
      setState(() {
        korisnikSacuvanaKnjigaId = null;
      });
    } on Exception catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, title: "Greška");
    }
  }

  Future _addSacuvanaKnjiga(int knjigaId) async {
    try {
      await korisnikSacuvanaKnjigaProvider
          .insert({'citalacId': 1, 'knjigaId': knjigaId});
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Uspješno dodata knjiga");
      await _getSacuvanaKnjiga();
    } on Exception catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.toString());
    }
  }
}
