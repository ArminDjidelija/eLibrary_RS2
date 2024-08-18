import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/upit.dart';
import 'package:elibrary_bibliotekar/providers/biblioteke_provider.dart';
import 'package:elibrary_bibliotekar/providers/upiti_provider.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/novi_uposleni_screen.dart';
import 'package:elibrary_bibliotekar/screens/upit_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpitiListScreen extends StatefulWidget {
  const UpitiListScreen({super.key});

  @override
  State<UpitiListScreen> createState() => _UpitiListScreenState();
}

class _UpitiListScreenState extends State<UpitiListScreen> {
  late UpitiProvider provider;
  late UpitiDataSource _source;

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

    provider = context.read<UpitiProvider>();
    _source = UpitiDataSource(provider: provider, context: context);
    setState(() {});
    //updateFilter("");
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Biblioteke",
        Container(
          child: Column(
            children: [
              _buildSearch(),
              _isLoading ? Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
        ));
  }

  TextEditingController _imePrezimeEditingController = TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _imePrezimeEditingController,
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
                _source.filterServerSide(_imePrezimeEditingController.text);
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
                    builder: (context) => BibliotekaDetailsScreen()));
              },
              child: const Text("Nova biblioteka")),
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
                    child: Text("Ime"),
                  )),
                  // DataColumn(
                  //     label: Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text("Adresa"),
                  // )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Naslov"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Odgovoreno"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Akcija"),
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

class UpitiDataSource extends AdvancedDataTableSource<Upit> {
  List<Upit>? data = [];
  final UpitiProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String nazivGTE = "";
  dynamic filter;
  BuildContext context;
  UpitiDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(
            "${item!.citalac!.ime.toString()} ${item!.citalac!.prezime.toString()}"),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(item!.naslov.toString()),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: item.odgovor == null ? Text("Ne") : Text("Da"),
      )),
      // DataCell(Container(
      //   alignment: Alignment.centerLeft,
      //   child: Text(item!.adresa.toString()),
      // )),
      DataCell(Row(
        children: [
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpitDetailsScreen(
                        upit: item,
                      )));
            },
            child: const Text(
              'Detalji',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      )),
    ]);
  }

  void filterServerSide(naziv) {
    nazivGTE = naziv;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Upit>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': nazivGTE,
    };
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        filter: filter,
        page: page,
        pageSize: pageSize,
        orderBy: 'UpitId',
        sortDirection: 'Descending',
        includeTables: "Citalac");
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
