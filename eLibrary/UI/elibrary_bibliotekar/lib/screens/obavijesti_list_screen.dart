import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/obavijest.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/obavijesti_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/knjiga_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/obavijest_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObavijestiListScreen extends StatefulWidget {
  const ObavijestiListScreen({super.key});

  @override
  State<ObavijestiListScreen> createState() => _ObavijestiListScreenState();
}

class _ObavijestiListScreenState extends State<ObavijestiListScreen> {
  late ObavijestiProvider provider;
  late ObavijestiDataSource _source;
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

    provider = context.read<ObavijestiProvider>();
    _source = ObavijestiDataSource(provider: provider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Obavijesti",
        Container(
          child: Column(
            children: [
              _buildSearch(),
              _isLoading ? Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
        ));
  }

  TextEditingController _naslovEditingController = TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _naslovEditingController,
            decoration: const InputDecoration(labelText: "Naslov"),
            onChanged: (value) async {
              _source.filterServerSide(value);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                _source.filterServerSide(_naslovEditingController.text);
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
                    builder: (context) => ObavijestDetailsScreen()));
              },
              child: const Text("Nova obavijest")),
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
                    child: Text("Naslov"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Datum"),
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

class ObavijestiDataSource extends AdvancedDataTableSource<Obavijest> {
  List<Obavijest>? data = [];
  final ObavijestiProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String naslovGTE = "";
  dynamic filter;
  BuildContext context;
  ObavijestiDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(
        Container(
          alignment: Alignment.centerLeft,
          child: Text("${item!.naslov}"),
        ),
      ),
      DataCell(
        Container(
          alignment: Alignment.centerLeft,
          child: Text(formatDateTimeToLocal(item.datum.toString())),
        ),
      ),
      DataCell(Row(
        children: [
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.blue)),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ObavijestDetailsScreen(
                          obavijest: item,
                        )));
              },
              child: const Text(
                "Uredi",
                style: TextStyle(color: Colors.white),
              )),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
              onPressed: () async {
                await provider.delete(item.obavijestId!);
                filterServerSide("");
              },
              child: const Text(
                "Izbrisi",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ))
    ]);
  }

  void filterServerSide(String naslov) {
    naslovGTE = naslov;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Obavijest>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'naslovGTE': naslovGTE,
      'bibliotekaId': AuthProvider.bibliotekaId
    };
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        filter: filter,
        page: page,
        pageSize: pageSize,
        orderBy: "Datum",
        sortDirection: "descending");
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
