import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:elibrary_bibliotekar/models/knjiga.dart';
import 'package:elibrary_bibliotekar/models/search_result.dart';
import 'package:elibrary_bibliotekar/providers/knjiga_provider.dart';
import 'package:elibrary_bibliotekar/providers/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KnjigeListScreen extends StatefulWidget {
  const KnjigeListScreen({super.key});

  @override
  State<KnjigeListScreen> createState() => _KnjigeListScreenState();
}

class _KnjigeListScreenState extends State<KnjigeListScreen> {
  late KnjigaProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider = context.read<KnjigaProvider>();
  }

  SearchResult<Knjiga>? result = null;
  // KnjigaDataSource? _dataSource;

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Knjige",
        Container(
          child: Column(
            children: [_buildSearch(), _buildResultView()],
          ),
        ));
  }

  TextEditingController _naslovEditingController = TextEditingController();
  TextEditingController _autorEditingController = TextEditingController();

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _naslovEditingController,
            decoration: InputDecoration(labelText: "Naziv"),
            onChanged: (value) async {
              _updateFilter(value, _autorEditingController.text);
            },
          )),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            controller: _autorEditingController,
            decoration: InputDecoration(labelText: "Autor"),
            onChanged: (value) async {
              _updateFilter(_naslovEditingController.text, value);
            },
          )),
          ElevatedButton(
              onPressed: () async {
                var filter = {
                  'naslovGTE': _naslovEditingController.text,
                  'autor': _autorEditingController.text
                };
                _updateFilter(_naslovEditingController.text,
                    _autorEditingController.text);

                setState(() {});
              },
              child: Text("Pretraga")),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                //todo pretraga
              },
              child: Text("Nova knjiga")),
        ],
      ),
    );
  }

  Future<void> _updateFilter(String naslov, String autor) async {
    // Update filter object based on current text field values
    var filter = {
      'naslovGTE': naslov,
      'autor': autor,
      'page': 1,
      'pageSize': 5
    };

    // Consider adding validation or error handling here, if needed

    // Call the provider to fetch data with the updated filter
    result = await provider.get(filter: filter);
    setState(() {});
  }

  Widget _buildResultView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 2,
            ),
            DataTable(
              columns: const [
                // DataColumn(label: Text("Id"), numeric: true),
                DataColumn(
                  label: Text("Naziv"),
                ),
                DataColumn(label: Text("ISBN")),
                DataColumn(label: Text("Godina izdanja")),
                DataColumn(label: Text("Broj izdanja")),
                DataColumn(label: Text("Broj stranica")),
                DataColumn(label: Text("Slika")),
              ],
              // source: _dataSource ?? KnjigaDataSource([]),
              // rowsPerPage: 5,
              // columnSpacing: 20,
              rows: result?.resultList
                      .map((e) => DataRow(cells: [
                            // DataCell(Text(e.knjigaId.toString())),
                            DataCell(Text(e.naslov.toString() ?? "")),
                            DataCell(Text(e.isbn.toString() ?? "")),
                            DataCell(Text(e.godinaIzdanja.toString() ?? "")),
                            DataCell(Text(e.brojIzdanja.toString() ?? "")),
                            DataCell(Text(e.brojStranica.toString() ?? "")),
                            DataCell(e.slika != null
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    child: imageFromString(e.slika!),
                                  )
                                : Text("")),
                          ]))
                      .toList()
                      .cast<DataRow>() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}

// class KnjigaDataSource extends DataTableSource {
//   final List<Knjiga> data;

//   KnjigaDataSource(this.data);

//   @override
//   DataRow getRow(int index) {
//     assert(index >= 0);
//     // if (index >= data.length) return null;
//     final knjiga = data[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text(knjiga.naslov ?? "")),
//         DataCell(Text(knjiga.isbn ?? "")),
//         DataCell(Text(knjiga.godinaIzdanja.toString())),
//         DataCell(Text(knjiga.brojIzdanja.toString())),
//         DataCell(Text(knjiga.brojStranica.toString())),
//         DataCell(knjiga.slika != null
//             ? Container(
//                 width: 50,
//                 height: 50,
//                 child: imageFromString(knjiga.slika!),
//               )
//             : Text("")),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 1;
// }
