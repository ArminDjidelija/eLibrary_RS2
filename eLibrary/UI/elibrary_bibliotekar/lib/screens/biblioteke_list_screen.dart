import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/providers/biblioteke_provider.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BibliotekeListScreen extends StatefulWidget {
  const BibliotekeListScreen({super.key});

  @override
  State<BibliotekeListScreen> createState() => _BibliotekeListScreenState();
}

class _BibliotekeListScreenState extends State<BibliotekeListScreen> {
  late BibliotekeProvider provider;
  late BibliotekeDataSource _source;

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

    provider = context.read<BibliotekeProvider>();
    _source = BibliotekeDataSource(provider: provider, context: context);
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
            decoration: const InputDecoration(labelText: "Naziv biblioteke"),
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
                    child: Text("Naziv"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Adresa"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Kanton"),
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

class BibliotekeDataSource extends AdvancedDataTableSource<Biblioteka> {
  List<Biblioteka>? data = [];
  final BibliotekeProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String nazivGTE = "";
  dynamic filter;
  BuildContext context;
  BibliotekeDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(item!.naziv.toString()),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(item!.adresa.toString()),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(item!.kanton!.naziv.toString()),
      )),
      DataCell(ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BibliotekaDetailsScreen(
                    biblioteka: item,
                  )));
        },
        child: const Text(
          'Uredi biblioteku',
          style: TextStyle(color: Colors.white),
        ),
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
  Future<RemoteDataSourceDetails<Biblioteka>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'nazivGTE': nazivGTE,
    };
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        filter: filter,
        page: page,
        pageSize: pageSize,
        includeTables: "Kanton");
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}