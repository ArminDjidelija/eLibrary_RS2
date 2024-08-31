import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_bibliotekar/models/valuta.dart';
import 'package:elibrary_bibliotekar/providers/tip_clanarine_biblioteka_provider.dart';
import 'package:elibrary_bibliotekar/providers/valute_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class TipClanarineBibliotekaDetailsScreen extends StatefulWidget {
  TipClanarineBiblioteka? tipClanarineBiblioteka;
  TipClanarineBibliotekaDetailsScreen({super.key, this.tipClanarineBiblioteka});

  @override
  State<TipClanarineBibliotekaDetailsScreen> createState() =>
      _TipClanarineBibliotekaDetailsScreenState();
}

class _TipClanarineBibliotekaDetailsScreenState
    extends State<TipClanarineBibliotekaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late TipClanarineBibliotekaProvider tipClanarineBibliotekaProvider;
  late ValutaProvider valutaProvider;
  SearchResult<Valuta>? valutaResult;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    tipClanarineBibliotekaProvider =
        context.read<TipClanarineBibliotekaProvider>();
    valutaProvider = context.read<ValutaProvider>();

    super.initState();
    _initialValue = {
      'tipClanarineBibliotekaId':
          widget.tipClanarineBiblioteka?.tipClanarineBibliotekaId.toString(),
      'naziv': widget.tipClanarineBiblioteka?.naziv.toString(),
      'trajanje': widget.tipClanarineBiblioteka?.trajanje.toString(),
      'iznos': widget.tipClanarineBiblioteka?.iznos.toString(),
      'bibliotekaId': widget.tipClanarineBiblioteka?.bibliotekaId.toString(),
      'valutaId': widget.tipClanarineBiblioteka?.valutaId.toString(),
    };
    if (widget.tipClanarineBiblioteka?.tipClanarineBibliotekaId != null) {
      isEditing = true;
    } else {
      isEditing = false;
    }
    initForm();
  }

  Future initForm() async {
    valutaResult = await valutaProvider.get();

    setState(() {
      isLoading = false;
    });
    print("retreived valute: ${valutaResult?.resultList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Tip clanarine",
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
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Trajanje"),
                  name: 'trajanje',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    //FormBuilderValidators.numeric(errorText: "Mora biti broj"),
                    //FormBuilderValidators.max(365,
                    //    errorText: "Maksimalna vrijednost je 365"),
                    //FormBuilderValidators.min(1,
                    //    errorText: "Minimalna vrijednost je 1"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: const InputDecoration(labelText: "Iznos"),
                  name: 'iznos',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    //FormBuilderValidators.numeric(errorText: "Mora biti broj"),
                    //FormBuilderValidators.min(0,
                    //  errorText: "Mora biti veći od 0"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderDropdown(
                    name: "valutaId",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Obavezno polje"),
                    ]),
                    decoration: const InputDecoration(labelText: "Valuta"),
                    items: valutaResult?.resultList
                            .map((e) => DropdownMenuItem(
                                value: e.valutaId.toString(),
                                child: Text(e.naziv ?? "")))
                            .toList() ??
                        [],
                  ),
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
                var request = Map.from(_formKey.currentState!.value);
                if (formCheck == true) {
                  if (widget.tipClanarineBiblioteka == null) {
                    try {
                      await tipClanarineBibliotekaProvider.insert(request);
                      QuickAlert.show(
                          context: context,
                          width: 450,
                          type: QuickAlertType.success,
                          text: "Tip clanarine je uspješno dodat");
                      _formKey.currentState?.reset();
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          width: 450,
                          type: QuickAlertType.error,
                          text: "Greška prilikom dodavanja");
                    }
                  } else {
                    if (widget.tipClanarineBiblioteka != null) {
                      request['bibliotekaId'] =
                          widget.tipClanarineBiblioteka!.bibliotekaId;
                    }
                    try {
                      await tipClanarineBibliotekaProvider.update(
                          widget.tipClanarineBiblioteka!
                              .tipClanarineBibliotekaId!,
                          request);
                      QuickAlert.show(
                          context: context,
                          width: 450,
                          type: QuickAlertType.success,
                          text: "Tip clanarine je uspješno uređen");
                    } on Exception catch (e) {
                      QuickAlert.show(
                          context: context,
                          width: 450,
                          type: QuickAlertType.error,
                          text: "Greška prilikom uredivanja");
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
