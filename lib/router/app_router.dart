import 'package:auto_route/auto_route.dart';
import 'package:telegram_app/pages/chat_page.dart';
import 'package:telegram_app/pages/main_page.dart';
import 'package:telegram_app/pages/new_message_page.dart';
import 'package:telegram_app/pages/sign_in_page.dart';
import 'package:telegram_app/pages/sign_up_page.dart';

// Notacuin Notazione
@MaterialAutoRouter(
  // replaceInRouteName: 'Page, Route',
  replaceInRouteName: 'Page,Route',
  preferRelativeImports: false,
  routes: <AutoRoute>[
    AutoRoute(page: MainPage, initial: true),

    AutoRoute(page: SignInPage),
    AutoRoute(page: SignUpPage),
    AutoRoute(page: NewMessagePage),
    AutoRoute(page: ChatPage),
  ]
)
class $AppRouter {}