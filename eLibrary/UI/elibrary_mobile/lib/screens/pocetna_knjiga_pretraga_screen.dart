import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/models/vrsta_grade.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/vrsta_grade_provider.dart';
import 'package:elibrary_mobile/screens/napredna_pretraga_knjige_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  int _selectedVrstaGrade = 0;

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
    super.initState();

    knjigaProvider = context.read<KnjigaProvider>();
    vrstaGradeProvider = context.read<VrstaGradeProvider>();

    _initForm();
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

  final TextEditingController _naslovEditingController =
      TextEditingController();

  Widget _buildAppBarHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _naslovEditingController,
              decoration: const InputDecoration(
                hintText: 'Naslov knjige',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NaprednaPretragaKnjiga(
                        vrstaGradeId: _selectedVrstaGrade,
                        naslov: _naslovEditingController.text,
                      )));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: vrstaGradeResult?.resultList != null
                  ? ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: vrstaGradeResult!.resultList!
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: RadioListTile<int>(
                                  title: Text(
                                    e.naziv.toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  value: e.vrstaGradeId!,
                                  groupValue: _selectedVrstaGrade,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedVrstaGrade = value!;
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    )
                  : const Center(
                      child: Text("Nema podataka"),
                    )),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NaprednaPretragaKnjiga(
                          vrstaGradeId: _selectedVrstaGrade,
                          naslov: _naslovEditingController.text,
                        )));
              },
              child: Icon(Icons.search),
            ),
          )
        ],
      ),
    );
  }

  Future _initForm() async {
    try {
      vrstaGradeResult = await vrstaGradeProvider.get(retrieveAll: true);
    } on Exception catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Greška",
          text: e.toString());
      return;
    }
    var pocetni = VrstaGrade();
    pocetni.vrstaGradeId = 0;
    pocetni.naziv = "Bilo koji tip građe";
    if (vrstaGradeResult?.resultList != null) {
      vrstaGradeResult?.resultList.insert(0, pocetni);
    } else {
      vrstaGradeResult?.resultList = [pocetni];
    }
    setState(() {});
  }
}
