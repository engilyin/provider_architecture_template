import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider_start/core/models/post/post.dart';
import 'package:provider_start/ui/views/home/home_view.dart';
import 'package:provider_start/ui/views/login/login_view.dart';
import 'package:provider_start/ui/views/main/main_view.dart';
import 'package:provider_start/ui/views/settings/settings_view.dart';
import 'package:provider_start/ui/views/startup/start_up_view.dart';
import 'package:provider_start/ui/widgets/stateful/post_details/post_details_view.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends _$AppRouter {

  @override
  RouteType get defaultRouteType => const RouteType.adaptive(); //.cupertino, .adaptive ..etc

  @override
  final List<AutoRoute> routes = [
    AdaptiveRoute(page: MainRoute.page),
    AdaptiveRoute(page: LoginRoute.page),
    AdaptiveRoute(page: StartUpRoute.page, initial: true),
    AdaptiveRoute(page: PostDetailsRoute.page)
  ];
}
