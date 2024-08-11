import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/uloga.dart';
import 'package:elibrary_bibliotekar/models/vrsta_sadrzaja.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_uposleni_provider.dart';
import 'package:elibrary_bibliotekar/providers/korisnici_provider.dart';
import 'package:elibrary_bibliotekar/providers/uloge_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class NoviUposleniScreen extends StatefulWidget {
  int? bibliotekaId;
  NoviUposleniScreen({super.key, this.bibliotekaId});
  @override
  State<NoviUposleniScreen> createState() => _NoviUposleniScreenState();
}

class _NoviUposleniScreenState extends State<NoviUposleniScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late BibliotekaUposleniProvider bibliotekaUposleniProvider;
  late KorisnikProvider korisnikProvider;
  late UlogeProvider ulogeProvider;
  List<int> uloge = [];

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    bibliotekaUposleniProvider = context.read<BibliotekaUposleniProvider>();
    korisnikProvider = context.read<KorisnikProvider>();
    ulogeProvider = context.read<UlogeProvider>();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Novi uposleni",
        Column(
          children: [_buildForm(), _saveRow()],
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
                  decoration: InputDecoration(labelText: "Ime"),
                  name: 'ime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(2),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Prezime"),
                  name: 'prezime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(2),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Email"),
                  name: 'email',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Telefon"),
                  name: 'telefon',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(5),
                  ]),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Korisnicko ime"),
                  name: 'korisnickoIme',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(4),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Lozinka"),
                  name: 'lozinka',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(4),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Lozinka potvrda"),
                  name: 'lozinkaPotvrda',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(4),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    width: 300,
                    child: DropdownSearch<Uloga>.multiSelection(
                      popupProps: const PopupPropsMultiSelection.menu(
                          // isFilterOnline: true,
                          // showSearchBox: true,
                          searchDelay: Duration(milliseconds: 5)),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Odaberi uloge",
                        ),
                      ),
                      asyncItems: (String filter) async {
                        var uloge = await getUloge();
                        return uloge;
                      },
                      onChanged: (List<Uloga> c) {
                        if (c != null || c.isNotEmpty) {
                          uloge = c.map((a) => a.ulogaId!).toList();
                        }
                        c.forEach((element) {
                          print(element.ulogaId);
                        });
                      },
                      compareFn: (item1, item2) =>
                          item1.ulogaId == item2.ulogaId,
                      itemAsString: (Uloga u) => "${u.naziv}",
                      validator: (List<Uloga>? c) {
                        if (c == null || c.isEmpty) {
                          return 'Obavezno polje';
                        }
                      },
                      onSaved: (newValue) => {
                        if (newValue != null) {print(newValue.length)}
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
              onPressed: () async {
                var formaCheck = _formKey.currentState?.saveAndValidate();
                if (formaCheck == true) {
                  //TODO provjera username  i email da li vec postoji

                  print("Sve uredu");
                  var request = Map.from(_formKey.currentState!.value);
                  request['uloge'] = uloge;
                  try {
                    if (widget.bibliotekaId != null) {
                      var user = await korisnikProvider.insert(request);
                      await bibliotekaUposleniProvider.insert({
                        'korisnikId': user.korisnikId,
                        'bibliotekaId': widget.bibliotekaId
                      });
                    } else {
                      var user = await korisnikProvider.insert(request);
                      await bibliotekaUposleniProvider
                          .insert({'korisnikId': user.korisnikId});
                    }
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Uspješno kreiran novi bibliotekar!");
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: e.toString());
                  }
                } else {
                  print("Belaj");
                }
              },
              child: Text("Sacuvaj"))
        ],
      ),
    );
  }

  Future<List<Uloga>> getUloge() async {
    var result = await ulogeProvider.get(retrieveAll: true);
    if (result == null) {
      return [];
    }
    var lista = result.resultList;
    lista.removeWhere(
        (element) => element.naziv!.toLowerCase().contains("administrator"));
    return lista;
  }
}
