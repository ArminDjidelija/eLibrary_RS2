import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/kanton.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/citaoci_provider.dart';
import 'package:elibrary_bibliotekar/providers/kanton_provider.dart';
import 'package:elibrary_bibliotekar/screens/citaoci_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class NoviCitalacScreen extends StatefulWidget {
  NoviCitalacScreen({super.key});
  @override
  State<NoviCitalacScreen> createState() => _NoviCitalacSCreenState();
}

class _NoviCitalacSCreenState extends State<NoviCitalacScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CitaociProvider citaociProvider;
  late KantonProvider kantonProvider;

  SearchResult<Kanton>? kantoniResult;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    citaociProvider = context.read<CitaociProvider>();
    kantonProvider = context.read<KantonProvider>();
    // TODO: implement initState
    super.initState();

    initForm();
  }

  Future initForm() async {
    kantoniResult = await kantonProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Novi čitalac",
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
                  decoration: const InputDecoration(labelText: "Ime"),
                  name: 'ime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(2),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Prezime"),
                  name: 'prezime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(2),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Email"),
                  name: 'email',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.email(),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Telefon"),
                  name: 'telefon',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(5),
                  ]),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration:
                      const InputDecoration(labelText: "Korisnicko ime"),
                  name: 'korisnickoIme',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(4),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Institucija"),
                  name: 'institucija',
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "kantonId",
                  decoration: const InputDecoration(labelText: "Kanton"),
                  items: kantoniResult?.resultList
                          .map((e) => DropdownMenuItem(
                              value: e.kantonId.toString(),
                              child: Text(e.naziv ?? "")))
                          .toList() ??
                      [],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
              ],
            ),
            // Row(
            //   children: [],
            // )
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

                  try {
                    await citaociProvider.insert(request);
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Uspješno kreiran novi čitalac!",
                      onCancelBtnTap: () => {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => CitaociListScreen(),
                          ),
                        ),
                      },
                      onConfirmBtnTap: () => {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => CitaociListScreen(),
                          ),
                        ),
                      },
                    );
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: e.toString());
                  }
                }
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }
}
