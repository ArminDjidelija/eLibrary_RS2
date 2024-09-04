import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/kanton.dart';
import 'package:elibrary_bibliotekar/providers/biblioteke_provider.dart';
import 'package:elibrary_bibliotekar/providers/kanton_provider.dart';
import 'package:elibrary_bibliotekar/screens/biblioteke_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class BibliotekaDetailsScreen extends StatefulWidget {
  Biblioteka? biblioteka;
  BibliotekaDetailsScreen({super.key, this.biblioteka});

  @override
  State<BibliotekaDetailsScreen> createState() =>
      _BibliotekaDetailsScreenState();
}

class _BibliotekaDetailsScreenState extends State<BibliotekaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late BibliotekeProvider bibliotekeProvider;
  late KantonProvider kantonProvider;
  List<Kanton> kantoni = [];

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    bibliotekeProvider = context.read<BibliotekeProvider>();
    kantonProvider = context.read<KantonProvider>();
    super.initState();
    _initialValue = {
      'bibliotekaId': widget.biblioteka?.bibliotekaId.toString(),
      'naziv': widget.biblioteka?.naziv.toString(),
      'adresa': widget.biblioteka?.adresa.toString(),
      'opis': widget.biblioteka?.opis.toString(),
      'web': widget.biblioteka?.web.toString(),
      'telefon': widget.biblioteka?.telefon.toString(),
      'mail': widget.biblioteka?.mail.toString(),
      'kantonId': widget.biblioteka?.kantonId.toString(),
    };
    if (widget.biblioteka?.bibliotekaId != null) {
      isEditing = true;
    } else {
      isEditing = false;
    }
    initForm();
  }

  Future initForm() async {
    var kantoniSearch = await kantonProvider.get(retrieveAll: true);
    kantoni = kantoniSearch.resultList;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
      "Biblioteka detalji",
      Column(
        children: [_buildForm(), _saveRow()],
      ),
    );
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
                  decoration: const InputDecoration(labelText: "Naziv"),
                  name: 'naziv',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.maxLength(100,
                        errorText: "Maksimalno dužina je 100 znakova"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Adresa"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.maxLength(100,
                        errorText: "Maksimalno dužina je 100 znakova"),
                  ]),
                  name: 'adresa',
                )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Opis"),
                  minLines: 1,
                  maxLines: null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.maxLength(500,
                        errorText: "Maksimalno dužina je 500 znakova"),
                  ]),
                  name: 'opis',
                )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Web"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.url(errorText: "Nepravilna adresa"),
                  ]),
                  name: 'web',
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Telefon"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.match(r'^\+\d{7,15}$',
                        errorText:
                            "Telefon ima od 7 do 15 cifara i počinje znakom+"),
                  ]),
                  name: 'telefon',
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Mail"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                  name: 'mail',
                )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 400,
                  child: FormBuilderDropdown(
                    name: "kantonId",
                    decoration: const InputDecoration(labelText: "Kanton"),
                    items: kantoni
                            .map((e) => DropdownMenuItem(
                                value: e.kantonId.toString(),
                                child: Text(e.naziv ?? "")))
                            .toList() ??
                        [],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Obavezno polje"),
                    ]),
                  ),
                )
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
                var formCheck = _formKey.currentState?.saveAndValidate();
                if (formCheck == true) {
                  var request = Map.from(_formKey.currentState!.value);
                  if (widget.biblioteka == null) {
                    try {
                      await bibliotekeProvider.insert(request);
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Uspješno dodata biblioteka",
                          width: 300,
                          onCancelBtnTap: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BibliotekeListScreen(),
                                ))
                              },
                          onConfirmBtnTap: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BibliotekeListScreen(),
                                ))
                              });
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška pri dodavanju biblioteke",
                          width: 300);
                    }
                  } else {
                    try {
                      await bibliotekeProvider.update(
                          widget.biblioteka!.bibliotekaId!, request);
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Uspješno modifikovana biblioteka",
                          width: 400);
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška pri modifikovanju biblioteke",
                          width: 400);
                    }
                  }
                }
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }
}
