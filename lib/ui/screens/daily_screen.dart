import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:things/blocs/add_thoughts/add_thoughts_bloc.dart';
import 'package:things/blocs/day_thoughts/day_thoughts_bloc.dart';
import 'package:things/di.dart';
import 'package:things/i18n/translations.g.dart';
import 'package:things/ui/widgets/widgets.dart';
import 'package:things/utils.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  late final PageController _pageController;

  var _today = DateTime.now().onlyDate;
  var _currentPageIndex = 0;

  bool get _todaySynchronized => _today == .now().onlyDate;

  void _onPageChanged(int index) {
    _currentPageIndex = index;
    setState(() {});
  }

  void _onBackToToday() {
    _today = .now().onlyDate;
    setState(() {});
    _pageController.animateToPage(
      0,
      duration: const .new(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = .new();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addThoughtStateListener(BuildContext context, AddThoughtsState state) {
    final (String? text, AnimatedTopSnackBarType type) = switch (state) {
      AddThoughtsSuccess() => (state.reaction ?? t.dailyScreen.saved, .info),
      AddThoughtsFailure() => (state.message, .error),
      _ => (null, .info),
    };
    if (text == null) return;
    AnimatedTopSnackBar.show(context: context, message: text, type: type);
  }

  Widget _bottomWidgetLayoutBuilder(
    Widget topChild,
    Key topChildKey,
    Widget bottomChild,
    Key bottomChildKey,
  ) {
    final expandSecond =
        (topChildKey as ValueKey<CrossFadeState>).value == .showSecond;
    return Stack(
      children: expandSecond
          ? [
              Positioned(key: bottomChildKey, child: bottomChild),
              Positioned.fill(key: topChildKey, child: topChild),
            ]
          : [
              Positioned.fill(key: bottomChildKey, child: bottomChild),
              Positioned(key: topChildKey, child: topChild),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                reverse: true,
                onPageChanged: _onPageChanged,
                allowImplicitScrolling: true,
                itemBuilder: (context, index) => _DayPage(
                  date: _today.subtract(.new(days: index)),
                ),
              ),
            ),
            Padding(
              padding: const .all(16),
              child: AnimatedCrossFade(
                crossFadeState: _currentPageIndex == 0 && _todaySynchronized
                    ? .showFirst
                    : .showSecond,
                duration: const .new(milliseconds: 200),
                firstChild: BlocProvider(
                  create: (context) => getIt<AddThoughtsBloc>(),
                  child: BlocConsumer<AddThoughtsBloc, AddThoughtsState>(
                    listenWhen: (_, cur) =>
                        cur is AddThoughtsSuccess || cur is AddThoughtsFailure,
                    listener: _addThoughtStateListener,
                    buildWhen: (prev, cur) =>
                        prev is AddThoughtsInProgress ||
                        cur is AddThoughtsInProgress,
                    builder: (context, state) {
                      return ThoughtInputWidget(
                        onSubmit: (content) => context
                            .read<AddThoughtsBloc>()
                            .add(.addRequested(content: content)),
                        enabled: state is! AddThoughtsInProgress,
                        isLoading: state is AddThoughtsInProgress,
                      );
                    },
                  ),
                ),
                secondChild: ElevatedButton.icon(
                  onPressed: _onBackToToday,
                  iconAlignment: .end,
                  label: Text(t.dailyScreen.backToToday),
                  icon: const Icon(Icons.arrow_forward),
                ),
                layoutBuilder: _bottomWidgetLayoutBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPage extends StatelessWidget {
  const _DayPage({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DayThoughtsBloc>(param1: date)..add(const .loadRequested()),
      child: BlocBuilder<DayThoughtsBloc, DayThoughtsState>(
        builder: (context, state) {
          final child = switch (state) {
            DayThoughtsInitial() || DayThoughtsLoadInProgress() => const Center(
              child: CircularProgressIndicator(),
            ),
            DayThoughtsStateLoadSuccess(:final thoughts) => ThoughtListWidget(
              thoughts: thoughts,
            ),
            DayThoughtsLoadFailure(:final message) => Center(
              child: Text('Error: $message'),
            ),
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateHeaderWidget(date: date),
              Expanded(child: child),
            ],
          );
        },
      ),
    );
  }
}
