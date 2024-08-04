import 'package:elibrary_mobile/models/obavijest.dart';
import 'package:elibrary_mobile/providers/obavijesti_provider.dart';
import 'package:elibrary_mobile/providers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ObavijestScreen extends StatefulWidget {
  Obavijest obavijest;
  ObavijestScreen({super.key, required this.obavijest});

  @override
  State<ObavijestScreen> createState() => _ObavijestScreenState();
}

class _ObavijestScreenState extends State<ObavijestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _initForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          // color: Colors.blue,
          // margin: EdgeInsets.only(bottom: 5),
          height: 75,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: const Row(
            children: [
              Text(
                "Obavijest",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildObavijesti()],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObavijesti() {
    return _buildPrijasnjiPenalCard(obavijest: widget.obavijest);
  }

  Widget _buildPrijasnjiPenalCard({required Obavijest obavijest}) {
    return InkWell(
      onTap: () => {},
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: const Icon(Icons.newspaper),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            obavijest.naslov.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                              Text(
                                formatDateToLocal(obavijest.datum.toString()),
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                obavijest.biblioteka!.naziv.toString(),
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  obavijest.tekst!,
                  style: const TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
