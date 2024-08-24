import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/upit.dart';
import 'package:elibrary_bibliotekar/providers/upiti_provider.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/upit_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

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
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    provider = context.read<UpitiProvider>();
    _source = UpitiDataSource(provider: provider, context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Biblioteke",
        Container(
          child: Column(
            children: [
              _buildSearch(),
              _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
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
              _source.filterServerSide(value);
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
                    child: const Text("Ime"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Naslov"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Odgovoreno"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Akcija"),
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
        child: item.odgovor == null ? const Text("Ne") : const Text("Da"),
      )),
      DataCell(Row(
        children: [
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpitDetailsScreen(
                    upit: item,
                  ),
                ),
              );
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
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': nazivGTE,
    };

    try {
      var result = await provider.get(
          filter: filter,
          page: page,
          pageSize: pageSize,
          orderBy: 'UpitId',
          sortDirection: 'Descending',
          includeTables: "Citalac");
      data = result.resultList;
      count = result.count;
    } on Exception catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: e.toString());
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
