import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('es'),
    Locale('lt'),
    Locale('ro'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LexNova'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// No description provided for @navFirm.
  ///
  /// In en, this message translates to:
  /// **'Our Firm'**
  String get navFirm;

  /// No description provided for @navBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get navBook;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystem;

  /// No description provided for @settingsLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsLight;

  /// No description provided for @settingsDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsDark;

  /// No description provided for @settingsAdmin.
  ///
  /// In en, this message translates to:
  /// **'Staff / Admin Login'**
  String get settingsAdmin;

  /// No description provided for @settingsLegal.
  ///
  /// In en, this message translates to:
  /// **'LEGAL & COMPLIANCE'**
  String get settingsLegal;

  /// No description provided for @settingsDemo.
  ///
  /// In en, this message translates to:
  /// **'About this Demo'**
  String get settingsDemo;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTerms;

  /// No description provided for @settingsGdpr.
  ///
  /// In en, this message translates to:
  /// **'GDPR & Data Use'**
  String get settingsGdpr;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get settingsData;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCache;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared (Demo)'**
  String get settingsCacheCleared;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settingsVersion;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageLt.
  ///
  /// In en, this message translates to:
  /// **'Lietuvių'**
  String get languageLt;

  /// No description provided for @languageRo.
  ///
  /// In en, this message translates to:
  /// **'Română'**
  String get languageRo;

  /// No description provided for @languageEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageEs;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to LexNova'**
  String get homeWelcome;

  /// No description provided for @homeSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search services, lawyers, insights...'**
  String get homeSearchPlaceholder;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeBookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get homeBookAppointment;

  /// No description provided for @homeOurServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get homeOurServices;

  /// No description provided for @homeLatestInsights.
  ///
  /// In en, this message translates to:
  /// **'Latest Insights'**
  String get homeLatestInsights;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get servicesTitle;

  /// No description provided for @servicesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get servicesSearchHint;

  /// No description provided for @servicesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get servicesFilterAll;

  /// No description provided for @servicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get servicesEmpty;

  /// No description provided for @servicesRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get servicesRetry;

  /// No description provided for @servicesLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get servicesLearnMore;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @insightsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search insights...'**
  String get insightsSearchHint;

  /// No description provided for @insightsSortLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest First'**
  String get insightsSortLatest;

  /// No description provided for @insightsSortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get insightsSortOldest;

  /// No description provided for @insightsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No insights found'**
  String get insightsEmpty;

  /// No description provided for @insightsReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get insightsReadMore;

  /// No description provided for @insightsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get insightsRetry;

  /// No description provided for @appointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get appointmentTitle;

  /// No description provided for @appointmentDateSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get appointmentDateSelect;

  /// No description provided for @appointmentTimeSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get appointmentTimeSelect;

  /// No description provided for @appointmentBookAnother.
  ///
  /// In en, this message translates to:
  /// **'Book Another'**
  String get appointmentBookAnother;

  /// No description provided for @appointmentSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get appointmentSuccessTitle;

  /// No description provided for @appointmentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your appointment request has been sent successfully.'**
  String get appointmentSuccessMessage;

  /// No description provided for @ourFirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Firm'**
  String get ourFirmTitle;

  /// No description provided for @teamOurTeam.
  ///
  /// In en, this message translates to:
  /// **'Our Team'**
  String get teamOurTeam;

  /// No description provided for @teamEmpty.
  ///
  /// In en, this message translates to:
  /// **'No team members found.'**
  String get teamEmpty;

  /// No description provided for @teamError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load team'**
  String get teamError;

  /// No description provided for @teamRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get teamRetry;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact & Office'**
  String get contactTitle;

  /// No description provided for @contactAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get contactAddress;

  /// No description provided for @contactOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get contactOpenMaps;

  /// No description provided for @contactCopyAddress.
  ///
  /// In en, this message translates to:
  /// **'Copy Address'**
  String get contactCopyAddress;

  /// No description provided for @contactCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get contactCopied;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactPhone;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmail;

  /// No description provided for @contactOfficeHours.
  ///
  /// In en, this message translates to:
  /// **'Office Hours'**
  String get contactOfficeHours;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search services, insights, team...'**
  String get searchHint;

  /// No description provided for @searchStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Search for legal services,\ninsights, and experts.'**
  String get searchStartTitle;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found for'**
  String get searchNoResults;

  /// No description provided for @searchFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchFilterAll;

  /// No description provided for @searchFilterServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get searchFilterServices;

  /// No description provided for @searchFilterInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get searchFilterInsights;

  /// No description provided for @searchFilterTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get searchFilterTeam;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'lt', 'ro'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'lt':
      return AppLocalizationsLt();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
