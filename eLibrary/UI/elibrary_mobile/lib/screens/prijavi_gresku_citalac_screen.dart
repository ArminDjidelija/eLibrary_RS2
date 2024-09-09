import 'package:elibrary_mobile/models/kanton.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/kanton_provider.dart';
import 'package:elibrary_mobile/providers/upiti_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class GreskaCitalacScreen extends StatefulWidget {
  const GreskaCitalacScreen({super.key});

  @override
  State<GreskaCitalacScreen> createState() => _GreskaCitalacScreenState();
}

class _GreskaCitalacScreenState extends State<GreskaCitalacScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late UpitiProvider upitiProvider;
  late KantonProvider kantonProvider;
  // List<Kanton> kantoni = [];
  List<Kanton> kantoni = [];
  bool promijeniLozinku = false;
  int? kanton = AuthProvider.kantonId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    upitiProvider = context.read<UpitiProvider>();
    kantonProvider = context.read<KantonProvider>();
    _initialValue = {
      'naslov': null,
      'upit': null,
      'citalacId': AuthProvider.citalacId.toString()
    };
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
                  decoration: const InputDecoration(labelText: "Naslov"),
                  name: 'naslov',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
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
                  decoration: const InputDecoration(labelText: "Opis"),
                  name: 'upit',
                  minLines: 1,
                  maxLines: null,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                  ]),
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
                var formCheck = _formKey.currentState?.saveAndValidate();
                if (formCheck == true) {
                  var request = Map.from(_formKey.currentState!.value);
                  request['citalacId'] = AuthProvider.citalacId;
                  try {
                    await upitiProvider.insert(request);
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Uspješno prijavljena greška");
                    _formKey.currentState?.reset();
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: e.toString());
                  }
                }
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }
}
