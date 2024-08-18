import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/pozajmica_info.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/screens/novi_penal_screen.dart';
import 'package:elibrary_bibliotekar/screens/pozajmica_detalji_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CitalacDetaljiScreen extends StatefulWidget {
  Citalac? citalac;
  CitalacDetaljiScreen({super.key, this.citalac});

  @override
  State<CitalacDetaljiScreen> createState() => _CitalacDetaljiScreenState();
}

class _CitalacDetaljiScreenState extends State<CitalacDetaljiScreen> {
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
  List<PozajmicaInfo> pozajmicaInfo = [];
  // late Jezi? knjiga;
  // late Knjiga? knjiga;
  // late Knjiga? knjiga;
  late PozajmiceDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;

  final GlobalKey chartKey = GlobalKey();

  @override
  // TODO: implement context
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        citalacId: widget.citalac!.citalacId);

    // initForm();
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
      "Detalji knjige",
      Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Poravnanje sadržaja od vrha
            children: [
              _buildKnjigaDetalji(),
              _isLoading ? const Text("Nema podataka") : _buildPaginatedTable(),
            ],
          ),
        ),
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AdvancedPaginatedDataTable(
        header: const Text("Historija pozajmica"),
        dataRowHeight: 75,
        columns: const [
          DataColumn(label: Text("Knjiga")),
          DataColumn(label: Text("Datum preuzimanja")),
          DataColumn(label: Text("Datum vraćanja")),
          DataColumn(label: Text("Akcija")),
        ],
        source: _source,
        addEmptyRows: false,
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
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(color: Colors.black),
            //       borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            //   width: 400,
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(5.0),
            //         child: knjiga?.slika != null
            //             ? Container(
            //                 width: 350,
            //                 height: 440,
            //                 child: imageFromString(knjiga!.slika!),
            //               )
            //             : Text("Nema slike!"),
            //       )
            //     ],
            //   ),
            // ),
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
                            child: Text("Ime"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget.citalac!.ime.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Prezime"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget.citalac!.prezime.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Email"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget.citalac!.email.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Korisnicko ime"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child:
                                Text(widget.citalac!.korisnickoIme.toString()),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Institucija"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(widget.citalac!.institucija.toString()),
                          )
                        ]),
                        // TableRow(children: [
                        //   const Padding(
                        //     padding: EdgeInsets.all(5),
                        //     child: Text("ISBN"),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(5),
                        //     child: Text(knjiga!.isbn.toString()),
                        //   )
                        // ]),
                        // TableRow(children: [
                        //   const Padding(
                        //     padding: EdgeInsets.all(5),
                        //     child: Text("Godina izdanja"),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(5),
                        //     child: Text(knjiga!.godinaIzdanja.toString()),
                        //   )
                        // ]),
                        // TableRow(children: [
                        //   const Padding(
                        //     padding: EdgeInsets.all(5),
                        //     child: Text("Broj izdanja"),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(5),
                        //     child: Text(knjiga!.brojIzdanja.toString()),
                        //   )
                        // ]),
                        // TableRow(children: [
                        //   const Padding(
                        //     padding: EdgeInsets.all(5),
                        //     child: Text("Broj stranica"),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(5),
                        //     child: Text(knjiga!.brojStranica.toString()),
                        //   )
                        // ]),
                        // TableRow(children: [
                        //   const Padding(
                        //     padding: EdgeInsets.all(5),
                        //     child: Text("Jezik"),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(5),
                        //     child: knjiga?.jezik == null
                        //         ? const Text("")
                        //         : Text(knjiga!.jezik!.naziv.toString()),
                        //   )
                        // ]),
                        // TableRow(children: [
                        //   const Padding(
                        //     padding: EdgeInsets.all(5),
                        //     child: Text("Uvez"),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(5),
                        //     child: knjiga?.uvez == null
                        //         ? const Text("")
                        //         : Text(knjiga!.uvez!.naziv.toString()),
                        //   )
                        // ]),
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

  // Future initForm() async {
  //   int? knjigaId = widget.bibliotekaKnjiga?.knjigaId;

  //   try {
  //     knjigaAutoriResult = await knjigaAutoriProvider.get(
  //         filter: {'knjigaId': knjigaId},
  //         retrieveAll: true,
  //         includeTables: 'Autor');

  //     knjigaVrsteSadrzajaResult = await knjigaVrsteSadrzajaProvider.get(
  //         filter: {'knjigaId': knjigaId},
  //         retrieveAll: true,
  //         includeTables: 'VrstaSadrzaja');

  //     knjigaCiljneGrupeResult = await knjigaCiljnaGrupaProvider.get(
  //         filter: {'knjigaId': knjigaId},
  //         retrieveAll: true,
  //         includeTables: 'CiljnaGrupa');

  //     knjigaResult = await knjigaProvider.get(
  //         filter: {'knjigaId': knjigaId},
  //         retrieveAll: true,
  //         includeTables: 'Uvez,Jezik,Izdavac');

  //     var pozajmicaInfoResult = await provider
  //         .getReportData(widget.bibliotekaKnjiga!.bibliotekaKnjigaId!);

  //     pozajmicaInfo = pozajmicaInfoResult;

  //     if (knjigaResult?.count == 1 && knjigaResult?.resultList != null) {
  //       knjiga = knjigaResult!.resultList[0];
  //     }
  //   } on Exception catch (e) {
  //     print("Greška neka");
  //   }

  //   setState(() {});
  //   print(
  //       "${knjigaAutoriResult?.count} ${knjigaVrsteSadrzajaResult?.count} ${knjigaCiljneGrupeResult?.count}");
  // }

  Widget _buildApp() {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }
}

class PozajmiceDataSource extends AdvancedDataTableSource<Pozajmica> {
  List<Pozajmica>? data = [];
  final PozajmiceProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  int? citalacId;
  String autor = "";
  String naslov = "";
  String isbn = "";
  dynamic filter;
  BuildContext context;
  PozajmiceDataSource(
      {required this.provider, required this.context, required this.citalacId});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      // DataCell(Text(
      //     "${item!.citalac!.ime.toString()} ${item!.citalac!.prezime.toString()}")),
      DataCell(Text(item!.bibliotekaKnjiga!.knjiga!.naslov.toString())),
      DataCell(Text(DateFormat("dd.MM.yyyy. HH:mm").format(
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
              .parseStrict(item!.datumPreuzimanja!.toString())))),
      DataCell(Text(DateFormat("dd.MM.yyyy. HH:mm").format(
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
              .parseStrict(item!.stvarniDatumVracanja!.toString())))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.blue)),
              onPressed: () {
                // Prva akcija dugmeta
                print('First button pressed for item: ${item.trajanje}');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PozajmicaDetailsScreen(
                          pozajmica: item,
                        )));
              },
              child: Text(
                'Detalji',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8), // Razmak između dugmadi
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
              onPressed: () {
                // Druga akcija dugmeta
                print(
                    'Second button pressed for item: ${item.datumPreuzimanja}');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoviPenalScreen(
                          pozajmica: item,
                        )));
              },
              child: Text(
                'Dodaj penale',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      )
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
      'citalacId': citalacId,
      'vraceno': true,
      'bibliotekaId': AuthProvider.bibliotekaId
    };
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        filter: filter,
        page: page,
        pageSize: pageSize,
        includeTables: "BibliotekaKnjiga.Knjiga,Citalac",
        orderBy: "DatumPreuzimanja",
        sortDirection: "descending");
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
