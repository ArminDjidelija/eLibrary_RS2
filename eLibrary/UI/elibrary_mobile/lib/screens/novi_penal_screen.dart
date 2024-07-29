import 'package:elibrary_mobile/layouts/citalac_master_screen.dart';
import 'package:elibrary_mobile/models/kanton.dart';
import 'package:elibrary_mobile/models/pozajmica.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/providers/citaoci_provider.dart';
import 'package:elibrary_mobile/providers/kanton_provider.dart';
import 'package:elibrary_mobile/providers/penali_provider.dart';
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

  SearchResult<Kanton>? kantoniResult;

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
    // TODO: implement initState
    super.initState();

    initForm();
  }

  Future initForm() async {
    kantoniResult = await kantonProvider.get();

    print("retreived kantoni: ${kantoniResult?.resultList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return CitalacMasterScreen(
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
                  decoration: InputDecoration(labelText: "Opis"),
                  name: 'opis',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(2),
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
                    width: 200,
                    child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Iznos"),
                      name: 'iznos',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.integer(),
                      ]),
                    )),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text("Valuta KM"),
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
                  //TODO provjera username  i email da li vec postoji

                  print("Sve uredu");
                  var request = Map.from(_formKey.currentState!.value);

                  try {
                    request['pozajmicaId'] = widget.pozajmica!.pozajmicaId;
                    penaliProvider.insert(request);
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Uspješno kreiran novi penal!");
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
}
