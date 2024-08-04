import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_mobile/models/ciljna_grupa.dart';
import 'package:elibrary_mobile/models/kanton.dart';
import 'package:elibrary_mobile/providers/kanton_provider.dart';
import 'package:flutter/material.dart';
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
  late KantonProvider kantonProvider;
  // List<Kanton> kantoni = [];
  List<int> kantoni = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kantonProvider = context.read<KantonProvider>();

    _initForm();
    _initialValue = {'ime': "Armin", 'prezime': "Didelija"};
  }

  Future _initForm() async {
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
          Container(
            child: _buildProfileHeader(),
          ),
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
                Expanded(
                    child: DropdownSearch<Kanton>.multiSelection(
                  popupProps: const PopupPropsMultiSelection.menu(
                      isFilterOnline: true,
                      showSearchBox: true,
                      searchDelay: Duration(milliseconds: 5)),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText: "Odaberi kanton",
                          hintText: "Unesite naziv kantona")),
                  asyncItems: (String filter) async {
                    var kantoni = await getKantone(filter);
                    return kantoni;
                  },
                  onChanged: (List<Kanton> c) {
                    if (c != null || c.isNotEmpty) {
                      kantoni = c.map((a) => a.kantonId!).toList();
                    }
                    c.forEach((element) {
                      print(element.kantonId);
                    });
                  },
                  compareFn: (item1, item2) => item1.kantonId == item2.kantonId,
                  itemAsString: (Kanton u) => "${u.naziv}",
                  validator: (List<Kanton>? c) {
                    if (c == null || c.isEmpty) {
                      return 'Obavezno polje';
                    }
                  },
                  onSaved: (newValue) => {
                    if (newValue != null) {print(newValue.length)}
                  },
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
}
