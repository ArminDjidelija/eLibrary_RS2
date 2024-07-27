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
  List<int> autori = [];
  List<int> ciljneGrupe = [];
  List<int> vrsteSadrzaja = [];

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
      'vrstaGradeId': widget.knjiga?.vrsteGradeId.toString(),
    };
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
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  //   FormBuilderValidators.email(),
                  // ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Godina izdanja"),
                  name: 'godinaIzdanja',
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Broj izdanja"),
                  name: 'brojIzdanja',
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Broj stranica"),
                  name: 'brojStranica',
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
                    child: FormBuilderDropdown(
                  name: "jezikId",
                  decoration: InputDecoration(labelText: "Jezik"),
                  items: jeziciResult?.resultList
                          .map((e) => DropdownMenuItem(
                              value: e.jezikId.toString(),
                              child: Text(e.naziv ?? "")))
                          .toList() ??
                      [],
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
                )),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "vrstaGradeId",
                  decoration: InputDecoration(labelText: "Vrsta građe"),
                  items: vrsteGradeResult?.resultList
                          .map((e) => DropdownMenuItem(
                              value: e.vrstaGradeId.toString(),
                              child: Text(e.naziv ?? "")))
                          .toList() ??
                      [],
                ))
              ],
            ),
            Row(
              children: [
                Container(
                    width: 250,
                    child: DropdownSearch<Izdavac>(
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
                        autori = c.map((a) => a.ciljnaGrupaId!).toList();
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
                  )
                      // FormBuilderCheckboxGroup<List<int>>(
                      //   // name: "autorId",
                      //   name: "ciljneGrupe",
                      //   decoration: InputDecoration(labelText: "Ciljne grupe"),
                      //   // valueTransformer: (value) => value ?? [],
                      //   validator: (value) {
                      //     return null;
                      //   },

                      //   options: ciljneGrupeResult?.resultList
                      //           .map((e) => FormBuilderFieldOption(
                      //               value: [e.ciljnaGrupaId!],
                      //               child: Text(e.naziv ?? "")))
                      //           .toList() ??
                      //       [],
                      // )
                      ),
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
                        autori = c.map((a) => a.vrstaSadrzajaId!).toList();
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

                if (widget.knjiga == null && formCheck == true) {
                  List<List<int>> autoriList =
                      _formKey.currentState?.value['autori'];

                  List<int> autori = autoriList.expand((list) => list).toList();
                  print(autori);

                  List<List<int>> ciljneGrupeList =
                      _formKey.currentState?.value['ciljneGrupe'];
                  List<int> ciljneGrupe =
                      ciljneGrupeList.expand((list) => list).toList();
                  print(ciljneGrupe);

                  List<List<int>> vrsteSadrzajaList =
                      _formKey.currentState?.value['vrsteSadrzaja'];
                  List<int> vrsteSadrzaja =
                      vrsteSadrzajaList.expand((list) => list).toList();
                  print(vrsteSadrzaja);

                  var request = Map.from(_formKey.currentState!.value);

                  final knjigaSlanje = {
                    'naslov': _formKey.currentState?.value['naslov'],
                    'godinaIzdanja':
                        _formKey.currentState?.value['godinaIzdanja'],
                    'brojIzdanja': _formKey.currentState?.value['brojIzdanja'],
                    'brojStranica':
                        _formKey.currentState?.value['brojStranica'],
                    'isbn': _formKey.currentState?.value['isbn'],
                    'napomena': _formKey.currentState?.value['napomena'],
                    'uvezId': _formKey.currentState?.value['uvezId'],
                    'izdavacId': _formKey.currentState?.value['izdavacId'],
                    'vrsteGradeId':
                        _formKey.currentState?.value['vrstaGradeId'],
                    'jezikId': _formKey.currentState?.value['jezikId'],
                    'autori': autori,
                    'ciljneGrupe': ciljneGrupe,
                    'vrsteSadrzaja': vrsteSadrzaja,
                    'slika': _base64Image
                  };
                  // print(knjigaSlanje);
                  knjigaProvider.insert(knjigaSlanje);
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Uspješno dodata knjiga",
                      width: 300);
                } else if (formCheck == true) {
                  _base64Image ??= widget.knjiga?.slika;
                  final knjigaUpdate = {
                    'naslov': _formKey.currentState?.value['naslov'],
                    'godinaIzdanja':
                        _formKey.currentState?.value['godinaIzdanja'],
                    'brojIzdanja': _formKey.currentState?.value['brojIzdanja'],
                    'brojStranica':
                        _formKey.currentState?.value['brojStranica'],
                    'isbn': _formKey.currentState?.value['isbn'],
                    'napomena': _formKey.currentState?.value['napomena'],
                    'uvezId': _formKey.currentState?.value['uvezId'],
                    'izdavacId': _formKey.currentState?.value['izdavacId'],
                    'vrsteGradeId':
                        _formKey.currentState?.value['vrstaGradeId'],
                    'jezikId': _formKey.currentState?.value['jezikId'],
                    'slika': _base64Image ?? widget.knjiga!.slika
                  };

                  // print(knjigaUpdate);
                  knjigaProvider.update(widget.knjiga!.knjigaId!, knjigaUpdate);
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
