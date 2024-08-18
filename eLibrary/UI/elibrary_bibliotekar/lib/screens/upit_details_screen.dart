import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/izdavac.dart';
import 'package:elibrary_bibliotekar/models/upit.dart';
import 'package:elibrary_bibliotekar/providers/izdavac_provider.dart';
import 'package:elibrary_bibliotekar/providers/upiti_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class UpitDetailsScreen extends StatefulWidget {
  Upit? upit;
  UpitDetailsScreen({super.key, this.upit});

  @override
  State<UpitDetailsScreen> createState() => _UpitDetailsScreenState();
}

class _UpitDetailsScreenState extends State<UpitDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late UpitiProvider upitiProvider;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    upitiProvider = context.read<UpitiProvider>();
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'upitId': widget.upit?.upitId.toString(),
      'upit': widget.upit?.upit.toString(),
      'naslov': widget.upit?.naslov.toString(),
      'odgovor': widget.upit?.odgovor.toString(),
    };
    if (widget.upit?.upitId != null) {
      isEditing = true;
    } else {
      isEditing = false;
    }
    //initForm();
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Upit",
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
                  enabled: false,
                  name: 'naslov',
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
                  decoration: InputDecoration(labelText: "Upit"),
                  enabled: false,
                  name: 'upit',
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
                  decoration: InputDecoration(labelText: "Odgovor"),
                  name: 'odgovor',
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
                  upitiProvider.update(
                      widget.upit!.upitId!, {'odgovor': request['odgovor']});
                }
              },
              child: Text("Sacuvaj"))
        ],
      ),
    );
  }
}
