import 'package:elibrary_mobile/models/obavijest.dart';
import 'package:elibrary_mobile/providers/obavijesti_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:elibrary_mobile/screens/obavijest_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ObavijestiScreen extends StatefulWidget {
  const ObavijestiScreen({super.key});

  @override
  State<ObavijestiScreen> createState() => _ObavijestiScreenState();
}

class _ObavijestiScreenState extends State<ObavijestiScreen> {
  late ObavijestiProvider obavijestiProvider;
  List<Obavijest> obavijesti = [];

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

    obavijestiProvider = context.read<ObavijestiProvider>();

    _firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);

    // _initForm();
  }

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      obavijesti = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    var obavijestiResult = await obavijestiProvider.get(
        page: page,
        pageSize: 10,
        includeTables: 'Biblioteka',
        orderBy: 'Datum',
        sortDirection: 'Descending');

    obavijesti = obavijestiResult.resultList;
    total = obavijestiResult.count;

    setState(() {
      isFirstLoadRunning = false;
      total = obavijestiResult!.count;
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

      var obavijestiResult = await obavijestiProvider.get(
          page: page,
          pageSize: 10,
          includeTables: 'Biblioteka',
          orderBy: 'Datum',
          sortDirection: 'Descending');

      if (obavijestiResult!.resultList.isNotEmpty) {
        obavijesti.addAll(obavijestiResult!.resultList);
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
          height: 75,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: const Row(
            children: [
              Text(
                "Obavijesti",
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
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, top: 5),
            child: const Text(
              "Obavijesti",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == obavijesti.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      hasNextPage
                          ? 'Učitavanje...'
                          : total != 0
                              ? 'Pregledali ste sve obavijesti!'
                              : 'Nema više obavijesti',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              } else {
                return _buildPrijasnjiPenalCard(obavijest: obavijesti[index]);
              }
            },
            childCount: obavijesti.length + 1,
          ),
        ),
      ],
    );
  }

  // Widget _buildPage() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [_buildObavijesti()],
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
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObavijesti() {
    return isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: obavijesti.length + 1,
            controller: scrollController,
            itemBuilder: (_, index) {
              if (index == obavijesti.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    hasNextPage
                        ? 'Učitavanje...'
                        : total != 0
                            ? 'Pregledali ste sve obavijesti!'
                            : 'Nema više obavijesti',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              } else {
                return _buildPrijasnjiPenalCard(obavijest: obavijesti[index]);
              }
            },
          );
  }

  Widget _buildPrijasnjiPenalCard({required Obavijest obavijest}) {
    return InkWell(
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ObavijestScreen(
                  obavijest: obavijest,
                )))
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: const Icon(Icons.newspaper),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          obavijest.naslov.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text(
                              formatDateTimeToLocal(obavijest.datum.toString()),
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              obavijest.biblioteka!.naziv.toString(),
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black, // Boja obruba
                      width: 1.0, // Širina obruba
                    ),
                  ),
                ),
                child: Text(
                  obavijest.tekst!.length > 100
                      ? obavijest.tekst!.substring(0, 100) + '...'
                      : obavijest.tekst!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
