import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/tip_clanarine_biblioteka_provider.dart';
import 'package:elibrary_bibliotekar/screens/tip_clanarine_biblioteka_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TipClanarineBibliotekaListScreen extends StatefulWidget {
  const TipClanarineBibliotekaListScreen({super.key});

  @override
  State<TipClanarineBibliotekaListScreen> createState() =>
      _TipClanarinaBibliotekaListScreenState();
}

class _TipClanarinaBibliotekaListScreenState
    extends State<TipClanarineBibliotekaListScreen> {
  late TipClanarineBibliotekaProvider provider;
  SearchResult<TipClanarineBiblioteka>? result;
  List<TipClanarineBiblioteka> data = [];
  late TipClanarinaBibliotekaDataSource _source;
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

    provider = context.read<TipClanarineBibliotekaProvider>();
    _source =
        TipClanarinaBibliotekaDataSource(provider: provider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Tipovi članarina",
        Column(
          children: [
            _buildSearch(),
            _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
          ],
        ));
  }

  final TextEditingController _trajanjeOdEditingController =
      TextEditingController();
  final TextEditingController _trajanjeDoEditingController =
      TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
              width: 300,
              child: TextField(
                controller: _trajanjeOdEditingController,
                decoration:
                    const InputDecoration(labelText: "Trajanje od (dani)"),
                onChanged: (value) async {
                  _source.filterServerSide(_trajanjeOdEditingController.text,
                      _trajanjeDoEditingController.text);
                },
              )),
          const SizedBox(
            width: 8,
          ),
          Container(
              width: 300,
              child: TextField(
                controller: _trajanjeDoEditingController,
                decoration:
                    const InputDecoration(labelText: "Trajanje do (dani)"),
                onChanged: (value) async {
                  _source.filterServerSide(_trajanjeOdEditingController.text,
                      _trajanjeDoEditingController.text);
                },
              )),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                //
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TipClanarineBibliotekaDetailsScreen()));
              },
              child: const Text("Novi tip clanarine")),
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
                    child: const Text("Naziv"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Trajanje (dani)"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Iznos"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Valuta"),
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

class TipClanarinaBibliotekaDataSource
    extends AdvancedDataTableSource<TipClanarineBiblioteka> {
  List<TipClanarineBiblioteka>? data = [];
  final TipClanarineBibliotekaProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  dynamic filter;
  dynamic trajanjeGTE;
  dynamic trajanjeLTE;
  BuildContext context;
  TipClanarinaBibliotekaDataSource(
      {required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        onSelectChanged: (selected) => {
              if (selected == true)
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TipClanarineBibliotekaDetailsScreen(
                            tipClanarineBiblioteka: item,
                          ))),
                }
            },
        cells: [
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.naziv.toString()),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.trajanje.toString()),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.iznos.toString()),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.valuta!.naziv.toString()),
          )),
        ]);
  }

  void filterServerSide(trajanjeOd, trajanjeDo) {
    trajanjeGTE = trajanjeOd;
    trajanjeLTE = trajanjeDo;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<TipClanarineBiblioteka>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'bibliotekaId': AuthProvider.bibliotekaId,
      'trajanjeGTE': trajanjeGTE,
      'trajanjeLTE': trajanjeLTE
    };

    try {
      var result = await provider.get(
          filter: filter,
          page: page,
          pageSize: pageSize,
          includeTables: "Biblioteka,Valuta");

      data = result!.resultList;
      count = result!.count;
    } on Exception catch (e) {
      print(e);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
