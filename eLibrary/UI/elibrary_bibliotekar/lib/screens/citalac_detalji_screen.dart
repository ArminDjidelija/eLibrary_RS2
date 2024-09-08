import 'dart:async';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/pozajmica_info.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:elibrary_bibliotekar/screens/novi_penal_screen.dart';
import 'package:elibrary_bibliotekar/screens/pozajmica_detalji_screen.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
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
import 'package:elibrary_bibliotekar/providers/uvez_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  late PozajmiceDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;

  final GlobalKey chartKey = GlobalKey();

  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
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

    _source = PozajmiceDataSource(
        provider: pozajmiceProvider,
        context: context,
        citalacId: widget.citalac!.citalacId);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
      "Detalji knjige",
      Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKnjigaDetalji(),
              _isLoading ? const Text("Nema podataka") : _buildPaginatedTable(),
            ],
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              children: [
                Table(
                  border: TableBorder.all(
                      color: Colors.black,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth()
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                        child: Text(widget.citalac!.korisnickoIme.toString()),
                      )
                    ]),
                    TableRow(children: [
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Institucija"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(widget.citalac!.institucija == null
                            ? "Nije uneseno"
                            : widget.citalac!.institucija.toString()),
                      )
                    ]),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )
        ],
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
      DataCell(Text(formatDateTimeToLocal(item!.datumPreuzimanja!.toString()))),
      DataCell(Text(formatDateToLocal(item!.stvarniDatumVracanja!.toString()))),
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PozajmicaDetailsScreen(
                          pozajmica: item,
                        )));
              },
              child: const Text(
                'Detalji',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoviPenalScreen(
                      pozajmica: item,
                    ),
                  ),
                );
              },
              child: const Text(
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
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'citalacId': citalacId,
      'vraceno': true,
      'bibliotekaId': AuthProvider.bibliotekaId
    };

    try {
      var result = await provider.get(
          filter: filter,
          page: page,
          pageSize: pageSize,
          includeTables: "BibliotekaKnjiga.Knjiga,Citalac",
          orderBy: "DatumPreuzimanja",
          sortDirection: "descending");
      data = result.resultList;
      count = result.count;
    } on Exception catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: e.toString(),
          width: 300);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
