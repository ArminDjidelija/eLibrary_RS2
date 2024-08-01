import 'package:elibrary_mobile/layouts/base_mobile_screen.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/models/vrsta_grade.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/vrsta_grade_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PocetnaKnjigaPretragaScreen extends StatefulWidget {
  String naslov = "";
  PocetnaKnjigaPretragaScreen({super.key, this.naslov = ""});

  @override
  State<PocetnaKnjigaPretragaScreen> createState() =>
      _PocetnaKnjigaPretragaScreenState();
}

class _PocetnaKnjigaPretragaScreenState
    extends State<PocetnaKnjigaPretragaScreen> {
  late VrstaGradeProvider vrstaGradeProvider;
  SearchResult<VrstaGrade>? vrstaGradeResult;

  late KnjigaProvider knjigaProvider;

  int page = 1;

  final int limit = 20;

  bool isFirstLoadRunning = false;
  bool hasNextPage = true;

  bool isLoadMoreRunning = false;

  List<Knjiga> knjige = [];

  late ScrollController scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    knjigaProvider = context.read<KnjigaProvider>();
    vrstaGradeProvider = context.read<VrstaGradeProvider>();

    _initForm();
    // _firstLoad();
    // scrollController = ScrollController()..addListener(_loadMore);
    // _initForm();
  }

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
    });

    var knjigeResult = await knjigaProvider.get(page: page, pageSize: 3);
    if (knjigeResult != null) {
      knjige = knjigeResult!.resultList;
    }

    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false) {
      setState(() {
        isLoadMoreRunning = true;
      });

      page += 1;
      var knjigeResult = await knjigaProvider.get(page: page, pageSize: 3);
      if (knjigeResult.resultList.isNotEmpty) {
        knjige.addAll(knjigeResult!.resultList);
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
    // return BaseMobileScreen(
    //   title: "Homepage",
    //   widget: _buildPage(),
    //   appBarWidget: _buildAppBarHeader(),
    // );

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
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pretraga...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: vrstaGradeResult?.resultList != null
                  ? ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: vrstaGradeResult!.resultList!
                          .map((e) => Text(e.naziv.toString()))
                          .toList(),
                    )
                  : Center(
                      child: Text("Nema podataka"),
                    ))
        ],
      ),
    );
  }

  Future _initForm() async {
    vrstaGradeResult = await vrstaGradeProvider.get(retrieveAll: true);

    setState(() {});
  }

  // Widget _buildPage() {
  //   return isFirstLoadRunning
  //       ? const Center(
  //           child: CircularProgressIndicator(),
  //         )
  //       : Column(
  //           children: [
  //             Expanded(
  //               child: ListView.builder(
  //                 itemCount: knjige.length,
  //                 controller: scrollController,
  //                 itemBuilder: (_, index) => Card(
  //                   margin:
  //                       const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
  //                   child: ListTile(
  //                     title: Text(knjige[index].naslov!),
  //                     subtitle: Text(knjige[index].godinaIzdanja.toString()),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             if (isLoadMoreRunning == true)
  //               const Padding(
  //                 padding: EdgeInsets.only(top: 10, bottom: 40),
  //                 child: Center(
  //                   child: CircularProgressIndicator(),
  //                 ),
  //               ),
  //             if (hasNextPage == false)
  //               Container(
  //                 padding: EdgeInsets.only(top: 30, bottom: 40),
  //                 color: Colors.amber,
  //                 child: const Center(
  //                   child: Text("Pregledali ste sve knjige!"),
  //                 ),
  //               )
  //           ],
  //         );
  // }
}
