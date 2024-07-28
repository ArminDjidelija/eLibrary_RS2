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
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/ciljne_grupe_provider.dart';
import 'package:elibrary_bibliotekar/providers/izdavac_provider.dart';
import 'package:elibrary_bibliotekar/providers/jezici_provider.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/uvez_provider.dart';
import 'package:elibrary_bibliotekar/providers/vrsta_grade_provider.dart';
import 'package:elibrary_bibliotekar/providers/vrste_sadrzaja_provider.dart';
import 'package:file_picker/file_picker.dart';
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
      'napomena': widget.knjiga?.napomena.toString(),
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
    setState(() {
      isLoading = false;
    });
    print("retreived jezici: ${jeziciResult?.resultList.length}");
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
                  decoration: InputDecoration(labelText: "Naslov"),
                  name: 'naslov',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Godina izdanja"),
                  name: 'godinaIzdanja',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Broj izdanja"),
                  name: 'brojIzdanja',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Broj stranica"),
                  name: 'brojStranica',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Opis"),
                  name: 'napomena',
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "ISBN"),
                  name: 'isbn',
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: DropdownSearch<Jezik>(
                  selectedItem: pocetniJezik,
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
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "uvezId",
                  decoration: InputDecoration(labelText: "Uvez"),
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
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "vrsteGradeId",
                  decoration: InputDecoration(labelText: "Vrsta građe"),
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
                        print(c.naziv);
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
                    )
                    // FormBuilderDropdown(
                    //   name: "izdavacId",
                    //   decoration: InputDecoration(labelText: "Izdavac"),
                    //   items: izdavaciResult?.resultList
                    //           .map((e) => DropdownMenuItem(
                    //               value: e.izdavacId.toString(),
                    //               child: Text(e.naziv ?? "")))
                    //           .toList() ??
                    //       [],
                    // )
                    ),
                SizedBox(
                  width: 10,
                ),
                if (isEditing == false) ...[
                  Expanded(
                      child: DropdownSearch<Autor>.multiSelection(
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
                      if (c != null || c.isNotEmpty) {
                        autori = c.map((a) => a.autorId!).toList();
                      }
                      c.forEach((element) {
                        print(element.autorId);
                      });
                    },
                    compareFn: (item1, item2) => item1.autorId == item2.autorId,
                    itemAsString: (Autor u) =>
                        "${u.ime} ${u.prezime}, ${u.godinaRodjenja}",
                    validator: (List<Autor>? c) {
                      if (c == null || c.isEmpty) {
                        return 'Obavezno polje';
                      }
                    },
                    onSaved: (newValue) => {
                      if (newValue != null) {print(newValue.length)}
                    },
                  )
                      //      FormBuilderCheckboxGroup<List<int>>(
                      //   // name: "autorId",
                      //   name: "autori",
                      //   decoration: InputDecoration(labelText: "Autori"),
                      //   // valueTransformer: (value) => value ?? [],
                      //   validator: (value) {
                      //     return null;
                      //   },

                      //   options: autoriResult?.resultList
                      //           .map((e) => FormBuilderFieldOption(
                      //               value: [e.autorId!],
                      //               child: Text(
                      //                   "${e.ime} ${e.prezime}, ${e.godinaRodjenja}" ??
                      //                       "")))
                      //           .toList() ??
                      //       [],
                      // )
                      ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: DropdownSearch<CiljnaGrupa>.multiSelection(
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
                      }
                      c.forEach((element) {
                        print(element.ciljnaGrupaId);
                      });
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
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: DropdownSearch<VrstaSadrzaja>.multiSelection(
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
                        vrsteSadrzaja =
                            c.map((a) => a.vrstaSadrzajaId!).toList();
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
                  )
                      //      FormBuilderCheckboxGroup<List<int>>(
                      //   // name: "autorId",
                      //   name: "vrsteSadrzaja",
                      //   decoration: InputDecoration(labelText: "Vrste sadrzaja"),
                      //   // valueTransformer: (value) => value ?? [],
                      //   validator: (value) {
                      //     return null;
                      //   },

                      //   options: vrsteSadrzajaResult?.resultList
                      //           .map((e) => FormBuilderFieldOption(
                      //               value: [e.vrstaSadrzajaId!],
                      //               child: Text(e.naziv ?? "")))
                      //           .toList() ??
                      //       [],
                      // )
                      )
                ],
              ],
            ),
            Row(
              children: [
                Container(
                    width: 300,
                    child: FormBuilderField(
                      name: "imageId",
                      builder: (field) {
                        return InputDecorator(
                          decoration:
                              InputDecoration(label: Text("Odaberite sliku")),
                          child: ListTile(
                            leading: Icon(Icons.image),
                            title: Text("Select image"),
                            trailing: Icon(Icons.file_upload),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () {
                var formCheck = _formKey.currentState?.saveAndValidate();
                print(autori);
                print(ciljneGrupe);
                print(vrsteSadrzaja);
                if (widget.knjiga == null && formCheck == true) {
                  // List<List<int>> autoriList =
                  //     _formKey.currentState?.value['autori'];

                  // List<int> autori = autoriList.expand((list) => list).toList();
                  // print(autori);

                  // List<List<int>> ciljneGrupeList =
                  //     _formKey.currentState?.value['ciljneGrupe'];
                  // List<int> ciljneGrupe =
                  //     ciljneGrupeList.expand((list) => list).toList();
                  // print(ciljneGrupe);

                  // List<List<int>> vrsteSadrzajaList =
                  //     _formKey.currentState?.value['vrsteSadrzaja'];
                  // List<int> vrsteSadrzaja =
                  //     vrsteSadrzajaList.expand((list) => list).toList();
                  // print(vrsteSadrzaja);

                  var request = Map.from(_formKey.currentState!.value);

                  request['autori'] = autori;
                  request['ciljneGrupe'] = ciljneGrupe;
                  request['vrsteSadrzaja'] = vrsteSadrzaja;
                  request['jezikId'] = jezikId;
                  request['izdavacId'] = izdavacId;
                  request['slika'] = _base64Image;
                  print(request);

                  knjigaProvider.insert(request);
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Uspješno dodata knjiga",
                      width: 300);
                } else if (formCheck == true) {
                  _base64Image ??= widget.knjiga?.slika;
                  var request = Map.from(_formKey.currentState!.value);
                  request['jezikId'] = jezikId;
                  request['izdavacId'] = izdavacId;
                  request['slika'] = _base64Image;

                  // print(knjigaUpdate);
                  knjigaProvider.update(widget.knjiga!.knjigaId!, request);
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Uspješno modifikovana knjiga",
                      width: 400);
                }
              },
              child: Text("Sacuvaj"))
        ],
      ),
    );
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
    if (result == null) {
      return [];
    }
    return result.resultList;
  }

  Future<List<Autor>> getAutori(String filter) async {
    var result = await autoriProvider.get(
        page: 1,
        pageSize: 10,
        filter: {'imePrezimeGTE': filter},
        orderBy: 'Ime',
        sortDirection: 'ascending');
    if (result == null) {
      return [];
    }
    return result.resultList;
  }

  Future<List<CiljnaGrupa>> getCiljneGrupe(String filter) async {
    var result = await ciljneGrupeProvider.get(
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

  Future<List<VrstaSadrzaja>> getVrsteSadrzaja(String filter) async {
    var result = await vrsteSadrzajaProvider.get(
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
}
