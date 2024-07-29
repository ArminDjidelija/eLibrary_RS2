// import 'dart:convert';
// import 'dart:io';

// import 'package:elibrary_mobile/layouts/bibliotekar_master_screen.dart';
// import 'package:elibrary_mobile/models/autor.dart';
// import 'package:elibrary_mobile/models/ciljna_grupa.dart';
// import 'package:elibrary_mobile/models/izdavac.dart';
// import 'package:elibrary_mobile/models/jezik.dart';
// import 'package:elibrary_mobile/models/knjiga.dart';
// import 'package:elibrary_mobile/models/search_result.dart';
// import 'package:elibrary_mobile/models/uvez.dart';
// import 'package:elibrary_mobile/models/vrsta_grade.dart';
// import 'package:elibrary_mobile/models/vrsta_sadrzaja.dart';
// import 'package:elibrary_mobile/providers/autori_provider.dart';
// import 'package:elibrary_mobile/providers/ciljne_grupe_provider.dart';
// import 'package:elibrary_mobile/providers/izdavac_provider.dart';
// import 'package:elibrary_mobile/providers/jezici_provider.dart';
// import 'package:elibrary_mobile/providers/knjiga_provider.dart';
// import 'package:elibrary_mobile/providers/uvez_provider.dart';
// import 'package:elibrary_mobile/providers/vrsta_grade_provider.dart';
// import 'package:elibrary_mobile/providers/vrste_sadrzaja_provider.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:provider/provider.dart';

// class AutorDetailsScreen extends StatefulWidget {
//   Autor? autor;
//   AutorDetailsScreen({super.key, this.autor});

//   @override
//   State<AutorDetailsScreen> createState() => _KnjigaDetailsScreenState();
// }

// class _KnjigaDetailsScreenState extends State<AutorDetailsScreen> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   Map<String, dynamic> _initialValue = {};
//   late AutoriProvider autoriProvider;

//   bool isLoading = true;
//   bool isEditing = false;
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     autoriProvider = context.read<AutoriProvider>();
//     // TODO: implement initState
//     super.initState();
//     _initialValue = {
//       'autorId': widget.autor?.autorId.toString(),
//       'ime': widget.autor?.ime.toString(),
//       'prezime': widget.autor?.prezime.toString(),
//       'godinaRodjenja': widget.autor?.godinaRodjenja.toString(),
//     };
//     if (widget.autor?.autorId != null) {
//       isEditing = true;
//     } else {
//       isEditing = false;
//     }
//     //initForm();
//   }

//   // Future initForm() async {
//   //   jeziciResult = await jezikProvider.get();
//   //   vrsteGradeResult = await vrstaGradeProvider.get();
//   //   izdavaciResult = await izdavacProvider.get();
//   //   uveziResult = await uvezProvider.get();
//   //   autoriResult = await autoriProvider.get();
//   //   ciljneGrupeResult = await ciljneGrupeProvider.get();
//   //   vrsteSadrzajaResult = await vrsteSadrzajaProvider.get();
//   //   setState(() {
//   //     isLoading = false;
//   //   });
//   //   print("retreived jezici: ${jeziciResult?.resultList.length}");
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return CitalacMasterScreen(
//         "Autor detalji",
//         Column(
//           children: [_buildForm(), _saveRow()],
//         ));
//   }

//   Widget _buildForm() {
//     return FormBuilder(
//       key: _formKey,
//       initialValue: _initialValue,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                     child: FormBuilderTextField(
//                   decoration: InputDecoration(labelText: "Ime"),
//                   name: 'ime',
//                   // validator: FormBuilderValidators.compose([
//                   //   FormBuilderValidators.required(),
//                   //   FormBuilderValidators.email(),
//                   // ]),
//                 )),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                     child: FormBuilderTextField(
//                   decoration: InputDecoration(labelText: "Prezime"),
//                   name: 'prezime',
//                 )),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                     child: FormBuilderTextField(
//                   decoration: InputDecoration(labelText: "Godina rođenja"),
//                   name: 'godinaRodjenja',
//                 )),
//                 SizedBox(
//                   width: 10,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _saveRow() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 _formKey.currentState?.saveAndValidate();
//                 var request = Map.from(_formKey.currentState!.value);
//                 if (widget.autor == null) {
//                   autoriProvider.insert(request);
//                 } else {
//                   autoriProvider.update(widget.autor!.autorId!, request);
//                 }
//                 // print(knjigaSlanje);
//               },
//               child: Text("Sacuvaj"))
//         ],
//       ),
//     );
//   }
// }
