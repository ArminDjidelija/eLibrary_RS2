import 'package:elibrary_mobile/layouts/citalac_master_screen.dart';
import 'package:elibrary_mobile/models/autor.dart';
import 'package:elibrary_mobile/models/search_result.dart';
import 'package:elibrary_mobile/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_mobile/models/valuta.dart';
import 'package:elibrary_mobile/providers/autori_provider.dart';
import 'package:elibrary_mobile/providers/tip_clanarine_biblioteka_provider.dart';
import 'package:elibrary_mobile/providers/valute_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

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

    // TODO: implement initState
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
    return CitalacMasterScreen(
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
                  decoration: InputDecoration(labelText: "Biblioteka"),
                  name: 'bibliotekaId',
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  //   FormBuilderValidators.email(),
                  // ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Naziv"),
                  name: 'naziv',
                  // validator: FormBuilderValidators.compose([
                  //   FormBuilderValidators.required(),
                  //   FormBuilderValidators.email(),
                  // ]),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Trajanje"),
                  name: 'trajanje',
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Iznos"),
                  name: 'iznos',
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "valutaId",
                  decoration: InputDecoration(labelText: "Valuta"),
                  items: valutaResult?.resultList
                          .map((e) => DropdownMenuItem(
                              value: e.valutaId.toString(),
                              child: Text(e.naziv ?? "")))
                          .toList() ??
                      [],
                )),
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
                _formKey.currentState?.saveAndValidate();
                var request = Map.from(_formKey.currentState!.value);
                if (widget.tipClanarineBiblioteka == null) {
                  tipClanarineBibliotekaProvider.insert(request);
                } else {
                  tipClanarineBibliotekaProvider.update(
                      widget.tipClanarineBiblioteka!.tipClanarineBibliotekaId!,
                      request);
                }
                // print(knjigaSlanje);
              },
              child: Text("Sacuvaj"))
        ],
      ),
    );
  }
}
