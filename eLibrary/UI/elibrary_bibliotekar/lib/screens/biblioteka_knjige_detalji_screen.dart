import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:elibrary_bibliotekar/models/pozajmica_info.dart';
import 'package:elibrary_bibliotekar/screens/novi_penal_screen.dart';
import 'package:elibrary_bibliotekar/screens/pozajmica_detalji_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/knjiga_autor.dart';
import 'package:elibrary_bibliotekar/models/knjiga_ciljna_grupa.dart';
import 'package:elibrary_bibliotekar/models/knjiga_vrsta_sadrzaja.dart';
import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/izdavac_provider.dart';
import 'package:elibrary_bibliotekar/providers/jezici_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_ciljna_grupa_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_vrste_sadrzaja_provider.dart';
import 'package:elibrary_bibliotekar/providers/pozajmice_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:elibrary_bibliotekar/providers/uvez_provider.dart';
import 'package:elibrary_bibliotekar/screens/biblioteka_knjiga_edit_screen.dart';
import 'package:elibrary_bibliotekar/screens/nova_pozajmica_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BibliotekaKnjigaDetailsScreen extends StatefulWidget {
  BibliotekaKnjiga? bibliotekaKnjiga;
  BibliotekaKnjigaDetailsScreen({super.key, this.bibliotekaKnjiga});

  @override
  State<BibliotekaKnjigaDetailsScreen> createState() =>
      _BibliotekaKnjigaDetailsScreenState();
}

class _BibliotekaKnjigaDetailsScreenState
    extends State<BibliotekaKnjigaDetailsScreen> {
  late BibliotekaKnjigaProvider provider;
  late PozajmiceProvider pozajmiceProvider;
  late KnjigaAutoriProvider knjigaAutoriProvider;
  late KnjigaVrsteSadrzajaProvider knjigaVrsteSadrzajaProvider;
  late KnjigaCiljnaGrupaProvider knjigaCiljnaGrupaProvider;
  late JezikProvider jezikProvider;
  late IzdavacProvider izdavacProvider;
  late UvezProvider uvezProvider;
  late KnjigaProvider knjigaProvider;

  SearchResult<BibliotekaKnjiga>? result;
  SearchResult<KnjigaAutor>? knjigaAutoriResult;
  SearchResult<KnjigaVrstaSadrzaja>? knjigaVrsteSadrzajaResult;
  SearchResult<KnjigaCiljnaGrupa>? knjigaCiljneGrupeResult;
  SearchResult<Knjiga>? knjigaResult;
  List<BibliotekaKnjiga> data = [];
  List<PozajmicaInfo> pozajmicaInfo = [];
  late Knjiga? knjiga;

  late PozajmiceDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;
  bool prijasnjePozajmice = false;
  final GlobalKey chartKey = GlobalKey();

  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    knjiga = widget.bibliotekaKnjiga?.knjiga;
  }

  @override
  void initState() {
    super.initState();

    provider = context.read<BibliotekaKnjigaProvider>();
    pozajmiceProvider = context.read<PozajmiceProvider>();
    knjigaAutoriProvider = context.read<KnjigaAutoriProvider>();
    knjigaVrsteSadrzajaProvider = context.read<KnjigaVrsteSadrzajaProvider>();
    knjigaCiljnaGrupaProvider = context.read<KnjigaCiljnaGrupaProvider>();
    jezikProvider = context.read<JezikProvider>();
    izdavacProvider = context.read<IzdavacProvider>();
    knjigaProvider = context.read<KnjigaProvider>();
    uvezProvider = context.read<UvezProvider>();
    knjiga = widget.bibliotekaKnjiga?.knjiga;

    // knjiga = widget.bibliotekaKnjiga?.knjiga;
    _source = PozajmiceDataSource(
        provider: pozajmiceProvider,
        context: context,
        bibliotekaKnjigaId: widget.bibliotekaKnjiga!.bibliotekaKnjigaId);

    initForm();
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
      "Detalji knjige",
      Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildKnjigaDetalji(),
              _isLoading ? const Text("Nema podataka") : _buildPaginatedTable()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginatedTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AdvancedPaginatedDataTable(
        header: Text(prijasnjePozajmice == false
            ? "Trenutne pozajmice"
            : "Historija pozajmica"),
        dataRowHeight: 75,
        columns: const [
          DataColumn(label: Text("Čitalac")),
          DataColumn(label: Text("Datum preuzimanja")),
          DataColumn(label: Text("Preporučeni datum vraćanja")),
          DataColumn(label: Text("Postavljeno trajanje (dani)")),
          DataColumn(label: Text("Vraćeno")),
          DataColumn(label: Text("Akcija")),
        ],
        source: _source,
        addEmptyRows: false,
      ),
    );
  }

  Widget _buildKnjigaDetalji() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              width: 400,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: knjiga?.slika != null
                          ? SizedBox(
                              width: 350,
                              height: 440,
                              child: knjiga?.slika != null
                                  ? imageFromString(knjiga!.slika!)
                                  : Image.asset("assets/images/empty.png"),
                            )
                          : SizedBox(
                              width: 350,
                              height: 440,
                              child: Image.asset("assets/images/empty.png"),
                            )),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(
                          color: Colors.black,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      columnWidths: const <int, TableColumnWidth>{
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth()
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        _buildTabelRow("Naslov", knjiga?.naslov.toString()),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Autori"),
                          ),
                          knjigaAutoriResult == null
                              ? const Text("Nema autora")
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(knjigaAutoriResult!.resultList
                                      .map((ka) =>
                                          '${ka.autor!.ime} ${ka.autor!.prezime}')
                                      .join(', ')),
                                )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Vrste sadržaja"),
                          ),
                          knjigaVrsteSadrzajaResult == null
                              ? const Text("Nema vrsti sadrzaja")
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(knjigaVrsteSadrzajaResult!
                                      .resultList
                                      .map((ka) => '${ka.vrstaSadrzaja!.naziv}')
                                      .join(', ')),
                                )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Ciljne grupe"),
                          ),
                          knjigaCiljneGrupeResult == null
                              ? const Text("Nema ciljnih grupa")
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(knjigaCiljneGrupeResult!
                                      .resultList
                                      .map((ka) => '${ka.ciljnaGrupa!.naziv}')
                                      .join(', ')),
                                )
                        ]),
                        _buildTabelRow("ISBN", knjiga?.isbn),
                        _buildTabelRow(
                            "Godina izdanja", knjiga?.godinaIzdanja.toString()),
                        _buildTabelRow(
                            "Broj izdanja", knjiga?.brojIzdanja.toString()),
                        _buildTabelRow(
                            "Broj stranica", knjiga?.brojStranica.toString()),
                        _buildTabelRow(
                            "Jezik", knjiga?.jezik?.naziv.toString()),
                        _buildTabelRow("Uvez", knjiga?.uvez?.naziv.toString()),
                        _buildTabelRow(
                            "Izdavac", knjiga?.izdavac?.naziv.toString()),
                        _buildTabelRow(
                            "Lokacija",
                            widget.bibliotekaKnjiga?.lokacija == null ||
                                    widget.bibliotekaKnjiga!.lokacija == ""
                                ? "Nije unesena lokacija"
                                : widget.bibliotekaKnjiga!.lokacija.toString()),
                        _buildTabelRow("Broj kopija",
                            widget.bibliotekaKnjiga!.brojKopija.toString()),
                        _buildTabelRow(
                            "Maksimalno pozajmica",
                            widget.bibliotekaKnjiga!.dostupnoPozajmica
                                .toString()),
                        _buildTabelRow(
                            "Maksimalno čitaonica",
                            widget.bibliotekaKnjiga!.dostupnoCitaonica
                                .toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Flex(
                      direction: Axis.horizontal, // Row-like behavior
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              prikaziGraf();
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.blue)),
                            child: const Text(
                              "Izvještaj",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      BibliotekaKnjigaEditScreen(
                                        bibliotekaKnjiga:
                                            widget.bibliotekaKnjiga,
                                      )));
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.blue)),
                            child: const Text(
                              "Uredi",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.bibliotekaKnjiga!.trenutnoDostupno! > 0)
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NovaPozajmicaScreen(
                                          bibliotekaKnjiga:
                                              widget.bibliotekaKnjiga,
                                        )));
                              },
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.blue)),
                              child: const Text(
                                "Nova pozajmica",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                            value: prijasnjePozajmice,
                            onChanged: (value) async {
                              setState(() {
                                prijasnjePozajmice = value!;
                              });
                              _source.filterServerSide(prijasnjePozajmice);
                            }),
                        const Text("Prijašnje pozajmice")
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TableRow _buildTabelRow(String? label, String? text) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(5),
        child: Text(label ?? ""),
      ),
      Padding(
        padding: const EdgeInsets.all(5),
        child: Text(text ?? ""),
      )
    ]);
  }

  Future generateInvoice() async {
    try {
      Uint8List chartImage = await _captureChart();
      var pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Godisnji izvjestaj",
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "eLibrary",
                      ),
                    ],
                  ),
                ],
              ),
              pw.Divider(thickness: 0.5),
              pw.Container(
                height: 400,
                width: double.infinity,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.white,
                ),
                child: pw.Image(pw.MemoryImage(chartImage)),
              ),
            ],
          ),
        ),
      );

      final dir = await getApplicationDocumentsDirectory();
      final vrijeme = DateTime.now();
      String path =
          '${dir.path}/Izvjestaj-${widget.bibliotekaKnjiga!.knjiga!.naslov}.pdf';
      File file = File(path);
      file.writeAsBytes(await pdf.save());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Izvještaj"),
            content: Text("Putanja do fajla:\n$path"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Zatvori"),
              ),
            ],
          );
        },
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future prikaziGraf() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Prikaz grafikona"),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 600, // Širina grafikona unutar dijaloga
                height: 350, // Visina grafikona unutar dijaloga
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildChart(),
                )),
          ),
          actions: [
            TextButton(
              child: const Text("Zatvori"),
              onPressed: () {
                Navigator.of(context).pop(); // Zatvori dialog
              },
            ),
            TextButton(
              child: const Text("Generiši izvjestaj"),
              onPressed: () async {
                generateInvoice();
                Navigator.of(context).pop(); // Zatvori dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<Uint8List> _captureChart() async {
    try {
      RenderRepaintBoundary boundary =
          chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      throw Exception("Error capturing chart: $e");
    }
  }

  Widget buildChart() {
    return RepaintBoundary(
      key: chartKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    final months =
                        pozajmicaInfo.map((e) => e.mjesecString).toList();

                    Map<int, String> monthLabels = {
                      for (var item in pozajmicaInfo)
                        item.rb!: item.mjesecString!
                    };
                    String label =
                        monthLabels[value.toInt()] ?? value.toInt().toString();

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        label,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: true),
            gridData: const FlGridData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: pozajmicaInfo
                    .map((e) =>
                        FlSpot(e.rb!.toDouble(), e.brojPozajmica!.toDouble()))
                    .toList(),
                isCurved: false,
                barWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future initForm() async {
    int? knjigaId = widget.bibliotekaKnjiga?.knjigaId;

    try {
      knjigaAutoriResult = await knjigaAutoriProvider.get(
          filter: {'knjigaId': knjigaId},
          retrieveAll: true,
          includeTables: 'Autor');

      knjigaVrsteSadrzajaResult = await knjigaVrsteSadrzajaProvider.get(
          filter: {'knjigaId': knjigaId},
          retrieveAll: true,
          includeTables: 'VrstaSadrzaja');

      knjigaCiljneGrupeResult = await knjigaCiljnaGrupaProvider.get(
          filter: {'knjigaId': knjigaId},
          retrieveAll: true,
          includeTables: 'CiljnaGrupa');

      knjigaResult = await knjigaProvider.get(
          filter: {'knjigaId': knjigaId},
          retrieveAll: true,
          includeTables: 'Uvez,Jezik,Izdavac');

      var pozajmicaInfoResult = await provider
          .getReportData(widget.bibliotekaKnjiga!.bibliotekaKnjigaId!);

      pozajmicaInfo = pozajmicaInfoResult;

      if (knjigaResult?.count == 1 && knjigaResult?.resultList != null) {
        knjiga = knjigaResult!.resultList[0];
      }
    } on Exception catch (e) {
      print("Greška neka");
    }

    setState(() {});
    print(
        "${knjigaAutoriResult?.count} ${knjigaVrsteSadrzajaResult?.count} ${knjigaCiljneGrupeResult?.count}");
  }

  Widget _buildApp() {
    return Container(
      child: const Column(
        children: [],
      ),
    );
  }
}

class PozajmiceDataSource extends AdvancedDataTableSource<Pozajmica> {
  List<Pozajmica>? data = [];
  final PozajmiceProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  int? bibliotekaKnjigaId;
  String autor = "";
  String naslov = "";
  String isbn = "";
  bool vraceno = false;
  dynamic filter;
  BuildContext context;
  PozajmiceDataSource(
      {required this.provider,
      required this.context,
      required this.bibliotekaKnjigaId});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(cells: [
      DataCell(Text(
          "${item!.citalac!.ime.toString()} ${item!.citalac!.prezime.toString()}")),
      DataCell(Text(formatDateTimeToLocal(item!.datumPreuzimanja!.toString()))),
      DataCell(Text(
          formatDateTimeToLocal(item!.preporuceniDatumVracanja!.toString()))),
      DataCell(Text(item!.trajanje.toString())),
      DataCell(item.stvarniDatumVracanja == null
          ? const Text("Ne")
          : const Text("Da")),
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
                            try {
                              await provider
                                  .potvrdiPozajmicu(item.pozajmicaId!);
                            } on Exception catch (e) {}
                            filterServerSide(vraceno);
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
                  )
                : ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PozajmicaDetailsScreen(
                            pozajmica: item,
                          ),
                        ),
                      );
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoviPenalScreen(
                            pozajmica: item,
                          ),
                        ),
                      );
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

  void filterServerSide(vracenoo) {
    vraceno = vracenoo;
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
    filter = {'bibliotekaKnjigaId': bibliotekaKnjigaId, 'vraceno': vraceno};

    try {
      var result = await provider.get(
          filter: filter,
          page: page,
          pageSize: pageSize,
          includeTables: "BibliotekaKnjiga,Citalac",
          orderBy: "DatumPreuzimanja",
          sortDirection: "descending");
      data = result.resultList;
      count = result.count;
    } on Exception catch (e) {
      print(e);
    }
    return RemoteDataSourceDetails(count, data!);
  }
}
