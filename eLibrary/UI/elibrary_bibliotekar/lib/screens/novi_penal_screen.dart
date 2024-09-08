import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/kanton.dart';
import 'package:elibrary_bibliotekar/models/pozajmica.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/models/valuta.dart';
import 'package:elibrary_bibliotekar/providers/kanton_provider.dart';
import 'package:elibrary_bibliotekar/providers/penali_provider.dart';
import 'package:elibrary_bibliotekar/providers/valute_provider.dart';
import 'package:elibrary_bibliotekar/screens/historija_pozajmica_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class NoviPenalScreen extends StatefulWidget {
  Pozajmica? pozajmica;
  NoviPenalScreen({super.key, required this.pozajmica});
  @override
  State<NoviPenalScreen> createState() => _NoviPenalSCreenState();
}

class _NoviPenalSCreenState extends State<NoviPenalScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late PenaliProvider penaliProvider;
  late KantonProvider kantonProvider;
  late ValutaProvider valutaProvider;

  SearchResult<Kanton>? kantoniResult;
  SearchResult<Valuta>? valutaResult;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    penaliProvider = context.read<PenaliProvider>();
    kantonProvider = context.read<KantonProvider>();
    valutaProvider = context.read<ValutaProvider>();
    // TODO: implement initState
    super.initState();

    initForm();
  }

  Future initForm() async {
    kantoniResult = await kantonProvider.get();
    valutaResult = await valutaProvider.get();

    print("retreived kantoni: ${kantoniResult?.resultList.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Novi penal",
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
                  decoration: const InputDecoration(labelText: "Opis"),
                  name: 'opis',
                  minLines: 1,
                  maxLines: null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(2,
                        errorText: "Minimalno 2 znaka"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    width: 200,
                    child: FormBuilderTextField(
                      decoration: const InputDecoration(labelText: "Iznos"),
                      name: 'iznos',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje"),
                        FormBuilderValidators.numeric(
                            errorText: "Mora biti broj"),
                        FormBuilderValidators.min(1,
                            errorText: "Mora biti minimum 1"),
                      ]),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 200,
                  child: FormBuilderDropdown(
                    name: "valutaId",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Obavezno polje"),
                    ]),
                    decoration: const InputDecoration(labelText: "Valuta"),
                    items: valutaResult?.resultList
                            .map((e) => DropdownMenuItem(
                                value: e.valutaId.toString(),
                                child: Text(e.naziv ?? "")))
                            .toList() ??
                        [],
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
                var formaCheck = _formKey.currentState?.saveAndValidate();
                if (formaCheck == true) {
                  var request = Map.from(_formKey.currentState!.value);

                  try {
                    request['pozajmicaId'] = widget.pozajmica!.pozajmicaId;
                    penaliProvider.insert(request);
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Uspješno kreiran novi penal!",
                        onCancelBtnTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => PozajmiceListScreen()));
                        },
                        onConfirmBtnTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => PozajmiceListScreen()));
                        });
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: e.toString());
                  }
                } else {}
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }
}
