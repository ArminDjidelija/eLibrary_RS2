import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_knjiga_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class NovaBibliotekaKnjigaScreen extends StatefulWidget {
  Knjiga knjiga;
  NovaBibliotekaKnjigaScreen({super.key, required this.knjiga});

  @override
  State<NovaBibliotekaKnjigaScreen> createState() =>
      _NovaBibliotekaKnjigaScreenState();
}

class _NovaBibliotekaKnjigaScreenState
    extends State<NovaBibliotekaKnjigaScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AutoriProvider autoriProvider;
  late BibliotekaKnjigaProvider bibliotekaKnjigaProvider;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    autoriProvider = context.read<AutoriProvider>();
    bibliotekaKnjigaProvider = context.read<BibliotekaKnjigaProvider>();
    _initialValue = {
      'knjigaId': widget.knjiga?.knjigaId.toString(),
      // 'bibliotekaId': 2,
    };
    //initForm();
  }

  // Future initForm() async {
  //   jeziciResult = await jezikProvider.get();
  //   vrsteGradeResult = await vrstaGradeProvider.get();
  //   izdavaciResult = await izdavacProvider.get();
  //   uveziResult = await uvezProvider.get();
  //   autoriResult = await autoriProvider.get();
  //   ciljneGrupeResult = await ciljneGrupeProvider.get();
  //   vrsteSadrzajaResult = await vrsteSadrzajaProvider.get();
  //   setState(() {
  //     isLoading = false;
  //   });
  //   print("retreived jezici: ${jeziciResult?.resultList.length}");
  // }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Novi fond",
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
                    child: Text(
                  "${widget.knjiga.naslov!}, ${widget.knjiga.isbn!}",
                  style: TextStyle(fontSize: 18),
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Broj kopija"),
                  name: 'brojKopija',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Broj kopija je obavezna vrijednost"),
                    FormBuilderValidators.numeric(
                        errorText: "Broj kopija mora biti broj"),
                    FormBuilderValidators.min(1),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Lokacija"),
                  name: 'lokacija',
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration:
                      InputDecoration(labelText: "Dostupno za citaonicu"),
                  name: 'dostupnoCitaonica',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText:
                            "Broj pozajmica u citaonici je obavezna vrijednost"),
                    FormBuilderValidators.numeric(
                        errorText: "Broj pozajmica mora biti broj"),
                    FormBuilderValidators.min(1),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration:
                      InputDecoration(labelText: "Dostupno za pozajmicu"),
                  name: 'dostupnoPozajmica',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Broj pozajmica je obavezna vrijednost"),
                    FormBuilderValidators.numeric(
                        errorText: "Broj pozajmica mora biti broj"),
                    FormBuilderValidators.min(1),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
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
                var request = Map.from(_formKey.currentState!.value);
                request['bibliotekaId'] = 2;
                request['knjigaId'] = widget.knjiga.knjigaId;
                print(request);

                if (formCheck == true) {
                  try {
                    bibliotekaKnjigaProvider.insert(request);
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: e.toString());
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
