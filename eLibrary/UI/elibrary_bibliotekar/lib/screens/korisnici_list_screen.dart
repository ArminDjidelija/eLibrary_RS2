import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/korisnik.dart';
import 'package:elibrary_bibliotekar/providers/korisnici_provider.dart';
import 'package:elibrary_bibliotekar/screens/novi_citalac_screen.dart';
import 'package:elibrary_bibliotekar/screens/novi_korisnik_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

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
  TextEditingController _emailEditingController = TextEditingController();

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
                    builder: (context) => NoviKorisnikScreen()));
              },
              child: const Text("Novi korisnik")),
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
                  DataColumn(label: Text("Broj telefona")),
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

class KorisnikDataSource extends AdvancedDataTableSource<Korisnik> {
  List<Korisnik>? data = [];
  final KorisnikProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezime = "";
  String email = "";
  dynamic filter;
  BuildContext context;
  KorisnikDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Text(item!.ime.toString())),
      DataCell(Text(item.prezime.toString())),
      DataCell(Text(item.korisnickoIme.toString())),
      DataCell(Text(item.email.toString())),
      DataCell(Text(item.telefon.toString())),
      DataCell(ElevatedButton(
        onPressed: () {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: "Da li ste sigurni da želite izbrisati ovog korisnika?",
              headerBackgroundColor: Colors.red,
              onConfirmBtnTap: () async => {
                    await provider.delete(item.korisnikId!),
                    Navigator.pop(context),
                    print("confirm"),
                    filterServerSide("", "")
                  },
              onCancelBtnTap: () async => {Navigator.pop(context)});
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
        child: const Text(
          "Izbrisi korisnika",
          style: TextStyle(color: Colors.white),
        ),
      ))
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
  Future<RemoteDataSourceDetails<Korisnik>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezime,
      'email': email,
    };
    print("Metoda u get next row");
    print(filter);
    var result =
        await provider.get(filter: filter, page: page, pageSize: pageSize);
    print(result);
    if (result != null) {
      data = result.resultList;
      count = result.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
