// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:firebase_auth/firebase_auth.dart' as _i8;
import 'package:flutter/material.dart' as _i7;
import 'package:telegram_app/models/user.dart' as _i9;
import 'package:telegram_app/pages/chat_page.dart' as _i5;
import 'package:telegram_app/pages/main_page.dart' as _i1;
import 'package:telegram_app/pages/new_message_page.dart' as _i4;
import 'package:telegram_app/pages/sign_in_page.dart' as _i2;
import 'package:telegram_app/pages/sign_up_page.dart' as _i3;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.MainPage(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: _i2.SignInPage()),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: _i3.SignUpPage()),
      );
    },
    NewMessageRoute.name: (routeData) {
      final args = routeData.argsAs<NewMessageRouteArgs>();
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(
            child: _i4.NewMessagePage(
          key: args.key,
          user: args.user,
        )),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(
            child: _i5.ChatPage(
          key: args.key,
          user: args.user,
          other: args.other,
        )),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          MainRoute.name,
          path: '/',
        ),
        _i6.RouteConfig(
          SignInRoute.name,
          path: '/sign-in-page',
        ),
        _i6.RouteConfig(
          SignUpRoute.name,
          path: '/sign-up-page',
        ),
        _i6.RouteConfig(
          NewMessageRoute.name,
          path: '/new-message-page',
        ),
        _i6.RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
      ];
}

/// generated route for
/// [_i1.MainPage]
class MainRoute extends _i6.PageRouteInfo<void> {
  const MainRoute()
      : super(
          MainRoute.name,
          path: '/',
        );

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.SignInPage]
class SignInRoute extends _i6.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/sign-in-page',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i3.SignUpPage]
class SignUpRoute extends _i6.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: '/sign-up-page',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i4.NewMessagePage]
class NewMessageRoute extends _i6.PageRouteInfo<NewMessageRouteArgs> {
  NewMessageRoute({
    _i7.Key? key,
    required _i8.User user,
  }) : super(
          NewMessageRoute.name,
          path: '/new-message-page',
          args: NewMessageRouteArgs(
            key: key,
            user: user,
          ),
        );

  static const String name = 'NewMessageRoute';
}

class NewMessageRouteArgs {
  const NewMessageRouteArgs({
    this.key,
    required this.user,
  });

  final _i7.Key? key;

  final _i8.User user;

  @override
  String toString() {
    return 'NewMessageRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i5.ChatPage]
class ChatRoute extends _i6.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i7.Key? key,
    required _i8.User user,
    required _i9.User other,
  }) : super(
          ChatRoute.name,
          path: '/chat-page',
          args: ChatRouteArgs(
            key: key,
            user: user,
            other: other,
          ),
        );

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.user,
    required this.other,
  });

  final _i7.Key? key;

  final _i8.User user;

  final _i9.User other;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, user: $user, other: $other}';
  }
}
