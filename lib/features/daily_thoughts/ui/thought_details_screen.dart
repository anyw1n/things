import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thoughts/core/database/app_database.dart';
import 'package:thoughts/core/di/di.dart';
import 'package:thoughts/core/i18n/translations.g.dart';
import 'package:thoughts/features/daily_thoughts/bloc/thought_details/thought_details_bloc.dart';

class ThoughtDetailsScreen extends StatelessWidget {
  const ThoughtDetailsScreen({
    required this.thoughtId,
    super.key,
  });

  final int thoughtId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              getIt<ThoughtDetailsBloc>(param1: thoughtId)
                ..add(const .loadRequested()),
          child: BlocBuilder<ThoughtDetailsBloc, ThoughtDetailsState>(
            builder: (context, state) {
              return switch (state) {
                ThoughtDetailsInitial() || ThoughtDetailsLoadInProgress() =>
                  const Center(child: CircularProgressIndicator()),
                ThoughtDetailsLoadFailure(:final message) => Center(
                  child: Text('Error: $message'),
                ),
                ThoughtDetailsNotFound() => Center(
                  child: Column(
                    mainAxisSize: .min,
                    spacing: 12,
                    children: [
                      Text(t.thoughtDetailsScreen.thoughtNotFound),
                      TextButton.icon(
                        onPressed: context.pop,
                        icon: const Icon(Icons.arrow_back),
                        label: Text(t.back),
                      ),
                    ],
                  ),
                ),
                ThoughtDetailsLoadSuccess(:final thought) =>
                  _ThoughtDetailsView(
                    thought: thought,
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _ThoughtDetailsView extends StatelessWidget {
  const _ThoughtDetailsView({required this.thought});

  final Thought thought;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return SingleChildScrollView(
      padding: const .all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${thought.icon} ${thought.title}',
                  style: textTheme.displayMedium,
                ),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: t.thoughtDetailsScreen.dateCreated(
                    date: thought.createdAt,
                  ),
                  style: textTheme.displaySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(thought.content),
        ],
      ),
    );
  }
}
