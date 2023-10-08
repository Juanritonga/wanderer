import 'package:flutter/material.dart';

import 'package:wanderer/presentations/bloc/router_bloc.dart';

import 'package:wanderer/presentations/pages/auth/login_page.dart';
import 'package:wanderer/presentations/pages/auth/register_page.dart';
import 'package:wanderer/presentations/pages/auth/resetConfirmation.dart';
import 'package:wanderer/presentations/pages/auth/reset_page.dart';
import 'package:wanderer/presentations/pages/favorite_page.dart';
import 'package:wanderer/presentations/pages/getStarted/first_page.dart';
import 'package:wanderer/presentations/pages/getStarted/third_page.dart';
import 'package:wanderer/presentations/pages/add_marker/maps_page.dart';
import 'package:wanderer/presentations/pages/add_marker/marker_category.dart';
import 'package:wanderer/presentations/pages/marker_page/marker_paget.dart';
import 'package:wanderer/presentations/pages/pengelola_page/name_form_page.dart';
import 'package:wanderer/presentations/pages/splashScreen.dart';
import 'package:wanderer/presentations/pages/tab_screen.dart';
import 'package:wanderer/presentations/pages/add_marker/tambah_marker.dart';
import '../../domain/entities/marker.dart';
import '../pages/getStarted/second_page.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  bool? isFirstTime;

  //THIS IS FOR ROUTING GETTING STARTED
  bool second = false;
  bool third = false;

  String categoryName = "";
  Markers marker = const Markers(
      name: "name",
      description: "description",
      image: [],
      jenis: "jenis",
      latitude: 0,
      longitude: 0,
      userId: "userId",
      contact: "contact",
      socialMedia: "socialMedia",
      address: "",
      harga: "");

  final RouterCubit routerCubit;

  MyRouterDelegate(this.routerCubit)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    await routerCubit.checkLoginStatus();
    isFirstTime = routerCubit.state;
    print("start $isFirstTime");
    notifyListeners();
  }

  List<Page> _historyStack = [];

  @override
  Widget build(BuildContext context) {
    if (isFirstTime == null) {
      _historyStack = _splashScreen;
    } else if (isFirstTime == true) {
      _historyStack = _gettingStartedStack;
    } else {
      _historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: _historyStack,
      onGenerateRoute: (settings) {
        if (settings.name == ResetPage.routeName) {
          return MaterialPageRoute(
            builder: (context) => const ResetPage(),
            settings: settings,
          );
        }
        if (settings.name == RegisterPage.routeName) {
          return MaterialPageRoute(
            builder: (context) => const RegisterPage(),
            settings: settings,
          );
        }

        if (settings.name == ResetConfirmation.routeName) {
          return MaterialPageRoute(
              builder: (context) => const ResetConfirmation(),
              settings: settings);
        }
        if (settings.name == LoginPage.routeName) {
          return MaterialPageRoute(
            builder: (context) => const LoginPage(),
            settings: settings,
          );
        }
        if (settings.name == TabScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) => const TabScreen(),
            settings: settings,
          );
        }
        if (settings.name == MarkerCategoryPage.routeName) {
          return MaterialPageRoute(
            builder: (context) => MarkerCategoryPage(),
            settings: settings,
          );
        }
        if (settings.name == AddMarkerPage.routeName) {
          return MaterialPageRoute(
            builder: (context) => AddMarkerPage(
              category: categoryName,
            ),
            settings: settings,
          );
        }
        if (settings.name == MapFullPage.routeName) {
          return MaterialPageRoute(
            builder: (context) => const MapFullPage(),
            settings: settings,
          );
        }
        if (settings.name == MarkerPage.routeName) {
          return MaterialPageRoute(
            builder: (context) => MarkerPage(),
            settings: settings,
          );
        }
        if (settings.name == FavoritePage.routeName) {
          return MaterialPageRoute(
            builder: (context) => const FavoritePage(),
            settings: settings,
          );
        }
        if (settings.name == NameFormPage.routeName) {
          return MaterialPageRoute(
            builder: (context) => const NameFormPage(),
            settings: settings,
          );
        }

        return null;
      },
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  void nextSecond() {
    second = true;
    notifyListeners();
  }

  void nextThird() {
    third = true;
    second = false;
    notifyListeners();
  }

  void firstTimeDone() {
    isFirstTime = false;
    routerCubit.firstTimeFalse();
    notifyListeners();
  }

  void addCategory(String category) {
    categoryName = category;
    notifyListeners();
  }

  List<Page> get _gettingStartedStack => [
        const MaterialPage(
          key: ValueKey('firstPage'),
          child: GettingStartedFirst(),
        ),
        if (second == true)
          const MaterialPage(
            key: ValueKey('secondPage'),
            child: GettingStartedSecond(),
          ),
        if (third == true)
          const MaterialPage(
            key: ValueKey('thirdPage'),
            child: GettingStartedThird(),
          ),
      ];

  List<Page> get _loggedOutStack => [
        const MaterialPage(key: ValueKey('tabscreen'), child: TabScreen()),
      ];
  List<Page> get _splashScreen => [
        const MaterialPage(
          key: ValueKey('value'),
          child: SplashScreen(),
        ),
      ];
}
