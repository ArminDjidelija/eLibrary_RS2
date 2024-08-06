import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/clanarina.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/clanarine_provider.dart';
import 'package:elibrary_bibliotekar/screens/nova_clanarina_screen.dart';
import 'package:elibrary_bibliotekar/screens/tip_clanarine_biblioteka_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClanarineListScreen extends StatefulWidget {
  const ClanarineListScreen({super.key});

  @override
  State<ClanarineListScreen> createState() => _ClanarineListScreenState();
}

class _ClanarineListScreenState extends State<ClanarineListScreen> {
  late ClanarineProvider provider;
  SearchResult<Clanarina>? result;
  List<Clanarina> data = [];
  late ClanarinaDataSource _source;
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

    provider = context.read<ClanarineProvider>();
    _source = ClanarinaDataSource(provider: provider, context: context);
    // updateFilter("");
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Članarine",
        Container(
          child: Column(
            children: [
              _buildSearch(),
              _isLoading ? Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
        ));
  }

  Future<void> updateFilter(String imePrezime) async {
    setState(() {
      _isLoading = true;
    });

    var filter = {
      'imePrezimeGTE': imePrezime,
      'page': page,
      'pageSize': pageSize,
      'includeTables': 'Biblioteka,Valuta'
    };
    print("Metoda u updatefilter");
    print(filter);
    result = await provider.get(filter: filter);
    setState(() {
      if (result != null) {
        data = result!.resultList;
        count = result!.count;
        // print(data);
      }
      _isLoading = false;
    });
  }

  TextEditingController _imePrezimeEditingController = TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Expanded(
          //     child: TextField(
          //   controller: _imePrezimeEditingController,
          //   decoration: const InputDecoration(labelText: "Ime prezime"),
          //   onChanged: (value) async {
          //     // page = 1;
          //     _source.filterServerSide(value);
          //     // await updateFilter(value, _autorEditingController.text);
          //   },
          // )),
          // const SizedBox(
          //   width: 8,
          // ),
          // ElevatedButton(
          //     onPressed: () async {
          //       // updateFilter(_naslovEditingController.text,
          //       //     _autorEditingController.text);
          //       _source.filterServerSide(_imePrezimeEditingController.text);
          //       setState(() {});
          //     },
          //     child: const Text("Pretraga")),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                //
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NovaClanarinaScreen()));
              },
              child: const Text("Nova clanarina")),
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
                    child: Text("Citalac"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Tip clanarine"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Iznos"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Pocetak clanarine"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Kraj clanarine"),
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

class ClanarinaDataSource extends AdvancedDataTableSource<Clanarina> {
  List<Clanarina>? data = [];
  final ClanarineProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  dynamic filter;
  BuildContext context;
  ClanarinaDataSource({required this.provider, required this.context});

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
        //               builder: (context) => TipClanarineBibliotekaDetailsScreen(
        //                     tipClanarineBiblioteka: item,
        //                   ))),
        //         }
        //     },
        cells: [
          DataCell(Container(
            alignment: Alignment.centerLeft,
            // child: Text("${item!.citalac!.ime} ${item!.citalac!.prezime}"),
            child: Text("${item!.citalac!.ime} ${item!.citalac!.prezime}"),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.tipClanarineBiblioteka!.naziv.toString()),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.iznos!.toStringAsFixed(2)),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(DateFormat("dd.MM.yyyy. HH:mm").format(
                DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
                    .parseStrict(item!.pocetak!.toString()))),
          )),

          DataCell(
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat("dd.MM.yyyy. HH:mm").format(
                    DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
                        .parseStrict(item!.kraj!.toString())),
              ),
            ),
          ),
          // DataCell(Text(item!.prezime.toString())),
          // DataCell(Text(item!.godinaRodjenja.toString())),
        ]);
  }

  void filterServerSide() {
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Clanarina>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    // filter = {
    //   'page': page,
    //   'pageSize': pageSize,
    //   'includeTables': 'Biblioteka,Valuta'
    // };
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        page: page,
        pageSize: pageSize,
        includeTables: "Citalac,Uplate,TipClanarineBiblioteka");
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
