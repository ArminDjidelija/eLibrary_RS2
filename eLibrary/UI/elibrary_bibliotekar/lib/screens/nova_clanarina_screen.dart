import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_bibliotekar/providers/citaoci_provider.dart';
import 'package:elibrary_bibliotekar/providers/tip_clanarine_biblioteka_provider.dart';
import 'package:elibrary_bibliotekar/screens/tip_clanarine_biblioteka_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class NovaClanarinaScreen extends StatefulWidget {
  const NovaClanarinaScreen({super.key});

  @override
  State<NovaClanarinaScreen> createState() => _NovaClanarinaScreenState();
}

class _NovaClanarinaScreenState extends State<NovaClanarinaScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late TipClanarineBibliotekaProvider tipClanarineBibliotekaProvider;
  late CitaociProvider citaociProvider;
  List<TipClanarineBiblioteka> tipoviClanarina = [];

  Citalac? pocetniCitalac;
  int? citalacId;

  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tipClanarineBibliotekaProvider =
        context.read<TipClanarineBibliotekaProvider>();
    citaociProvider = context.read<CitaociProvider>();

    initForm();
  }

  Future initForm() async {
    var tipoviClanarinaResult = await tipClanarineBibliotekaProvider.get(
      retrieveAll: true,
    );
    tipoviClanarina = tipoviClanarinaResult.resultList;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Nova",
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
                    child: FormBuilderDropdown(
                  name: "tipClanarineId",
                  decoration: InputDecoration(labelText: "Tip clanarine"),
                  items: tipoviClanarina
                          .map((e) => DropdownMenuItem(
                              value: e.naziv.toString(),
                              child: Text(e.naziv ?? "")))
                          .toList() ??
                      [],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
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
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: DropdownSearch<Citalac>(
                  popupProps: PopupPropsMultiSelection.menu(
                      // showSelectedItems: true,
                      isFilterOnline: true,
                      showSearchBox: true,
                      searchDelay: Duration(milliseconds: 5)),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText: "Odaberi korisnika",
                          hintText: "Unesite ime i prezime čitaoca")),
                  asyncItems: (String filter) async {
                    var citaoci = await getCitaoci(filter);
                    return citaoci;
                  },
                  onChanged: (Citalac? c) {
                    citalacId = c!.citalacId;
                    // _getClanarine(c);
                  },
                  itemAsString: (Citalac u) =>
                      "${u.ime} ${u.prezime} --- ${u.korisnickoIme} --- ${u.email}",
                  validator: (Citalac? c) {
                    if (c == null) {
                      return 'Obavezno polje';
                    }
                  },
                  onSaved: (newValue) => {
                    if (newValue != null) {print(newValue.citalacId)}
                  },
                )),
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
                if (formCheck == true) {
                  // if (widget.tipClanarineBiblioteka == null) {
                  //   tipClanarineBibliotekaProvider.insert(request);
                  // } else {
                  //   tipClanarineBibliotekaProvider.update(
                  //       widget
                  //           .tipClanarineBiblioteka!.tipClanarineBibliotekaId!,
                  //       request);
                  // }
                }
                // print(knjigaSlanje);
              },
              child: Text("Sacuvaj"))
        ],
      ),
    );
  }

  Future<List<Citalac>> getCitaoci(String filter) async {
    var citaociScreen = await citaociProvider
        .get(page: 1, pageSize: 10, filter: {'imePrezimeGTE': filter});
    return citaociScreen.resultList;
  }
}
