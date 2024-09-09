import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/penal.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/penali_provider.dart';
import 'package:elibrary_mobile/providers/tip_uplate_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class PenaliCitalacScreen extends StatefulWidget {
  String? secret;
  String? public;
  String? sandBoxMode;
  PenaliCitalacScreen({super.key}) {
    secret = const String.fromEnvironment("_paypalSecret", defaultValue: "");
    public = const String.fromEnvironment("_paypalPublic", defaultValue: "");
    sandBoxMode =
        const String.fromEnvironment("_sandBoxMode", defaultValue: "true");
  }

  @override
  State<PenaliCitalacScreen> createState() => _PenaliCitalacScreenState();
}

class _PenaliCitalacScreenState extends State<PenaliCitalacScreen> {
  late PenaliProvider penaliProvider;
  late TipUplateProvider tipUplateProvider;
  List<Penal> trenutniPenali = [];
  List<Penal> prijasnjiPenali = [];
  int? tipPlacanjaId;

  int page = 1;

  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;

  bool isLoadMoreRunning = false;
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    penaliProvider = context.read<PenaliProvider>();
    tipUplateProvider = context.read<TipUplateProvider>();

    _firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);

    _initForm();
  }

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      prijasnjiPenali = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    var prijasnjiPenaliResult = await penaliProvider.get(
        page: page,
        pageSize: 10,
        orderBy: 'PenalId',
        sortDirection: 'descending',
        filter: {'placeno': true, 'citalacId': AuthProvider.citalacId},
        includeTables: 'Uplata,Valuta');

    prijasnjiPenali = prijasnjiPenaliResult.resultList;
    total = prijasnjiPenaliResult.count;

    setState(() {
      isFirstLoadRunning = false;
      total = prijasnjiPenaliResult!.count;
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

      var prijasnjiPenaliResult = await penaliProvider.get(
          page: page,
          pageSize: 10,
          orderBy: 'PenalId',
          sortDirection: 'descending',
          filter: {'placeno': true, 'citalacId': AuthProvider.citalacId},
          includeTables: 'Uplata,Valuta');

      if (prijasnjiPenaliResult!.resultList.isNotEmpty) {
        prijasnjiPenali.addAll(prijasnjiPenaliResult!.resultList);
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
    var penaliResult = await penaliProvider.get(
        retrieveAll: true,
        includeTables: 'Pozajmica,Valuta',
        filter: {'placeno': false, 'citalacId': AuthProvider.citalacId});
    trenutniPenali = penaliResult.resultList;
    var tipoviUplatum =
        await tipUplateProvider.get(filter: {'naziv': 'online'});
    if (tipoviUplatum.resultList.isNotEmpty) {
      tipPlacanjaId = tipoviUplatum.resultList.first.tipUplateId;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          // color: Colors.blue,
          // margin: EdgeInsets.only(bottom: 5),
          height: 75,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: const Row(
            children: [
              Text(
                "Penali",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return CustomScrollView(
      controller: scrollController, // Attach your scroll controller here
      slivers: [
        // Trenutni penali section
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, top: 5),
            child: const Text(
              "Trenutni penali",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildTrenutniPenali(),
        ),

        // Historija penala section
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, top: 5),
            child: const Text(
              "Historija penala",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == prijasnjiPenali.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      hasNextPage
                          ? 'Učitavanje...'
                          : total != 0
                              ? 'Pregledali ste sve penale!'
                              : 'Nema više penala',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              } else {
                return _buildPrijasnjiPenalCard(penal: prijasnjiPenali[index]);
              }
            },
            childCount: prijasnjiPenali.length + 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTrenutniPenali() {
    if (trenutniPenali.isNotEmpty) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: trenutniPenali
            .map((e) => _buildTrenutniPenalCard(penal: e))
            .toList(),
      );
    } else {
      return Container(
        height: 50,
        child: const Center(
          child: Text("Nema penala za platiti"),
        ),
      );
    }
  }

  Widget _buildTrenutniPenalCard({required Penal penal}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Biblioteka>(
                future: getBibliotekaByPenal(penal.penalId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Greška sa učitavanjem',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      'Biblioteka: ${snapshot.data!.naziv}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return const Text(
                      'Nema biblioteke',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            ),
            _buildInfoRow('Razlog', penal.opis.toString()),
            _buildInfoRow(
                'Iznos', "${penal.iznos} ${penal.valuta!.skracenica}"),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.blue)),
                onPressed: () async {
                  try {
                    await makePayment(penal);
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: e.toString());
                  }
                },
                child: const Text(
                  "Plati",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrijasnjiPenalCard({required Penal penal}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Biblioteka>(
                future: getBibliotekaByPenal(penal.penalId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Greška sa učitavanjem',
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      'Biblioteka: ${snapshot.data!.naziv}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return const Text(
                      'Nema biblioteke',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            ),
            _buildInfoRow('Opis', penal.opis!),
            _buildInfoRow(
                'Iznos', "${penal.iznos} ${penal.valuta!.skracenica}"),
          ],
        ),
      ),
    );
  }

  Future<Biblioteka> getBibliotekaByPenal(int penalId) async {
    var penal = await penaliProvider.getById(penalId);
    var biblioteka = await penaliProvider.getBibliotekaByPenal(penalId);
    if (biblioteka != null) {
      return biblioteka;
    }
    var novaBiblioteka = Biblioteka();
    novaBiblioteka.naziv = "Nema biblioteke";
    return novaBiblioteka;
  }

  Future makePayment(Penal penal) async {
    var secret = dotenv.env['_paypalSecret'];
    var public = dotenv.env['_paypalPublic'];

    var valueSecret =
        (widget.secret == "" || widget.secret == null) ? secret : widget.secret;
    var valuePublic =
        (widget.public == "" || widget.public == null) ? public : widget.public;

    if ((valueSecret?.isEmpty ?? true) || (valuePublic?.isEmpty ?? true)) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Greška",
          text: "Greška sa plaćanjem");
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => PaypalCheckoutView(
              sandboxMode: widget.sandBoxMode == "true"
                  ? true
                  : widget.sandBoxMode == "false"
                      ? false
                      : true,
              clientId: valuePublic,
              secretKey: valueSecret,
              transactions: [
                {
                  "amount": {
                    "total": penal.iznos,
                    "currency": "USD",
                    "details": {
                      "subtotal": penal.iznos,
                      "shipping": '0',
                      "shipping_discount": 0
                    }
                  },
                  "description": "Platiti ce se penal.",
                  "item_list": {
                    "items": [
                      {
                        "name": "Penal",
                        "quantity": 1,
                        "price": penal.iznos,
                        "currency": "USD"
                      }
                    ],
                  }
                }
              ],
              note: "Kontaktirajte nas za bilo kakve poteskoce",
              onSuccess: (Map params) async {
                print("onSuccess: $params");
                try {
                  Navigator.pop(context);
                  await penaliProvider.Plati(penal.penalId!,
                      tipPlacanjaId == null ? 1 : tipPlacanjaId!);
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Uspješno kreirana članarina");
                  _firstLoad();
                  _initForm();
                } on Exception catch (e) {}
                Navigator.pop(context);
              },
              onError: (error) {
                print("onSuccess: $error");
                ("onError: $error");
                Navigator.pop(context);
              },
              onCancel: () {
                print('cancelled:');
                Navigator.pop(context);
              },
            )),
      ),
    );
  }
}
