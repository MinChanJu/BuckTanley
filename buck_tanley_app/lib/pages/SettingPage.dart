import 'package:buck_tanley_app/widgets/AdBanner.dart';
import 'package:buck_tanley_app/widgets/LogoAppBar.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: LogoAppBar(),
      //body: ,
      bottomNavigationBar: AdBanner(),
    );
  }
}