import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/rezervacija.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/rezervacije_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:elibrary_bibliotekar/screens/nova_pozajmica_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RezervacijeListScreen extends StatefulWidget {
  const RezervacijeListScreen({super.key});

  @override
  State<RezervacijeListScreen> createState() => _PozajmiceListScreenState();
}

class _PozajmiceListScreenState extends State<RezervacijeListScreen> {
  late RezervacijeProvider provider;
  late KnjigaProvider knjigaProvider;
  late RezervacijaDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;

  List<String> allowedActions = [];
  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    provider = context.read<RezervacijeProvider>();
    knjigaProvider = context.read<KnjigaProvider>();
    _source = RezervacijaDataSource(
        provider: provider, knjigaProvider: knjigaProvider, context: context);
  }

  Future<List<String>> getAllowedActions(int id) async {
    var allowedActions = await provider.getAllowedActions(id);
    return allowedActions;
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Rezervacije",
        Column(
          children: [
            _buildSearch(),
            _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
          ],
        ));
  }

  TextEditingController _imeEditingController = TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _imeEditingController,
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
                _source.filterServerSide(_imeEditingController.text);
                setState(() {});
              },
              child: const Text("Pretraga")),
          const SizedBox(
            width: 8,
          ),
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
                    child: const Text("Ime prezime"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Knjiga"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Datum kreiranja"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Stanje"),
                  )),
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

class RezervacijaDataSource extends AdvancedDataTableSource<Rezervacija> {
  List<Rezervacija>? data = [];
  final RezervacijeProvider provider;
  final KnjigaProvider knjigaProvider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezimeGTE = "";
  dynamic filter;
  BuildContext context;
  RezervacijaDataSource(
      {required this.provider,
      required this.knjigaProvider,
      required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text("${item!.citalac!.ime} ${item!.citalac!.prezime}"),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(
            "${item.bibliotekaKnjiga!.knjiga!.naslov}, ${item.bibliotekaKnjiga!.knjiga!.godinaIzdanja}"),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(formatDateTimeToLocal(item!.datumKreiranja!.toString())),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(item.state.toString()),
      )),
      DataCell(
        FutureBuilder<List<String>>(
          key: ValueKey(item.rezervacijaId),
          future: getAllowedActions(item.rezervacijaId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Greška');
            } else if (!snapshot.hasData) {
              return const Text('Nema podataka');
            } else {
              return Row(
                children: buildActionButtons(
                    snapshot.data!, item.rezervacijaId!, item),
              );
            }
          },
        ),
      )
    ]);
  }

  void filterServerSide(ime) {
    imePrezimeGTE = ime;
    data = [];
    count = 0;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Rezervacija>> getNextPage(
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
          includeTables: "Citalac,BibliotekaKnjiga.Knjiga",
          orderBy: "DatumKreiranja",
          sortDirection: "descending");
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

  Future<Knjiga> fetchKnjiga(int? knjigaId) async {
    var knjiga = await knjigaProvider.getById(knjigaId!);
    return knjiga;
  }

  Future<List<String>> getAllowedActions(int id) async {
    var allowedActions = await provider.getAllowedActions(id);
    return allowedActions;
  }

  List<Widget> buildActionButtons(
      List<String> allowedActions, int id, Rezervacija rezervacija) {
    List<Widget> buttons = [];

    if (allowedActions.contains('Odobri')) {
      buttons.add(ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)),
        onPressed: () {
          QuickAlert.show(
              context: context,
              width: 450,
              type: QuickAlertType.confirm,
              title: "Jeste li sigurni?",
              text: "Da li želite odobriti rezervaciju?",
              confirmBtnText: "Da",
              cancelBtnText: "Ne",
              onConfirmBtnTap: () async {
                await provider.odobri(id);

                filterServerSide("");
                Navigator.pop(context);
              },
              onCancelBtnTap: () {
                Navigator.pop(context);
              });
        },
        child: const Text(
          'Odobri',
          style: TextStyle(color: Colors.white),
        ),
      ));
      buttons.add(const SizedBox(
        width: 8,
      ));
    }

    if (allowedActions.contains('Zavrsi')) {
      buttons.add(ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)),
        onPressed: () {
          QuickAlert.show(
              context: context,
              width: 450,
              type: QuickAlertType.confirm,
              title: "Jeste li sigurni?",
              text:
                  "Da li želite kreirati pozajmicu na osnovu ove rezervacije?",
              confirmBtnText: "Da",
              cancelBtnText: "Ne",
              onConfirmBtnTap: () async {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NovaPozajmicaScreen(
                          bibliotekaKnjiga: rezervacija.bibliotekaKnjiga,
                          citalac: rezervacija.citalac,
                          rezervacija: rezervacija,
                        )));
              },
              onCancelBtnTap: () {
                Navigator.pop(context);
              });
        },
        child: const Text(
          'Kreiraj pozajmicu',
          style: TextStyle(color: Colors.white),
        ),
      ));
      buttons.add(const SizedBox(
        width: 8,
      ));
    }

    if (allowedActions.contains('Ponisti')) {
      buttons.add(ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
        onPressed: () {
          QuickAlert.show(
              context: context,
              width: 450,
              type: QuickAlertType.confirm,
              title: "Jeste li sigurni?",
              text: "Da li želite poništiti rezervaciju?",
              confirmBtnText: "Da",
              cancelBtnText: "Ne",
              onConfirmBtnTap: () async {
                await provider.ponisti(id);
                filterServerSide("");
                Navigator.pop(context);
              },
              onCancelBtnTap: () {
                print("Cancel: ${id}");
                Navigator.pop(context);
              });
        },
        child: const Text(
          'Poništi',
          style: TextStyle(color: Colors.white),
        ),
      ));
      buttons.add(const SizedBox(
        width: 8,
      ));
    }

    if (allowedActions.contains('Obnovi')) {
      buttons.add(ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
        onPressed: () {
          QuickAlert.show(
              context: context,
              width: 450,
              type: QuickAlertType.confirm,
              title: "Jeste li sigurni?",
              text: "Da li želite obnoviti rezervaciju?",
              confirmBtnText: "Da",
              cancelBtnText: "Ne",
              onConfirmBtnTap: () async {
                await provider.obnovi(id);
                filterServerSide("");
                Navigator.pop(context);
              },
              onCancelBtnTap: () {
                print("Cancel: ${id}");
                Navigator.pop(context);
              });
        },
        child: const Text(
          'Obnovi',
          style: TextStyle(color: Colors.white),
        ),
      ));
      buttons.add(const SizedBox(
        width: 8,
      ));
    }

    return buttons;
  }
}
