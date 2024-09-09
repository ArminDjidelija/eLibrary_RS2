import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_mobile/models/ciljna_grupa.dart';
import 'package:elibrary_mobile/models/kanton.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/citaoci_provider.dart';
import 'package:elibrary_mobile/providers/kanton_provider.dart';
import 'package:elibrary_mobile/screens/moj_elibrary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class CitalacProfilScreen extends StatefulWidget {
  const CitalacProfilScreen({super.key});

  @override
  State<CitalacProfilScreen> createState() => _CitalacProfilScreenState();
}

class _CitalacProfilScreenState extends State<CitalacProfilScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CitaociProvider citaociProvider;
  late KantonProvider kantonProvider;
  // List<Kanton> kantoni = [];
  List<Kanton> kantoni = [];
  bool promijeniLozinku = false;
  int? kanton = AuthProvider.kantonId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    citaociProvider = context.read<CitaociProvider>();
    kantonProvider = context.read<KantonProvider>();
    _initialValue = {
      'ime': AuthProvider.ime.toString(),
      'prezime': AuthProvider.prezime.toString(),
      'kantonId': AuthProvider.kantonId.toString(),
      'telefon': AuthProvider.telefon.toString(),
      'institucija': AuthProvider.institucija == null
          ? ""
          : AuthProvider.institucija.toString(),
      'lozinka': null,
      'novaLozinka': null,
      'lozinkaPotvrda': null
    };
    _initForm();
  }

  Future _initForm() async {
    var kantoniResult = await kantonProvider.get(retrieveAll: true);
    kantoni = kantoniResult.resultList;
    setState(() {});
  }

  Future<List<Kanton>> getKantone(String naziv) async {
    var kantoniSearch = await kantonProvider
        .get(retrieveAll: true, filter: {'nazivGTE': naziv});
    var kantoniList = kantoniSearch.resultList;
    return kantoniList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildPage(),
    );
  }

  Widget _buildAppBarHeader() {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: const Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Profil",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [_buildProfileHeader(), _saveRow()]),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
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
                  decoration: const InputDecoration(labelText: "Ime"),
                  name: 'ime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(2,
                        errorText: "Minimalna dužina je 2 znaka"),
                    FormBuilderValidators.maxLength(50,
                        errorText: "Maksimalna dužina je 50 znakova"),
                  ]),
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
                  decoration: const InputDecoration(labelText: "Prezime"),
                  name: 'prezime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(2,
                        errorText: "Minimalna dužina je 2 znaka"),
                    FormBuilderValidators.maxLength(50,
                        errorText: "Maksimalna dužina je 50 znakova"),
                  ]),
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
                  decoration: const InputDecoration(labelText: "Telefon"),
                  name: 'telefon',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.match(r'^\+\d{7,15}$',
                        errorText:
                            "Telefon ima od 7 do 15 cifara i počinje znakom+"),
                  ]),
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
                  decoration: const InputDecoration(labelText: "Institucija"),
                  name: 'institucija',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.maxLength(100,
                        errorText: "Maksimalno 100 znakova"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown(
                    name: "kantonId",
                    onChanged: (value) =>
                        {kanton = int.parse(value.toString())},
                    decoration: const InputDecoration(labelText: "Kanton"),
                    items: kantoni
                            .map((e) => DropdownMenuItem(
                                value: e.kantonId.toString(),
                                child: Text(e.naziv ?? "")))
                            .toList() ??
                        [],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Obavezno polje"),
                    ]),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderCheckbox(
                  initialValue: promijeniLozinku,
                  name: 'promijeniLozinku',
                  title: const Text("Promijeni lozinku"),
                  onChanged: (value) => {
                    setState(() {
                      promijeniLozinku = value!;
                    })
                  },
                )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            if (promijeniLozinku == true)
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: FormBuilderTextField(
                      decoration:
                          const InputDecoration(labelText: "Stara lozinka"),
                      obscureText: true,
                      name: 'lozinka',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje"),
                      ]),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            if (promijeniLozinku == true)
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: FormBuilderTextField(
                      decoration:
                          const InputDecoration(labelText: "Nova lozinka"),
                      name: 'novaLozinka',
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje"),
                      ]),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            if (promijeniLozinku == true)
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: FormBuilderTextField(
                      decoration: const InputDecoration(
                          labelText: "Potvrda nove lozinke"),
                      name: 'lozinkaPotvrda',
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje"),
                      ]),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
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
                if (formCheck == true) {
                  var request = Map.from(_formKey.currentState!.value);
                  request['kantonId'] = kanton;
                  try {
                    await citaociProvider.update(
                        AuthProvider.citalacId!, request);
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: "Uspješno modifikovan profil",
                    );
                    AuthProvider.ime = request['ime'];
                    AuthProvider.prezime = request['prezime'];
                    AuthProvider.telefon = request['telefon'];
                    AuthProvider.institucija = request['institucija'];
                    AuthProvider.kantonId = kanton;

                    if (request['lozinka'] != null &&
                        request['novaLozinka'] != null &&
                        request['lozinkaPotvrda'] != null &&
                        promijeniLozinku == true) {
                      AuthProvider.password = request['novaLozinka'];
                      resetPassword();
                      setState(() {
                        _formKey.currentState?.fields['promijeniLozinku']
                            ?.didChange(false);
                      });
                    }
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: e.toString());

                    resetPassword();
                  }
                }
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }

  void resetPassword() {
    setState(() {
      _formKey.currentState?.fields['lozinka']?.didChange(null);
      _formKey.currentState?.fields['novaLozinka']?.didChange(null);
      _formKey.currentState?.fields['lozinkaPotvrda']?.didChange(null);
    });
  }
}
