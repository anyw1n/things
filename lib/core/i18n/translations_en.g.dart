///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Things'
	String get title => 'Things';

	late final TranslationsDailyScreenEn dailyScreen = TranslationsDailyScreenEn.internal(_root);
	late final TranslationsThoughtDetailsScreenEn thoughtDetailsScreen = TranslationsThoughtDetailsScreenEn.internal(_root);

	/// en: 'Back'
	String get back => 'Back';
}

// Path: dailyScreen
class TranslationsDailyScreenEn {
	TranslationsDailyScreenEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add a thought...'
	String get addThoughtHint => 'Add a thought...';

	/// en: 'No thoughts for this day.'
	String get noThoughts => 'No thoughts for this day.';

	/// en: '(today) {Today} (yesterday) {Yesterday} (other) {${date: DateFormat('EEEE')}}'
	String dateHeaderTitle({required HeaderDateContext context, required DateTime date}) {
		switch (context) {
			case HeaderDateContext.today:
				return 'Today';
			case HeaderDateContext.yesterday:
				return 'Yesterday';
			case HeaderDateContext.other:
				return '${DateFormat('EEEE', 'en').format(date)}';
		}
	}

	/// en: '${date: DateFormat('MMM d')}'
	String dateHeaderSubtitle({required DateTime date}) => '${DateFormat('MMM d', 'en').format(date)}';

	/// en: 'Back to today'
	String get backToToday => 'Back to today';

	/// en: 'Saved'
	String get saved => 'Saved';

	/// en: 'Switch view'
	String get switchView => 'Switch view';
}

// Path: thoughtDetailsScreen
class TranslationsThoughtDetailsScreenEn {
	TranslationsThoughtDetailsScreenEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Thought not found'
	String get thoughtNotFound => 'Thought not found';

	/// en: '${date: DateFormat('MMM d, HH:mm')}'
	String dateCreated({required DateTime date}) => '${DateFormat('MMM d, HH:mm', 'en').format(date)}';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'title' => 'Things',
			'dailyScreen.addThoughtHint' => 'Add a thought...',
			'dailyScreen.noThoughts' => 'No thoughts for this day.',
			'dailyScreen.dateHeaderTitle' => ({required HeaderDateContext context, required DateTime date}) { switch (context) { case HeaderDateContext.today: return 'Today'; case HeaderDateContext.yesterday: return 'Yesterday'; case HeaderDateContext.other: return '${DateFormat('EEEE', 'en').format(date)}'; } }, 
			'dailyScreen.dateHeaderSubtitle' => ({required DateTime date}) => '${DateFormat('MMM d', 'en').format(date)}',
			'dailyScreen.backToToday' => 'Back to today',
			'dailyScreen.saved' => 'Saved',
			'dailyScreen.switchView' => 'Switch view',
			'thoughtDetailsScreen.thoughtNotFound' => 'Thought not found',
			'thoughtDetailsScreen.dateCreated' => ({required DateTime date}) => '${DateFormat('MMM d, HH:mm', 'en').format(date)}',
			'back' => 'Back',
			_ => null,
		};
	}
}
