import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/izdavac.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/izdavac_provider.dart';
import 'package:elibrary_bibliotekar/screens/izdavac_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class IzdavaciListScreen extends StatefulWidget {
  const IzdavaciListScreen({super.key});

  @override
  State<IzdavaciListScreen> createState() => _IzdavaciListScreenState();
}

class _IzdavaciListScreenState extends State<IzdavaciListScreen> {
  late IzdavacProvider provider;
  SearchResult<Izdavac>? result;
  List<Izdavac> data = [];
  late IzdavacDataSource _source;
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
  }

  @override
  void initState() {
    super.initState();

    provider = context.read<IzdavacProvider>();
    _source = IzdavacDataSource(provider: provider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Izdavači",
        Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSearch(),
                _isLoading ? Text("Nema podataka") : _buildPaginatedTable()
              ],
            ),
          ),
        ));
  }

  Future<void> updateFilter(String imePrezime) async {
    setState(() {
      _isLoading = true;
    });

    var filter = {'nazivGTE': imePrezime, 'page': page, 'pageSize': pageSize};
    print("Metoda u updatefilter");
    print(filter);
    result = await provider.get(filter: filter);
    setState(() {
      if (result != null) {
        data = result!.resultList;
        count = result!.count;
      }
      _isLoading = false;
    });
  }

  TextEditingController _nazivEditingController = TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _nazivEditingController,
            decoration: const InputDecoration(labelText: "Naziv"),
            onChanged: (value) async {
              _source.filterServerSide(value);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                _source.filterServerSide(_nazivEditingController.text);
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
                    builder: (context) => IzdavacDetailsScreen()));
              },
              child: const Text("Novi izdavac")),
        ],
      ),
    );
  }

  Widget _buildPaginatedTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 600,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 600,
              child: AdvancedPaginatedDataTable(
                columns: [
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Naziv"),
                  )),
                  if (AuthProvider.korisnikUloge!.any(
                      (element) => element.uloga!.naziv == "Administrator"))
                    DataColumn(
                        label: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Akcija"),
                    )),
                ],
                source: _source,
                addEmptyRows: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IzdavacDataSource extends AdvancedDataTableSource<Izdavac> {
  List<Izdavac>? data = [];
  final IzdavacProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String nazivGTE = "";
  dynamic filter;
  BuildContext context;
  IzdavacDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    if (AuthProvider.korisnikUloge!
        .any((element) => element.uloga!.naziv == "Administrator")) {
      return DataRow(cells: [
        DataCell(Container(
          alignment: Alignment.centerLeft,
          child: Text(item!.naziv.toString()),
        )),
        DataCell(ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IzdavacDetailsScreen(
                        izdavac: item,
                      )));
            },
            child: const Text(
              "Detalji",
              style: TextStyle(color: Colors.white),
            )))
      ]);
    } else {
      return DataRow(cells: [
        DataCell(Container(
          alignment: Alignment.centerLeft,
          child: Text(item!.naziv.toString()),
        )),
      ]);
    }
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
  Future<RemoteDataSourceDetails<Izdavac>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {'nazivGTE': nazivGTE};

    try {
      var result =
          await provider.get(filter: filter, page: page, pageSize: pageSize);
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
