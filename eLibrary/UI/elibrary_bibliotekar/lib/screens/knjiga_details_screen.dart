import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/ciljna_grupa.dart';
import 'package:elibrary_bibliotekar/models/izdavac.dart';
import 'package:elibrary_bibliotekar/models/jezik.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/models/uvez.dart';
import 'package:elibrary_bibliotekar/models/vrsta_grade.dart';
import 'package:elibrary_bibliotekar/models/vrsta_sadrzaja.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/ciljne_grupe_provider.dart';
import 'package:elibrary_bibliotekar/providers/izdavac_provider.dart';
import 'package:elibrary_bibliotekar/providers/jezici_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_ciljna_grupa_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_vrste_sadrzaja_provider.dart';
import 'package:elibrary_bibliotekar/providers/uvez_provider.dart';
import 'package:elibrary_bibliotekar/providers/vrsta_grade_provider.dart';
import 'package:elibrary_bibliotekar/providers/vrste_sadrzaja_provider.dart';
import 'package:elibrary_bibliotekar/screens/knjige_list_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class KnjigaDetailsScreen extends StatefulWidget {
  Knjiga? knjiga;
  KnjigaDetailsScreen({super.key, this.knjiga});

  @override
  State<KnjigaDetailsScreen> createState() => _KnjigaDetailsScreenState();
}

class _KnjigaDetailsScreenState extends State<KnjigaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KnjigaProvider knjigaProvider;
  late UvezProvider uvezProvider;
  late VrstaGradeProvider vrstaGradeProvider;
  late JezikProvider jezikProvider;
  late IzdavacProvider izdavacProvider;
  late AutoriProvider autoriProvider;
  late CiljneGrupeProvider ciljneGrupeProvider;
  late VrsteSadrzajaProvider vrsteSadrzajaProvider;
  late KnjigaAutoriProvider knjigaAutoriProvider;
  late KnjigaCiljnaGrupaProvider knjigaCiljnaGrupaProvider;
  late KnjigaVrsteSadrzajaProvider knjigaVrsteSadrzajaProvider;

  SearchResult<Jezik>? jeziciResult;
  SearchResult<Uvez>? uveziResult;
  SearchResult<VrstaGrade>? vrsteGradeResult;
  SearchResult<Izdavac>? izdavaciResult;
  SearchResult<Autor>? autoriResult;
  SearchResult<VrstaSadrzaja>? vrsteSadrzajaResult;
  SearchResult<CiljnaGrupa>? ciljneGrupeResult;
  bool isLoading = true;
  bool isEditing = false;

  int? izdavacId;
  int? jezikId;
  List<int> autori = [];
  List<int> ciljneGrupe = [];
  List<int> vrsteSadrzaja = [];

  Jezik? pocetniJezik;
  Izdavac? pocetniIzdavac;

  List<Autor> autoriList = [];
  List<CiljnaGrupa> ciljneGrupeList = [];
  List<VrstaSadrzaja> vrsteSadrzajaList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    knjigaProvider = context.read<KnjigaProvider>();
    uvezProvider = context.read<UvezProvider>();
    vrstaGradeProvider = context.read<VrstaGradeProvider>();
    jezikProvider = context.read<JezikProvider>();
    izdavacProvider = context.read<IzdavacProvider>();
    autoriProvider = context.read<AutoriProvider>();
    ciljneGrupeProvider = context.read<CiljneGrupeProvider>();
    vrsteSadrzajaProvider = context.read<VrsteSadrzajaProvider>();
    knjigaAutoriProvider = context.read<KnjigaAutoriProvider>();
    knjigaVrsteSadrzajaProvider = context.read<KnjigaVrsteSadrzajaProvider>();
    knjigaCiljnaGrupaProvider = context.read<KnjigaCiljnaGrupaProvider>();

    // TODO: implement initState
    super.initState();
    _initialValue = {
      'knjigaId': widget.knjiga?.knjigaId.toString(),
      'naslov': widget.knjiga?.naslov.toString(),
      'godinaIzdanja': widget.knjiga?.godinaIzdanja.toString(),
      'brojIzdanja': widget.knjiga?.brojIzdanja.toString(),
      'brojStranica': widget.knjiga?.brojStranica.toString(),
      'izdavacId': widget.knjiga?.izdavacId.toString(),
      'jezikId': widget.knjiga?.jezikId.toString(),
      'isbn': widget.knjiga?.isbn.toString(),
      'uvezId': widget.knjiga?.uvezId.toString(),
      'napomena': widget.knjiga?.napomena == null
          ? ""
          : widget.knjiga?.napomena.toString(),
      'slika': widget.knjiga?.slika.toString(),
      'vrsteGradeId': widget.knjiga?.vrsteGradeId.toString(),
    };
    jezikId = widget.knjiga?.jezikId;
    izdavacId = widget.knjiga?.izdavacId;

    pocetniJezik = widget.knjiga?.jezik;
    pocetniIzdavac = widget.knjiga?.izdavac;
    if (widget.knjiga?.knjigaId != null) {
      isEditing = true;
    } else {
      isEditing = false;
    }
    initForm();
  }

  Future initForm() async {
    jeziciResult = await jezikProvider.get();
    vrsteGradeResult = await vrstaGradeProvider.get();
    izdavaciResult = await izdavacProvider.get();
    uveziResult = await uvezProvider.get();
    autoriResult = await autoriProvider.get();
    ciljneGrupeResult = await ciljneGrupeProvider.get();
    vrsteSadrzajaResult = await vrsteSadrzajaProvider.get();

    if (widget.knjiga?.knjigaId != null) {
      var autoriKnjigaResult = await knjigaAutoriProvider.get(
          filter: {'knjigaId': widget.knjiga!.knjigaId!},
          retrieveAll: true,
          includeTables: "Autor");
      autoriList = autoriKnjigaResult.resultList.map((e) => e.autor!).toList();

      var ciljneGrupeKnjigaResult = await knjigaCiljnaGrupaProvider.get(
          filter: {'knjigaId': widget.knjiga!.knjigaId!},
          retrieveAll: true,
          includeTables: "CiljnaGrupa");
      ciljneGrupeList = ciljneGrupeKnjigaResult.resultList
          .map((e) => e.ciljnaGrupa!)
          .toList();

      var vrsteSadrzajaKnjigaResult = await knjigaVrsteSadrzajaProvider.get(
          filter: {'knjigaId': widget.knjiga!.knjigaId!},
          retrieveAll: true,
          includeTables: "VrstaSadrzaja");

      vrsteSadrzajaList = vrsteSadrzajaKnjigaResult.resultList
          .map((e) => e.vrstaSadrzaja!)
          .toList();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Detalji",
        Column(
          children: [isLoading ? Container() : _buildForm(), _saveRow()],
        ));
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Naslov"),
                  name: 'naslov',
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.max(200,
                        errorText: "Maksimalno dužina je 200 znakova"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration:
                      const InputDecoration(labelText: "Godina izdanja"),
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  name: 'godinaIzdanja',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.numeric(errorText: "Mora biti broj"),
                    FormBuilderValidators.min(0,
                        errorText: "Minimalna godina je 0"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Broj izdanja"),
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  name: 'brojIzdanja',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.integer(
                        errorText: "Mora biti cijeli broj"),
                    FormBuilderValidators.min(1,
                        errorText: "Minimalna vrijednost je 1"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Broj stranica"),
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  name: 'brojStranica',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.integer(
                        errorText: "Mora biti cijeli broj"),
                    FormBuilderValidators.min(1,
                        errorText: "Minimalna vrijednost je 1"),
                  ]),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Opis"),
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  name: 'napomena',
                  minLines: 1,
                  maxLines: null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.maxLength(500,
                        errorText: "Maksimalno dužina je 500 znakova"),
                  ]),
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "ISBN"),
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  name: 'isbn',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.maxLength(20,
                        errorText: "Maksimalno dužina je 20 znakova"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: DropdownSearch<Jezik>(
                  selectedItem: pocetniJezik,
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  popupProps: const PopupPropsMultiSelection.menu(
                      // showSelectedItems: true,
                      isFilterOnline: true,
                      showSearchBox: true,
                      searchDelay: Duration(milliseconds: 5)),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText: "Odaberi jezik",
                          hintText: "Unesite naziv jezika")),
                  asyncItems: (String filter) async {
                    var jezici = await getJezici(filter);
                    return jezici;
                  },
                  onChanged: (Jezik? c) {
                    jezikId = c!.jezikId;
                    print(c.naziv);
                  },
                  itemAsString: (Jezik u) => "${u.naziv}",
                  validator: (Jezik? c) {
                    if (c == null) {
                      return 'Obavezno polje';
                    }
                  },
                  onSaved: (newValue) => {
                    if (newValue != null) {print(newValue.jezikId)}
                  },
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "uvezId",
                  decoration: const InputDecoration(labelText: "Uvez"),
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  items: uveziResult?.resultList
                          .map((e) => DropdownMenuItem(
                              value: e.uvezId.toString(),
                              child: Text(e.naziv ?? "")))
                          .toList() ??
                      [],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  name: "vrsteGradeId",
                  decoration: const InputDecoration(labelText: "Vrsta građe"),
                  items: vrsteGradeResult?.resultList
                          .map((e) => DropdownMenuItem(
                              value: e.vrstaGradeId.toString(),
                              child: Text(e.naziv ?? "")))
                          .toList() ??
                      [],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                ))
              ],
            ),
            Row(
              children: [
                Container(
                    width: 250,
                    child: DropdownSearch<Izdavac>(
                      enabled: AuthProvider.korisnikUloge!
                              .any((x) => x.uloga?.naziv == "Administrator") ||
                          widget.knjiga == null,
                      selectedItem: pocetniIzdavac,
                      popupProps: const PopupPropsMultiSelection.menu(
                          // showSelectedItems: true,
                          isFilterOnline: true,
                          showSearchBox: true,
                          searchDelay: Duration(milliseconds: 5)),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              labelText: "Odaberi izdavača",
                              hintText: "Unesite naziv izdavača")),
                      asyncItems: (String filter) async {
                        var citaoci = await getIzdavaci(filter);
                        return citaoci;
                      },
                      onChanged: (Izdavac? c) {
                        izdavacId = c!.izdavacId;
                      },
                      itemAsString: (Izdavac u) => "${u.naziv}",
                      validator: (Izdavac? c) {
                        if (c == null) {
                          return 'Obavezno polje';
                        }
                      },
                      onSaved: (newValue) => {
                        if (newValue != null) {print(newValue.izdavacId)}
                      },
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: DropdownSearch<Autor>.multiSelection(
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  selectedItems: autoriList,
                  popupProps: const PopupPropsMultiSelection.menu(
                      isFilterOnline: true,
                      showSearchBox: true,
                      searchDelay: Duration(milliseconds: 5)),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText: "Odaberi autore",
                          hintText: "Unesite ime i prezime autora")),
                  asyncItems: (String filter) async {
                    var autori = await getAutori(filter);
                    return autori;
                  },
                  onChanged: (List<Autor> c) {
                    if (c.isNotEmpty) {
                      autori = c.map((a) => a.autorId!).toList();
                      autoriList = c;
                    }
                  },
                  compareFn: (item1, item2) => item1.autorId == item2.autorId,
                  itemAsString: (Autor u) =>
                      "${u.ime} ${u.prezime}, ${u.godinaRodjenja ?? ''}",
                  validator: (List<Autor>? c) {
                    if (c == null || c.isEmpty) {
                      return 'Obavezno polje';
                    }
                  },
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: DropdownSearch<CiljnaGrupa>.multiSelection(
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  selectedItems: ciljneGrupeList,
                  popupProps: const PopupPropsMultiSelection.menu(
                      isFilterOnline: true,
                      showSearchBox: true,
                      searchDelay: Duration(milliseconds: 5)),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText: "Odaberi ciljne grupe",
                          hintText: "Unesite naziv ciljne grupe")),
                  asyncItems: (String filter) async {
                    var ciljneGrupe = await getCiljneGrupe(filter);
                    return ciljneGrupe;
                  },
                  onChanged: (List<CiljnaGrupa> c) {
                    if (c != null || c.isNotEmpty) {
                      ciljneGrupe = c.map((a) => a.ciljnaGrupaId!).toList();
                      ciljneGrupeList = c;
                    }
                  },
                  compareFn: (item1, item2) =>
                      item1.ciljnaGrupaId == item2.ciljnaGrupaId,
                  itemAsString: (CiljnaGrupa u) => "${u.naziv}",
                  validator: (List<CiljnaGrupa>? c) {
                    if (c == null || c.isEmpty) {
                      return 'Obavezno polje';
                    }
                  },
                  onSaved: (newValue) => {
                    if (newValue != null) {print(newValue.length)}
                  },
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: DropdownSearch<VrstaSadrzaja>.multiSelection(
                  enabled: AuthProvider.korisnikUloge!
                          .any((x) => x.uloga?.naziv == "Administrator") ||
                      widget.knjiga == null,
                  selectedItems: vrsteSadrzajaList,
                  popupProps: const PopupPropsMultiSelection.menu(
                      isFilterOnline: true,
                      showSearchBox: true,
                      searchDelay: Duration(milliseconds: 5)),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText: "Odaberi vrste sadržaja",
                          hintText: "Unesite naziv vrste sadržaja")),
                  asyncItems: (String filter) async {
                    var vrsteSadrzaja = await getVrsteSadrzaja(filter);
                    return vrsteSadrzaja;
                  },
                  onChanged: (List<VrstaSadrzaja> c) {
                    if (c != null || c.isNotEmpty) {
                      vrsteSadrzaja = c.map((a) => a.vrstaSadrzajaId!).toList();
                      vrsteSadrzajaList = c;
                    }
                    c.forEach((element) {
                      print(element.vrstaSadrzajaId);
                    });
                  },
                  compareFn: (item1, item2) =>
                      item1.vrstaSadrzajaId == item2.vrstaSadrzajaId,
                  itemAsString: (VrstaSadrzaja u) => "${u.naziv}",
                  validator: (List<VrstaSadrzaja>? c) {
                    if (c == null || c.isEmpty) {
                      return 'Obavezno polje';
                    }
                  },
                  onSaved: (newValue) => {
                    if (newValue != null) {print(newValue.length)}
                  },
                ))
              ],
              // ],
            ),
            if (AuthProvider.korisnikUloge!
                    .any((x) => x.uloga?.naziv == "Administrator") ||
                widget.knjiga == null)
              Row(
                children: [
                  Container(
                      width: 300,
                      child: FormBuilderField(
                        name: "imageId",
                        builder: (field) {
                          return InputDecorator(
                            decoration: const InputDecoration(
                                label: Text("Odaberite sliku")),
                            child: ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text("Select image"),
                              trailing: const Icon(Icons.file_upload),
                              onTap: getImage,
                            ),
                          );
                        },
                      ))
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _saveRow() {
    if (AuthProvider.korisnikUloge!
            .any((x) => x.uloga?.naziv == "Administrator") ||
        widget.knjiga == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var formCheck = _formKey.currentState?.saveAndValidate();
                  print(autori);
                  print(ciljneGrupe);
                  print(vrsteSadrzaja);
                  if (widget.knjiga == null && formCheck == true) {
                    var request = Map.from(_formKey.currentState!.value);

                    request['autori'] = autori;
                    request['ciljneGrupe'] = ciljneGrupe;
                    request['vrsteSadrzaja'] = vrsteSadrzaja;
                    request['jezikId'] = jezikId;
                    request['izdavacId'] = izdavacId;
                    request['slika'] = _base64Image;
                    //return;
                    try {
                      await knjigaProvider.insert(request);
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Uspješno dodata knjiga",
                        width: 300,
                        onCancelBtnTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const KnjigeListScreen(),
                            ),
                          )
                        },
                        onConfirmBtnTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const KnjigeListScreen(),
                            ),
                          )
                        },
                      );

                      // _formKey.currentState?.reset();
                      // autori = [];
                      // ciljneGrupe = [];
                      // vrsteSadrzaja = [];

                      // autoriList = [];
                      // ciljneGrupeList = [];
                      // vrsteSadrzajaList = [];

                      // _base64Image = null;
                      // jezikId = null;
                      // izdavacId = null;
                      // setState(() {});

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => KnjigeListScreen(),
                      //   ),
                      // );
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška pri dodavanju knjige",
                          width: 300);
                    }
                  } else if (formCheck == true) {
                    _base64Image ??= widget.knjiga?.slika;
                    var request = Map.from(_formKey.currentState!.value);
                    request['autori'] =
                        autoriList.map((e) => e.autorId!).toList();
                    request['ciljneGrupe'] =
                        ciljneGrupeList.map((e) => e.ciljnaGrupaId!).toList();
                    request['vrsteSadrzaja'] = vrsteSadrzajaList
                        .map((e) => e.vrstaSadrzajaId!)
                        .toList();
                    request['jezikId'] = jezikId;
                    request['izdavacId'] = izdavacId;
                    request['slika'] = _base64Image;

                    try {
                      await knjigaProvider.update(
                          widget.knjiga!.knjigaId!, request);
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Uspješno modifikovana knjiga",
                          width: 400);
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška sa ažuriranjem knjige",
                          width: 300);
                    }
                  }
                },
                child: const Text("Sacuvaj"))
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  File? _image;
  String? _base64Image;

  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }

  Future<List<Jezik>> getJezici(String filter) async {
    var result = await jezikProvider.get(
        page: 1,
        pageSize: 10,
        filter: {'nazivGTE': filter},
        orderBy: 'Naziv',
        sortDirection: 'ascending');
    if (result == null) {
      return [];
    }
    return result.resultList;
  }

  Future<List<Izdavac>> getIzdavaci(String filter) async {
    var result = await izdavacProvider.get(
        page: 1,
        pageSize: 10,
        filter: {'nazivGTE': filter},
        orderBy: 'Naziv',
        sortDirection: 'ascending');
    return result.resultList;
  }

  Future<List<Autor>> getAutori(String filter) async {
    var result = await autoriProvider.get(
        page: 1,
        pageSize: 10,
        filter: {'imePrezimeGTE': filter},
        orderBy: 'Ime',
        sortDirection: 'ascending');
    return result.resultList;
  }

  Future<List<CiljnaGrupa>> getCiljneGrupe(String filter) async {
    var result = await ciljneGrupeProvider.get(
        page: 1,
        pageSize: 10,
        filter: {'nazivGTE': filter},
        orderBy: 'Naziv',
        sortDirection: 'ascending');
    return result.resultList;
  }

  Future<List<VrstaSadrzaja>> getVrsteSadrzaja(String filter) async {
    var result = await vrsteSadrzajaProvider.get(
        page: 1,
        pageSize: 10,
        filter: {'nazivGTE': filter},
        orderBy: 'Naziv',
        sortDirection: 'ascending');
    return result.resultList;
  }
}
