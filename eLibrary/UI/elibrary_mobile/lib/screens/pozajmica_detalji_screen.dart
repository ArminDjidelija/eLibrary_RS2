// ignore_for_file: unused_import

import 'dart:async';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_mobile/layouts/citalac_master_screen.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/penal.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/providers/penali_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:elibrary_mobile/screens/knjiga_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class PozajmicaDetailsScreen extends StatefulWidget {
  Pozajmica? pozajmica;
  PozajmicaDetailsScreen({super.key, this.pozajmica});

  @override
  State<PozajmicaDetailsScreen> createState() => _PozajmicaDetailsScreenState();
}

class _PozajmicaDetailsScreenState extends State<PozajmicaDetailsScreen> {
  late PozajmiceProvider provider;
  late PenaliProvider penaliProvider;

  // late Jezi? knjiga;
  // late Knjiga? knjiga;
  // late Knjiga? knjiga;
  late PenaliDataSource _source;
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
    // knjiga = widget.pozajmica?.knjiga;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    provider = context.read<PozajmiceProvider>();
    penaliProvider = context.read<PenaliProvider>();
    _source = PenaliDataSource(
        provider: penaliProvider,
        context: context,
        pozajmicaId: widget.pozajmica!.pozajmicaId);
    // initForm();
  }

  @override
  Widget build(BuildContext context) {
    return CitalacMasterScreen(
      "Detalji pozajmice",
      SingleChildScrollView(
        child: Column(
          children: [
            _buildPozajmicaDetalji(),
            _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
          ],
        ),
      ),
    );
  }

  TextEditingController _naslovEditingController = TextEditingController();
  TextEditingController _autorEditingController = TextEditingController();
  TextEditingController _isbnEditingController = TextEditingController();

  Widget _buildPaginatedTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AdvancedPaginatedDataTable(
        header: const Text("Trenutne pozajmice"),
        dataRowHeight: 75,
        columns: const [
          DataColumn(label: Text("Opis")),
          DataColumn(label: Text("Iznos")),
          DataColumn(label: Text("Uplata")),
          // DataColumn(label: Text("Postavljeno trajanje (dani)")),
          // DataColumn(label: Text("Vraćeno")),
          // DataColumn(label: Text("Akcija")),
        ],
        source: _source,
        addEmptyRows: false,
      ),
    );
  }

  Widget _buildPozajmicaDetalji() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 650,
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
                            child: Text(
                              "Čitalac",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "${widget.pozajmica!.citalac!.ime} ${widget.pozajmica!.citalac!.prezime}",
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Email",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "${widget.pozajmica!.citalac!.email}",
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Datum preuzimanja",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              DateFormat("dd.MM.yyyy. HH:mm").format(
                                  DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
                                      .parseStrict(widget
                                          .pozajmica!.datumPreuzimanja
                                          .toString())),
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Rok vraćanja",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              DateFormat("dd.MM.yyyy. HH:mm").format(
                                  DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
                                      .parseStrict(widget
                                          .pozajmica!.preporuceniDatumVracanja
                                          .toString())),
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Stvarni datum vraćanja",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              DateFormat("dd.MM.yyyy. HH:mm").format(
                                  DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
                                      .parseStrict(widget
                                          .pozajmica!.stvarniDatumVracanja
                                          .toString())),
                              style: TextStyle(fontSize: 20),
                            ),
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

  Widget _buildApp() {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }
}

class PenaliDataSource extends AdvancedDataTableSource<Penal> {
  List<Penal>? data = [];
  final PenaliProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  int? pozajmicaId;
  String autor = "";
  String naslov = "";
  String isbn = "";
  dynamic filter;
  BuildContext context;
  PenaliDataSource(
      {required this.provider,
      required this.context,
      required this.pozajmicaId});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Text(item!.opis.toString())),
      DataCell(Text(item!.iznos.toString())),
      DataCell(
        item!.uplataId == null ? Text("Nije uplaćeno") : Text("Uplaćen penal"),
      ),
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
  Future<RemoteDataSourceDetails<Penal>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {'bibliotekaId': 2, 'pozajmicaId': pozajmicaId};
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
      filter: filter,
      page: page,
      pageSize: pageSize,
      includeTables: "Uplata,Pozajmica",
    );
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
