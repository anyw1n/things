import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:things/blocs/thoughts/thoughts_bloc.dart';
import 'package:things/di.dart';
import 'package:things/i18n/translations.g.dart';
import 'package:things/ui/widgets/widgets.dart';
import 'package:things/utils.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ThoughtsBloc>()..add(.loadRequested(date: .now())),
      child: const _DailyView(),
    );
  }
}

class _DailyView extends StatefulWidget {
  const _DailyView({super.key});

  @override
  State<_DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<_DailyView> {
  late final PageController _pageController;

  var _today = DateTime.now().onlyDate;
  var _currentPageIndex = 0;

  void _onPageChanged(int index) {
    _currentPageIndex = index;
    setState(() {});
    context.read<ThoughtsBloc>().add(
      .loadRequested(date: _today.subtract(.new(days: index))),
    );
  }

  void _onThoughtSubmit(String content) => context.read<ThoughtsBloc>().add(
    .addPressed(
      icon: '📝',
      title: 'Note',
      content: content,
    ),
  );

  void _onBackToToday() {
    _today = .now().onlyDate;
    setState(() {});
    if (_currentPageIndex == 0) {
      context.read<ThoughtsBloc>().add(.loadRequested(date: _today));
    } else {
      _pageController.animateToPage(
        0,
        duration: const .new(milliseconds: 500),
        curve: Curves.ease,
      );
    }
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
                itemBuilder: (context, index) {
                  final date = _today.subtract(.new(days: index));
                  return BlocSelector<
                    ThoughtsBloc,
                    ThoughtsState,
                    ThoughtsByDateState?
                  >(
                    selector: (state) => state.statesByDate[date],
                    builder: (context, state) {
                      final child = switch (state) {
                        null || ThoughtsByDateLoadInProgress() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        ThoughtsByDateLoadSuccess(:final thoughts) =>
                          ThoughtListWidget(thoughts: thoughts),
                        ThoughtsByDateLoadFailure(:final message) => Center(
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
                  );
                },
              ),
            ),
            Padding(
              padding: const .all(16),
              child: AnimatedCrossFade(
                crossFadeState:
                    _currentPageIndex == 0 && _today == .now().onlyDate
                    ? .showFirst
                    : .showSecond,
                duration: const .new(milliseconds: 200),
                firstChild: ThoughtInputWidget(
                  onSubmit: _onThoughtSubmit,
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
