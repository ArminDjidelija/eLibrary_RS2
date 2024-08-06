import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/izdavac.dart';
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/izdavac_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class IzdavacDetailsScreen extends StatefulWidget {
  Izdavac? izdavac;
  IzdavacDetailsScreen({super.key, this.izdavac});

  @override
  State<IzdavacDetailsScreen> createState() => _IzdavacDetailsScreenState();
}

class _IzdavacDetailsScreenState extends State<IzdavacDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late IzdavacProvider izdavacProvider;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    izdavacProvider = context.read<IzdavacProvider>();
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'izdavacId': widget.izdavac?.izdavacId.toString(),
      'naziv': widget.izdavac?.naziv.toString(),
    };
    if (widget.izdavac?.izdavacId != null) {
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
        "Izdavač detalji",
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
                    FormBuilderValidators.required(
                        errorText: "Vrijednost je obavezna"),
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
                var formValidate = _formKey.currentState?.saveAndValidate();
                var request = Map.from(_formKey.currentState!.value);
                if (formValidate == true) {
                  if (widget.izdavac == null) {
                    izdavacProvider.insert(request);
                  } else {
                    izdavacProvider.update(widget.izdavac!.izdavacId!, request);
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
