import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AutorDetailsScreen extends StatefulWidget {
  Autor? autor;
  AutorDetailsScreen({super.key, this.autor});

  @override
  State<AutorDetailsScreen> createState() => _AutorDetailsScreenState();
}

class _AutorDetailsScreenState extends State<AutorDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AutoriProvider autoriProvider;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    autoriProvider = context.read<AutoriProvider>();
    super.initState();
    _initialValue = {
      'autorId': widget.autor?.autorId.toString(),
      'ime': widget.autor?.ime.toString(),
      'prezime': widget.autor?.prezime.toString(),
      'godinaRodjenja': widget.autor?.godinaRodjenja.toString(),
    };
    if (widget.autor?.autorId != null) {
      isEditing = true;
    } else {
      isEditing = false;
    }
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
        "Autor detalji",
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
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
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
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Godina rođenja"),
                  name: 'godinaRodjenja',
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
              onPressed: () async {
                var formCheck = _formKey.currentState?.saveAndValidate();
                if (formCheck == true) {
                  var request = Map.from(_formKey.currentState!.value);
                  if (widget.autor == null) {
                    try {
                      await autoriProvider.insert(request);
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Uspješno dodat autor",
                          width: 300);
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška pri dodavanju autora",
                          width: 300);
                    }
                  } else {
                    try {
                      await autoriProvider.update(
                          widget.autor!.autorId!, request);
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Uspješno modifikovan autor",
                          width: 400);
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška pri ažuriranju autora",
                          width: 300);
                    }
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
