import 'dart:io';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../models/autor.dart';

class AutoriListScreen extends StatefulWidget {
  const AutoriListScreen({super.key});

  @override
  State<AutoriListScreen> createState() => _AutoriListScreenState();
}

class _AutoriListScreenState extends State<AutoriListScreen> {
  late AutoriProvider provider;
  SearchResult<Autor>? result;
  List<Autor> data = [];
  late AutorDataSource _source;
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

    provider = context.read<AutoriProvider>();
    _source = AutorDataSource(provider: provider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Autori",
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
          ElevatedButton(
              onPressed: () async {
                //
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AutorDetailsScreen()));
              },
              child: const Text("Novi autor")),
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
                    child: const Text("Prezime"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Godina rodjenja"),
                  )),
                  if (AuthProvider.korisnikUloge!.any(
                      (element) => element.uloga!.naziv == "Administrator"))
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

class AutorDataSource extends AdvancedDataTableSource<Autor> {
  List<Autor>? data = [];
  final AutoriProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezimeGTE = "";
  dynamic filter;
  BuildContext context;
  AutorDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];
    if (AuthProvider.korisnikUloge!
        .any((element) => element.uloga!.naziv == "Administrator")) {
      return DataRow(
          // onSelectChanged: (selected) => {
          //       if (selected == true)
          //         {
          //           Navigator.of(context).push(MaterialPageRoute(
          //               builder: (context) => AutorDetailsScreen(
          //                     autor: item,
          //                   ))),
          //         }
          //     },
          cells: [
            DataCell(Container(
              alignment: Alignment.centerLeft,
              child: Text(item!.ime.toString()),
            )),
            DataCell(Container(
              alignment: Alignment.centerLeft,
              child: Text(item!.prezime.toString()),
            )),
            DataCell(Container(
              alignment: Alignment.centerLeft,
              child: Text(item.godinaRodjenja == null
                  ? "Nije uneseno"
                  : item.godinaRodjenja.toString()),
            )),
            DataCell(ElevatedButton(
                child: const Text(
                  "Detalji",
                  style: TextStyle(color: Colors.white),
                ),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AutorDetailsScreen(
                            autor: item,
                          )));
                }))
            // DataCell(Text(item!.prezime.toString())),
            // DataCell(Text(item!.godinaRodjenja.toString())),
          ]);
    } else {}

    return DataRow(
        // onSelectChanged: (selected) => {
        //       if (selected == true)
        //         {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) => AutorDetailsScreen(
        //                     autor: item,
        //                   ))),
        //         }
        //     },
        cells: [
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.ime.toString()),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.prezime.toString()),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item!.godinaRodjenja.toString()),
          )),
          // DataCell(Text(item!.prezime.toString())),
          // DataCell(Text(item!.godinaRodjenja.toString())),
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
  Future<RemoteDataSourceDetails<Autor>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezimeGTE,
    };
    try {
      var result =
          await provider?.get(filter: filter, page: page, pageSize: pageSize);
      if (result != null) {
        data = result!.resultList;
        count = result!.count;
        // print(data);
      }
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
