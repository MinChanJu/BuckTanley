import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetItSettings.init();
  await FirebaseSettings.init();
  await PermissionSettings.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<MessageProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<FriendProvider>()),
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BuckTanley",
      navigatorKey: getIt<GlobalKey<NavigatorState>>(),
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return child!;
              },
            ),
          ],
        );
      },
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
