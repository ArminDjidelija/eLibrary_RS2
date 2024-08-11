import 'dart:async';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
import 'package:elibrary_bibliotekar/models/jezik.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/knjiga_autor.dart';
import 'package:elibrary_bibliotekar/models/knjiga_ciljna_grupa.dart';
import 'package:elibrary_bibliotekar/models/knjiga_vrsta_sadrzaja.dart';
import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/izdavac_provider.dart';
import 'package:elibrary_bibliotekar/providers/jezici_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_ciljna_grupa_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_vrste_sadrzaja_provider.dart';
import 'package:elibrary_bibliotekar/providers/pozajmice_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:elibrary_bibliotekar/providers/uvez_provider.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_knjiga_edit_screen.dart';
import 'package:elibrary_bibliotekar/screens/knjiga_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/knjige_list_screen.dart';
import 'package:elibrary_bibliotekar/screens/nova_pozajmica_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BibliotekaKnjigaDetailsScreen extends StatefulWidget {
  BibliotekaKnjiga? bibliotekaKnjiga;
  BibliotekaKnjigaDetailsScreen({super.key, this.bibliotekaKnjiga});

  @override
  State<BibliotekaKnjigaDetailsScreen> createState() =>
      _BibliotekaKnjigaDetailsScreenState();
}

class _BibliotekaKnjigaDetailsScreenState
    extends State<BibliotekaKnjigaDetailsScreen> {
  late BibliotekaKnjigaProvider provider;
  late PozajmiceProvider pozajmiceProvider;
  late KnjigaAutoriProvider knjigaAutoriProvider;
  late KnjigaVrsteSadrzajaProvider knjigaVrsteSadrzajaProvider;
  late KnjigaCiljnaGrupaProvider knjigaCiljnaGrupaProvider;
  late JezikProvider jezikProvider;
  late IzdavacProvider izdavacProvider;
  late UvezProvider uvezProvider;
  late KnjigaProvider knjigaProvider;

  SearchResult<BibliotekaKnjiga>? result;
  SearchResult<KnjigaAutor>? knjigaAutoriResult;
  SearchResult<KnjigaVrstaSadrzaja>? knjigaVrsteSadrzajaResult;
  SearchResult<KnjigaCiljnaGrupa>? knjigaCiljneGrupeResult;
  SearchResult<Knjiga>? knjigaResult;
  List<BibliotekaKnjiga> data = [];
  late Knjiga? knjiga;
  // late Jezi? knjiga;
  // late Knjiga? knjiga;
  // late Knjiga? knjiga;
  late PozajmiceDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;

  @override
  // TODO: implement context
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    knjiga = widget.bibliotekaKnjiga?.knjiga;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    provider = context.read<BibliotekaKnjigaProvider>();
    pozajmiceProvider = context.read<PozajmiceProvider>();
    knjigaAutoriProvider = context.read<KnjigaAutoriProvider>();
    knjigaVrsteSadrzajaProvider = context.read<KnjigaVrsteSadrzajaProvider>();
    knjigaCiljnaGrupaProvider = context.read<KnjigaCiljnaGrupaProvider>();
    jezikProvider = context.read<JezikProvider>();
    izdavacProvider = context.read<IzdavacProvider>();
    knjigaProvider = context.read<KnjigaProvider>();
    uvezProvider = context.read<UvezProvider>();

    // knjiga = widget.bibliotekaKnjiga?.knjiga;
    _source = PozajmiceDataSource(
        provider: pozajmiceProvider,
        context: context,
        bibliotekaKnjigaId: widget.bibliotekaKnjiga!.bibliotekaKnjigaId);

    initForm();
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Detalji knjige",
        Container(
          child: Column(
            children: [
              // _buildKnjigaDetalji(),
              // _buildSearch(),
              _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
        ));
  }

  TextEditingController _naslovEditingController = TextEditingController();
  TextEditingController _autorEditingController = TextEditingController();
  TextEditingController _isbnEditingController = TextEditingController();

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _naslovEditingController,
            decoration: const InputDecoration(labelText: "Naziv"),
            onChanged: (value) async {
              _source.filterServerSide(value, _autorEditingController.text,
                  _isbnEditingController.text);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            controller: _autorEditingController,
            decoration: const InputDecoration(labelText: "Autor"),
            onChanged: (value) async {
              _source.filterServerSide(_naslovEditingController.text, value,
                  _isbnEditingController.text);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            controller: _isbnEditingController,
            decoration: const InputDecoration(labelText: "ISBN"),
            onChanged: (value) async {
              _source.filterServerSide(_naslovEditingController.text,
                  _autorEditingController.text, value);
            },
          )),
          ElevatedButton(
              onPressed: () async {
                _source.filterServerSide(_naslovEditingController.text,
                    _autorEditingController.text, _isbnEditingController.text);
                setState(() {});
              },
              child: const Text("Pretraga")),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                //
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => KnjigaDetailsScreen()));
              },
              child: const Text("Nova knjiga")),
        ],
      ),
    );
  }

  Widget _buildPaginatedTable() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: SizedBox(
                  width: double.infinity,
                  child: AdvancedPaginatedDataTable(
                    header: const Text("Trenutne pozajmice"),
                    columns: [
                      const DataColumn(label: Text("Čitalac")),
                      const DataColumn(label: Text("Datum preuzimanja")),
                      // DataColumn(label: Text("Broj izdanja")),
                      // DataColumn(label: Text("Broj stranica")),
                      const DataColumn(
                          label: Text("Preporučeni datum vraćanja")),
                      // const DataColumn(label: Text("Akcija")),
                    ],
                    source: _source,
                    addEmptyRows: false,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKnjigaDetalji() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              width: 400,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: knjiga?.slika != null
                        ? Container(
                            width: 350,
                            height: 440,
                            child: imageFromString(knjiga!.slika!),
                          )
                        : Text("Nema slike!"),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.black),
                //     borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
                            child: Text(knjiga!.naslov.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Autori"),
                          ),
                          knjigaAutoriResult == null
                              ? const Text("Nema autora")
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(knjigaAutoriResult!.resultList
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
                          knjigaVrsteSadrzajaResult == null
                              ? const Text("Nema vrsti sadrzaja")
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(knjigaVrsteSadrzajaResult!
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
                            child: Text(knjiga!.isbn.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Godina izdanja"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(knjiga!.godinaIzdanja.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Broj izdanja"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(knjiga!.brojIzdanja.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Broj stranica"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(knjiga!.brojStranica.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Jezik"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: knjiga?.jezik == null
                                ? const Text("")
                                : Text(knjiga!.jezik!.naziv.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Uvez"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: knjiga?.uvez == null
                                ? const Text("")
                                : Text(knjiga!.uvez!.naziv.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Izdavac"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: knjiga?.izdavac == null
                                ? const Text("")
                                : Text(knjiga!.izdavac!.naziv.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Lokacija"),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: widget.bibliotekaKnjiga!.lokacija ==
                                          null ||
                                      widget.bibliotekaKnjiga!.lokacija == ""
                                  ? Text("Nije unesena lokacija u biblioteci")
                                  : Text(widget.bibliotekaKnjiga!.lokacija
                                      .toString()))
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Broj kopija"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                                widget.bibliotekaKnjiga!.brojKopija.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Maksimalno pozajmica"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget
                                .bibliotekaKnjiga!.dostupnoPozajmica
                                .toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Maksimalno čitaonica"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget
                                .bibliotekaKnjiga!.dostupnoCitaonica
                                .toString()),
                          )
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    BibliotekaKnjigaEditScreen(
                                      bibliotekaKnjiga: widget.bibliotekaKnjiga,
                                    )));
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.blue)),
                          child: const Text(
                            "Uredi",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NovaPozajmicaScreen(
                                      bibliotekaKnjiga: widget.bibliotekaKnjiga,
                                    )));
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.blue)),
                          child: const Text(
                            "Nova pozajmica",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future initForm() async {
    int? knjigaId = widget.bibliotekaKnjiga?.knjigaId;

    try {
      knjigaAutoriResult = await knjigaAutoriProvider.get(
          filter: {'knjigaId': knjigaId},
          retrieveAll: true,
          includeTables: 'Autor');

      knjigaVrsteSadrzajaResult = await knjigaVrsteSadrzajaProvider.get(
          filter: {'knjigaId': knjigaId},
          retrieveAll: true,
          includeTables: 'VrstaSadrzaja');

      knjigaCiljneGrupeResult = await knjigaCiljnaGrupaProvider.get(
          filter: {'knjigaId': knjigaId},
          retrieveAll: true,
          includeTables: 'CiljnaGrupa');

      knjigaResult = await knjigaProvider.get(
          filter: {'knjigaId': knjigaId},
          retrieveAll: true,
          includeTables: 'Uvez,Jezik,Izdavac');

      if (knjigaResult?.count == 1 && knjigaResult?.resultList != null) {
        knjiga = knjigaResult!.resultList[0];
      }
    } on Exception catch (e) {
      print("Greška neka");
    }

    setState(() {});
    print(
        "${knjigaAutoriResult?.count} ${knjigaVrsteSadrzajaResult?.count} ${knjigaCiljneGrupeResult?.count}");
  }
}

class PozajmiceDataSource extends AdvancedDataTableSource<Pozajmica> {
  List<Pozajmica>? data = [];
  final PozajmiceProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  int? bibliotekaKnjigaId;
  String autor = "";
  String naslov = "";
  String isbn = "";
  dynamic filter;
  BuildContext context;
  PozajmiceDataSource(
      {required this.provider,
      required this.context,
      required this.bibliotekaKnjigaId});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        // onSelectChanged: (selected) => {
        //       if (selected == true)
        //         {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) => const KnjigeListScreen())),
        //         }
        //     },
        cells: [
          DataCell(Text(
              "${item!.citalac!.ime.toString()} ${item!.citalac!.prezime.toString()}")),
          DataCell(Text(item!.datumPreuzimanja!.toString())),
          DataCell(Text(item!.preporuceniDatumVracanja.toString())),
        ]);
  }

  void filterServerSide(naslovv, autorr, isbnn) {
    naslov = naslovv;
    autor = autorr;
    isbn = isbnn;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Pozajmica>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      // 'bibliotekaId': 2,
    };
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        // filter: filter,
        page: page,
        pageSize: pageSize,
        includeTables: "BibliotekaKnjiga,Citalac");
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
