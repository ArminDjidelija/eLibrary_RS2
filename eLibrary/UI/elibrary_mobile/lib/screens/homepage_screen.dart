import 'package:elibrary_mobile/layouts/base_mobile_screen.dart';
import 'package:flutter/material.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseMobileScreen(
      title: "Homepage",
      widget: _buildPage(),
      appBarWidget: _buildAppBarHeader(),
    );
  }

  Widget _buildAppBarHeader() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        children: [
          // IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pretraži eLibrary',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 45.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality here
              },
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildPage() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Preporučene knjige",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildPreporuceneKnjige(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreporuceneKnjige() {
    return Placeholder();
  }
}
