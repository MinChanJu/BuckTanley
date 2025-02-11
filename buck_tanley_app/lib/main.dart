import 'package:buck_tanley_app/pages/LoginPage.dart';
import 'package:buck_tanley_app/pages/PageRouter.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userProvider = UserProvider();
  await userProvider.loadUser();
  
  runApp(
    app_provider.MultiProvider(
      providers: [
        app_provider.ChangeNotifierProvider(create: (_) => userProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool login = app_provider.Provider.of<UserProvider>(context, listen: false).isLogin;
    return MaterialApp(
      title: 'BuckTanley',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: login ? const PageRouter() : const LoginPage(),
    );
  }
}