import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/biblioteka.dart';
import 'package:elibrary_mobile/models/jezik.dart';
import 'package:elibrary_mobile/models/knjiga.dart';
import 'package:elibrary_mobile/providers/autori_provider.dart';
import 'package:elibrary_mobile/providers/biblioteka_provider.dart';
import 'package:elibrary_mobile/providers/jezici_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_autori_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/screens/knjiga_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NaprednaPretragaKnjiga extends StatefulWidget {
  String? naslov;
  int? vrstaGradeId;
  NaprednaPretragaKnjiga({super.key, this.naslov, this.vrstaGradeId});

  @override
  State<NaprednaPretragaKnjiga> createState() => _NaprednaPretragaKnjigaState();
}

class _NaprednaPretragaKnjigaState extends State<NaprednaPretragaKnjiga> {
  late KnjigaProvider knjigaProvider;
  late KnjigaAutoriProvider knjigaAutoriProvider;
  late BibliotekaProvider bibliotekaProvider;
  late JezikProvider jezikProvider;
  late AutoriProvider autoriProvider;

  int page = 1;

  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;

  bool isLoadMoreRunning = false;

  List<Knjiga> knjige = [];
  late ScrollController scrollController;

  String dropdown = 'Relevantnost';
  Map<String, Map<String?, String?>> sortOptions = {
    'Relevantnost': {'orderBy': null, 'sortDirection': null},
    'Naslov A-Z': {'orderBy': 'Naslov', 'sortDirection': 'ascending'},
    'Naslov Z-A': {'orderBy': 'Naslov', 'sortDirection': 'descending'},
    'Godina izdanja rastuća': {
      'orderBy': 'GodinaIzdanja',
      'sortDirection': 'ascending'
    },
    'Godina izdanja opadajuća': {
      'orderBy': 'GodinaIzdanja',
      'sortDirection': 'descending'
    },
  };

  Biblioteka? odabranaBiblioteka;
  int bibliotekaId = 0;

  Jezik? odabraniJezik;
  int jezikId = 0;

  @override
  void initState() {
    super.initState();

    knjigaProvider = context.read<KnjigaProvider>();
    knjigaAutoriProvider = context.read<KnjigaAutoriProvider>();
    bibliotekaProvider = context.read<BibliotekaProvider>();
    jezikProvider = context.read<JezikProvider>();
    autoriProvider = context.read<AutoriProvider>();

    _firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);
    // _initForm();
  }

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      knjige = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    Map<String, dynamic> searchRequest = {};
    if (widget.naslov != null) {
      searchRequest['naslovGTE'] = widget.naslov;
    }
    if (widget.vrstaGradeId != null && widget.vrstaGradeId != 0) {
      searchRequest['vrsteGradeId'] = widget.vrstaGradeId;
    }

    String? orderBy = sortOptions[dropdown]!['orderBy'];
    String? sortDirection = sortOptions[dropdown]!['sortDirection'];
    if (bibliotekaId != 0) {
      searchRequest['bibliotekaId'] = bibliotekaId;
    }
    if (jezikId != 0) {
      searchRequest['jezikId'] = jezikId;
    }
    searchRequest['autor'] = autorController.text;
    var knjigeResult = await knjigaProvider.get(
        page: page,
        pageSize: 10,
        filter: searchRequest,
        orderBy: orderBy,
        sortDirection: sortDirection,
        includeTables: 'Izdavac,Uvez,Jezik');

    if (knjigeResult != null) {
      knjige = knjigeResult!.resultList;
      total = knjigeResult.count;
    }

    setState(() {
      isFirstLoadRunning = false;
      total = knjigeResult.count;
      if (10 > total) {
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

      Map<String, dynamic> searchRequest = {};
      if (widget.naslov != null) {
        searchRequest['naslovGTE'] = widget.naslov;
      }
      if (widget.vrstaGradeId != null && widget.vrstaGradeId != 0) {
        searchRequest['vrsteGradeId'] = widget.vrstaGradeId;
      }

      String? orderBy = sortOptions[dropdown]!['orderBy'];
      String? sortDirection = sortOptions[dropdown]!['sortDirection'];
      if (bibliotekaId != 0) {
        searchRequest['bibliotekaId'] = bibliotekaId;
      }
      if (jezikId != 0) {
        searchRequest['jezikId'] = jezikId;
      }
      searchRequest['autor'] = autorController.text;
      print("load more");
      var knjigeResult = await knjigaProvider.get(
          page: page,
          pageSize: 10,
          filter: searchRequest,
          orderBy: orderBy,
          sortDirection: sortDirection,
          includeTables: 'Izdavac,Uvez,Jezik');
      if (knjigeResult.resultList.isNotEmpty) {
        for (var i = 0; i < knjigeResult.resultList.length; i++) {
          knjige.add(knjigeResult.resultList[i]);
        }

        //knjige.addAll(knjigeResult!.resultList);

        // setState(() {});
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

  TextEditingController _naslovController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: 40,
            child: TextField(
              controller: _naslovController,
              decoration: InputDecoration(
                hintText: 'Pretraga po naslovu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Handle search button press

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => NaprednaPretragaKnjiga(
                              vrstaGradeId: 0,
                              naslov: _naslovController.text,
                            )));
                  },
                ),
              ),
            ),
          ),
        ),
        body: _buildPage());
  }

  TextEditingController autorController = TextEditingController();

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Opcija pretrage',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownSearch<Biblioteka>(
                  selectedItem: odabranaBiblioteka,
                  popupProps: const PopupPropsMultiSelection.menu(
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
                    odabranaBiblioteka = c;
                  },
                  itemAsString: (Biblioteka u) => "${u.naziv}",
                  onSaved: (newValue) {
                    if (newValue != null) {
                      print(newValue.bibliotekaId);
                    }
                  },
                ),
                DropdownSearch<Jezik>(
                  selectedItem: odabraniJezik,
                  popupProps: const PopupPropsMultiSelection.menu(
                    isFilterOnline: true,
                    showSearchBox: true,
                    searchDelay: Duration(milliseconds: 5),
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Odaberi jezik",
                      hintText: "Unesite naziv jezika",
                    ),
                  ),
                  asyncItems: (String filter) async {
                    var jezici = await getJezike(filter);
                    return jezici;
                  },
                  onChanged: (Jezik? c) {
                    jezikId = c!.jezikId!;
                    odabraniJezik = c;
                  },
                  itemAsString: (Jezik u) => "${u.naziv}",
                  onSaved: (newValue) {
                    if (newValue != null) {
                      print(newValue.jezikId);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: autorController,
                  decoration: InputDecoration(
                    hintText: 'Ime prezime autora',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Poništi filtere'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        bibliotekaId = 0;
                        jezikId = 0;
                        odabranaBiblioteka = null;
                        odabraniJezik = null;
                        autorController.text = "";
                        _firstLoad();
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Pretraga'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _firstLoad();
                        // Add your search logic here
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.naslov != ""
              ? Text(
                  "Pretraga: ${widget.naslov}",
                  style: const TextStyle(fontSize: 22),
                )
              : Container(),
          Text(
            "Ukupno rezultata: ${total}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _showFilterDialog,
                icon: const Icon(Icons.filter_list),
                label: const Text('Filtriraj'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: dropdown,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdown = newValue!;
                    _firstLoad();
                  });
                },
                items: sortOptions.keys
                    .map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: knjige.length + 2,
                  controller: scrollController,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return _buildHeader();
                    } else if (index == knjige.length + 1) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            hasNextPage
                                ? 'Učitavanje...'
                                : total != 0
                                    ? 'Pregledali ste sve knjige!'
                                    : 'Nema rezultata pretrage',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      return _buildCard(knjige[index - 1]);
                    }
                  },
                ),
              ),
              if (isLoadMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
  }

  Widget _buildCard(Knjiga book) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => KnjigaScreen(
              knjiga: book,
            ),
          ));
        },
        child: Container(
          height: 200,
          child: Row(
            children: [
              Container(
                height: 200,
                width: 150,
                child: book.slika != null
                    ? Image.memory(
                        base64Decode(book.slika!),
                        fit: BoxFit.fitHeight,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Text('Greška pri učitavanju slike');
                        },
                      )
                    : Image.asset('assets/images/empty.png'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        book.naslov!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<List<String>>(
                        future: getAutoriKnjige(book.knjigaId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Učitavanje autora...");
                          } else if (snapshot.hasError) {
                            return const Text("Greška sa učitavanjem autora");
                          } else {
                            return Text(
                              "Autori: ${snapshot.data!.join(', ')}",
                              style: const TextStyle(fontSize: 18),
                            );
                          }
                        },
                      ),
                      Text(
                          "Autori: ${book.knjigaAutoris!.map((e) => e.autor!.ime! + " " + e.autor!.prezime!).join(', ')}"),
                      Text("Godina izdanja: ${book.godinaIzdanja}"),
                      Text("Jezik: ${book.jezik!.naziv}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> getAutoriKnjige(int knjigaId) async {
    print("get autori knjige");
    var knjigaAutori = await knjigaAutoriProvider.get(
        retrieveAll: true,
        includeTables: "Autor",
        filter: {'KnjigaId': knjigaId});
    if (knjigaAutori.resultList.isNotEmpty) {
      return knjigaAutori.resultList
          .map((e) => "${e.autor!.ime} ${e.autor!.prezime}")
          .toList();
    }
    return [];
  }

  Future<List<Biblioteka>> getBiblioteke(String? naziv) async {
    var biblioteke = await bibliotekaProvider
        .get(filter: {'nazivGTE': naziv}, page: 1, pageSize: 10);
    var pocetna = Biblioteka();
    pocetna.bibliotekaId = 0;
    pocetna.naziv = "Bilo koja biblioteka";
    if (biblioteke.resultList.isNotEmpty) {
      biblioteke?.resultList!.insert(0, pocetna);
      return biblioteke.resultList;
    }
    biblioteke?.resultList = [pocetna];
    return [];
  }

  Future<List<Jezik>> getJezike(String? naziv) async {
    print("get jezike");

    var jezici = await jezikProvider
        .get(filter: {'nazivGTE': naziv}, page: 1, pageSize: 10);
    var pocetni = Jezik();
    pocetni.jezikId = 0;
    pocetni.naziv = "Bilo koji jezik";
    if (jezici.resultList.isNotEmpty) {
      jezici?.resultList!.insert(0, pocetni);
      return jezici.resultList;
    }
    jezici?.resultList = [pocetni];
    return [];
  }

  Future<List<Autor>> gatAutore(String? imePrezime) async {
    print("get autore");
    var autori = await autoriProvider
        .get(filter: {'imePrezimeGTE': imePrezime}, page: 1, pageSize: 10);

    if (autori.resultList.isNotEmpty) {
      return autori.resultList;
    }
    return [];
  }
}
