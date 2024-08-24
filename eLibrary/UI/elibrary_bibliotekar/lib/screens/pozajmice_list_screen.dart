import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/pozajmice_provider.dart';
import 'package:elibrary_bibliotekar/providers/produzenje_pozajmice_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
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
  late PozajmicaDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;
  bool? vraceno = false;
  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
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
        Column(
          children: [
            _buildSearch(),
            _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
          ],
        ));
  }

  final TextEditingController _imeEditingController = TextEditingController();
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
              _source.filterServerSide(value, vraceno);
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
                  title: const Text("Vraceno?"),
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
                _source.filterServerSide(_imeEditingController.text, vraceno);
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
                    child: const Text("Datum preuzimanja"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Preporučeni rok vraćanja"),
                  )),
                  DataColumn(
                      label: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Vraćeno?"),
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
      ),
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

    return DataRow(cells: [
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text("${item!.citalac!.ime} ${item!.citalac!.prezime}"),
      )),
      DataCell(Container(
        alignment: Alignment.centerLeft,
        child: Text(item.bibliotekaKnjiga!.knjiga!.naslov.toString()),
      )),
      DataCell(Container(
          alignment: Alignment.centerLeft,
          child:
              Text(formatDateTimeToLocal(item.datumPreuzimanja.toString())))),
      DataCell(
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            formatDateTimeToLocal(item.preporuceniDatumVracanja.toString()),
          ),
        ),
      ),
      DataCell(item.stvarniDatumVracanja == null
          ? const Text("Ne")
          : const Text("Da")),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            item.stvarniDatumVracanja == null
                ? Row(
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.blue)),
                        onPressed: () {
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
                                try {
                                  await provider
                                      .potvrdiPozajmicu(item.pozajmicaId!);
                                } on Exception catch (e) {}
                                filterServerSide("", vraceno);
                                Navigator.pop(context);
                              },
                              onCancelBtnTap: () {
                                print("Cancel: ${item.pozajmicaId}");
                                Navigator.pop(context);
                              });
                        },
                        child: const Text(
                          'Potvrdi vraćanje',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (item.produzenjePozajmicas != null &&
                          item.produzenjePozajmicas!
                              .any((element) => element.odobreno == null))
                        ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.blue)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Odobrite produženje"),
                                  content: Text(
                                      "Zahtjev za produženjem pozajmice za ${item.produzenjePozajmicas!.firstWhere((element) => element.odobreno == null).produzenje} dana."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Zatvara dijalog
                                      },
                                      child: const Text("Odustani"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        var provider =
                                            new ProduzenjePozajmiceProvider();
                                        try {
                                          await provider.update(
                                              item.produzenjePozajmicas!
                                                  .firstWhere((element) =>
                                                      element.odobreno == null)
                                                  .produzenjePozajmiceId!,
                                              {'odobreno': false});
                                        } on Exception catch (e) {}
                                        Navigator.of(context).pop();
                                        filterServerSide("", false);
                                      },
                                      child: const Text("Poništi"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        var provider =
                                            new ProduzenjePozajmiceProvider();
                                        await provider.update(
                                            item.produzenjePozajmicas!
                                                .firstWhere((element) =>
                                                    element.odobreno == null)
                                                .produzenjePozajmiceId!,
                                            {'odobreno': true});
                                        Navigator.of(context).pop();
                                        filterServerSide("", false);
                                      },
                                      child: const Text("Odobri"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Produženje',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.blue)),
                          onPressed: () async {
                            try {
                              await provider.obavijesti(item.pozajmicaId!);
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  title: "Uspješno poslana obavijest");
                            } on Exception catch (e) {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: e.toString());
                            }
                          },
                          child: const Text(
                            "Obavijest",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )
                : ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PozajmicaDetailsScreen(
                                pozajmica: item,
                              )));
                    },
                    child: const Text(
                      'Detalji',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            const SizedBox(width: 8),
            item.stvarniDatumVracanja != null
                ? ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.red)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NoviPenalScreen(
                                pozajmica: item,
                              )));
                    },
                    child: const Text(
                      'Dodaj penale',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : const Text(""),
          ],
        ),
      )
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
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezimeGTE,
      'vraceno': vraceno,
      'bibliotekaId': AuthProvider.bibliotekaId
    };
    try {
      var result = await provider.get(
          page: page,
          pageSize: pageSize,
          includeTables: "Citalac,BibliotekaKnjiga.Knjiga,ProduzenjePozajmicas",
          orderBy: "DatumPreuzimanja",
          sortDirection: "descending",
          filter: filter);
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
    var knjiga = await this.knjigaProvider.getById(knjigaId!);
    return knjiga;
  }
}
