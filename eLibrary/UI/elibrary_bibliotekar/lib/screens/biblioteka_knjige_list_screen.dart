import 'dart:async';
import 'dart:ffi';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:elibrary_bibliotekar/screens/knjiga_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BibliotekaKnjigeListScreen extends StatefulWidget {
  const BibliotekaKnjigeListScreen({super.key});

  @override
  State<BibliotekaKnjigeListScreen> createState() =>
      _BibliotekaKnjigeListScreenState();
}

class _BibliotekaKnjigeListScreenState
    extends State<BibliotekaKnjigeListScreen> {
  late BibliotekaKnjigaProvider provider;
  SearchResult<BibliotekaKnjiga>? result;
  List<BibliotekaKnjiga> data = [];
  late KnjigaDataSource _source;
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
    // TODO: implement initState

    super.initState();
    provider = context.read<BibliotekaKnjigaProvider>();
    _source = KnjigaDataSource(provider: provider, context: context);
    //updateFilter("", "");
    // initForm();
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Biblioteka knjige",
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
  TextEditingController _autorEditingController = TextEditingController();
  TextEditingController _isbnEditingController = TextEditingController();

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _naslovEditingController,
            decoration: const InputDecoration(labelText: "Naziv"),
            onChanged: (value) async {
              // page = 1;
              _source.filterServerSide(value, _autorEditingController.text,
                  _isbnEditingController.text);
              // await updateFilter(value, _autorEditingController.text);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            controller: _autorEditingController,
            decoration: const InputDecoration(labelText: "Autor"),
            onChanged: (value) async {
              // page = 1;
              // await updateFilter(_naslovEditingController.text, value);
              _source.filterServerSide(_naslovEditingController.text, value,
                  _isbnEditingController.text);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            controller: _isbnEditingController,
            decoration: const InputDecoration(labelText: "ISBN"),
            onChanged: (value) async {
              // page = 1;
              // await updateFilter(_naslovEditingController.text, value);
              _source.filterServerSide(_naslovEditingController.text,
                  _autorEditingController.text, value);
            },
          )),
          ElevatedButton(
              onPressed: () async {
                var filter = {
                  'naslovGTE': _naslovEditingController.text,
                  'autor': _autorEditingController.text
                };
                // updateFilter(_naslovEditingController.text,
                //     _autorEditingController.text);
                _source.filterServerSide(_naslovEditingController.text,
                    _autorEditingController.text, _isbnEditingController.text);
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
                    builder: (context) => KnjigaDetailsScreen()));
              },
              child: const Text("Nova knjiga")),
        ],
      ),
    );
  }

  Future<void> updateFilter(String naslov, String autor, String isbn) async {
    _source.filterServerSide("", "", "");
    setState(() {
      _isLoading = true;
    });

    var filter = {
      // 'naslovGTE': naslov,
      // 'autor': autor,
      'page': page,
      'pageSize': pageSize,
      'bibliotekaId': 2,
      'includeTables': 'Knjiga'
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

  void _loadMoreData(String naslov, String autor) {
    if (!_isLoading) {
      // setState(() {
      //   page++;
      // });
      updateFilter(naslov, autor, "");
    }
  }

  Widget _buildPaginatedTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: AdvancedPaginatedDataTable(
              dataRowHeight: 75,
              columns: [
                DataColumn(label: Text("Naziv")),
                DataColumn(label: Text("ISBN")),
                DataColumn(label: Text("Godina izdanja")),
                DataColumn(label: Text("Broj izdanja")),
                DataColumn(label: Text("Broj stranica")),
                DataColumn(label: Text("Slika")),
              ],
              source: _source,
              addEmptyRows: false,
            )
            // PaginatedDataTable(
            //   header: Text("Knjige:"),
            //   rowsPerPage: pageSize,
            //   availableRowsPerPage: const [10, 25, 50],
            //   onRowsPerPageChanged: (value) {
            //     setState(() {
            //       pageSize = value!;
            //       _loadMoreData("", "");
            //     });
            //   },
            //   onPageChanged: (value) {
            //     setState(() {
            //       //page se odnosi na indeks, odnosno ako je page size 10, na drugoj stranici value=10
            //       page = (value ~/ pageSize).toInt() + 1;
            //       _loadMoreData("", "");
            //     });
            //   },
            //   columns: [
            //     DataColumn(label: Text("Naziv")),
            //     DataColumn(label: Text("ISBN")),
            //     DataColumn(label: Text("Godina izdanja")),
            //     DataColumn(label: Text("Broj izdanja")),
            //     DataColumn(label: Text("Broj stranica")),
            //     DataColumn(label: Text("Slika")),
            //   ],
            //   source: _KnjigaDataSource(
            //       data: data, count: count, page: page, pageSize: pageSize),
            // )
            ),
      ),
    );
  }

  // Future<List<BibliotekaKnjiga>> _getKnjige() async {
  //   var lista = await provider.get();
  //   return lista.resultList;
  // }

  Future initForm() async {
    await updateFilter("", "", "");
  }
}

class KnjigaDataSource extends AdvancedDataTableSource<BibliotekaKnjiga> {
  List<BibliotekaKnjiga>? data = [];
  final BibliotekaKnjigaProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String autor = "";
  String naslov = "";
  String isbn = "";
  dynamic filter;
  BuildContext context;
  KnjigaDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        selected: false,
        onSelectChanged: (selected) => {
              selected = selected ?? false,
              if (selected == true)
                {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => KnjigaDetailsScreen(
                  //           knjiga: item,
                  //         ))),
                }
            },
        cells: [
          DataCell(Text(item!.knjiga!.naslov.toString())),
          DataCell(Text(item!.knjiga!.isbn.toString())),
          DataCell(Text(item!.knjiga!.godinaIzdanja.toString())),
          DataCell(Text(item!.knjiga!.brojIzdanja.toString())),
          DataCell(Text(item!.knjiga!.brojStranica.toString())),
          DataCell(item!.knjiga!.slika != null
              ? Container(
                  width: 75,
                  height: 75,
                  child: imageFromString(item.knjiga!.slika!),
                )
              : const Text("")),
        ]);
  }

  void filterServerSide(naslovv, autorr, isbnn) {
    naslov = naslovv;
    autor = autorr;
    isbn = isbnn;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<BibliotekaKnjiga>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'naslovGTE': naslov,
      'autorGTE': autor,
      'isbn': isbn,
      'page': page,
      'pageSize': pageSize,
      'bibliotekaId': 2,
      'includeTables': 'Knjiga'
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
