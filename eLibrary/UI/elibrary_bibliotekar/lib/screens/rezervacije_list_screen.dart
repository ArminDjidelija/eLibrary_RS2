import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/models/rezervacija.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/pozajmice_provider.dart';
import 'package:elibrary_bibliotekar/providers/rezervacije_provider.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
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
  // SearchResult<Izdavac>? result;
  // List<Izdavac> data = [];
  late RezervacijaDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;

  List<String> allowedActions = [];
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
        Container(
          child: Column(
            children: [
              _buildSearch(),
              _isLoading ? Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
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
          ElevatedButton(
              onPressed: () async {
                //
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AutorDetailsScreen()));
              },
              child: const Text("Nova uplata")),
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
                    child: Text("Ime prezime"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Knjiga"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Datum kreiranja"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Stanje"),
                  )),
                  // DataColumn(
                  //     label: Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text("Odobrena"),
                  // )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Akcija"),
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

    return DataRow(
        // onSelectChanged: (selected) => {
        //       if (selected == true)
        //         {
        //           // Navigator.of(context).push(MaterialPageRoute(
        //           //     builder: (context) => AutorDetailsScreen(
        //           //           autor : item,
        //           //         ))),
        //         }
        //     },
        cells: [
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
            child: Text(
              DateFormat("dd.MM.yyyy. HH:mm").format(
                DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
                    .parseStrict(item!.datumKreiranja!.toString()),
              ),
            ),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item.state.toString()),
          )),
          DataCell(
            FutureBuilder<List<String>>(
              future: getAllowedActions(item.rezervacijaId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error');
                } else if (!snapshot.hasData) {
                  return Text('No data');
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
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        filter: filter,
        page: page,
        pageSize: pageSize,
        includeTables: "Citalac,BibliotekaKnjiga.Knjiga",
        orderBy: "DatumKreiranja",
        sortDirection: "descending");
    if (result != null) {
      data = result!.resultList;
      count = result!.count;
      // print(data);
    }
    return RemoteDataSourceDetails(count, data!);
  }

  Future<Knjiga> fetchKnjiga(int? knjigaId) async {
    var knjiga = await this.knjigaProvider.getById(knjigaId!);
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
          // Prva akcija dugmeta
          QuickAlert.show(
              context: context,
              width: 450,
              type: QuickAlertType.confirm,
              title: "Jeste li sigurni?",
              text: "Da li želite odobriti rezervaciju?",
              confirmBtnText: "Da",
              cancelBtnText: "Ne",
              onConfirmBtnTap: () async {
                print("Potvrdeno: ${id}");
                await provider.odobri(id);

                filterServerSide("");
                Navigator.pop(context);
              },
              onCancelBtnTap: () {
                print("Cancel: ${id}");
                Navigator.pop(context);
              });
          print('First button pressed for item: ${id}');
        },
        child: const Text(
          'Odobri',
          style: TextStyle(color: Colors.white),
        ),
      ));
      buttons.add(SizedBox(
        width: 8,
      ));
    }

    if (allowedActions.contains('Zavrsi')) {
      buttons.add(ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)),
        onPressed: () {
          // Prva akcija dugmeta
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
                print("Potvrdeno: ${id}");
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NovaPozajmicaScreen(
                          bibliotekaKnjiga: rezervacija.bibliotekaKnjiga,
                          citalac: rezervacija.citalac,
                          rezervacija: rezervacija,
                        )));
                // Navigator.pop(context);
              },
              onCancelBtnTap: () {
                print("Cancel: ${id}");
                Navigator.pop(context);
              });
          print('First button pressed for item: ${id}');
        },
        child: const Text(
          'Kreiraj pozajmicu',
          style: TextStyle(color: Colors.white),
        ),
      ));
      buttons.add(SizedBox(
        width: 8,
      ));
    }

    if (allowedActions.contains('Ponisti')) {
      buttons.add(ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
        onPressed: () {
          // Druga akcija dugmeta
          QuickAlert.show(
              context: context,
              width: 450,
              type: QuickAlertType.confirm,
              title: "Jeste li sigurni?",
              text: "Da li želite poništiti rezervaciju?",
              confirmBtnText: "Da",
              cancelBtnText: "Ne",
              onConfirmBtnTap: () async {
                print("Ponisteno: ${id}");
                await provider.ponisti(id);
                filterServerSide("");
                Navigator.pop(context);
              },
              onCancelBtnTap: () {
                print("Cancel: ${id}");
                Navigator.pop(context);
              });
          print('Second button pressed for item: ${id}');
        },
        child: const Text(
          'Poništi',
          style: TextStyle(color: Colors.white),
        ),
      ));
      buttons.add(SizedBox(
        width: 8,
      ));
    }

    if (allowedActions.contains('Obnovi')) {
      buttons.add(ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
        onPressed: () {
          // Druga akcija dugmeta
          QuickAlert.show(
              context: context,
              width: 450,
              type: QuickAlertType.confirm,
              title: "Jeste li sigurni?",
              text: "Da li želite obnoviti rezervaciju?",
              confirmBtnText: "Da",
              cancelBtnText: "Ne",
              onConfirmBtnTap: () async {
                print("Odobreno: ${id}");
                await provider.obnovi(id);
                filterServerSide("");
                Navigator.pop(context);
              },
              onCancelBtnTap: () {
                print("Cancel: ${id}");
                Navigator.pop(context);
              });
          print('Second button pressed for item: ${id}');
        },
        child: const Text(
          'Obnovi',
          style: TextStyle(color: Colors.white),
        ),
      ));
      buttons.add(SizedBox(
        width: 8,
      ));
    }

    return buttons;
  }
}
