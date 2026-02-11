import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:things/ui/screens/daily_screen.dart';

part 'app_router.g.dart';

final appRouter = GoRouter(routes: $appRoutes);

@immutable
@TypedGoRoute<DailyRoute>(path: '/')
class DailyRoute extends GoRouteData with $DailyRoute {
  const DailyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DailyScreen();
}
