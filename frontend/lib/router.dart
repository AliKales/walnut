import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/m_product.dart';
import 'package:frontend/pages/auth/login_page/login_page_view.dart';
import 'package:frontend/pages/auth/signup_page/signup_page_view.dart';
import 'package:frontend/pages/loading_page/loading_page_view.dart';
import 'package:frontend/pages/main_page/main_page_view.dart';
import 'package:frontend/pages/product_page/product_page_view.dart';
import 'package:frontend/pages/seller_page/seller_page_view.dart';
import 'package:go_router/go_router.dart';

abstract class PagePaths {
  PagePaths._();

  static String main = "/";
  static String login = "/login";
  static String signup = "/signup";
  static String loading = "/loading";
  static String seller = "/seller";
  static String product = "/product";
}

final appRouter = GoRouter(
  initialLocation: PagePaths.loading,
  routes: [
    AppRoute(PagePaths.main, (s) => const MainPageView()),
    AppRoute(PagePaths.loading, (s) => const LoadingPageView()),
    AppRoute(PagePaths.login, (s) => const LoginPageView()),
    AppRoute(PagePaths.signup, (s) => const SignupPageView()),
    AppRoute(PagePaths.seller, (s) => const SellerPageView()),
    AppRoute(
      PagePaths.product,
      (s) => ProductPageView(
        product: s.extra as MProduct?,
      ),
    ),
  ],
);

class AppRoute extends GoRoute {
  AppRoute(
    String path,
    Widget Function(GoRouterState s) child,
  ) : super(
          path: path,
          pageBuilder: (context, state) {
            if (Platform.isIOS) {
              return CupertinoPage(child: child.call(state));
            }
            return MaterialPage(child: child.call(state));
          },
        );
}

extension ExtGoRouter on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();

    return location;
  }
}

extension ExtGoRouterState on GoRouterState {
  Map<String, dynamic> get params {
    final q = uri.queryParameters;

    Map<String, dynamic> convertedMap = {};

    q.forEach((key, value) {
      if (int.tryParse(value) != null) {
        convertedMap[key] = int.parse(value);
      } else if (double.tryParse(value) != null) {
        convertedMap[key] = double.parse(value);
      } else if (value.toLowerCase() == 'true' ||
          value.toLowerCase() == 'false') {
        convertedMap[key] = value.toLowerCase() == 'true';
      } else {
        convertedMap[key] = value;
      }
    });

    return convertedMap;
  }

  T? getParam<T>(String key) {
    final p = params;

    if (!p.containsKey(key) || p[key] == null || p[key] == "null") return null;

    if (T is bool) {
      return bool.tryParse(p[key]) as T;
    }

    return p[key];
  }

  ///[isAt] check if given path is current path
  bool isAt(String path) {
    return fullPath?.contains(path) ?? false;
  }

  ///[isAt] check if given path is current path
  bool isAtAny(List<String> path) {
    final i = path
        .indexWhere((e) => e.contains(fullPath?.replaceFirst("/", "") ?? ""));
    return i == -1 ? false : true;
  }
}
