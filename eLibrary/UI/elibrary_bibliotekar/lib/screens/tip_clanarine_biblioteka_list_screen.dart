import 'dart:io';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_bibliotekar/providers/tip_clanarine_biblioteka_provider.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/tip_clanarine_biblioteka_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/autor.dart';

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

    provider = context.read<TipClanarineBibliotekaProvider>();
    _source =
        TipClanarinaBibliotekaDataSource(provider: provider, context: context);
    updateFilter("");
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Tipovi članarina",
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
                    child: Text("Biblioteka"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Naziv"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Trajanje (dani)"),
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
                ],
                source: _source,
                addEmptyRows: false,
              )),
        ),
      ), // Spacer(),
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
            child: Text(item!.biblioteka!.naziv.toString()),
          )),
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
  Future<RemoteDataSourceDetails<TipClanarineBiblioteka>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'page': page,
      'pageSize': pageSize,
      'includeTables': 'Biblioteka,Valuta'
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
