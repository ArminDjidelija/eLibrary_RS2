import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/upit.dart';
import 'package:elibrary_bibliotekar/providers/upiti_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
                  decoration: const InputDecoration(labelText: "Naslov"),
                  enabled: false,
                  name: 'naslov',
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
                  decoration: const InputDecoration(labelText: "Upit"),
                  enabled: false,
                  name: 'upit',
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
                  decoration: const InputDecoration(labelText: "Odgovor"),
                  minLines: 1,
                  maxLines: null,
                  name: 'odgovor',
                )),
                const SizedBox(
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
                var formValidate = _formKey.currentState?.saveAndValidate();
                var request = Map.from(_formKey.currentState!.value);
                if (formValidate == true) {
                  try {
                    await upitiProvider.update(
                        widget.upit!.upitId!, {'odgovor': request['odgovor']});
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Uspješno sačuvano!",
                        width: 400);
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
