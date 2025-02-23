import 'package:buck_tanley_app/SetUp.dart';
import 'package:provider/provider.dart'; // as app_provider;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: getIt<UserProvider>()),
        ChangeNotifierProvider<MessageProvider>.value(value: getIt<MessageProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // 앱 종료 시 실행되는 로직
      print('앱이 종료됩니다. 데이터 저장 중...');
      // 예: 로그아웃, 로컬 DB 저장 등
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BuckTanley",
      navigatorKey: getIt<GlobalKey<NavigatorState>>(),
      home: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLogin) {
            return const PageRouter();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
