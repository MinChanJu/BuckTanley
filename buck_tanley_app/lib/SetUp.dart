// Models
export 'package:buck_tanley_app/models/dto/ApiResponse.dart';
export 'package:buck_tanley_app/models/dto/LoginDTO.dart';
export 'package:buck_tanley_app/models/dto/MatchDTO.dart';
export 'package:buck_tanley_app/models/dto/UserDTO.dart';
export 'package:buck_tanley_app/models/entity/Friend.dart';
export 'package:buck_tanley_app/models/entity/Message.dart';
export 'package:buck_tanley_app/models/entity/User.dart';
export 'package:buck_tanley_app/models/Imager.dart';
export 'package:buck_tanley_app/models/Setting.dart';

// Pages
export 'package:buck_tanley_app/pages/ChatListPage.dart';
export 'package:buck_tanley_app/pages/ChattingPage.dart';
export 'package:buck_tanley_app/pages/FriendListPage.dart';
export 'package:buck_tanley_app/pages/HomePage.dart';
export 'package:buck_tanley_app/pages/LoginPage.dart';
export 'package:buck_tanley_app/pages/MatchingPage.dart';
export 'package:buck_tanley_app/pages/PageRouter.dart';
export 'package:buck_tanley_app/pages/RegisterPage.dart';
export 'package:buck_tanley_app/pages/SettingPage.dart';
export 'package:buck_tanley_app/pages/settings/AppInfoTab.dart';
export 'package:buck_tanley_app/pages/settings/HelpSupportTab.dart';
export 'package:buck_tanley_app/pages/settings/LogoutTab.dart';
export 'package:buck_tanley_app/pages/settings/MyPageTab.dart';
export 'package:buck_tanley_app/pages/settings/NotificationTab.dart';
export 'package:buck_tanley_app/pages/settings/SecurityTab.dart';

// Provider
export 'package:buck_tanley_app/provider/MessageProvider.dart';
export 'package:buck_tanley_app/provider/UserProvider.dart';

// Services
export 'package:buck_tanley_app/services/WebSocketService.dart';

// Utils
export 'package:buck_tanley_app/utils/ImageConverter.dart';
export 'package:buck_tanley_app/utils/Navigate.dart';
export 'package:buck_tanley_app/utils/Room.dart';
export 'package:buck_tanley_app/utils/Server.dart';
export 'package:buck_tanley_app/utils/Snack.dart';
export 'package:buck_tanley_app/utils/Time.dart';

// Widgets
export 'package:buck_tanley_app/widgets/AdBanner.dart';
export 'package:buck_tanley_app/widgets/ChatWidget.dart';
export 'package:buck_tanley_app/widgets/FriendWidget.dart';
export 'package:buck_tanley_app/widgets/LogoAppBar.dart';
export 'package:buck_tanley_app/widgets/MessageWidget.dart';
export 'package:buck_tanley_app/widgets/MiniGameWidget.dart';


// 🛠️ GetIt & instance 설정
import 'package:get_it/get_it.dart';
import 'package:buck_tanley_app/provider/MessageProvider.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:flutter/material.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Provider 등록
  getIt.registerSingleton<UserProvider>(UserProvider());
  getIt.registerSingleton<MessageProvider>(MessageProvider());

  // Navigator Key 등록
  getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

  // 초기 데이터 로딩
  await getIt<UserProvider>().loadUser();
}