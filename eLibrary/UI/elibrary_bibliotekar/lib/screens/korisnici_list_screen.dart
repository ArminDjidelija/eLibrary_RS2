import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/korisnik.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/citaoci_provider.dart';
import 'package:elibrary_bibliotekar/providers/korisnici_provider.dart';
import 'package:elibrary_bibliotekar/screens/novi_citalac_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KorisniciListScreen extends StatefulWidget {
  const KorisniciListScreen({super.key});

  @override
  State<KorisniciListScreen> createState() => _KorisniciListScreenState();
}

class _KorisniciListScreenState extends State<KorisniciListScreen> {
  late KorisnikProvider provider;

  late KorisnikDataSource _source;

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
    provider = context.read<KorisnikProvider>();
    _source = KorisnikDataSource(provider: provider, context: context);
  }

  TextEditingController _imePrezimeEditingController = TextEditingController();
  TextEditingController _autorEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Korisnici",
        Container(
          child: Column(
            children: [
              _buildSearch(),
              _isLoading ? Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
        ));
  }

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
              _source.filterServerSide(value, _autorEditingController.text);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            controller: _autorEditingController,
            decoration: const InputDecoration(labelText: "Email"),
            onChanged: (value) async {
              // page = 1;
              // await updateFilter(_naslovEditingController.text, value);
              _source.filterServerSide(
                  _imePrezimeEditingController.text, value);
            },
          )),
          ElevatedButton(
              onPressed: () async {
                _source.filterServerSide(_imePrezimeEditingController.text,
                    _autorEditingController.text);
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
                    builder: (context) => NoviCitalacScreen()));
              },
              child: const Text("Novi čitalac")),
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
                columns: const [
                  DataColumn(label: Text("Ime")),
                  DataColumn(label: Text("Prezime")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Broj telefona")),
                  DataColumn(label: Text("Korisnicko ime")),
                  // DataColumn(label: Text("Slika")),
                ],
                source: _source,
                addEmptyRows: false,
              )),
        ),
      ),
    );
  }
}

class KorisnikDataSource extends AdvancedDataTableSource<Korisnik> {
  List<Korisnik>? data = [];
  final KorisnikProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezime = "";
  String korisnickoIme = "";
  dynamic filter;
  BuildContext context;
  KorisnikDataSource({required this.provider, required this.context});

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
        //               builder: (context) => KnjigaDetailsScreen(
        //                     knjiga: item,
        //                   ))),
        //         }
        //     },
        cells: [
          DataCell(Text(item!.ime.toString())),
          DataCell(Text(item!.prezime.toString())),
          DataCell(Text(item!.email.toString())),
          DataCell(Text(item!.telefon.toString())),
          DataCell(Text(item!.korisnickoIme.toString())),
        ]);
  }

  void filterServerSide(imePrezimeGTE, username) {
    imePrezime = imePrezimeGTE;
    korisnickoIme = username;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Korisnik>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezime,
      'korisnickoIme': korisnickoIme,
    };
    print("Metoda u get next row");
    print(filter);
    var result =
        await provider?.get(filter: filter, page: page, pageSize: pageSize);
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
