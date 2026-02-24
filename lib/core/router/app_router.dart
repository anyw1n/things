import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thoughts/features/daily_thoughts/ui/daily_screen.dart';
import 'package:thoughts/features/daily_thoughts/ui/thought_details_screen.dart';

part 'app_router.g.dart';

/// Application router with typed route definitions.
final appRouter = GoRouter(routes: $appRoutes);

/// Root route that renders the daily thoughts screen.
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

/// Route for displaying details of a single thought by id.
@immutable
class ThoughtDetailsRoute extends GoRouteData with $ThoughtDetailsRoute {
  const ThoughtDetailsRoute({required this.id});

  /// Thought identifier resolved from the route path.
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ThoughtDetailsScreen(thoughtId: id);
}
