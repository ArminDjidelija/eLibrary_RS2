import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/izdavac.dart';
import 'package:elibrary_bibliotekar/providers/izdavac_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  }

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
                    decoration: const InputDecoration(labelText: "Naziv"),
                    name: 'naziv',
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(
                            errorText: "Vrijednost je obavezna"),
                        FormBuilderValidators.maxLength(200,
                            errorText: "Maksimalno dužina je 200 znakova"),
                      ],
                    ),
                  ),
                ),
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
                  if (widget.izdavac == null) {
                    try {
                      await izdavacProvider.insert(request);
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Uspješno dodat izdavač",
                        width: 300,
                      );
                      _formKey.currentState?.reset();
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška pri dodavanju izdavača",
                          width: 300);
                    }
                  } else {
                    try {
                      await izdavacProvider.update(
                          widget.izdavac!.izdavacId!, request);
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Uspješno modifikovan izdavač",
                          width: 400);
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška pri ažuriranju izdavača",
                          width: 300);
                    }
                  }
                }
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }
}
