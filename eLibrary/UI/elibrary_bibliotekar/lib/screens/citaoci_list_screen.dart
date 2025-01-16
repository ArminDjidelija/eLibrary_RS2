import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/citaoci_provider.dart';
import 'package:elibrary_bibliotekar/screens/citalac_detalji_screen.dart';
import 'package:elibrary_bibliotekar/screens/novi_citalac_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CitaociListScreen extends StatefulWidget {
  const CitaociListScreen({super.key});

  @override
  State<CitaociListScreen> createState() => _CitaociListScreenState();
}

class _CitaociListScreenState extends State<CitaociListScreen> {
  late CitaociProvider provider;
  SearchResult<Citalac>? result;
  List<Citalac> data = [];
  late CitalacDataSource _source;
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
    provider = context.read<CitaociProvider>();
    _source = CitalacDataSource(provider: provider, context: context);
  }

  TextEditingController _imePrezimeEditingController = TextEditingController();
  TextEditingController _autorEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Čitaoci",
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
                  DataColumn(label: Text("Institucija")),
                ],
                source: _source,
                addEmptyRows: false,
              )),
        ),
      ),
    );
  }
}

class CitalacDataSource extends AdvancedDataTableSource<Citalac> {
  List<Citalac>? data = [];
  final CitaociProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezime = "";
  String email = "";
  dynamic filter;
  BuildContext context;
  CitalacDataSource({required this.provider, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        onSelectChanged: (selected) => {
              if (selected == true &&
                  !AuthProvider.korisnikUloge!.any(
                      (element) => element.uloga!.naziv == "Administrator"))
                {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CitalacDetaljiScreen(
                        citalac: item,
                      ),
                    ),
                  ),
                }
            },
        cells: [
          DataCell(Text(item!.ime.toString())),
          DataCell(Text(item.prezime.toString())),
          DataCell(Text(item.email.toString())),
          DataCell(Text(item.telefon.toString())),
          DataCell(Text(item.institucija == null
              ? "Nije uneseno"
              : item.institucija.toString())),
        ]);
  }

  void filterServerSide(imePrezimeGTE, emailContains) {
    imePrezime = imePrezimeGTE;
    email = emailContains;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Citalac>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezime,
      'emailContains': email,
      'bibliotekaId': AuthProvider.bibliotekaId
    };

    try {
      var result =
          await provider.get(filter: filter, page: page, pageSize: pageSize);

      data = result!.resultList;
      count = result!.count;
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
