import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_mobile/layouts/citalac_master_screen.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/rezervacija.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/rezervacije_provider.dart';
import 'package:elibrary_mobile/screens/autor_details_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return CitalacMasterScreen(
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
                    child: Text("Ponistena"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Odobrena"),
                  )),
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
        onSelectChanged: (selected) => {
              if (selected == true)
                {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => AutorDetailsScreen(
                  //           autor : item,
                  //         ))),
                }
            },
        cells: [
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text("${item!.citalac!.ime} ${item!.citalac!.prezime}"),
          )),
          DataCell(FutureBuilder<Knjiga>(
            future: fetchKnjiga(item!.bibliotekaKnjiga!.knjigaId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data');
              } else {
                final knjiga = snapshot.data!;
                return Text("${knjiga.naslov}, ${knjiga.godinaIzdanja}");
              }
            },
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
            child: Text(item.ponistena == true ? "Da" : "Ne"),
          )),
          DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Text(item.odobreno == true ? "Da" : "Ne"),
          )),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.blue)),
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
                        onConfirmBtnTap: () {
                          print("Potvrdeno: ${item.rezervacijaId}");
                          //TODO dodaj na api da je potvrdena,
                          filterServerSide("");
                          Navigator.pop(context);
                        },
                        onCancelBtnTap: () {
                          print("Cancel: ${item.rezervacijaId}");
                          Navigator.pop(context);
                        });
                    print(
                        'First button pressed for item: ${item.bibliotekaKnjiga}');
                  },
                  child: const Text(
                    'Odobri',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8), // Razmak između dugmadi
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.red)),
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
                        onConfirmBtnTap: () {
                          print("Potvrdeno: ${item.rezervacijaId}");
                          //TODO dodaj na api da je potvrdena,
                          filterServerSide("");
                          Navigator.pop(context);
                        },
                        onCancelBtnTap: () {
                          print("Cancel: ${item.rezervacijaId}");
                          Navigator.pop(context);
                        });
                    print('Second button pressed for item: ${item.citalacId}');
                  },
                  child: const Text(
                    'Poništi',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {'imePrezimeGTE': imePrezimeGTE};
    print("Metoda u get next row");
    print(filter);
    var result = await provider?.get(
        filter: filter,
        page: page,
        pageSize: pageSize,
        includeTables: "Citalac,BibliotekaKnjiga",
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
}
