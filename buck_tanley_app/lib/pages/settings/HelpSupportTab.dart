import 'package:flutter/material.dart';

class HelpSupportTab extends StatelessWidget {
  const HelpSupportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("도움말 및 고객지원")),
      body: Center(child: Text("도움말 및 고객지원")),
    );
  }
}