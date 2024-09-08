import 'package:dropdown_search/dropdown_search.dart';
import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/autor.dart';
import 'package:elibrary_bibliotekar/models/biblioteka_knjiga.dart';
import 'package:elibrary_bibliotekar/models/citalac.dart';
import 'package:elibrary_bibliotekar/models/rezervacija.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/autori_provider.dart';
import 'package:elibrary_bibliotekar/providers/citaoci_provider.dart';
import 'package:elibrary_bibliotekar/providers/pozajmice_provider.dart';
import 'package:elibrary_bibliotekar/providers/rezervacije_provider.dart';
import 'package:elibrary_bibliotekar/screens/pozajmice_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class NovaPozajmicaScreen extends StatefulWidget {
  BibliotekaKnjiga? bibliotekaKnjiga;
  Citalac? citalac;
  Rezervacija? rezervacija;
  NovaPozajmicaScreen(
      {super.key, this.bibliotekaKnjiga, this.citalac, this.rezervacija});

  @override
  State<NovaPozajmicaScreen> createState() => _NovaPozajmicaScreenState();
}

class _NovaPozajmicaScreenState extends State<NovaPozajmicaScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AutoriProvider autoriProvider;
  late CitaociProvider citaociProvider;
  late PozajmiceProvider pozajmiceProvider;
  late RezervacijeProvider rezervacijeProvider;
  Citalac? citalac;
  SearchResult<Citalac>? citaociResult;
  List<Citalac> citaoci = [];
  bool isLoading = true;
  bool isEditing = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    autoriProvider = context.read<AutoriProvider>();
    citaociProvider = context.read<CitaociProvider>();
    pozajmiceProvider = context.read<PozajmiceProvider>();
    rezervacijeProvider = context.read<RezervacijeProvider>();
    // TODO: implement initState
    super.initState();
    citalac = widget.citalac;
    _initialValue = {
      'citalacId': widget.citalac?.citalacId,
      'bibliotekaKnjigaId': widget.bibliotekaKnjiga?.bibliotekaId
    };
    initForm();
  }

  Future initForm() async {
    getCitaoci("");
    setState(() {
      isLoading = false;
    });
  }

  Future<List<Citalac>> getCitaoci(String imePrezime) async {
    var req = {'imePrezimeGTE': imePrezime};
    citaociResult =
        await citaociProvider.get(page: 1, pageSize: 10, filter: req);
    if (citaociResult != null) {
      citaoci = citaociResult!.resultList;
      return citaociResult!.resultList;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Nova pozajmica",
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
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.bibliotekaKnjiga!.knjiga!.naslov.toString()}, ${widget.bibliotekaKnjiga!.knjiga!.godinaIzdanja.toString()}",
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                    width: 200,
                    child: FormBuilderTextField(
                      decoration: const InputDecoration(
                          labelText: "Dužina pozajmice (dani)"),
                      name: 'trajanje',
                      initialValue: "7",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Vrijednost je obavezna"),
                        FormBuilderValidators.integer(
                            errorText: "Vrijednost mora biti cijeli broj"),
                        FormBuilderValidators.min(1,
                            errorText: "Minimalno trajanje je 1 dan"),
                      ]),
                    )),
                const SizedBox(
                  width: 10,
                ),
                // Expanded(
                //     child: FormBuilderDateTimePicker(
                //   decoration: InputDecoration(labelText: "Datum preuzimanja"),
                //   firstDate: DateTime.now().subtract(Duration(days: 5)),
                //   initialDate: DateTime.now(),
                //   initialTime: TimeOfDay.now(),
                //   format: DateFormat("yyyy-MM-ddThh:mm"),
                //   name: 'datumPreuzimanja',
                //   validator: FormBuilderValidators.compose([
                //     FormBuilderValidators.required(),
                //   ]),
                // )),
                // SizedBox(
                //   width: 10,
                // ),
                Container(
                    width: 200,
                    child: FormBuilderCheckbox(
                      title: const Text("Moguće produžiti"),
                      initialValue: false,
                      name: 'moguceProduziti',
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: DropdownSearch<Citalac>(
                  selectedItem: citalac,
                  enabled: citalac == null,
                  popupProps: const PopupPropsMultiSelection.menu(
                      // showSelectedItems: true,
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
                    _getClanarine(c);
                  },
                  itemAsString: (Citalac u) =>
                      "${u.ime} ${u.prezime}, ${u.korisnickoIme}, ${u.email}",
                  validator: (Citalac? c) {
                    if (c == null) {
                      return 'Obavezno polje';
                    }
                  },
                  onSaved: (newValue) => {
                    if (newValue != null) {print(newValue.citalacId)}
                  },
                )),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            // Row(
            //   children: [],
            // )
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
                  if (citalac != null) {
                    request['citalacId'] = citalac!.citalacId;
                    request['bibliotekaKnjigaId'] =
                        widget.bibliotekaKnjiga!.bibliotekaKnjigaId;
                    pozajmiceProvider.insert(request);
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: "Uspješno dodata nova pozajmica");
                    if (citalac?.citalacId == widget.citalac?.citalacId) {
                      if (widget.rezervacija != null) {
                        rezervacijeProvider
                            .zavrsi(widget.rezervacija!.rezervacijaId!);
                      }
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PozajmiceListScreen()));
                    print(request);
                  }
                } else {}

                // print(knjigaSlanje);
              },
              child: const Text("Sacuvaj"))
        ],
      ),
    );
  }

  Future<List<String>> getData(String filter) async {
    return ["Novi", "Stari"];
  }

  Future _getClanarine(Citalac? c) async {
    citalac = c;
    print("GET CLANARINE ${c!.ime}");
  }
}
