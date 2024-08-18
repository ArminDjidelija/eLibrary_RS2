import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_mobile/models/ciljna_grupa.dart';
import 'package:elibrary_mobile/models/kanton.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/citaoci_provider.dart';
import 'package:elibrary_mobile/providers/kanton_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    citaociProvider = context.read<CitaociProvider>();
    kantonProvider = context.read<KantonProvider>();
    _initialValue = {
      'ime': AuthProvider.ime,
      'prezime': AuthProvider.prezime,
    };
    _initForm();
  }

  Future _initForm() async {
    var citalac = await citaociProvider.getById(AuthProvider.citalacId!);
    var kantoniResult = await kantonProvider.get(retrieveAll: true);

    setState(() {
      kantoni = kantoniResult.resultList;
      _initialValue['kantonId'] = citalac.kantonId;
      _initialValue['telefon'] = citalac.telefon;
      _initialValue['institucija'] = citalac.institucija;
    });
    _formKey.currentState?.reset();
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
                  decoration: InputDecoration(labelText: "Ime"),
                  name: 'ime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
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
                  decoration: InputDecoration(labelText: "Prezime"),
                  name: 'prezime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
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
                  decoration: InputDecoration(labelText: "Telefon"),
                  name: 'telefon',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
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
                  decoration: InputDecoration(labelText: "Institucija"),
                  name: 'institucija',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
                )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                if (kantoni.isNotEmpty)
                  Expanded(
                      child: FormBuilderDropdown(
                    // initialValue:
                    //     kantoni.isEmpty ? null : AuthProvider.kantonId,
                    name: "kantonId",
                    decoration: InputDecoration(labelText: "Kanton"),
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
                _formKey.currentState?.saveAndValidate();
                var request = Map.from(_formKey.currentState!.value);
                citaociProvider.update(AuthProvider.citalacId!, request);

                // print(knjigaSlanje);
              },
              child: Text("Sacuvaj"))
        ],
      ),
    );
  }
}
