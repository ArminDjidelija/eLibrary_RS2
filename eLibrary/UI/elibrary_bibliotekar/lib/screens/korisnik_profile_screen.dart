import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/providers/auth_provider.dart';
import 'package:elibrary_bibliotekar/providers/korisnici_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class KorisnikProfileScreen extends StatefulWidget {
  KorisnikProfileScreen({super.key});
  @override
  State<KorisnikProfileScreen> createState() => _KorisnikProfileCreenState();
}

class _KorisnikProfileCreenState extends State<KorisnikProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KorisnikProvider korisnikProvider;
  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _prezimeController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  bool promijeniLozinku = false;
  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    korisnikProvider = context.read<KorisnikProvider>();
    super.initState();

    initForm();
  }

  Future initForm() async {
    if (AuthProvider.korisnikId == null) {
      Navigator.pop(context);
    } else {
      var korisnik = await korisnikProvider.getById(AuthProvider.korisnikId!);

      _imeController.text = korisnik.ime ?? '';
      _prezimeController.text = korisnik.prezime ?? '';
      _telefonController.text = korisnik.telefon ?? '';

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Novi korisnik",
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
                  controller: _imeController,
                  decoration: const InputDecoration(labelText: "Ime"),
                  name: 'ime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(2,
                        errorText: "Minimalno dužina je 2 znaka"),
                    FormBuilderValidators.maxLength(50,
                        errorText: "Maksimalno dužina je 50 znakova"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  controller: _prezimeController,
                  decoration: const InputDecoration(labelText: "Prezime"),
                  name: 'prezime',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.minLength(2,
                        errorText: "Minimalna dužina je 2 znaka"),
                    FormBuilderValidators.maxLength(50,
                        errorText: "Maksimalno dužina je 50 znakova"),
                  ]),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: FormBuilderTextField(
                  controller: _telefonController,
                  decoration: const InputDecoration(labelText: "Telefon"),
                  name: 'telefon',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "Obavezno polje"),
                    FormBuilderValidators.match(r'^\+\d{7,15}$',
                        errorText:
                            "Telefon ima od 7 do 15 cifara i počinje znakom+"),
                  ]),
                )),
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
            if (promijeniLozinku)
              Row(
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Stara lozinka"),
                    name: 'staraLozinka',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Obavezno polje"),
                      FormBuilderValidators.minLength(2,
                          errorText: "Minimalna dužina je 2 znaka"),
                      FormBuilderValidators.maxLength(50,
                          errorText: "Maksimalno dužina je 50 znakova"),
                    ]),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Nova lozinka"),
                    name: 'lozinka',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Obavezno polje"),
                      FormBuilderValidators.minLength(2,
                          errorText: "Minimalna dužina je 2 znaka"),
                      FormBuilderValidators.maxLength(50,
                          errorText: "Maksimalno dužina je 50 znakova"),
                    ]),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Lozinka potvrda"),
                    name: 'lozinkaPotvrda',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Obavezno polje"),
                      FormBuilderValidators.minLength(2,
                          errorText: "Minimalna dužina je 2 znaka"),
                      FormBuilderValidators.maxLength(50,
                          errorText: "Maksimalno dužina je 50 znakova"),
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
                var formaCheck = _formKey.currentState?.saveAndValidate();
                if (formaCheck == true) {
                  var request = Map.from(_formKey.currentState!.value);

                  try {
                    await korisnikProvider.update(
                        AuthProvider.korisnikId!, request);
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Uspješno sačuvano!");
                    var lozinka = request['lozinka'];
                    var staraLozinka = request['staraLozinka'];
                    var lozinkaPotvrda = request['lozinkaPotvrda'];

                    if (promijeniLozinku == true &&
                        (lozinka != null || lozinka != "") &&
                        (staraLozinka != null || staraLozinka != "") &&
                        (lozinkaPotvrda != null || lozinkaPotvrda != "")) {
                      AuthProvider.password = lozinkaPotvrda.toString();
                    }

                    setState(() {
                      _formKey.currentState?.fields['lozinka']?.didChange(null);
                      _formKey.currentState?.fields['staraLozinka']
                          ?.didChange(null);
                      _formKey.currentState?.fields['lozinkaPotvrda']
                          ?.didChange(null);
                      _formKey.currentState?.fields['promijeniLozinku']
                          ?.didChange(false);
                    });
                  } on Exception catch (e) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: e.toString());
                  }
                }
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }
}
