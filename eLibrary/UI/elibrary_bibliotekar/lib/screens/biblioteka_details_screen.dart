import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/biblioteka.dart';
import 'package:elibrary_bibliotekar/models/kanton.dart';
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/biblioteke_provider.dart';
import 'package:elibrary_bibliotekar/providers/kanton_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

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
    // TODO: implement initState
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
                  decoration: InputDecoration(labelText: "Naziv"),
                  name: 'naziv',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Adresa"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  name: 'adresa',
                )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Opis"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  name: 'opis',
                )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Web"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  name: 'web',
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Telefon"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  name: 'telefon',
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Mail"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  name: 'mail',
                )),
                SizedBox(
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
                    decoration: InputDecoration(labelText: "Kanton"),
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
              onPressed: () {
                var formCheck = _formKey.currentState?.saveAndValidate();
                if (formCheck == true) {
                  var request = Map.from(_formKey.currentState!.value);
                  if (widget.biblioteka == null) {
                    bibliotekeProvider.insert(request);
                  } else {
                    bibliotekeProvider.update(
                        widget.biblioteka!.bibliotekaId!, request);
                  }
                }
                // print(knjigaSlanje);
              },
              child: Text("Sacuvaj"))
        ],
      ),
    );
  }
}
