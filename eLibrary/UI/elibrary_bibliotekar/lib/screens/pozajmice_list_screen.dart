import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/models/uplata.dart';
import 'package:elibrary_bibliotekar/providers/pozajmice_provider.dart';
import 'package:elibrary_bibliotekar/providers/uplate_provider.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PozajmiceListScreen extends StatefulWidget {
  const PozajmiceListScreen({super.key});

  @override
  State<PozajmiceListScreen> createState() => _PozajmiceListScreenState();
}

class _PozajmiceListScreenState extends State<PozajmiceListScreen> {
  late PozajmiceProvider provider;
  // SearchResult<Izdavac>? result;
  // List<Izdavac> data = [];
  late PozajmicaDataSource _source;
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

    provider = context.read<PozajmiceProvider>();
    _source = PozajmicaDataSource(provider: provider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Pozajmice",
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
            decoration: const InputDecoration(labelText: "Ime"),
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
                    child: Text("Ime"),
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

class PozajmicaDataSource extends AdvancedDataTableSource<Pozajmica> {
  List<Pozajmica>? data = [];
  final PozajmiceProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String nazivGTE = "";
  dynamic filter;
  BuildContext context;
  PozajmicaDataSource({required this.provider, required this.context});

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
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.citalacId.toString()),
          )),
          // DataCell(Text(item!.prezime.toString())),
          // DataCell(Text(item!.godinaRodjenja.toString())),
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
  Future<RemoteDataSourceDetails<Pozajmica>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'nazivGTE': nazivGTE,
      'page': page,
      'pageSize': pageSize,
      'includeTables': 'Citalac'
    };
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(filter: filter);
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
