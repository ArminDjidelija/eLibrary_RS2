import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/models/uplata.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/pozajmice_provider.dart';
import 'package:elibrary_bibliotekar/providers/uplate_provider.dart';
import 'package:elibrary_bibliotekar/screens/autor_details_screen.dart';
import 'package:elibrary_bibliotekar/screens/novi_penal_screen.dart';
import 'package:elibrary_bibliotekar/screens/pozajmica_detalji_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class PozajmiceListScreen extends StatefulWidget {
  const PozajmiceListScreen({super.key});

  @override
  State<PozajmiceListScreen> createState() => _PozajmiceListScreenState();
}

class _PozajmiceListScreenState extends State<PozajmiceListScreen> {
  late PozajmiceProvider provider;
  late KnjigaProvider knjigaProvider;
  // SearchResult<Izdavac>? result;
  // List<Izdavac> data = [];
  late PozajmicaDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;
  bool? vraceno = false;
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

    provider = context.read<PozajmiceProvider>();
    knjigaProvider = context.read<KnjigaProvider>();
    _source = PozajmicaDataSource(
        provider: provider, knjigaProvider: knjigaProvider, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Pozajmice",
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
              // page = 1;
              _source.filterServerSide(value, vraceno);
              // await updateFilter(value, _autorEditingController.text);
            },
          )),
          const SizedBox(
            width: 8,
          ),
          Container(
            width: 150,
            child: Container(
                width: 200,
                child: FormBuilderCheckbox(
                  title: Text("Vraceno"),
                  initialValue: false,
                  name: 'moguceProduziti',
                  onChanged: (value) => {
                    vraceno = value,
                    _source.filterServerSide(
                        _imeEditingController.text, vraceno)
                  },
                )),
          ),
          ElevatedButton(
              onPressed: () async {
                // updateFilter(_naslovEditingController.text,
                //     _autorEditingController.text);
                _source.filterServerSide(_imeEditingController.text, vraceno);
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
                    child: Text("Datum preuzimanja"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Preporučeni datum vraćanja"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Vraćeno?"),
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

class PozajmicaDataSource extends AdvancedDataTableSource<Pozajmica> {
  List<Pozajmica>? data = [];
  final PozajmiceProvider provider;
  final KnjigaProvider knjigaProvider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezimeGTE = "";
  bool vraceno = false;
  dynamic filter;
  BuildContext context;
  PozajmicaDataSource(
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
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) => AutorDetailsScreen(
        //                     autor : item,
        //                   ))),
        //         }
        //     },
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
                // return Column(
                //   crossAxisAlignment: CrossAxisAlignment.,
                //   children: [
                //     // Text('Autor: ${knjiga.autor}'),
                //     // Dodajte ostale atribute po potrebi
                //   ],
                // );
              }
            },
          )),
          DataCell(Container(
              alignment: Alignment.centerLeft,
              child: Text(DateFormat("dd.MM.yyyy. HH:mm").format(
                  DateFormat("yyyy-MM-ddTHH:mm:ss.SSS")
                      .parseStrict(item!.datumPreuzimanja.toString()))))),
          DataCell(
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat("dd.MM.yyyy. HH:mm").format(
                    DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parseStrict(
                        item!.preporuceniDatumVracanja.toString())),
              ),
            ),
          ),
          DataCell(item.stvarniDatumVracanja == null ? Text("Ne") : Text("Da")),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                item.stvarniDatumVracanja == null
                    ? ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.blue)),
                        onPressed: () {
                          // Prva akcija dugmeta
                          print(
                              'First button pressed for item: ${item.trajanje}');
                          QuickAlert.show(
                              context: context,
                              width: 450,
                              type: QuickAlertType.confirm,
                              title: "Jeste li sigurni?",
                              text:
                                  "Da li želite potvrditi da je pozajmica uspješno vraćena?",
                              confirmBtnText: "Da",
                              cancelBtnText: "Ne",
                              onConfirmBtnTap: () async {
                                print("Potvrdeno: ${item.pozajmicaId}");
                                //TODO dodaj na api da je potvrdena,
                                await provider
                                    .potvrdiPozajmicu(item.pozajmicaId!);
                                filterServerSide("", null);
                                Navigator.pop(context);
                              },
                              onCancelBtnTap: () {
                                print("Cancel: ${item.pozajmicaId}");
                                Navigator.pop(context);
                              });
                        },
                        child: Text(
                          'Potvrdi vraćanje',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.blue)),
                        onPressed: () {
                          // Prva akcija dugmeta
                          print(
                              'First button pressed for item: ${item.trajanje}');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PozajmicaDetailsScreen(
                                    pozajmica: item,
                                  )));
                        },
                        child: Text(
                          'Detalji',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                SizedBox(width: 8), // Razmak između dugmadi
                item.stvarniDatumVracanja != null
                    ? ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.red)),
                        onPressed: () {
                          // Druga akcija dugmeta
                          print(
                              'Second button pressed for item: ${item.datumPreuzimanja}');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NoviPenalScreen(
                                    pozajmica: item,
                                  )));
                        },
                        child: Text(
                          'Dodaj penale',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Text(""),
              ],
            ),
          )
          // DataCell(Text(item!.prezime.toString())),
          // DataCell(Text(item!.godinaRodjenja.toString())),
        ]);
  }

  void filterServerSide(ime, checked) {
    imePrezimeGTE = ime;
    vraceno = checked;
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Pozajmica>> getNextPage(
      NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    print("Metoda u get next row");
    filter = {'imePrezimeGTE': imePrezimeGTE, 'vraceno': vraceno};
    var result = await provider?.get(
        page: page,
        pageSize: pageSize,
        includeTables: 'Citalac,BibliotekaKnjiga',
        orderBy: "DatumPreuzimanja",
        sortDirection: "descending",
        filter: filter);
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
