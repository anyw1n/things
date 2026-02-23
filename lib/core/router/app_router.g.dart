// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$dailyRoute];

RouteBase get $dailyRoute => GoRouteData.$route(
  path: '/',
  factory: $DailyRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'thought/:id',
      factory: $ThoughtDetailsRoute._fromState,
    ),
  ],
);

mixin $DailyRoute on GoRouteData {
  static DailyRoute _fromState(GoRouterState state) => const DailyRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ThoughtDetailsRoute on GoRouteData {
  static ThoughtDetailsRoute _fromState(GoRouterState state) =>
      ThoughtDetailsRoute(id: int.parse(state.pathParameters['id']!));

  ThoughtDetailsRoute get _self => this as ThoughtDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/thought/${Uri.encodeComponent(_self.id.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
