import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
import 'package:elibrary_bibliotekar/providers/biblioteka_knjiga_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class BibliotekaKnjigaEditScreen extends StatefulWidget {
  BibliotekaKnjiga? bibliotekaKnjiga;
  BibliotekaKnjigaEditScreen({super.key, this.bibliotekaKnjiga});

  @override
  State<BibliotekaKnjigaEditScreen> createState() =>
      _BibliotekaKnjigaEditScreenState();
}

class _BibliotekaKnjigaEditScreenState
    extends State<BibliotekaKnjigaEditScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late BibliotekaKnjigaProvider provider;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    provider = context.read<BibliotekaKnjigaProvider>();
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'lokacija': widget.bibliotekaKnjiga?.lokacija != null
          ? widget.bibliotekaKnjiga?.lokacija
          : "",
      'brojKopija': widget.bibliotekaKnjiga?.brojKopija.toString(),
      'dostupnoCitaonica':
          widget.bibliotekaKnjiga?.dostupnoCitaonica.toString(),
      'dostupnoPozajmica':
          widget.bibliotekaKnjiga?.dostupnoPozajmica.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Biblioteka knjiga detalji",
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
                  decoration: const InputDecoration(labelText: "Lokacija"),
                  name: 'lokacija',
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Broj kopija"),
                    name: 'brojKopija',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Vrijednost je obavezna"),
                      FormBuilderValidators.integer(
                          errorText: "Vrijednost mora biti cijeli broj"),
                      FormBuilderValidators.min(1,
                          errorText: "Vrijednost mora biti barem 1")
                    ]),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Dostupno čitaonica"),
                    name: 'dostupnoCitaonica',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Vrijednost je obavezna"),
                      FormBuilderValidators.integer(
                          errorText: "Vrijednost mora biti cijeli broj"),
                      FormBuilderValidators.min(0,
                          errorText: "Vrijednost mora biti barem 0")
                    ]),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Dostupno pozajmica"),
                    name: 'dostupnoPozajmica',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Vrijednost je obavezna"),
                      FormBuilderValidators.integer(
                          errorText: "Vrijednost mora biti cijeli broj"),
                      FormBuilderValidators.min(0,
                          errorText: "Vrijednost mora biti barem 0")
                    ]),
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
              onPressed: () {
                var formCheck = _formKey.currentState?.saveAndValidate();
                if (formCheck == true) {
                  var request = Map.from(_formKey.currentState!.value);
                  provider.update(
                      widget!.bibliotekaKnjiga!.bibliotekaKnjigaId!, request);
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Uspješno modifikovana knjiga!");
                }
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }
}
