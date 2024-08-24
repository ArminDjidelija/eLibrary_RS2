import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/clanarina.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/clanarine_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:elibrary_bibliotekar/screens/nova_clanarina_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    provider = context.read<ClanarineProvider>();
    _source = ClanarinaDataSource(provider: provider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Članarine",
        Column(
          children: [
            _buildSearch(),
            _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
          ],
        ));
  }

  final TextEditingController _imePrezimeEditingController =
      TextEditingController();
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
              },
              child: const Text("Pretraga")),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NovaClanarinaScreen()));
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
                    child: const Text("Citalac"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Tip clanarine"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Iznos"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Pocetak clanarine"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Kraj clanarine"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Aktivna"),
                  )),
                ],
                source: _source,
                addEmptyRows: false,
              )),
        ),
      ),
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
  dynamic imePrezimeGTE;
  BuildContext context;
  ClanarinaDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text("${item!.citalac!.ime} ${item.citalac!.prezime}"),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(item.tipClanarineBiblioteka!.naziv.toString()),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(item.iznos!.toStringAsFixed(2)),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(formatDateTimeToLocal(item.pocetak!.toString())),
      )),
      DataCell(
        Container(
          alignment: Alignment.centerLeft,
          child: Text(formatDateTimeToLocal(item.kraj!.toString())),
        ),
      ),
      DataCell(DateTime.parse(item.kraj!).isAfter(DateTime.now())
          ? const Text("Da")
          : const Text("Ne")),
    ]);
  }

  void filterServerSide(imePrezime) {
    imePrezimeGTE = imePrezime;
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
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezimeGTE,
      'bibliotekaId': AuthProvider.bibliotekaId
    };

    try {
      var result = await provider.get(
          filter: filter,
          page: page,
          pageSize: pageSize,
          includeTables: "Citalac,Uplate,TipClanarineBiblioteka",
          orderBy: "ClanarinaId",
          sortDirection: "Descending");
      data = result.resultList;
      count = result.count;
    } on Exception catch (e) {
      QuickAlert.show(
          context: context,
          width: 450,
          type: QuickAlertType.error,
          text: "Greška prilikom dohvatanja podataka");
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
