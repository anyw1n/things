import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thoughts/features/daily_thoughts/ui/daily_screen.dart';
import 'package:thoughts/features/daily_thoughts/ui/thought_details_screen.dart';

part 'app_router.g.dart';

final appRouter = GoRouter(routes: $appRoutes);

@immutable
@TypedGoRoute<DailyRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ThoughtDetailsRoute>(path: 'thought/:id'),
  ],
)
class DailyRoute extends GoRouteData with $DailyRoute {
  const DailyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DailyScreen();
}

@immutable
class ThoughtDetailsRoute extends GoRouteData with $ThoughtDetailsRoute {
  const ThoughtDetailsRoute({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ThoughtDetailsScreen(thoughtId: id);
}
