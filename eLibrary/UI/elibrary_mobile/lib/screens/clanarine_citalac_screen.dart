import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/clanarina.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/rezervacija.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_mobile/providers/biblioteka_provider.dart';
import 'package:elibrary_mobile/providers/clanarine_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/rezervacije_provider.dart';
import 'package:elibrary_mobile/providers/tip_clanarine_biblioteka_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:elibrary_mobile/screens/tip_clanarine_biblioteka_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ClanarineCitalacScreen extends StatefulWidget {
  const ClanarineCitalacScreen({super.key});

  @override
  State<ClanarineCitalacScreen> createState() => _ClanarineCitalacScreenState();
}

class _ClanarineCitalacScreenState extends State<ClanarineCitalacScreen> {
  late KnjigaProvider knjigaProvider;
  late BibliotekaProvider bibliotekaProvider;
  late ClanarineProvider clanarineProvider;
  late TipClanarineBibliotekaProvider tipClanarineBibliotekaProvider;

  List<Clanarina> clanarine = [];
  List<Biblioteka> biblioteke = [];
  List<TipClanarineBiblioteka> tipClanarineBiblioteke = [];

  int page = 1;

  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;

  bool isLoadMoreRunning = false;
  late ScrollController scrollController;

  Biblioteka? odabranaBiblioteka;
  int bibliotekaId = 0;

  TipClanarineBiblioteka? odabraniTipClanarine;
  int tipClanarineId = 0;

  @override
  void initState() {
    super.initState();
    knjigaProvider = context.read<KnjigaProvider>();
    bibliotekaProvider = context.read<BibliotekaProvider>();
    clanarineProvider = context.read<ClanarineProvider>();
    tipClanarineBibliotekaProvider =
        context.read<TipClanarineBibliotekaProvider>();

    _firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);

    _initForm();
  }

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      clanarine = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    var clanarineResult = await clanarineProvider.get(
        page: page,
        pageSize: 10,
        orderBy: 'Pocetak',
        sortDirection: 'descending',
        includeTables: 'Biblioteka,TipClanarineBiblioteka,Uplate.Valuta');

    clanarine = clanarineResult!.resultList;
    total = clanarineResult!.count;

    setState(() {
      isFirstLoadRunning = false;
      total = clanarineResult!.count;
      if (10 * page > total) {
        hasNextPage = false;
      }
    });
  }

  void _loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 300) {
      setState(() {
        isLoadMoreRunning = true;
      });
      if (!hasNextPage) {
        return;
      }
      page += 1;

      var clanarineResult = await clanarineProvider.get(
          page: page,
          pageSize: 10,
          orderBy: 'Pocetak',
          sortDirection: 'descending',
          includeTables: 'Biblioteka,TipClanarineBiblioteka,Uplate.Valuta');

      if (clanarineResult!.resultList.isNotEmpty) {
        clanarine.addAll(clanarineResult!.resultList);
      } else {
        setState(() {
          hasNextPage = false;
        });
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  Future _initForm() async {
    // setState(() {});
  }

  Future<List<Biblioteka>> getBiblioteke(String? naziv) async {
    var biblioteke = await bibliotekaProvider
        .get(filter: {'nazivGTE': naziv}, page: 1, pageSize: 10);

    return biblioteke.resultList;
  }

  Future<List<TipClanarineBiblioteka>> getTipoviClanarina() async {
    var tipovi = await tipClanarineBibliotekaProvider.get(
        filter: {'bibliotekaId': bibliotekaId > 0 ? bibliotekaId : null},
        page: 1,
        pageSize: 10,
        includeTables: 'Valuta');

    return tipovi.resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBarHeader(),
        Expanded(
          child: _buildPage(),
        ),
      ],
    );
  }

  Widget _buildAppBarHeader() {
    return Container(
      // color: Colors.blue,
      // margin: EdgeInsets.only(bottom: 5),
      height: 75,
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: const Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Pozajmice",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   alignment: Alignment.centerLeft,
          //   margin: EdgeInsets.only(left: 10, top: 5),
          //   child: Text(
          //     "Trenutne pozajmice",
          //     style: TextStyle(fontSize: 24),
          //   ),
          // ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10, top: 5),
            child: Text(
              "Napravi članarinu:",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildBiblioteke(),
          _buildTipoviClanarina(),
          tipClanarineId > 0
              ? Container(
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.blue)),
                      onPressed: () => {},
                      child: Text(
                        "Nastavi na plaćanje",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              : Container(),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black, // Boja bordera
                  width: 2.0, // Širina bordera
                ),
              ),
            ),
            margin: EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Text(
              "Historija članarina",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildPrijasnjeClanarine(),
        ],
      ),
    );
  }

  Widget _buildPrijasnjeClanarine() {
    return isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            physics:
                NeverScrollableScrollPhysics(), // Disable ListView scrolling
            shrinkWrap: true, // Ensure ListView occupies only necessary space

            itemCount: clanarine.length + 1,
            controller: scrollController,
            itemBuilder: (_, index) {
              if (index == clanarine.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      hasNextPage
                          ? 'Učitavanje...'
                          : total != 0
                              ? 'Pregledali ste sve clanarine!'
                              : 'Nema više pozajmica',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              } else {
                return _buildPrijasnjaPozajmicaCard(
                    clanarina: clanarine[index]);
              }
            },
          );
  }

  Widget _buildPrijasnjaPozajmicaCard({required Clanarina clanarina}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Biblioteka', clanarina.biblioteka!.naziv.toString()),
            _buildInfoRow('Trajanje',
                "${formatDateToLocal(clanarina.pocetak.toString())} do ${formatDateToLocal(clanarina.kraj.toString())}"),
            _buildInfoRow('Iznos',
                "${clanarina.uplate!.iznos.toString()} ${clanarina.uplate!.valuta!.skracenica.toString()}"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Future<Knjiga> getKnjiga(int knjigaId) async {
    var knjiga = await knjigaProvider.getById(knjigaId);
    return knjiga;
  }

  Future<Biblioteka> getBiblioteka(int bibliotekaId) async {
    var biblioteka = await bibliotekaProvider.getById(bibliotekaId);
    return biblioteka;
  }

  Widget _buildBiblioteke() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownSearch<Biblioteka>(
        selectedItem: odabranaBiblioteka,
        popupProps: PopupPropsMultiSelection.menu(
          isFilterOnline: true,
          showSearchBox: true,
          searchDelay: Duration(milliseconds: 5),
        ),
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Odaberi biblioteku",
            hintText: "Unesite naziv biblioteke",
          ),
        ),
        asyncItems: (String filter) async {
          var biblioteke = await getBiblioteke(filter);
          return biblioteke;
        },
        onChanged: (Biblioteka? c) {
          bibliotekaId = c!.bibliotekaId!;
          setState(() {});
          odabranaBiblioteka = c;
        },
        itemAsString: (Biblioteka u) => "${u.naziv}",
        onSaved: (newValue) {
          if (newValue != null) {
            print(newValue.bibliotekaId);
          }
        },
      ),
    );
  }

  Widget _buildTipoviClanarina() {
    return bibliotekaId > 0
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: DropdownSearch<TipClanarineBiblioteka>(
              selectedItem: odabraniTipClanarine,
              popupProps: PopupPropsMultiSelection.menu(
                  // isFilterOnline: true,
                  // showSearchBox: true,
                  // searchDelay: Duration(milliseconds: 5),
                  ),
              // dropdownDecoratorProps: const DropDownDecoratorProps(
              //   dropdownSearchDecoration: InputDecoration(
              //     labelText: "Odaberi tip clanarine",
              //     hintText: "Unesite naziv ",
              //   ),
              // ),
              asyncItems: (String filter) async {
                var tipovi = await getTipoviClanarina();
                return tipovi;
              },
              onChanged: (TipClanarineBiblioteka? c) {
                tipClanarineId = c!.tipClanarineBibliotekaId!;
                odabraniTipClanarine = c;
                setState(() {});
              },
              itemAsString: (TipClanarineBiblioteka u) =>
                  "${u.naziv}, ${u.trajanje} dana, ${u.iznos} ${u.valuta!.skracenica}",
              onSaved: (newValue) {
                if (newValue != null) {
                  print(newValue.bibliotekaId);
                }
              },
            ),
          )
        : Container();
  }
}
