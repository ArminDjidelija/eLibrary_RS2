import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/korisnik_sacuvana_knjiga.dart';
import 'package:elibrary_mobile/models/penal.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/korisnik_sacuvana_knjiga_provider.dart';
import 'package:elibrary_mobile/providers/penali_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:elibrary_mobile/screens/knjiga_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class SacuvaneKnjigeCitalacScreen extends StatefulWidget {
  const SacuvaneKnjigeCitalacScreen({super.key});

  @override
  State<SacuvaneKnjigeCitalacScreen> createState() =>
      _SacuvaneKnjigeCitalacScreenState();
}

class _SacuvaneKnjigeCitalacScreenState
    extends State<SacuvaneKnjigeCitalacScreen> {
  late KorisnikSacuvanaKnjigaProvider korisnikSacuvanaKnjigaProvider;
  List<KorisnikSacuvanaKnjiga> sacuvaneKnjige = [];

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

    korisnikSacuvanaKnjigaProvider =
        context.read<KorisnikSacuvanaKnjigaProvider>();

    _firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);

    // _initForm();
  }

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      sacuvaneKnjige = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    var sacuvaneKnjigeResult = await korisnikSacuvanaKnjigaProvider.get(
        filter: {'citalacId': AuthProvider.citalacId},
        page: page,
        pageSize: 10,
        includeTables: 'Knjiga.Uvez,Knjiga.Jezik,Knjiga.Izdavac');

    sacuvaneKnjige = sacuvaneKnjigeResult.resultList;
    total = sacuvaneKnjigeResult.count;

    setState(() {
      isFirstLoadRunning = false;
      total = sacuvaneKnjigeResult!.count;
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

      var sacuvaneKnjigeResult = await korisnikSacuvanaKnjigaProvider.get(
          page: page,
          filter: {'citalacId': AuthProvider.citalacId},
          pageSize: 10,
          includeTables: 'Knjiga.Uvez,Knjiga.Jezik,Knjiga.Izdavac');

      if (sacuvaneKnjigeResult!.resultList.isNotEmpty) {
        sacuvaneKnjige.addAll(sacuvaneKnjigeResult!.resultList);
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
                "Sačuvane knjige",
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
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, top: 5),
            child: const Text(
              "Sačuvane knjige",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == sacuvaneKnjige.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      hasNextPage
                          ? 'Učitavanje...'
                          : total != 0
                              ? 'Pregledali ste sve sačuvane knjige!'
                              : 'Nema više sačuvanih knjiga',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              } else {
                return _buildPrijasnjiPenalCard(knjiga: sacuvaneKnjige[index]);
              }
            },
            childCount: sacuvaneKnjige.length + 1,
          ),
        ),
      ],
    );
  }

  // Widget _buildPage() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [_buildPrijasnjePenale()],
  //     ),
  //   );
  // }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrijasnjePenale() {
    return isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: sacuvaneKnjige.length + 1,
            controller: scrollController,
            itemBuilder: (_, index) {
              if (index == sacuvaneKnjige.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    hasNextPage
                        ? 'Učitavanje...'
                        : total != 0
                            ? 'Pregledali ste sve sačuvane knjige!'
                            : 'Nema više sačuvanih knjiga',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              } else {
                return _buildPrijasnjiPenalCard(knjiga: sacuvaneKnjige[index]);
              }
            },
          );
  }

  Widget _buildPrijasnjiPenalCard({required KorisnikSacuvanaKnjiga knjiga}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.symmetric(horizontal: 5),
                color: Colors.blue,
                child: _buildInfoRow('Knjiga', knjiga.knjiga!.naslov!)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.red),
                    ),
                    onPressed: () {
                      _ukloniSacuvanuKnjigu(knjiga.korisnikSacuvanaKnjigaId);
                    },
                    child: Text(
                      "Ukloni",
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KnjigaScreen(
                                knjiga: knjiga.knjiga!,
                              )));
                    },
                    child: Text(
                      "Pogledaj knjigu",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future _ukloniSacuvanuKnjigu(int? korisnikSacuvanaKnjigaId) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Jeste li sigurni?",
      confirmBtnText: "Da",
      cancelBtnText: "Ne",
      onConfirmBtnTap: () async => {
        await korisnikSacuvanaKnjigaProvider.delete(korisnikSacuvanaKnjigaId!),
        setState(() {
          _firstLoad();
        })
      },
    );
  }
}
