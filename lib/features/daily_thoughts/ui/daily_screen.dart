import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thoughts/core/di/di.dart';
import 'package:thoughts/core/i18n/translations.g.dart';
import 'package:thoughts/core/utils/utils.dart';
import 'package:thoughts/features/daily_thoughts/bloc/add_thoughts/add_thoughts_bloc.dart';
import 'package:thoughts/features/daily_thoughts/bloc/day_thoughts/day_thoughts_bloc.dart';
import 'package:thoughts/features/daily_thoughts/ui/widgets/widgets.dart';

enum _View {
  list,
  bubbles
  ;

  _View next() => values[(index + 1) % values.length];
}

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  late final PageController _pageController;

  var _today = DateTime.now().onlyDate;
  var _currentPageIndex = 0;
  var _view = _View.bubbles;

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
                  view: _view,
                  onSwitchView: () => setState(() => _view = _view.next()),
                  isActive: index == _currentPageIndex,
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
                alignment: .bottomCenter,
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
                secondChild: SizedBox(
                  width: .infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _onBackToToday,
                    iconAlignment: .end,
                    label: Text(t.dailyScreen.backToToday),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
                layoutBuilder: (top, topKey, bottom, bottomKey) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      key: bottomKey,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: bottom,
                    ),
                    Positioned(key: topKey, child: top),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPage extends StatelessWidget {
  const _DayPage({
    required this.date,
    required this.view,
    required this.onSwitchView,
    required this.isActive,
  });

  final DateTime date;
  final _View view;
  final void Function() onSwitchView;
  final bool isActive;

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
            DayThoughtsStateLoadSuccess(:final thoughts) => switch (view) {
              .list => ThoughtListWidget(thoughts: thoughts),
              .bubbles => Padding(
                padding: const .symmetric(horizontal: 16),
                child: ThoughtBubblesWidget(
                  thoughts: thoughts,
                  isActive: isActive,
                ),
              ),
            },
            DayThoughtsLoadFailure(:final message) => Center(
              child: Text('Error: $message'),
            ),
          };
          return Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  DateHeaderWidget(date: date),
                  Padding(
                    padding: const .all(16),
                    child: TextButton(
                      onPressed: onSwitchView,
                      child: Text(t.dailyScreen.switchView),
                    ),
                  ),
                ],
              ),
              Expanded(child: child),
            ],
          );
        },
      ),
    );
  }
}
