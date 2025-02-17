import 'dart:async';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_knjige_detalji_screen.dart';
import 'package:elibrary_bibliotekar/screens/knjiga_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    provider = context.read<BibliotekaKnjigaProvider>();
    _source = KnjigaDataSource(provider: provider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Biblioteka knjige",
        Container(
          child: Column(
            children: [
              _buildSearch(),
              _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
        ));
  }

  final TextEditingController _naslovEditingController =
      TextEditingController();
  final TextEditingController _autorEditingController = TextEditingController();
  final TextEditingController _isbnEditingController = TextEditingController();

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
              _source.filterServerSide(value, _autorEditingController.text,
                  _isbnEditingController.text);
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
              _source.filterServerSide(_naslovEditingController.text,
                  _autorEditingController.text, value);
            },
          )),
          ElevatedButton(
              onPressed: () async {
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

  Widget _buildPaginatedTable() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
              width: double.infinity,
              child: AdvancedPaginatedDataTable(
                dataRowHeight: 75,
                columns: const [
                  DataColumn(label: Text("Naziv")),
                  DataColumn(label: Text("ISBN")),
                  DataColumn(label: Text("Godina izdanja")),
                  DataColumn(label: Text("Slika")),
                  DataColumn(label: Text("Akcija")),
                ],
                source: _source,
                addEmptyRows: false,
              )),
        ),
      ),
    );
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

    return DataRow(cells: [
      DataCell(Text(item!.knjiga!.naslov.toString())),
      DataCell(Text(item!.knjiga!.isbn.toString())),
      DataCell(Text(item!.knjiga!.godinaIzdanja.toString())),
      DataCell(item!.knjiga!.slika != null
          ? Container(
              width: 75,
              height: 75,
              child: imageFromString(item.knjiga!.slika!),
            )
          : Image.asset(
              "assets/images/empty.png",
              height: 75,
              width: 75,
            )),
      DataCell(ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BibliotekaKnjigaDetailsScreen(
                      bibliotekaKnjiga: item,
                    )));
          },
          child: const Text(
            "Detalji",
            style: TextStyle(color: Colors.white),
          )))
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
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'naslovGTE': naslov,
      'autorGTE': autor,
      'isbn': isbn,
      'bibliotekaId': AuthProvider.bibliotekaId
    };

    try {
      var result = await provider?.get(
          filter: filter,
          page: page,
          pageSize: pageSize,
          includeTables: "Knjiga");
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
