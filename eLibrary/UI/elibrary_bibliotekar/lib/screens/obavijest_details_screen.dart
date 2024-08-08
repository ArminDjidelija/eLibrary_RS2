import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/obavijest.dart';
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/obavijesti_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ObavijestDetailsScreen extends StatefulWidget {
  Obavijest? obavijest;
  ObavijestDetailsScreen({super.key, this.obavijest});

  @override
  State<ObavijestDetailsScreen> createState() => _ObavijestDetailsScreenState();
}

class _ObavijestDetailsScreenState extends State<ObavijestDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ObavijestiProvider obavijestiProvider;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    obavijestiProvider = context.read<ObavijestiProvider>();
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'obavijestId': widget.obavijest?.obavijestId.toString(),
      'bibliotekaId': widget.obavijest?.biblioteka.toString(),
      'naslov': widget.obavijest?.naslov.toString(),
      'tekst': widget.obavijest?.tekst.toString(),
    };
    if (widget.obavijest?.obavijestId != null) {
      isEditing = true;
    } else {
      isEditing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Obavijest detalji",
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
                  decoration: InputDecoration(labelText: "Naslov"),
                  name: 'naslov',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
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
                  decoration: InputDecoration(labelText: "Tekst"),
                  name: 'tekst',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
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
                var request = Map.from(_formKey.currentState!.value);
                print(formCheck);
                if (widget.obavijest == null) {
                  request['bibliotekaId'] = 2;
                  obavijestiProvider.insert(request);
                } else {
                  obavijestiProvider.update(
                      widget.obavijest!.obavijestId!, request);
                }
                // print(knjigaSlanje);
              },
              child: Text("Sacuvaj"))
        ],
      ),
    );
  }
}
