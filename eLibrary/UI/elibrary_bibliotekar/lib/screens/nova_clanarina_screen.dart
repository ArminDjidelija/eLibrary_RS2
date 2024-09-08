import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/tip_clanarine_biblioteka.dart';
import 'package:elibrary_bibliotekar/models/tip_uplate.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/citaoci_provider.dart';
import 'package:elibrary_bibliotekar/providers/clanarine_provider.dart';
import 'package:elibrary_bibliotekar/providers/tip_clanarine_biblioteka_provider.dart';
import 'package:elibrary_bibliotekar/providers/tip_uplate_provider.dart';
import 'package:elibrary_bibliotekar/screens/clanarine_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  late ClanarineProvider clanarineProvider;
  late TipUplateProvider tipUplateProvider;
  List<TipClanarineBiblioteka> tipoviClanarina = [];
  List<TipUplate> tipoviUplata = [];

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
    super.initState();

    tipClanarineBibliotekaProvider =
        context.read<TipClanarineBibliotekaProvider>();
    citaociProvider = context.read<CitaociProvider>();
    clanarineProvider = context.read<ClanarineProvider>();
    tipUplateProvider = context.read<TipUplateProvider>();

    initForm();
  }

  Future initForm() async {
    var tipoviClanarinaResult = await tipClanarineBibliotekaProvider.get(
        retrieveAll: true, filter: {'bibliotekaId': AuthProvider.bibliotekaId});
    tipoviClanarina = tipoviClanarinaResult.resultList;

    var tipUplateResult = await tipUplateProvider.get(retrieveAll: true);
    tipoviUplata = tipUplateResult.resultList;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Nova članarina",
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
                    child: FormBuilderDropdown(
                  onChanged: (value) => {},
                  name: "tipClanarineBibliotekaId",
                  decoration: const InputDecoration(labelText: "Tip clanarine"),
                  items: tipoviClanarina
                      .map((e) => DropdownMenuItem(
                          value: e.tipClanarineBibliotekaId.toString(),
                          child: Text(e.naziv ?? "")))
                      .toList(),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderDropdown(
                  name: "tipUplateId",
                  decoration: const InputDecoration(labelText: "Tip uplate"),
                  items: tipoviUplata
                      .map((e) => DropdownMenuItem(
                          value: e.tipUplateId.toString(),
                          child: Text(e.naziv ?? "")))
                      .toList(),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: DropdownSearch<Citalac>(
                  popupProps: const PopupPropsMultiSelection.menu(
                      isFilterOnline: true,
                      showSearchBox: true,
                      searchDelay: Duration(milliseconds: 5)),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText: "Odaberi korisnika",
                          hintText: "Unesite ime i prezime čitaoca")),
                  asyncItems: (String filter) async {
                    var citaoci = await getCitaoci(filter);
                    return citaoci;
                  },
                  onChanged: (Citalac? c) {
                    citalacId = c!.citalacId;
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
              onPressed: () async {
                var formCheck = _formKey.currentState?.saveAndValidate();
                var request = Map.from(_formKey.currentState!.value);
                if (formCheck == true) {
                  try {
                    request['citalacId'] = citalacId;
                    request['bibliotekaId'] = AuthProvider.bibliotekaId;
                    await clanarineProvider.insert(request);
                    QuickAlert.show(
                        context: context,
                        width: 450,
                        type: QuickAlertType.success,
                        text: "Članarina je uspješno dodata",
                        onCancelBtnTap: () => {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => ClanarineListScreen(),
                                ),
                              ),
                            },
                        onConfirmBtnTap: () => {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => ClanarineListScreen(),
                                ),
                              ),
                            });
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        width: 450,
                        type: QuickAlertType.error,
                        text: "Greška prilikom dodavanja");
                  }
                }
              },
              child: const Text("Sacuvaj"))
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
