import 'package:elibrary_bibliotekar/layouts/bibliotekar_master_screen.dart';
import 'package:flutter/material.dart';

class KnjigeListScreen extends StatelessWidget {
  const KnjigeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BibliotekarMasterScreen(
        "Lista knjiga",
        Column(
          children: [
            Text("Lista knjiga placeholder"),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Nazad"))
          ],
        ));
  }
}
