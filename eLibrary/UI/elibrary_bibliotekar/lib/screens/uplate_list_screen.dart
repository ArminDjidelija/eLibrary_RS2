import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/uplata.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/uplate_provider.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UplateListScreen extends StatefulWidget {
  const UplateListScreen({super.key});

  @override
  State<UplateListScreen> createState() => _UplateListScreenState();
}

class _UplateListScreenState extends State<UplateListScreen> {
  late UplataProvider provider;
  // SearchResult<Izdavac>? result;
  // List<Izdavac> data = [];
  late UplataDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;

  @override
  // TODO: implement context
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    provider = context.read<UplataProvider>();
    _source = UplataDataSource(provider: provider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Uplate",
        Container(
          child: Column(
            children: [
              _buildSearch(),
              _isLoading ? Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
        ));
  }

  TextEditingController _imeEditingController = TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _imeEditingController,
            decoration: const InputDecoration(labelText: "Ime prezime"),
            onChanged: (value) async {
              // page = 1;
              _source.filterServerSide(value);
              // await updateFilter(value, _autorEditingController.text);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                // updateFilter(_naslovEditingController.text,
                //     _autorEditingController.text);
                _source.filterServerSide(_imeEditingController.text);
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
                    builder: (context) => AutorDetailsScreen()));
              },
              child: const Text("Nova uplata")),
        ],
      ),
    );
  }

  Widget _buildPaginatedTable() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
              width: double.infinity,
              child: AdvancedPaginatedDataTable(
                columns: [
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Ime prezime"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Vrijeme uplate"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Iznos"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Valuta"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Tip uplate"),
                  )),
                ],
                source: _source,
                addEmptyRows: false,
              )),
        ),
      ), // Spacer(),
    );
  }
}

class UplataDataSource extends AdvancedDataTableSource<Uplata> {
  List<Uplata>? data = [];
  final UplataProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezimeGTE = "";
  dynamic filter;
  BuildContext context;
  UplataDataSource({required this.provider, required this.context});

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
        //               builder: (context) => AutorDetailsScreen(
        //                     autor : item,
        //                   ))),
        //         }
        //     },
        cells: [
          DataCell(
            Container(
              alignment: Alignment.centerLeft,
              child: Text("${item!.citalac!.ime} ${item!.citalac!.prezime}"),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.centerLeft,
              child: Text(DateFormat("dd.MM.yyyy. HH:mm").format(
                  DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
                      .parseStrict(item!.datumUplate!.toString()))),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.centerLeft,
              child: Text(item!.iznos!.toStringAsFixed(2)),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.centerLeft,
              child: Text(item!.valuta!.naziv.toString()),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.centerLeft,
              child: Text(item!.tipUplate!.naziv.toString()),
            ),
          ),
          // DataCell(Text(item!.prezime.toString())),
          // DataCell(Text(item!.godinaRodjenja.toString())),
        ]);
  }

  void filterServerSide(ime) {
    imePrezimeGTE = ime;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Uplata>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezimeGTE,
      'bibliotekaId': AuthProvider.bibliotekaId
    };
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        filter: filter,
        page: page,
        pageSize: pageSize,
        includeTables: "Citalac,Biblioteka,Valuta,TipUplate",
        orderBy: "DatumUplate",
        sortDirection: "descending");
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
