import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_uposleni.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_uposleni_provider.dart';
import 'package:elibrary_bibliotekar/screens/novi_uposleni_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BibliotekaUposleniListScreen extends StatefulWidget {
  const BibliotekaUposleniListScreen({super.key});

  @override
  State<BibliotekaUposleniListScreen> createState() =>
      _BibliotekaUposleniListScreenState();
}

class _BibliotekaUposleniListScreenState
    extends State<BibliotekaUposleniListScreen> {
  late BibliotekaUposleniProvider provider;

  late BibliotekaUposlenikDataSource _source;

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
    provider = context.read<BibliotekaUposleniProvider>();
    _source =
        BibliotekaUposlenikDataSource(provider: provider, context: context);
  }

  TextEditingController _imePrezimeEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Uposleni biblioteka",
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
              _source.filterServerSide(value, _emailEditingController.text);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            controller: _emailEditingController,
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
                    _emailEditingController.text);
              },
              child: const Text("Pretraga")),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                //
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoviUposleniScreen()));
              },
              child: const Text("Novi uposleni")),
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
                  DataColumn(label: Text("Korisnicko ime")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Akcija")),
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

class BibliotekaUposlenikDataSource
    extends AdvancedDataTableSource<BibliotekaUposleni> {
  List<BibliotekaUposleni>? data = [];
  final BibliotekaUposleniProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezime = "";
  String email = "";
  dynamic filter;
  BuildContext context;
  BibliotekaUposlenikDataSource(
      {required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Text(item!.korisnik!.ime.toString())),
      DataCell(Text(item!.korisnik!.prezime.toString())),
      DataCell(Text(item!.korisnik!.korisnickoIme.toString())),
      DataCell(Text(item!.korisnik!.email.toString())),
      DataCell(
        ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
            onPressed: () async {
              try {
                await provider.delete(item.bibliotekaUposleniId!);
                filterServerSide("", "");
              } on Exception catch (e) {}
            },
            child: const Text(
              "Izbrisi",
              style: TextStyle(color: Colors.white),
            )),
      )
    ]);
  }

  void filterServerSide(imePrezimeGTE, mail) {
    imePrezime = imePrezimeGTE;
    email = mail;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<BibliotekaUposleni>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezime,
      'emailGTE': email,
      'bibliotekaId': AuthProvider.bibliotekaId
    };
    print(filter);
    var result = await provider.get(
      page: page,
      pageSize: pageSize,
      includeTables: 'Korisnik,Biblioteka',
      filter: filter,
    );
    print(result);
    if (result != null) {
      data = result.resultList;
      count = result.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
