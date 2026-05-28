// This file is generated, do not edit it manually!
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'Sheet1_localization_en.dart';
import 'Sheet1_localization_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Sheet1Localization
/// returned by `Sheet1Localization.of(context)`.
///
/// Applications need to include `Sheet1Localization.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'Sheet1/Sheet1_localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Sheet1Localization.localizationsDelegates,
///   supportedLocales: Sheet1Localization.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Sheet1Localization.supportedLocales
/// property.
abstract class Sheet1Localization {
  Sheet1Localization(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Sheet1Localization of(BuildContext context) {
    return Localizations.of<Sheet1Localization>(context, Sheet1Localization)!;
  }

  static const LocalizationsDelegate<Sheet1Localization> delegate =
      _Sheet1LocalizationDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// application name
  ///
  /// In en, this message translates to:
  /// **'NovaForge Starter'**
  String get title;

  /// yes label
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;
}

class _Sheet1LocalizationDelegate
    extends LocalizationsDelegate<Sheet1Localization> {
  const _Sheet1LocalizationDelegate();

  @override
  Future<Sheet1Localization> load(Locale locale) {
    return SynchronousFuture<Sheet1Localization>(
      lookupSheet1Localization(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_Sheet1LocalizationDelegate old) => false;
}

Sheet1Localization lookupSheet1Localization(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return Sheet1LocalizationEn();
    case 'ru':
      return Sheet1LocalizationRu();
  }

  throw FlutterError(
    'Sheet1Localization.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
