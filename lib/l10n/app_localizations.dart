import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get navHealth;

  /// No description provided for @navAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get navAnalyze;

  /// No description provided for @navCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get navCoach;

  /// No description provided for @navStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get navStyle;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your day starts here'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your daily plan and progress will appear here as tracking features become available.'**
  String get homeEmptyBody;

  /// No description provided for @sectionFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get sectionFeatures;

  /// No description provided for @healthIntro.
  ///
  /// In en, this message translates to:
  /// **'Track your body, nutrition, sleep and daily activity.'**
  String get healthIntro;

  /// No description provided for @analyzeIntro.
  ///
  /// In en, this message translates to:
  /// **'On-device camera analysis. Frames are processed on your phone and discarded.'**
  String get analyzeIntro;

  /// No description provided for @coachIntro.
  ///
  /// In en, this message translates to:
  /// **'Ask about fitness, food, sleep, posture, skin, hair or style. Answers come from the app\'s own guides and your data, with pictures and links.'**
  String get coachIntro;

  /// No description provided for @styleIntro.
  ///
  /// In en, this message translates to:
  /// **'Clothing, color and outfits based on your measurements and preferences.'**
  String get styleIntro;

  /// No description provided for @featureStateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get featureStateAvailable;

  /// No description provided for @featureStateBeta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get featureStateBeta;

  /// No description provided for @featureStateComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get featureStateComingSoon;

  /// No description provided for @featureStateDeviceRequired.
  ///
  /// In en, this message translates to:
  /// **'Not supported on this device'**
  String get featureStateDeviceRequired;

  /// No description provided for @featureStateModelRequired.
  ///
  /// In en, this message translates to:
  /// **'Model required'**
  String get featureStateModelRequired;

  /// No description provided for @featureStateOnlineRequired.
  ///
  /// In en, this message translates to:
  /// **'Internet required'**
  String get featureStateOnlineRequired;

  /// No description provided for @featureStatePremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get featureStatePremium;

  /// No description provided for @featureProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get featureProfile;

  /// No description provided for @featureHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get featureHeight;

  /// No description provided for @featureBodyMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get featureBodyMeasurements;

  /// No description provided for @featureWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get featureWeight;

  /// No description provided for @featureWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get featureWater;

  /// No description provided for @featureMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get featureMeals;

  /// No description provided for @featureSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get featureSleep;

  /// No description provided for @featureActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get featureActivity;

  /// No description provided for @featureExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get featureExercise;

  /// No description provided for @featureHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get featureHabits;

  /// No description provided for @featureRoutines.
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get featureRoutines;

  /// No description provided for @featureReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get featureReminders;

  /// No description provided for @featureProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get featureProgress;

  /// No description provided for @featureCameraHeight.
  ///
  /// In en, this message translates to:
  /// **'Camera height estimate'**
  String get featureCameraHeight;

  /// No description provided for @featurePosture.
  ///
  /// In en, this message translates to:
  /// **'Posture analysis'**
  String get featurePosture;

  /// No description provided for @featureExerciseTracking.
  ///
  /// In en, this message translates to:
  /// **'Exercise tracking'**
  String get featureExerciseTracking;

  /// No description provided for @featureFace.
  ///
  /// In en, this message translates to:
  /// **'Face analysis'**
  String get featureFace;

  /// No description provided for @featureStyle.
  ///
  /// In en, this message translates to:
  /// **'Style recommendations'**
  String get featureStyle;

  /// No description provided for @featureWardrobe.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe'**
  String get featureWardrobe;

  /// No description provided for @featureAiCoach.
  ///
  /// In en, this message translates to:
  /// **'AI Coach'**
  String get featureAiCoach;

  /// No description provided for @featureHealthIntegration.
  ///
  /// In en, this message translates to:
  /// **'Connected data'**
  String get featureHealthIntegration;

  /// No description provided for @featureBackup.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup'**
  String get featureBackup;

  /// No description provided for @featureCommerce.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get featureCommerce;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'A private space for your wellbeing'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Track your body, health, habits and style in one place. Everything works offline.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this device'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPrivacyEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Records are stored in an encrypted database on this phone.'**
  String get onboardingPrivacyEncrypted;

  /// No description provided for @onboardingPrivacyCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera analysis runs on the device. Frames are not saved unless you choose to save them.'**
  String get onboardingPrivacyCamera;

  /// No description provided for @onboardingPrivacyAccount.
  ///
  /// In en, this message translates to:
  /// **'No account is required.'**
  String get onboardingPrivacyAccount;

  /// No description provided for @onboardingPrivacyAi.
  ///
  /// In en, this message translates to:
  /// **'AI is optional. The app works fully without it.'**
  String get onboardingPrivacyAi;

  /// No description provided for @onboardingPrefsTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your preferences'**
  String get onboardingPrefsTitle;

  /// No description provided for @onboardingPrefsBody.
  ///
  /// In en, this message translates to:
  /// **'You can change these at any time in Settings.'**
  String get onboardingPrefsBody;

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get actionGetStarted;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnits;

  /// No description provided for @unitsMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric (cm, kg, L)'**
  String get unitsMetric;

  /// No description provided for @unitsImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial (ft/in, lb, oz)'**
  String get unitsImperial;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @privacyStorageSummary.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored only on this device, in an encrypted database.'**
  String get privacyStorageSummary;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @wellnessDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Personality supports wellness and lifestyle habits. It does not provide medical advice or diagnosis.'**
  String get wellnessDisclaimer;

  /// No description provided for @settingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'The setting could not be saved. Please try again.'**
  String get settingsSaveError;

  /// No description provided for @startupErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to open your data'**
  String get startupErrorTitle;

  /// No description provided for @startupErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Personality could not open its secure storage. Your data has not been changed.'**
  String get startupErrorBody;

  /// No description provided for @featureBodyProportions.
  ///
  /// In en, this message translates to:
  /// **'Body proportions'**
  String get featureBodyProportions;

  /// No description provided for @sourceUserEntered.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get sourceUserEntered;

  /// No description provided for @sourceCameraDerived.
  ///
  /// In en, this message translates to:
  /// **'Camera estimate'**
  String get sourceCameraDerived;

  /// No description provided for @sourceDeviceDerived.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get sourceDeviceDerived;

  /// No description provided for @sourceHealthPlatform.
  ///
  /// In en, this message translates to:
  /// **'Health platform'**
  String get sourceHealthPlatform;

  /// No description provided for @sourceCalculated.
  ///
  /// In en, this message translates to:
  /// **'Calculated'**
  String get sourceCalculated;

  /// No description provided for @sourceImported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get sourceImported;

  /// No description provided for @sourceAiGenerated.
  ///
  /// In en, this message translates to:
  /// **'AI generated'**
  String get sourceAiGenerated;

  /// No description provided for @confidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Low confidence'**
  String get confidenceLow;

  /// No description provided for @confidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium confidence'**
  String get confidenceMedium;

  /// No description provided for @confidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High confidence'**
  String get confidenceHigh;

  /// No description provided for @valueCm.
  ///
  /// In en, this message translates to:
  /// **'{value} cm'**
  String valueCm(String value);

  /// No description provided for @valueKg.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String valueKg(String value);

  /// No description provided for @valueLb.
  ///
  /// In en, this message translates to:
  /// **'{value} lb'**
  String valueLb(String value);

  /// No description provided for @valueIn.
  ///
  /// In en, this message translates to:
  /// **'{value} in'**
  String valueIn(String value);

  /// No description provided for @valueFtIn.
  ///
  /// In en, this message translates to:
  /// **'{feet} ft {inches} in'**
  String valueFtIn(String feet, String inches);

  /// No description provided for @unitCmShort.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCmShort;

  /// No description provided for @unitKgShort.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKgShort;

  /// No description provided for @unitLbShort.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitLbShort;

  /// No description provided for @unitInShort.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get unitInShort;

  /// No description provided for @unitFtShort.
  ///
  /// In en, this message translates to:
  /// **'ft'**
  String get unitFtShort;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @deleteRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get deleteRecordTitle;

  /// No description provided for @deleteRecordBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes the record from this device.'**
  String get deleteRecordBody;

  /// No description provided for @recordSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Please try again.'**
  String get recordSaveError;

  /// No description provided for @loadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load'**
  String get loadErrorTitle;

  /// No description provided for @loadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'This information could not be loaded. Your data has not been changed.'**
  String get loadErrorBody;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get fieldNotes;

  /// No description provided for @fieldMethod.
  ///
  /// In en, this message translates to:
  /// **'How was it measured?'**
  String get fieldMethod;

  /// No description provided for @methodSelfMeasured.
  ///
  /// In en, this message translates to:
  /// **'Measured myself'**
  String get methodSelfMeasured;

  /// No description provided for @methodMeasuredByOther.
  ///
  /// In en, this message translates to:
  /// **'Measured by another person'**
  String get methodMeasuredByOther;

  /// No description provided for @methodProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional measurement'**
  String get methodProfessional;

  /// No description provided for @methodScale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get methodScale;

  /// No description provided for @methodEstimated.
  ///
  /// In en, this message translates to:
  /// **'My estimate'**
  String get methodEstimated;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a value'**
  String get validationRequired;

  /// No description provided for @validationRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between {min} and {max}'**
  String validationRange(String min, String max);

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileIntro.
  ///
  /// In en, this message translates to:
  /// **'Everything here is optional and stays on this device.'**
  String get profileIntro;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get profileName;

  /// No description provided for @profileAgeRange.
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get profileAgeRange;

  /// No description provided for @profileActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get profileActivityLevel;

  /// No description provided for @profileGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get profileGoals;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @ageUnder18.
  ///
  /// In en, this message translates to:
  /// **'Under 18'**
  String get ageUnder18;

  /// No description provided for @age18to24.
  ///
  /// In en, this message translates to:
  /// **'18–24'**
  String get age18to24;

  /// No description provided for @age25to34.
  ///
  /// In en, this message translates to:
  /// **'25–34'**
  String get age25to34;

  /// No description provided for @age35to44.
  ///
  /// In en, this message translates to:
  /// **'35–44'**
  String get age35to44;

  /// No description provided for @age45to54.
  ///
  /// In en, this message translates to:
  /// **'45–54'**
  String get age45to54;

  /// No description provided for @age55to64.
  ///
  /// In en, this message translates to:
  /// **'55–64'**
  String get age55to64;

  /// No description provided for @age65plus.
  ///
  /// In en, this message translates to:
  /// **'65+'**
  String get age65plus;

  /// No description provided for @activitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Mostly sitting'**
  String get activitySedentary;

  /// No description provided for @activityLight.
  ///
  /// In en, this message translates to:
  /// **'Lightly active'**
  String get activityLight;

  /// No description provided for @activityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderately active'**
  String get activityModerate;

  /// No description provided for @activityActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activityActive;

  /// No description provided for @activityVeryActive.
  ///
  /// In en, this message translates to:
  /// **'Very active'**
  String get activityVeryActive;

  /// No description provided for @goalPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get goalPosture;

  /// No description provided for @goalWeightManagement.
  ///
  /// In en, this message translates to:
  /// **'Weight management'**
  String get goalWeightManagement;

  /// No description provided for @goalFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get goalFitness;

  /// No description provided for @goalFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility and mobility'**
  String get goalFlexibility;

  /// No description provided for @goalHydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get goalHydration;

  /// No description provided for @goalSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get goalSleep;

  /// No description provided for @goalHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits and routines'**
  String get goalHabits;

  /// No description provided for @goalStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get goalStyle;

  /// No description provided for @goalGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get goalGrooming;

  /// No description provided for @heightTitle.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightTitle;

  /// No description provided for @heightEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add your height to improve body-proportion and clothing recommendations.'**
  String get heightEmpty;

  /// No description provided for @heightAdd.
  ///
  /// In en, this message translates to:
  /// **'Add height'**
  String get heightAdd;

  /// No description provided for @heightPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary height'**
  String get heightPrimary;

  /// No description provided for @heightPinnedNote.
  ///
  /// In en, this message translates to:
  /// **'You chose this record as your primary height.'**
  String get heightPinnedNote;

  /// No description provided for @heightLatestManualNote.
  ///
  /// In en, this message translates to:
  /// **'Using your most recent manual measurement.'**
  String get heightLatestManualNote;

  /// No description provided for @heightVariationNote.
  ///
  /// In en, this message translates to:
  /// **'Height naturally varies by about 1–2 cm during the day. Small differences between records are normal and are not treated as growth.'**
  String get heightVariationNote;

  /// No description provided for @heightSetPrimary.
  ///
  /// In en, this message translates to:
  /// **'Use as primary'**
  String get heightSetPrimary;

  /// No description provided for @weightTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightTitle;

  /// No description provided for @weightEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add your first weight entry to start seeing trends.'**
  String get weightEmpty;

  /// No description provided for @weightAdd.
  ///
  /// In en, this message translates to:
  /// **'Add weight'**
  String get weightAdd;

  /// No description provided for @weightLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get weightLatest;

  /// No description provided for @weightGoalRange.
  ///
  /// In en, this message translates to:
  /// **'Goal range'**
  String get weightGoalRange;

  /// No description provided for @weightGoalNotSet.
  ///
  /// In en, this message translates to:
  /// **'No goal range set'**
  String get weightGoalNotSet;

  /// No description provided for @weightSetGoal.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get weightSetGoal;

  /// No description provided for @weightGoalMin.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get weightGoalMin;

  /// No description provided for @weightGoalMax.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get weightGoalMax;

  /// No description provided for @weightGoalInvalid.
  ///
  /// In en, this message translates to:
  /// **'The second value must be higher than the first.'**
  String get weightGoalInvalid;

  /// No description provided for @weightClearGoal.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weightClearGoal;

  /// No description provided for @goalBelow.
  ///
  /// In en, this message translates to:
  /// **'Below your goal range'**
  String get goalBelow;

  /// No description provided for @goalWithin.
  ///
  /// In en, this message translates to:
  /// **'Within your goal range'**
  String get goalWithin;

  /// No description provided for @goalAbove.
  ///
  /// In en, this message translates to:
  /// **'Above your goal range'**
  String get goalAbove;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @periodQuarter.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get periodQuarter;

  /// No description provided for @weightTrendChange.
  ///
  /// In en, this message translates to:
  /// **'Change in 7-day average over this period: {change}'**
  String weightTrendChange(String change);

  /// No description provided for @weightTrendInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Add at least two entries in this period to see a trend.'**
  String get weightTrendInsufficient;

  /// No description provided for @weightChartLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight chart with {count} entries'**
  String weightChartLabel(int count);

  /// No description provided for @weightAverageLegend.
  ///
  /// In en, this message translates to:
  /// **'7-day average'**
  String get weightAverageLegend;

  /// No description provided for @weightEntriesLegend.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get weightEntriesLegend;

  /// No description provided for @measurementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get measurementsTitle;

  /// No description provided for @measurementsIntro.
  ///
  /// In en, this message translates to:
  /// **'Optional. Used for body proportions and clothing fit. Measure over light clothing with a soft tape.'**
  String get measurementsIntro;

  /// No description provided for @measurementNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get measurementNotRecorded;

  /// No description provided for @measurementAdd.
  ///
  /// In en, this message translates to:
  /// **'Add measurement'**
  String get measurementAdd;

  /// No description provided for @measurementCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom measurement'**
  String get measurementCustom;

  /// No description provided for @measurementCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurement name'**
  String get measurementCustomLabel;

  /// No description provided for @measurementType.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measurementType;

  /// No description provided for @mShoulderWidth.
  ///
  /// In en, this message translates to:
  /// **'Shoulder width'**
  String get mShoulderWidth;

  /// No description provided for @mChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get mChest;

  /// No description provided for @mWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get mWaist;

  /// No description provided for @mHip.
  ///
  /// In en, this message translates to:
  /// **'Hip'**
  String get mHip;

  /// No description provided for @mNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get mNeck;

  /// No description provided for @mArmLength.
  ///
  /// In en, this message translates to:
  /// **'Arm length'**
  String get mArmLength;

  /// No description provided for @mLegLength.
  ///
  /// In en, this message translates to:
  /// **'Leg length'**
  String get mLegLength;

  /// No description provided for @mTorsoLength.
  ///
  /// In en, this message translates to:
  /// **'Torso length'**
  String get mTorsoLength;

  /// No description provided for @mInseam.
  ///
  /// In en, this message translates to:
  /// **'Inseam'**
  String get mInseam;

  /// No description provided for @mShoulderWidthHelp.
  ///
  /// In en, this message translates to:
  /// **'Straight across the back, from shoulder point to shoulder point.'**
  String get mShoulderWidthHelp;

  /// No description provided for @mChestHelp.
  ///
  /// In en, this message translates to:
  /// **'Around the fullest part of the chest, keeping the tape level.'**
  String get mChestHelp;

  /// No description provided for @mWaistHelp.
  ///
  /// In en, this message translates to:
  /// **'Around the natural waist, just above the navel.'**
  String get mWaistHelp;

  /// No description provided for @mHipHelp.
  ///
  /// In en, this message translates to:
  /// **'Around the fullest part of the hips.'**
  String get mHipHelp;

  /// No description provided for @mNeckHelp.
  ///
  /// In en, this message translates to:
  /// **'Around the base of the neck.'**
  String get mNeckHelp;

  /// No description provided for @mArmLengthHelp.
  ///
  /// In en, this message translates to:
  /// **'From the shoulder point to the wrist, with the arm relaxed.'**
  String get mArmLengthHelp;

  /// No description provided for @mLegLengthHelp.
  ///
  /// In en, this message translates to:
  /// **'From the hip bone to the floor, along the outside of the leg.'**
  String get mLegLengthHelp;

  /// No description provided for @mTorsoLengthHelp.
  ///
  /// In en, this message translates to:
  /// **'From the top of the shoulder to the natural waist.'**
  String get mTorsoLengthHelp;

  /// No description provided for @mInseamHelp.
  ///
  /// In en, this message translates to:
  /// **'From the crotch to the floor, along the inside of the leg.'**
  String get mInseamHelp;

  /// No description provided for @proportionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Body proportions'**
  String get proportionsTitle;

  /// No description provided for @proportionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Neutral descriptions used for clothing fit and silhouette suggestions.'**
  String get proportionsIntro;

  /// No description provided for @proportionsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These are not assessments of health or appearance, and there is no ideal shape.'**
  String get proportionsDisclaimer;

  /// No description provided for @proportionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add your height and a few measurements to see your proportions.'**
  String get proportionsEmpty;

  /// No description provided for @proportionsMissing.
  ///
  /// In en, this message translates to:
  /// **'Add {items} to see {metric}.'**
  String proportionsMissing(String items, String metric);

  /// No description provided for @proportionsBasedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on: {inputs}'**
  String proportionsBasedOn(String inputs);

  /// No description provided for @proportionsAddMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get proportionsAddMeasurements;

  /// No description provided for @metricLegLine.
  ///
  /// In en, this message translates to:
  /// **'Leg line'**
  String get metricLegLine;

  /// No description provided for @metricShoulderBreadth.
  ///
  /// In en, this message translates to:
  /// **'Shoulder breadth'**
  String get metricShoulderBreadth;

  /// No description provided for @metricUpperTaper.
  ///
  /// In en, this message translates to:
  /// **'Chest-to-waist difference'**
  String get metricUpperTaper;

  /// No description provided for @metricHipBalance.
  ///
  /// In en, this message translates to:
  /// **'Hip-to-chest balance'**
  String get metricHipBalance;

  /// No description provided for @descShorterLegLine.
  ///
  /// In en, this message translates to:
  /// **'Shorter leg line relative to height'**
  String get descShorterLegLine;

  /// No description provided for @descBalancedLegLine.
  ///
  /// In en, this message translates to:
  /// **'Balanced leg line'**
  String get descBalancedLegLine;

  /// No description provided for @descLongerLegLine.
  ///
  /// In en, this message translates to:
  /// **'Longer leg line relative to height'**
  String get descLongerLegLine;

  /// No description provided for @descNarrowerShoulders.
  ///
  /// In en, this message translates to:
  /// **'Narrower shoulders relative to height'**
  String get descNarrowerShoulders;

  /// No description provided for @descAverageShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulder width in the middle range for your height'**
  String get descAverageShoulders;

  /// No description provided for @descBroaderShoulders.
  ///
  /// In en, this message translates to:
  /// **'Broader shoulders relative to height'**
  String get descBroaderShoulders;

  /// No description provided for @descStraightTaper.
  ///
  /// In en, this message translates to:
  /// **'Straighter line through the torso'**
  String get descStraightTaper;

  /// No description provided for @descModerateTaper.
  ///
  /// In en, this message translates to:
  /// **'Moderate taper from chest to waist'**
  String get descModerateTaper;

  /// No description provided for @descPronouncedTaper.
  ///
  /// In en, this message translates to:
  /// **'Pronounced taper from chest to waist'**
  String get descPronouncedTaper;

  /// No description provided for @descChestFuller.
  ///
  /// In en, this message translates to:
  /// **'Chest measures fuller than hips'**
  String get descChestFuller;

  /// No description provided for @descBalancedChestHip.
  ///
  /// In en, this message translates to:
  /// **'Chest and hips measure similarly'**
  String get descBalancedChestHip;

  /// No description provided for @descHipsFuller.
  ///
  /// In en, this message translates to:
  /// **'Hips measure fuller than chest'**
  String get descHipsFuller;

  /// No description provided for @valueFlOz.
  ///
  /// In en, this message translates to:
  /// **'{value} fl oz'**
  String valueFlOz(String value);

  /// No description provided for @valueLitres.
  ///
  /// In en, this message translates to:
  /// **'{value} L'**
  String valueLitres(String value);

  /// No description provided for @valueMl.
  ///
  /// In en, this message translates to:
  /// **'{value} ml'**
  String valueMl(String value);

  /// No description provided for @durationHm.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHm(int hours, int minutes);

  /// No description provided for @valueMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String valueMinutes(int minutes);

  /// No description provided for @valueSteps.
  ///
  /// In en, this message translates to:
  /// **'{value} steps'**
  String valueSteps(String value);

  /// No description provided for @valueKm.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String valueKm(String value);

  /// No description provided for @valueMiles.
  ///
  /// In en, this message translates to:
  /// **'{value} mi'**
  String valueMiles(String value);

  /// No description provided for @valueKcal.
  ///
  /// In en, this message translates to:
  /// **'{value} kcal'**
  String valueKcal(int value);

  /// No description provided for @mealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealLunch;

  /// No description provided for @mealSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get mealSnack;

  /// No description provided for @mealDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealDinner;

  /// No description provided for @mealCustom.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get mealCustom;

  /// No description provided for @activityWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get activityWalking;

  /// No description provided for @activityRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get activityRunning;

  /// No description provided for @activityCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get activityCycling;

  /// No description provided for @activitySwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get activitySwimming;

  /// No description provided for @activitySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get activitySports;

  /// No description provided for @activityOther.
  ///
  /// In en, this message translates to:
  /// **'Other activity'**
  String get activityOther;

  /// No description provided for @exNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get exNeck;

  /// No description provided for @exShoulder.
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get exShoulder;

  /// No description provided for @exUpperBack.
  ///
  /// In en, this message translates to:
  /// **'Upper back'**
  String get exUpperBack;

  /// No description provided for @exLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get exLowerBack;

  /// No description provided for @exCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get exCore;

  /// No description provided for @exMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get exMobility;

  /// No description provided for @exYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get exYoga;

  /// No description provided for @exStretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching'**
  String get exStretching;

  /// No description provided for @exPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get exPosture;

  /// No description provided for @exGeneralFitness.
  ///
  /// In en, this message translates to:
  /// **'General fitness'**
  String get exGeneralFitness;

  /// No description provided for @exStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get exStrength;

  /// No description provided for @exCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get exCardio;

  /// No description provided for @targetOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'This value is outside the supported range.'**
  String get targetOutOfRange;

  /// No description provided for @targetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily targets'**
  String get targetsTitle;

  /// No description provided for @targetsIntro.
  ///
  /// In en, this message translates to:
  /// **'These are starting points you can change at any time. They are not medical recommendations.'**
  String get targetsIntro;

  /// No description provided for @unitLitreShort.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get unitLitreShort;

  /// No description provided for @unitFlOzShort.
  ///
  /// In en, this message translates to:
  /// **'fl oz'**
  String get unitFlOzShort;

  /// No description provided for @unitHoursShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get unitHoursShort;

  /// No description provided for @unitMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get unitMinutesShort;

  /// No description provided for @unitMlShort.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMlShort;

  /// No description provided for @unitKmShort.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get unitKmShort;

  /// No description provided for @unitMiShort.
  ///
  /// In en, this message translates to:
  /// **'mi'**
  String get unitMiShort;

  /// No description provided for @stepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsLabel;

  /// No description provided for @activeMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Active minutes'**
  String get activeMinutesLabel;

  /// No description provided for @waterCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom amount'**
  String get waterCustom;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @ofTarget.
  ///
  /// In en, this message translates to:
  /// **'Target: {value}'**
  String ofTarget(String value);

  /// No description provided for @lastSevenDays.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get lastSevenDays;

  /// No description provided for @weekChartLabel.
  ///
  /// In en, this message translates to:
  /// **'{metric} for the last 7 days'**
  String weekChartLabel(String metric);

  /// No description provided for @todayEntries.
  ///
  /// In en, this message translates to:
  /// **'Today\'s entries'**
  String get todayEntries;

  /// No description provided for @waterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No water logged today.'**
  String get waterEmpty;

  /// No description provided for @mealAdd.
  ///
  /// In en, this message translates to:
  /// **'Log meal'**
  String get mealAdd;

  /// No description provided for @mealsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log what you eat, in your own words. Calories are optional.'**
  String get mealsEmpty;

  /// No description provided for @mealType.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get mealType;

  /// No description provided for @mealCustomName.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get mealCustomName;

  /// No description provided for @mealFood.
  ///
  /// In en, this message translates to:
  /// **'What did you eat?'**
  String get mealFood;

  /// No description provided for @mealQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity (optional)'**
  String get mealQuantity;

  /// No description provided for @mealCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories (optional)'**
  String get mealCalories;

  /// No description provided for @mealCaloriesHelp.
  ///
  /// In en, this message translates to:
  /// **'Only if you want to track them.'**
  String get mealCaloriesHelp;

  /// No description provided for @fieldTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get fieldTime;

  /// No description provided for @sleepAdd.
  ///
  /// In en, this message translates to:
  /// **'Log sleep'**
  String get sleepAdd;

  /// No description provided for @sleepLastNight.
  ///
  /// In en, this message translates to:
  /// **'Last night'**
  String get sleepLastNight;

  /// No description provided for @sleepConsistencyInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Log at least two nights this week to see how consistent your bedtime is.'**
  String get sleepConsistencyInsufficient;

  /// No description provided for @sleepConsistency.
  ///
  /// In en, this message translates to:
  /// **'Your bedtime varied by about {minutes} min this week.'**
  String sleepConsistency(int minutes);

  /// No description provided for @sleepDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Sleep tracking here is for personal awareness and does not assess sleep disorders.'**
  String get sleepDisclaimer;

  /// No description provided for @sleepEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sleep logged yet.'**
  String get sleepEmpty;

  /// No description provided for @sleepWakeBeforeBed.
  ///
  /// In en, this message translates to:
  /// **'Wake time must be after bedtime.'**
  String get sleepWakeBeforeBed;

  /// No description provided for @sleepTooLong.
  ///
  /// In en, this message translates to:
  /// **'A sleep entry cannot be longer than 24 hours.'**
  String get sleepTooLong;

  /// No description provided for @sleepBedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get sleepBedtime;

  /// No description provided for @sleepWakeTime.
  ///
  /// In en, this message translates to:
  /// **'Wake time'**
  String get sleepWakeTime;

  /// No description provided for @sleepDurationPreview.
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration}'**
  String sleepDurationPreview(String duration);

  /// No description provided for @activityAdd.
  ///
  /// In en, this message translates to:
  /// **'Log activity'**
  String get activityAdd;

  /// No description provided for @activeMinutesNote.
  ///
  /// In en, this message translates to:
  /// **'Active minutes include activities and exercise sessions.'**
  String get activeMinutesNote;

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activity logged yet. Automatic step import from Health Connect comes later.'**
  String get activityEmpty;

  /// No description provided for @activityNeedsValue.
  ///
  /// In en, this message translates to:
  /// **'Enter steps, a duration or a distance.'**
  String get activityNeedsValue;

  /// No description provided for @activityKindLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityKindLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance (optional)'**
  String get distanceLabel;

  /// No description provided for @exerciseAdd.
  ///
  /// In en, this message translates to:
  /// **'Log exercise'**
  String get exerciseAdd;

  /// No description provided for @exerciseEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log exercise you have done. A guided exercise library comes in a later update.'**
  String get exerciseEmpty;

  /// No description provided for @exerciseThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get exerciseThisWeek;

  /// No description provided for @setsReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {reps}'**
  String setsReps(int sets, int reps);

  /// No description provided for @exerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseName;

  /// No description provided for @exerciseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get exerciseCategory;

  /// No description provided for @setsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets (optional)'**
  String get setsLabel;

  /// No description provided for @repsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps (optional)'**
  String get repsLabel;

  /// No description provided for @habitAdd.
  ///
  /// In en, this message translates to:
  /// **'Add habit'**
  String get habitAdd;

  /// No description provided for @habitEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit habit'**
  String get habitEdit;

  /// No description provided for @habitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a small habit you want to repeat, and choose the days it applies.'**
  String get habitsEmpty;

  /// No description provided for @habitsTodaySummary.
  ///
  /// In en, this message translates to:
  /// **'You completed {done} of {total} habits today.'**
  String habitsTodaySummary(int done, int total);

  /// No description provided for @habitsNotToday.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled today'**
  String get habitsNotToday;

  /// No description provided for @habitWeekAdherence.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} this week'**
  String habitWeekAdherence(int done, int total);

  /// No description provided for @habitSkippedToday.
  ///
  /// In en, this message translates to:
  /// **'Skipped today'**
  String get habitSkippedToday;

  /// No description provided for @habitSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get habitSkip;

  /// No description provided for @habitUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get habitUndo;

  /// No description provided for @habitArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get habitArchive;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Habit'**
  String get habitName;

  /// No description provided for @habitDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get habitDays;

  /// No description provided for @habitDaysRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one day.'**
  String get habitDaysRequired;

  /// No description provided for @habitsNoneToday.
  ///
  /// In en, this message translates to:
  /// **'None today'**
  String get habitsNoneToday;

  /// No description provided for @homeBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get homeBodyTitle;

  /// No description provided for @mealsLogged.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None logged} =1{1 meal} other{{count} meals}}'**
  String mealsLogged(int count);

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s plan'**
  String get planTitle;

  /// No description provided for @routineNew.
  ///
  /// In en, this message translates to:
  /// **'New routine'**
  String get routineNew;

  /// No description provided for @routinesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Build a daily routine with times for water, meals, movement and rest. Reminders are optional.'**
  String get routinesEmpty;

  /// No description provided for @routineFromExample.
  ///
  /// In en, this message translates to:
  /// **'Start from an example'**
  String get routineFromExample;

  /// No description provided for @templateRoutineName.
  ///
  /// In en, this message translates to:
  /// **'My daily routine'**
  String get templateRoutineName;

  /// No description provided for @newRoutineName.
  ///
  /// In en, this message translates to:
  /// **'New routine'**
  String get newRoutineName;

  /// No description provided for @routineItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String routineItemCount(int count);

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @routineNotFound.
  ///
  /// In en, this message translates to:
  /// **'This routine no longer exists.'**
  String get routineNotFound;

  /// No description provided for @actionDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get actionDuplicate;

  /// No description provided for @routineCopyName.
  ///
  /// In en, this message translates to:
  /// **'{name} (copy)'**
  String routineCopyName(String name);

  /// No description provided for @routineAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get routineAddItem;

  /// No description provided for @routinePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused — not part of today\'s plan.'**
  String get routinePaused;

  /// No description provided for @routineNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items yet. Add times for the things you want to do.'**
  String get routineNoItems;

  /// No description provided for @reminderOn.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get reminderOn;

  /// No description provided for @reminderOff.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get reminderOff;

  /// No description provided for @routineName.
  ///
  /// In en, this message translates to:
  /// **'Routine name'**
  String get routineName;

  /// No description provided for @routineItemTitle.
  ///
  /// In en, this message translates to:
  /// **'What'**
  String get routineItemTitle;

  /// No description provided for @routineItemKind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get routineItemKind;

  /// No description provided for @kindWake.
  ///
  /// In en, this message translates to:
  /// **'Wake'**
  String get kindWake;

  /// No description provided for @kindMeal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get kindMeal;

  /// No description provided for @kindWindDown.
  ///
  /// In en, this message translates to:
  /// **'Wind down'**
  String get kindWindDown;

  /// No description provided for @kindCustom.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get kindCustom;

  /// No description provided for @templatePostureBreak.
  ///
  /// In en, this message translates to:
  /// **'Posture break'**
  String get templatePostureBreak;

  /// No description provided for @remindersChannelName.
  ///
  /// In en, this message translates to:
  /// **'Routine reminders'**
  String get remindersChannelName;

  /// No description provided for @remindersChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders for items in your routines'**
  String get remindersChannelDescription;

  /// No description provided for @reminderActionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get reminderActionDone;

  /// No description provided for @reminderActionSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze 10 min'**
  String get reminderActionSnooze;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Planned for {time}'**
  String reminderBody(String time);

  /// No description provided for @planEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing is planned for today. Create a routine to see your plan here.'**
  String get planEmpty;

  /// No description provided for @planSummary.
  ///
  /// In en, this message translates to:
  /// **'Completed {done} of {total} planned'**
  String planSummary(int done, int total);

  /// No description provided for @planBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Skipped {skipped} · Missed {missed} · Moved {moved} · Remaining {open}'**
  String planBreakdown(int skipped, int missed, int moved, int open);

  /// No description provided for @planWeekAdherence.
  ///
  /// In en, this message translates to:
  /// **'Plan completed, last 7 days (%)'**
  String get planWeekAdherence;

  /// No description provided for @planAdherenceNote.
  ///
  /// In en, this message translates to:
  /// **'This shows how much of your plan happened. It is separate from health results such as water or steps.'**
  String get planAdherenceNote;

  /// No description provided for @planUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get planUpcoming;

  /// No description provided for @planDue.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get planDue;

  /// No description provided for @planDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get planDone;

  /// No description provided for @planSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get planSkipped;

  /// No description provided for @planMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get planMissed;

  /// No description provided for @planMovedFrom.
  ///
  /// In en, this message translates to:
  /// **'moved from {time}'**
  String planMovedFrom(String time);

  /// No description provided for @planReschedule.
  ///
  /// In en, this message translates to:
  /// **'Move to another time'**
  String get planReschedule;

  /// No description provided for @planHomeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No plan for today yet'**
  String get planHomeEmpty;

  /// No description provided for @planAllDone.
  ///
  /// In en, this message translates to:
  /// **'Nothing left for today'**
  String get planAllDone;

  /// No description provided for @planNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {title} — {time}'**
  String planNext(String title, String time);

  /// No description provided for @suggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestionTitle;

  /// No description provided for @suggestionMissed.
  ///
  /// In en, this message translates to:
  /// **'{title} at {time} was missed on {count} of the last {total} scheduled days.'**
  String suggestionMissed(String title, String time, int count, int total);

  /// No description provided for @suggestionLate.
  ///
  /// In en, this message translates to:
  /// **'{title} at {time} was usually done later — on {count} of the last {total} scheduled days.'**
  String suggestionLate(String title, String time, int count, int total);

  /// No description provided for @suggestionRescheduled.
  ///
  /// In en, this message translates to:
  /// **'You moved {title} from {time} {count} times recently.'**
  String suggestionRescheduled(String title, String time, int count);

  /// No description provided for @suggestionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Move it to {time}?'**
  String suggestionQuestion(String time);

  /// No description provided for @suggestionAccept.
  ///
  /// In en, this message translates to:
  /// **'Move to {time}'**
  String suggestionAccept(String time);

  /// No description provided for @suggestionDismiss.
  ///
  /// In en, this message translates to:
  /// **'Keep current time'**
  String get suggestionDismiss;

  /// No description provided for @notificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for this app. Your plan still works here; enable notifications in Android settings to get reminders.'**
  String get notificationsBlocked;

  /// No description provided for @remindersEnable.
  ///
  /// In en, this message translates to:
  /// **'Routine reminders'**
  String get remindersEnable;

  /// No description provided for @remindersOnNote.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be reminded of routine items that have reminders turned on.'**
  String get remindersOnNote;

  /// No description provided for @remindersOffNote.
  ///
  /// In en, this message translates to:
  /// **'Off. Your plan is still available in the app.'**
  String get remindersOffNote;

  /// No description provided for @remindersAdaptive.
  ///
  /// In en, this message translates to:
  /// **'Timing suggestions'**
  String get remindersAdaptive;

  /// No description provided for @remindersAdaptiveNote.
  ///
  /// In en, this message translates to:
  /// **'Suggest a better time when an item is often missed or done late. Nothing changes unless you accept.'**
  String get remindersAdaptiveNote;

  /// No description provided for @remindersTimingNote.
  ///
  /// In en, this message translates to:
  /// **'To save battery, Android may deliver reminders a few minutes late.'**
  String get remindersTimingNote;

  /// No description provided for @remindersNext.
  ///
  /// In en, this message translates to:
  /// **'Next reminders'**
  String get remindersNext;

  /// No description provided for @remindersNoneUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No reminders in the next two days.'**
  String get remindersNoneUpcoming;

  /// No description provided for @featureCameraCheck.
  ///
  /// In en, this message translates to:
  /// **'Camera check'**
  String get featureCameraCheck;

  /// No description provided for @cameraSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get cameraSwitch;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera access is unavailable. Manual tracking remains available.'**
  String get cameraUnavailable;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access was not allowed. Manual tracking remains available. To use the camera, allow it for Personality in Android settings.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraFailed.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be started. Close other apps using the camera and try again.'**
  String get cameraFailed;

  /// No description provided for @cameraIntro.
  ///
  /// In en, this message translates to:
  /// **'Check your camera setup and lighting. Frames are analyzed on this phone and discarded — nothing is saved or uploaded.'**
  String get cameraIntro;

  /// No description provided for @cameraStart.
  ///
  /// In en, this message translates to:
  /// **'Start camera'**
  String get cameraStart;

  /// No description provided for @cameraStop.
  ///
  /// In en, this message translates to:
  /// **'Stop camera'**
  String get cameraStop;

  /// No description provided for @cameraPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Camera frames stay in memory only while being analyzed and are then discarded. The camera stops when you leave this screen or switch apps.'**
  String get cameraPrivacyNote;

  /// No description provided for @cameraProcessingOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Processing on device'**
  String get cameraProcessingOnDevice;

  /// No description provided for @cameraWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for frames…'**
  String get cameraWaiting;

  /// No description provided for @cameraLighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get cameraLighting;

  /// No description provided for @cameraAnalysisRate.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get cameraAnalysisRate;

  /// No description provided for @cameraFramesStats.
  ///
  /// In en, this message translates to:
  /// **'{fps} frames per second · {frames} analyzed'**
  String cameraFramesStats(int fps, int frames);

  /// No description provided for @poseModelRequired.
  ///
  /// In en, this message translates to:
  /// **'Posture analysis needs the pose model, which arrives in a later update. Lighting and camera checks work now.'**
  String get poseModelRequired;

  /// No description provided for @poseNoPerson.
  ///
  /// In en, this message translates to:
  /// **'No person detected. Step into the frame.'**
  String get poseNoPerson;

  /// No description provided for @posePersonDetected.
  ///
  /// In en, this message translates to:
  /// **'Person detected'**
  String get posePersonDetected;

  /// No description provided for @poseReposition.
  ///
  /// In en, this message translates to:
  /// **'Move into the guide so your whole body is visible.'**
  String get poseReposition;

  /// No description provided for @poseHoldStill.
  ///
  /// In en, this message translates to:
  /// **'Hold still for a moment.'**
  String get poseHoldStill;

  /// No description provided for @cameraPowerMode.
  ///
  /// In en, this message translates to:
  /// **'Camera power mode'**
  String get cameraPowerMode;

  /// No description provided for @powerLow.
  ///
  /// In en, this message translates to:
  /// **'Low power'**
  String get powerLow;

  /// No description provided for @powerStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get powerStandard;

  /// No description provided for @powerHigh.
  ///
  /// In en, this message translates to:
  /// **'High accuracy'**
  String get powerHigh;

  /// No description provided for @powerLowNote.
  ///
  /// In en, this message translates to:
  /// **'Lower resolution, 5 analyses per second. Saves battery; results may be less stable.'**
  String get powerLowNote;

  /// No description provided for @powerStandardNote.
  ///
  /// In en, this message translates to:
  /// **'Balanced resolution, 10 analyses per second. Recommended for most phones.'**
  String get powerStandardNote;

  /// No description provided for @powerHighNote.
  ///
  /// In en, this message translates to:
  /// **'Higher resolution, 15 analyses per second. Most stable results; uses more battery and may warm the phone.'**
  String get powerHighNote;

  /// No description provided for @lightingGood.
  ///
  /// In en, this message translates to:
  /// **'Good light'**
  String get lightingGood;

  /// No description provided for @lightingDim.
  ///
  /// In en, this message translates to:
  /// **'Dim'**
  String get lightingDim;

  /// No description provided for @lightingTooDark.
  ///
  /// In en, this message translates to:
  /// **'Too dark'**
  String get lightingTooDark;

  /// No description provided for @lightingTooBright.
  ///
  /// In en, this message translates to:
  /// **'Too bright'**
  String get lightingTooBright;

  /// No description provided for @lightingLowContrast.
  ///
  /// In en, this message translates to:
  /// **'Lens covered?'**
  String get lightingLowContrast;

  /// No description provided for @lightingGoodAdvice.
  ///
  /// In en, this message translates to:
  /// **'Lighting is good for analysis.'**
  String get lightingGoodAdvice;

  /// No description provided for @lightingDimAdvice.
  ///
  /// In en, this message translates to:
  /// **'Usable, but more light will give steadier results.'**
  String get lightingDimAdvice;

  /// No description provided for @lightingTooDarkAdvice.
  ///
  /// In en, this message translates to:
  /// **'Please improve the lighting — turn on a light or face a window.'**
  String get lightingTooDarkAdvice;

  /// No description provided for @lightingTooBrightAdvice.
  ///
  /// In en, this message translates to:
  /// **'Too much light — avoid standing in front of a bright window.'**
  String get lightingTooBrightAdvice;

  /// No description provided for @lightingLowContrastAdvice.
  ///
  /// In en, this message translates to:
  /// **'The image is almost uniform. Check that the lens is not covered.'**
  String get lightingLowContrastAdvice;

  /// No description provided for @deviceInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get deviceInfoTitle;

  /// No description provided for @deviceInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hardware and processing quality'**
  String get deviceInfoSubtitle;

  /// No description provided for @deviceInfoIntro.
  ///
  /// In en, this message translates to:
  /// **'Personality adjusts camera and analysis quality to this phone\'s hardware. Only hardware facts are read; no identifiers are collected.'**
  String get deviceInfoIntro;

  /// No description provided for @deviceUnknownNote.
  ///
  /// In en, this message translates to:
  /// **'Hardware details could not be read, so the most conservative settings are used.'**
  String get deviceUnknownNote;

  /// No description provided for @deviceTier.
  ///
  /// In en, this message translates to:
  /// **'Performance level'**
  String get deviceTier;

  /// No description provided for @tierHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get tierHigh;

  /// No description provided for @tierMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get tierMedium;

  /// No description provided for @tierLow.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get tierLow;

  /// No description provided for @deviceRam.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get deviceRam;

  /// No description provided for @deviceCores.
  ///
  /// In en, this message translates to:
  /// **'Processor cores'**
  String get deviceCores;

  /// No description provided for @deviceAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android version'**
  String get deviceAndroid;

  /// No description provided for @deviceStorage.
  ///
  /// In en, this message translates to:
  /// **'Free storage'**
  String get deviceStorage;

  /// No description provided for @deviceCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get deviceCamera;

  /// No description provided for @deviceProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get deviceProcessing;

  /// No description provided for @deviceAnalysisRate.
  ///
  /// In en, this message translates to:
  /// **'Default analysis rate'**
  String get deviceAnalysisRate;

  /// No description provided for @deviceCameraResolution.
  ///
  /// In en, this message translates to:
  /// **'Default camera resolution'**
  String get deviceCameraResolution;

  /// No description provided for @deviceLocalAi.
  ///
  /// In en, this message translates to:
  /// **'Optional local AI supported'**
  String get deviceLocalAi;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @unknownValue.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownValue;

  /// No description provided for @valueGb.
  ///
  /// In en, this message translates to:
  /// **'{value} GB'**
  String valueGb(String value);

  /// No description provided for @valueFps.
  ///
  /// In en, this message translates to:
  /// **'{fps} per second'**
  String valueFps(int fps);

  /// No description provided for @privacyCameraSummary.
  ///
  /// In en, this message translates to:
  /// **'Camera analysis runs on this phone. Frames are never saved or uploaded unless you explicitly choose to save a photo.'**
  String get privacyCameraSummary;

  /// No description provided for @pmHeadTilt.
  ///
  /// In en, this message translates to:
  /// **'Head tilt'**
  String get pmHeadTilt;

  /// No description provided for @pmShoulderLevel.
  ///
  /// In en, this message translates to:
  /// **'Shoulder level'**
  String get pmShoulderLevel;

  /// No description provided for @pmHipLevel.
  ///
  /// In en, this message translates to:
  /// **'Hip level'**
  String get pmHipLevel;

  /// No description provided for @pmTorsoLean.
  ///
  /// In en, this message translates to:
  /// **'Torso lean'**
  String get pmTorsoLean;

  /// No description provided for @pmKneeAlignment.
  ///
  /// In en, this message translates to:
  /// **'Knee alignment'**
  String get pmKneeAlignment;

  /// No description provided for @pmHeadForward.
  ///
  /// In en, this message translates to:
  /// **'Head position'**
  String get pmHeadForward;

  /// No description provided for @bandAligned.
  ///
  /// In en, this message translates to:
  /// **'Within typical range'**
  String get bandAligned;

  /// No description provided for @bandSlight.
  ///
  /// In en, this message translates to:
  /// **'Slight'**
  String get bandSlight;

  /// No description provided for @bandNoticeable.
  ///
  /// In en, this message translates to:
  /// **'Noticeable'**
  String get bandNoticeable;

  /// No description provided for @dirNone.
  ///
  /// In en, this message translates to:
  /// **'Centered'**
  String get dirNone;

  /// No description provided for @dirLeftHigher.
  ///
  /// In en, this message translates to:
  /// **'Left side higher'**
  String get dirLeftHigher;

  /// No description provided for @dirRightHigher.
  ///
  /// In en, this message translates to:
  /// **'Right side higher'**
  String get dirRightHigher;

  /// No description provided for @dirTiltLeft.
  ///
  /// In en, this message translates to:
  /// **'Tilted toward your left'**
  String get dirTiltLeft;

  /// No description provided for @dirTiltRight.
  ///
  /// In en, this message translates to:
  /// **'Tilted toward your right'**
  String get dirTiltRight;

  /// No description provided for @dirKneeLeft.
  ///
  /// In en, this message translates to:
  /// **'Larger on the left knee'**
  String get dirKneeLeft;

  /// No description provided for @dirKneeRight.
  ///
  /// In en, this message translates to:
  /// **'Larger on the right knee'**
  String get dirKneeRight;

  /// No description provided for @dirLeanLeft.
  ///
  /// In en, this message translates to:
  /// **'Leaning toward your left'**
  String get dirLeanLeft;

  /// No description provided for @dirLeanRight.
  ///
  /// In en, this message translates to:
  /// **'Leaning toward your right'**
  String get dirLeanRight;

  /// No description provided for @dirHeadAhead.
  ///
  /// In en, this message translates to:
  /// **'Head ahead of the shoulders'**
  String get dirHeadAhead;

  /// No description provided for @dirLeanForward.
  ///
  /// In en, this message translates to:
  /// **'Leaning forward'**
  String get dirLeanForward;

  /// No description provided for @dirLeanBack.
  ///
  /// In en, this message translates to:
  /// **'Leaning back'**
  String get dirLeanBack;

  /// No description provided for @viewFront.
  ///
  /// In en, this message translates to:
  /// **'Front view'**
  String get viewFront;

  /// No description provided for @viewSide.
  ///
  /// In en, this message translates to:
  /// **'Side view'**
  String get viewSide;

  /// No description provided for @poseTooFar.
  ///
  /// In en, this message translates to:
  /// **'Move a little closer to the phone.'**
  String get poseTooFar;

  /// No description provided for @poseTooClose.
  ///
  /// In en, this message translates to:
  /// **'Step back so your whole body fits in the guide.'**
  String get poseTooClose;

  /// No description provided for @poseUnclearView.
  ///
  /// In en, this message translates to:
  /// **'Face the camera directly, or turn fully sideways.'**
  String get poseUnclearView;

  /// No description provided for @poseLowVisibility.
  ///
  /// In en, this message translates to:
  /// **'Your body isn\'t clearly visible. Fitted clothes and a plain background help.'**
  String get poseLowVisibility;

  /// No description provided for @postureReady.
  ///
  /// In en, this message translates to:
  /// **'Ready — {view} detected. Stand naturally and tap Analyze.'**
  String postureReady(String view);

  /// No description provided for @postureAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get postureAnalyze;

  /// No description provided for @postureCapturing.
  ///
  /// In en, this message translates to:
  /// **'Hold still while several frames are analyzed…'**
  String get postureCapturing;

  /// No description provided for @postureHistory.
  ///
  /// In en, this message translates to:
  /// **'Posture history'**
  String get postureHistory;

  /// No description provided for @postureHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Complete your first posture check.'**
  String get postureHistoryEmpty;

  /// No description provided for @postureIntro.
  ///
  /// In en, this message translates to:
  /// **'Get an estimated alignment of your head, shoulders, hips and knees. Analysis runs on this phone; frames are discarded.'**
  String get postureIntro;

  /// No description provided for @postureTipPhone.
  ///
  /// In en, this message translates to:
  /// **'Prop the phone upright at about waist height.'**
  String get postureTipPhone;

  /// No description provided for @postureTipDistance.
  ///
  /// In en, this message translates to:
  /// **'Stand 2–3 metres away so your whole body fits.'**
  String get postureTipDistance;

  /// No description provided for @postureTipLight.
  ///
  /// In en, this message translates to:
  /// **'Use even lighting; avoid a bright window behind you.'**
  String get postureTipLight;

  /// No description provided for @postureTipClothes.
  ///
  /// In en, this message translates to:
  /// **'Fitted clothing makes landmarks easier to see.'**
  String get postureTipClothes;

  /// No description provided for @postureTipViews.
  ///
  /// In en, this message translates to:
  /// **'Face the camera for a front view, or stand sideways for head position.'**
  String get postureTipViews;

  /// No description provided for @lensFront.
  ///
  /// In en, this message translates to:
  /// **'Front camera'**
  String get lensFront;

  /// No description provided for @lensBack.
  ///
  /// In en, this message translates to:
  /// **'Back camera'**
  String get lensBack;

  /// No description provided for @postureDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Estimated alignment from the camera for personal awareness — not a medical or spinal assessment. For pain or concerns, consult a qualified professional.'**
  String get postureDisclaimer;

  /// No description provided for @postureNotReliable.
  ///
  /// In en, this message translates to:
  /// **'Posture could not be reliably measured.'**
  String get postureNotReliable;

  /// No description provided for @postureResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated alignment · {view}'**
  String postureResultTitle(String view);

  /// No description provided for @postureFramesUsed.
  ///
  /// In en, this message translates to:
  /// **'{count} frames'**
  String postureFramesUsed(int count);

  /// No description provided for @postureSaved.
  ///
  /// In en, this message translates to:
  /// **'Posture check saved'**
  String get postureSaved;

  /// No description provided for @postureSavedShort.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get postureSavedShort;

  /// No description provided for @postureRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get postureRetake;

  /// No description provided for @postureSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggested for you'**
  String get postureSuggestions;

  /// No description provided for @postureLowConfidenceNote.
  ///
  /// In en, this message translates to:
  /// **'Results were uncertain, so no suggestions are shown. Try again with better light and your whole body in the guide.'**
  String get postureLowConfidenceNote;

  /// No description provided for @postureChange.
  ///
  /// In en, this message translates to:
  /// **'{change} since last check'**
  String postureChange(String change);

  /// No description provided for @postureFlaggedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All within typical range} =1{1 to look at} other{{count} to look at}}'**
  String postureFlaggedCount(int count);

  /// No description provided for @valueDegrees.
  ///
  /// In en, this message translates to:
  /// **'{value}°'**
  String valueDegrees(String value);

  /// No description provided for @exerciseSafetyNote.
  ///
  /// In en, this message translates to:
  /// **'These are general mobility ideas, not treatment. Stop if anything hurts.'**
  String get exerciseSafetyNote;

  /// No description provided for @whyThis.
  ///
  /// In en, this message translates to:
  /// **'Why this?'**
  String get whyThis;

  /// No description provided for @whyObserved.
  ///
  /// In en, this message translates to:
  /// **'{metric} measured {degrees}° ({band}) in this check.'**
  String whyObserved(String metric, String degrees, String band);

  /// No description provided for @whyRepeated.
  ///
  /// In en, this message translates to:
  /// **'Your previous check showed this too.'**
  String get whyRepeated;

  /// No description provided for @whyGoal.
  ///
  /// In en, this message translates to:
  /// **'Posture is one of your goals.'**
  String get whyGoal;

  /// No description provided for @whyMaintenance.
  ///
  /// In en, this message translates to:
  /// **'All estimated alignments were within the typical range; regular breaks help keep it that way.'**
  String get whyMaintenance;

  /// No description provided for @alternativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Alternative: {name}'**
  String alternativeLabel(String name);

  /// No description provided for @poseAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'On-device analysis could not run on this frame. If this keeps happening, restart the camera.'**
  String get poseAnalysisFailed;

  /// No description provided for @postureStepBack.
  ///
  /// In en, this message translates to:
  /// **'Step back into the guide — capture starts at zero.'**
  String get postureStepBack;

  /// No description provided for @postureCountdown.
  ///
  /// In en, this message translates to:
  /// **'Starting in {seconds}'**
  String postureCountdown(int seconds);

  /// No description provided for @exerciseLibrary.
  ///
  /// In en, this message translates to:
  /// **'Exercise library'**
  String get exerciseLibrary;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterCameraTracked.
  ///
  /// In en, this message translates to:
  /// **'Camera-tracked'**
  String get filterCameraTracked;

  /// No description provided for @cameraTracked.
  ///
  /// In en, this message translates to:
  /// **'Camera-tracked'**
  String get cameraTracked;

  /// No description provided for @howTo.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get howTo;

  /// No description provided for @trackWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Track with camera'**
  String get trackWithCamera;

  /// No description provided for @logAsDone.
  ///
  /// In en, this message translates to:
  /// **'Log as done'**
  String get logAsDone;

  /// No description provided for @savedToLog.
  ///
  /// In en, this message translates to:
  /// **'Saved to your exercise log'**
  String get savedToLog;

  /// No description provided for @repsValue.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String repsValue(int count);

  /// No description provided for @trackingSetupFront.
  ///
  /// In en, this message translates to:
  /// **'Prop the phone upright at waist height, step back 2–3 m and face the camera so your whole body is visible.'**
  String get trackingSetupFront;

  /// No description provided for @trackingSetupSide.
  ///
  /// In en, this message translates to:
  /// **'Place the phone at floor or waist height to your side, so it sees your whole body from the side.'**
  String get trackingSetupSide;

  /// No description provided for @trackingTargetReps.
  ///
  /// In en, this message translates to:
  /// **'Goal: {count} reps'**
  String trackingTargetReps(int count);

  /// No description provided for @trackingTargetHold.
  ///
  /// In en, this message translates to:
  /// **'Goal: hold for {seconds} seconds'**
  String trackingTargetHold(int seconds);

  /// No description provided for @trackingReady.
  ///
  /// In en, this message translates to:
  /// **'Ready — tap Start, then get into position during the countdown.'**
  String get trackingReady;

  /// No description provided for @trackingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get trackingStart;

  /// No description provided for @trackingFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get trackingFinish;

  /// No description provided for @trackingOfReps.
  ///
  /// In en, this message translates to:
  /// **'of {count} reps'**
  String trackingOfReps(int count);

  /// No description provided for @trackingOfSeconds.
  ///
  /// In en, this message translates to:
  /// **'of {seconds}s'**
  String trackingOfSeconds(int seconds);

  /// No description provided for @holdSecondsValue.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String holdSecondsValue(int seconds);

  /// No description provided for @trackingSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session summary'**
  String get trackingSummaryTitle;

  /// No description provided for @trackingRepsDone.
  ///
  /// In en, this message translates to:
  /// **'Reps counted'**
  String get trackingRepsDone;

  /// No description provided for @trackingHoldTime.
  ///
  /// In en, this message translates to:
  /// **'Time in position'**
  String get trackingHoldTime;

  /// No description provided for @trackingTargetReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached — well done.'**
  String get trackingTargetReached;

  /// No description provided for @trackingCountNote.
  ///
  /// In en, this message translates to:
  /// **'Counted by the camera on this phone. It can occasionally miss or add a rep.'**
  String get trackingCountNote;

  /// No description provided for @saveToLog.
  ///
  /// In en, this message translates to:
  /// **'Save to log'**
  String get saveToLog;

  /// No description provided for @trackingDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get trackingDone;

  /// No description provided for @cueStepIntoView.
  ///
  /// In en, this message translates to:
  /// **'Step into view so your whole body is visible.'**
  String get cueStepIntoView;

  /// No description provided for @cueGoLower.
  ///
  /// In en, this message translates to:
  /// **'Go a little lower if it feels comfortable.'**
  String get cueGoLower;

  /// No description provided for @cueKneesOverToes.
  ///
  /// In en, this message translates to:
  /// **'Keep your knees in line with your toes.'**
  String get cueKneesOverToes;

  /// No description provided for @cueChestUp.
  ///
  /// In en, this message translates to:
  /// **'Keep your chest up.'**
  String get cueChestUp;

  /// No description provided for @cueRaiseHigher.
  ///
  /// In en, this message translates to:
  /// **'Raise your arms a little higher.'**
  String get cueRaiseHigher;

  /// No description provided for @cueRaiseEvenly.
  ///
  /// In en, this message translates to:
  /// **'Raise both arms evenly.'**
  String get cueRaiseEvenly;

  /// No description provided for @cueLiftKneeHigher.
  ///
  /// In en, this message translates to:
  /// **'Lift your knee a little higher.'**
  String get cueLiftKneeHigher;

  /// No description provided for @cueKeepBodyStraight.
  ///
  /// In en, this message translates to:
  /// **'Keep a straight line from shoulders to ankles.'**
  String get cueKeepBodyStraight;

  /// No description provided for @cueGetIntoPosition.
  ///
  /// In en, this message translates to:
  /// **'Get into position.'**
  String get cueGetIntoPosition;

  /// No description provided for @cueGoodForm.
  ///
  /// In en, this message translates to:
  /// **'Good — keep going.'**
  String get cueGoodForm;

  /// No description provided for @cueKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going at a steady pace.'**
  String get cueKeepGoing;

  /// No description provided for @faceHistory.
  ///
  /// In en, this message translates to:
  /// **'Face history'**
  String get faceHistory;

  /// No description provided for @faceHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Complete a face check to see style suggestions here.'**
  String get faceHistoryEmpty;

  /// No description provided for @faceIntro.
  ///
  /// In en, this message translates to:
  /// **'Estimate your face shape from its proportions and get hairstyle, beard, glasses and grooming ideas.'**
  String get faceIntro;

  /// No description provided for @facePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your face is analyzed on this phone. No photo is taken or stored; only proportions are saved, and only if you tap Save.'**
  String get facePrivacy;

  /// No description provided for @faceTipLight.
  ///
  /// In en, this message translates to:
  /// **'Face a window or lamp so light falls evenly on your face.'**
  String get faceTipLight;

  /// No description provided for @faceTipHair.
  ///
  /// In en, this message translates to:
  /// **'Keep hair away from your forehead and jawline.'**
  String get faceTipHair;

  /// No description provided for @faceTipStraight.
  ///
  /// In en, this message translates to:
  /// **'Look straight at the camera with a neutral expression; keep your head level.'**
  String get faceTipStraight;

  /// No description provided for @faceDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Face shape is an estimate from the camera, used only for style ideas. It says nothing about attractiveness, and every face suits many styles.'**
  String get faceDisclaimer;

  /// No description provided for @faceNone.
  ///
  /// In en, this message translates to:
  /// **'No face detected. Look at the camera.'**
  String get faceNone;

  /// No description provided for @faceMultiple.
  ///
  /// In en, this message translates to:
  /// **'More than one face is visible. Make sure only you are in view.'**
  String get faceMultiple;

  /// No description provided for @faceModelRequired.
  ///
  /// In en, this message translates to:
  /// **'Face analysis isn\'t available on this device.'**
  String get faceModelRequired;

  /// No description provided for @faceReady.
  ///
  /// In en, this message translates to:
  /// **'Face detected — tap Analyze and hold still.'**
  String get faceReady;

  /// No description provided for @faceTooFar.
  ///
  /// In en, this message translates to:
  /// **'Bring the phone a little closer to your face.'**
  String get faceTooFar;

  /// No description provided for @faceTooClose.
  ///
  /// In en, this message translates to:
  /// **'Move the phone a little further away.'**
  String get faceTooClose;

  /// No description provided for @faceInGuide.
  ///
  /// In en, this message translates to:
  /// **'Keep your whole face inside the oval.'**
  String get faceInGuide;

  /// No description provided for @faceCapturing.
  ///
  /// In en, this message translates to:
  /// **'Hold still while a few frames are measured…'**
  String get faceCapturing;

  /// No description provided for @faceNotReliable.
  ///
  /// In en, this message translates to:
  /// **'Face shape could not be reliably estimated.'**
  String get faceNotReliable;

  /// No description provided for @faceSaved.
  ///
  /// In en, this message translates to:
  /// **'Face check saved'**
  String get faceSaved;

  /// No description provided for @faceResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated face shape'**
  String get faceResultTitle;

  /// No description provided for @faceShapeBetween.
  ///
  /// In en, this message translates to:
  /// **'{first} / {second}'**
  String faceShapeBetween(String first, String second);

  /// No description provided for @faceLowConfidenceNote.
  ///
  /// In en, this message translates to:
  /// **'The estimate was uncertain, so no style suggestions are shown. Try again with even light and your head level.'**
  String get faceLowConfidenceNote;

  /// No description provided for @shapeOval.
  ///
  /// In en, this message translates to:
  /// **'Oval'**
  String get shapeOval;

  /// No description provided for @shapeRound.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get shapeRound;

  /// No description provided for @shapeSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get shapeSquare;

  /// No description provided for @shapeOblong.
  ///
  /// In en, this message translates to:
  /// **'Oblong'**
  String get shapeOblong;

  /// No description provided for @shapeHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get shapeHeart;

  /// No description provided for @shapeDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get shapeDiamond;

  /// No description provided for @ratioLengthWidth.
  ///
  /// In en, this message translates to:
  /// **'Length ÷ cheekbone width'**
  String get ratioLengthWidth;

  /// No description provided for @ratioForeheadCheek.
  ///
  /// In en, this message translates to:
  /// **'Forehead ÷ cheekbone width'**
  String get ratioForeheadCheek;

  /// No description provided for @ratioJawCheek.
  ///
  /// In en, this message translates to:
  /// **'Jaw ÷ cheekbone width'**
  String get ratioJawCheek;

  /// No description provided for @styleHair.
  ///
  /// In en, this message translates to:
  /// **'Hairstyles'**
  String get styleHair;

  /// No description provided for @styleBeard.
  ///
  /// In en, this message translates to:
  /// **'Beard styles'**
  String get styleBeard;

  /// No description provided for @styleBeardNote.
  ///
  /// In en, this message translates to:
  /// **'If you have or want facial hair.'**
  String get styleBeardNote;

  /// No description provided for @styleGlasses.
  ///
  /// In en, this message translates to:
  /// **'Glasses frames'**
  String get styleGlasses;

  /// No description provided for @favoriteAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get favoriteAdd;

  /// No description provided for @favoriteRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get favoriteRemove;

  /// No description provided for @groomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Simple grooming routine'**
  String get groomingTitle;

  /// No description provided for @groomingAddRoutine.
  ///
  /// In en, this message translates to:
  /// **'Add to my routines'**
  String get groomingAddRoutine;

  /// No description provided for @groomingRoutineName.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get groomingRoutineName;

  /// No description provided for @groomingRoutineAdded.
  ///
  /// In en, this message translates to:
  /// **'Grooming routine added to your routines'**
  String get groomingRoutineAdded;

  /// No description provided for @faceBetweenNote.
  ///
  /// In en, this message translates to:
  /// **'Your proportions are also close to {shape}, so ideas for both are shown:'**
  String faceBetweenNote(String shape);

  /// No description provided for @cardFlipHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to see details'**
  String get cardFlipHint;

  /// No description provided for @tryOn.
  ///
  /// In en, this message translates to:
  /// **'Try on'**
  String get tryOn;

  /// No description provided for @tryOnOpen.
  ///
  /// In en, this message translates to:
  /// **'Try on glasses & beard styles'**
  String get tryOnOpen;

  /// No description provided for @faceArtLegend.
  ///
  /// In en, this message translates to:
  /// **'Grey: reference shape · Colour: your proportions'**
  String get faceArtLegend;

  /// No description provided for @tryOnHint.
  ///
  /// In en, this message translates to:
  /// **'Press and hold the preview to compare without.'**
  String get tryOnHint;

  /// No description provided for @tryOnComparing.
  ///
  /// In en, this message translates to:
  /// **'Showing without the style'**
  String get tryOnComparing;

  /// No description provided for @tryOnNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get tryOnNone;

  /// No description provided for @tryOnNote.
  ///
  /// In en, this message translates to:
  /// **'Live preview drawn on this phone; nothing is recorded. Beard previews are approximate shading, not a photo-real render.'**
  String get tryOnNote;

  /// No description provided for @featureProgressSnapshots.
  ///
  /// In en, this message translates to:
  /// **'Progress snapshots'**
  String get featureProgressSnapshots;

  /// No description provided for @snapFace.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get snapFace;

  /// No description provided for @snapBodyFront.
  ///
  /// In en, this message translates to:
  /// **'Body · front'**
  String get snapBodyFront;

  /// No description provided for @snapBodySide.
  ///
  /// In en, this message translates to:
  /// **'Body · side'**
  String get snapBodySide;

  /// No description provided for @snapTake.
  ///
  /// In en, this message translates to:
  /// **'Take snapshot'**
  String get snapTake;

  /// No description provided for @snapCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare before / after'**
  String get snapCompare;

  /// No description provided for @snapEmpty.
  ///
  /// In en, this message translates to:
  /// **'Take your first snapshot. Repeat it regularly in the same place and light to see changes over time.'**
  String get snapEmpty;

  /// No description provided for @snapPrivacyShort.
  ///
  /// In en, this message translates to:
  /// **'Stored only on this phone, inside the encrypted database. Never uploaded or added to your gallery.'**
  String get snapPrivacyShort;

  /// No description provided for @snapLongPressDelete.
  ///
  /// In en, this message translates to:
  /// **'Long-press a snapshot to delete it.'**
  String get snapLongPressDelete;

  /// No description provided for @snapWeeklyReminder.
  ///
  /// In en, this message translates to:
  /// **'Remind me weekly (Sunday 9:00)'**
  String get snapWeeklyReminder;

  /// No description provided for @snapDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all snapshots'**
  String get snapDeleteAll;

  /// No description provided for @snapReminderRoutine.
  ///
  /// In en, this message translates to:
  /// **'Progress snapshot'**
  String get snapReminderRoutine;

  /// No description provided for @snapReminderItem.
  ///
  /// In en, this message translates to:
  /// **'Take a progress snapshot'**
  String get snapReminderItem;

  /// No description provided for @snapReminderAdded.
  ///
  /// In en, this message translates to:
  /// **'Weekly snapshot reminder added to your routines'**
  String get snapReminderAdded;

  /// No description provided for @snapConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Track changes with private photos'**
  String get snapConsentTitle;

  /// No description provided for @snapConsentStored.
  ///
  /// In en, this message translates to:
  /// **'Photos are saved only when you tap Save, inside this app\'s encrypted database.'**
  String get snapConsentStored;

  /// No description provided for @snapConsentNeverUploaded.
  ///
  /// In en, this message translates to:
  /// **'They never leave this phone and are not added to your gallery.'**
  String get snapConsentNeverUploaded;

  /// No description provided for @snapConsentOptIn.
  ///
  /// In en, this message translates to:
  /// **'This is optional; every other feature works without photos.'**
  String get snapConsentOptIn;

  /// No description provided for @snapConsentDelete.
  ///
  /// In en, this message translates to:
  /// **'You can delete any snapshot, or all of them, at any time.'**
  String get snapConsentDelete;

  /// No description provided for @snapConsentAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand — turn on snapshots'**
  String get snapConsentAccept;

  /// No description provided for @snapGhost.
  ///
  /// In en, this message translates to:
  /// **'Show previous snapshot as a guide'**
  String get snapGhost;

  /// No description provided for @snapGhostHelp.
  ///
  /// In en, this message translates to:
  /// **'Line yourself up with the faint image so snapshots are comparable.'**
  String get snapGhostHelp;

  /// No description provided for @snapTipFace.
  ///
  /// In en, this message translates to:
  /// **'Same place and light each time; face the camera with a neutral expression.'**
  String get snapTipFace;

  /// No description provided for @snapTipBody.
  ///
  /// In en, this message translates to:
  /// **'Prop the phone at waist height, step back so your whole body fits, and wear similar clothing each time.'**
  String get snapTipBody;

  /// No description provided for @snapCapture.
  ///
  /// In en, this message translates to:
  /// **'Capture (3-second timer)'**
  String get snapCapture;

  /// No description provided for @snapSaveEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Save privately'**
  String get snapSaveEncrypted;

  /// No description provided for @snapSaved.
  ///
  /// In en, this message translates to:
  /// **'Snapshot saved privately'**
  String get snapSaved;

  /// No description provided for @snapBefore.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get snapBefore;

  /// No description provided for @snapAfter.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get snapAfter;

  /// No description provided for @snapCompareHelp.
  ///
  /// In en, this message translates to:
  /// **'Drag across the image to compare. Choose any two snapshots below.'**
  String get snapCompareHelp;

  /// No description provided for @colourTitle.
  ///
  /// In en, this message translates to:
  /// **'Colour & style'**
  String get colourTitle;

  /// No description provided for @colourYourPalette.
  ///
  /// In en, this message translates to:
  /// **'Your palette'**
  String get colourYourPalette;

  /// No description provided for @colourDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Palettes are colour-theory suggestions, not rules — wear what you enjoy.'**
  String get colourDisclaimer;

  /// No description provided for @quizVeinQ.
  ///
  /// In en, this message translates to:
  /// **'What colour do the veins on your inner wrist look?'**
  String get quizVeinQ;

  /// No description provided for @quizVeinHelp.
  ///
  /// In en, this message translates to:
  /// **'Look in daylight, without filters.'**
  String get quizVeinHelp;

  /// No description provided for @quizVeinBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue or purple'**
  String get quizVeinBlue;

  /// No description provided for @quizVeinGreen.
  ///
  /// In en, this message translates to:
  /// **'Greenish'**
  String get quizVeinGreen;

  /// No description provided for @quizVeinBoth.
  ///
  /// In en, this message translates to:
  /// **'Hard to tell / both'**
  String get quizVeinBoth;

  /// No description provided for @quizJewelQ.
  ///
  /// In en, this message translates to:
  /// **'Which jewellery looks better on your skin?'**
  String get quizJewelQ;

  /// No description provided for @quizJewelHelp.
  ///
  /// In en, this message translates to:
  /// **'Think of rings or a watch against your hand.'**
  String get quizJewelHelp;

  /// No description provided for @quizJewelSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get quizJewelSilver;

  /// No description provided for @quizJewelGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get quizJewelGold;

  /// No description provided for @quizJewelBoth.
  ///
  /// In en, this message translates to:
  /// **'Both look good'**
  String get quizJewelBoth;

  /// No description provided for @quizSunQ.
  ///
  /// In en, this message translates to:
  /// **'How does your skin usually react to the sun?'**
  String get quizSunQ;

  /// No description provided for @quizSunHelp.
  ///
  /// In en, this message translates to:
  /// **'Without sunscreen, after a short time outdoors.'**
  String get quizSunHelp;

  /// No description provided for @quizSunBurns.
  ///
  /// In en, this message translates to:
  /// **'Burns or turns pink'**
  String get quizSunBurns;

  /// No description provided for @quizSunTans.
  ///
  /// In en, this message translates to:
  /// **'Tans easily'**
  String get quizSunTans;

  /// No description provided for @quizSunBoth.
  ///
  /// In en, this message translates to:
  /// **'A bit of both'**
  String get quizSunBoth;

  /// No description provided for @quizDepthQ.
  ///
  /// In en, this message translates to:
  /// **'Which is closest to your skin depth?'**
  String get quizDepthQ;

  /// No description provided for @quizDepthHelp.
  ///
  /// In en, this message translates to:
  /// **'This sets how much contrast your palette has.'**
  String get quizDepthHelp;

  /// No description provided for @quizSeePalette.
  ///
  /// In en, this message translates to:
  /// **'See my palette'**
  String get quizSeePalette;

  /// No description provided for @quizRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake colour quiz'**
  String get quizRetake;

  /// No description provided for @undertoneWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm undertone'**
  String get undertoneWarm;

  /// No description provided for @undertoneCool.
  ///
  /// In en, this message translates to:
  /// **'Cool undertone'**
  String get undertoneCool;

  /// No description provided for @undertoneNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral undertone'**
  String get undertoneNeutral;

  /// No description provided for @undertoneWarmExplain.
  ///
  /// In en, this message translates to:
  /// **'Earthy, golden and olive shades tend to harmonise with your skin.'**
  String get undertoneWarmExplain;

  /// No description provided for @undertoneCoolExplain.
  ///
  /// In en, this message translates to:
  /// **'Jewel tones, blues and rosy shades tend to harmonise with your skin.'**
  String get undertoneCoolExplain;

  /// No description provided for @undertoneNeutralExplain.
  ///
  /// In en, this message translates to:
  /// **'Most balanced shades suit you; avoid only very extreme colours near the face.'**
  String get undertoneNeutralExplain;

  /// No description provided for @depthLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get depthLight;

  /// No description provided for @depthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get depthMedium;

  /// No description provided for @depthDeep.
  ///
  /// In en, this message translates to:
  /// **'Deep'**
  String get depthDeep;

  /// No description provided for @paletteBest.
  ///
  /// In en, this message translates to:
  /// **'Best colours'**
  String get paletteBest;

  /// No description provided for @paletteBestNote.
  ///
  /// In en, this message translates to:
  /// **'Wear these near your face — tops, shirts, scarves. Tap one to try it on.'**
  String get paletteBestNote;

  /// No description provided for @paletteNeutrals.
  ///
  /// In en, this message translates to:
  /// **'Your neutrals'**
  String get paletteNeutrals;

  /// No description provided for @paletteNeutralsNote.
  ///
  /// In en, this message translates to:
  /// **'Foundation colours for trousers, outerwear and shoes.'**
  String get paletteNeutralsNote;

  /// No description provided for @paletteSparingly.
  ///
  /// In en, this message translates to:
  /// **'Use sparingly'**
  String get paletteSparingly;

  /// No description provided for @paletteSparinglyNote.
  ///
  /// In en, this message translates to:
  /// **'Fine away from the face or as small accents.'**
  String get paletteSparinglyNote;

  /// No description provided for @drapeOpen.
  ///
  /// In en, this message translates to:
  /// **'Try colours on live'**
  String get drapeOpen;

  /// No description provided for @drapeTitle.
  ///
  /// In en, this message translates to:
  /// **'Colour drape'**
  String get drapeTitle;

  /// No description provided for @drapeHint.
  ///
  /// In en, this message translates to:
  /// **'Tap colours below and compare'**
  String get drapeHint;

  /// No description provided for @drapeNote.
  ///
  /// In en, this message translates to:
  /// **'A colour drape shows how a shade looks next to your face. Live preview only; nothing is recorded. Room lighting affects how colours appear.'**
  String get drapeNote;

  /// No description provided for @stylePrefsTitle.
  ///
  /// In en, this message translates to:
  /// **'Styles you like'**
  String get stylePrefsTitle;

  /// No description provided for @prefClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get prefClassic;

  /// No description provided for @prefMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get prefMinimal;

  /// No description provided for @prefSmartCasual.
  ///
  /// In en, this message translates to:
  /// **'Smart casual'**
  String get prefSmartCasual;

  /// No description provided for @prefStreet.
  ///
  /// In en, this message translates to:
  /// **'Streetwear'**
  String get prefStreet;

  /// No description provided for @prefTraditional.
  ///
  /// In en, this message translates to:
  /// **'Traditional / ethnic'**
  String get prefTraditional;

  /// No description provided for @prefSporty.
  ///
  /// In en, this message translates to:
  /// **'Sporty'**
  String get prefSporty;

  /// No description provided for @wardrobeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add clothing'**
  String get wardrobeAdd;

  /// No description provided for @wardrobeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a few pieces you wear often — tops, bottoms and shoes — and get outfit ideas from your own clothes.'**
  String get wardrobeEmpty;

  /// No description provided for @wardrobePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Clothing photos stay on this phone inside the encrypted database.'**
  String get wardrobePrivacy;

  /// No description provided for @outfitIdeas.
  ///
  /// In en, this message translates to:
  /// **'Outfit ideas'**
  String get outfitIdeas;

  /// No description provided for @outfitIdeasTab.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get outfitIdeasTab;

  /// No description provided for @outfitSavedTab.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get outfitSavedTab;

  /// No description provided for @outfitNone.
  ///
  /// In en, this message translates to:
  /// **'No combinations for this occasion yet. Add tops, bottoms and shoes, or mark items for this occasion.'**
  String get outfitNone;

  /// No description provided for @outfitPaletteHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: complete the colour quiz to rank outfits by your palette.'**
  String get outfitPaletteHint;

  /// No description provided for @outfitSave.
  ///
  /// In en, this message translates to:
  /// **'Save outfit'**
  String get outfitSave;

  /// No description provided for @outfitSavedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Saved outfits appear here, ready for busy mornings.'**
  String get outfitSavedEmpty;

  /// No description provided for @outfitWoreToday.
  ///
  /// In en, this message translates to:
  /// **'Wore it today'**
  String get outfitWoreToday;

  /// No description provided for @garmentName.
  ///
  /// In en, this message translates to:
  /// **'Name (e.g. white oxford shirt)'**
  String get garmentName;

  /// No description provided for @garmentPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo (optional)'**
  String get garmentPhoto;

  /// No description provided for @garmentRetakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake photo'**
  String get garmentRetakePhoto;

  /// No description provided for @garmentPhotoTip.
  ///
  /// In en, this message translates to:
  /// **'Lay the item flat or hang it in good light, filling the frame. Its colour is read from the centre.'**
  String get garmentPhotoTip;

  /// No description provided for @garmentCategory.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get garmentCategory;

  /// No description provided for @garmentColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get garmentColour;

  /// No description provided for @garmentColourFromPhoto.
  ///
  /// In en, this message translates to:
  /// **'Colour (read from photo — adjust if needed)'**
  String get garmentColourFromPhoto;

  /// No description provided for @garmentPattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get garmentPattern;

  /// No description provided for @garmentFormality.
  ///
  /// In en, this message translates to:
  /// **'Formality'**
  String get garmentFormality;

  /// No description provided for @garmentOccasions.
  ///
  /// In en, this message translates to:
  /// **'Occasions'**
  String get garmentOccasions;

  /// No description provided for @garmentOccasionsHelp.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to allow any occasion.'**
  String get garmentOccasionsHelp;

  /// No description provided for @catTop.
  ///
  /// In en, this message translates to:
  /// **'Top / shirt'**
  String get catTop;

  /// No description provided for @catBottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get catBottom;

  /// No description provided for @catOnePiece.
  ///
  /// In en, this message translates to:
  /// **'Dress / one-piece'**
  String get catOnePiece;

  /// No description provided for @catOuterwear.
  ///
  /// In en, this message translates to:
  /// **'Outerwear'**
  String get catOuterwear;

  /// No description provided for @catFootwear.
  ///
  /// In en, this message translates to:
  /// **'Footwear'**
  String get catFootwear;

  /// No description provided for @catEthnicTop.
  ///
  /// In en, this message translates to:
  /// **'Kurta / ethnic top'**
  String get catEthnicTop;

  /// No description provided for @catEthnicBottom.
  ///
  /// In en, this message translates to:
  /// **'Ethnic bottom'**
  String get catEthnicBottom;

  /// No description provided for @catAccessory.
  ///
  /// In en, this message translates to:
  /// **'Accessory'**
  String get catAccessory;

  /// No description provided for @patSolid.
  ///
  /// In en, this message translates to:
  /// **'Solid'**
  String get patSolid;

  /// No description provided for @patStripes.
  ///
  /// In en, this message translates to:
  /// **'Stripes'**
  String get patStripes;

  /// No description provided for @patChecks.
  ///
  /// In en, this message translates to:
  /// **'Checks'**
  String get patChecks;

  /// No description provided for @patPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get patPrint;

  /// No description provided for @occCasual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get occCasual;

  /// No description provided for @occWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get occWork;

  /// No description provided for @occFormal.
  ///
  /// In en, this message translates to:
  /// **'Formal'**
  String get occFormal;

  /// No description provided for @occFestive.
  ///
  /// In en, this message translates to:
  /// **'Festive'**
  String get occFestive;

  /// No description provided for @occSport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get occSport;

  /// No description provided for @form1.
  ///
  /// In en, this message translates to:
  /// **'Very relaxed'**
  String get form1;

  /// No description provided for @form2.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get form2;

  /// No description provided for @form3.
  ///
  /// In en, this message translates to:
  /// **'Smart'**
  String get form3;

  /// No description provided for @form4.
  ///
  /// In en, this message translates to:
  /// **'Dressy'**
  String get form4;

  /// No description provided for @form5.
  ///
  /// In en, this message translates to:
  /// **'Formal'**
  String get form5;

  /// No description provided for @reasonAllNeutral.
  ///
  /// In en, this message translates to:
  /// **'All neutral colours — easy and polished.'**
  String get reasonAllNeutral;

  /// No description provided for @reasonOneAccent.
  ///
  /// In en, this message translates to:
  /// **'One accent colour against neutrals.'**
  String get reasonOneAccent;

  /// No description provided for @reasonTonal.
  ///
  /// In en, this message translates to:
  /// **'Tonal colours from the same family.'**
  String get reasonTonal;

  /// No description provided for @reasonAnalogous.
  ///
  /// In en, this message translates to:
  /// **'Neighbouring colours that blend smoothly.'**
  String get reasonAnalogous;

  /// No description provided for @reasonComplementary.
  ///
  /// In en, this message translates to:
  /// **'Opposite colours for a confident contrast.'**
  String get reasonComplementary;

  /// No description provided for @reasonInPalette.
  ///
  /// In en, this message translates to:
  /// **'The colour near your face is in your palette.'**
  String get reasonInPalette;

  /// No description provided for @reasonOnePattern.
  ///
  /// In en, this message translates to:
  /// **'A single pattern, balanced by solids.'**
  String get reasonOnePattern;

  /// No description provided for @reasonMatchedFormality.
  ///
  /// In en, this message translates to:
  /// **'Every piece suits the occasion.'**
  String get reasonMatchedFormality;

  /// No description provided for @reasonFavourite.
  ///
  /// In en, this message translates to:
  /// **'Includes a favourite piece.'**
  String get reasonFavourite;

  /// No description provided for @reasonNotWorn.
  ///
  /// In en, this message translates to:
  /// **'None of these were worn this week.'**
  String get reasonNotWorn;

  /// No description provided for @outfitWornCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not worn yet} =1{Worn once} other{Worn {count} times}}'**
  String outfitWornCount(int count);

  /// No description provided for @journeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your journey'**
  String get journeyTitle;

  /// No description provided for @journeyLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String journeyLevel(int level);

  /// No description provided for @journeyXpToNext.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to level {level}'**
  String journeyXpToNext(int xp, int level);

  /// No description provided for @journeyTodayXp.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP today'**
  String journeyTodayXp(int xp);

  /// No description provided for @journeyStreak.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No streak yet} =1{1-day streak} other{{count}-day streak}}'**
  String journeyStreak(int count);

  /// No description provided for @journeyRestDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No rest days banked} =1{1 rest day banked} other{{count} rest days banked}}'**
  String journeyRestDays(int count);

  /// No description provided for @journeyRestDaysHelp.
  ///
  /// In en, this message translates to:
  /// **'Every 7 active days earns a rest day. A missed day uses one, so your streak continues.'**
  String get journeyRestDaysHelp;

  /// No description provided for @journeyStartTimelapse.
  ///
  /// In en, this message translates to:
  /// **'Take a face snapshot to start your time-lapse'**
  String get journeyStartTimelapse;

  /// No description provided for @journeyOneSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Add another snapshot next week to see your change'**
  String get journeyOneSnapshot;

  /// No description provided for @journeySnapshotCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 snapshot} other{{count} snapshots}}'**
  String journeySnapshotCount(int count);

  /// No description provided for @journeyFirst.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get journeyFirst;

  /// No description provided for @journeyLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get journeyLatest;

  /// No description provided for @journeyPlay.
  ///
  /// In en, this message translates to:
  /// **'Play time-lapse'**
  String get journeyPlay;

  /// No description provided for @journeyPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get journeyPause;

  /// No description provided for @journeyCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare side by side'**
  String get journeyCompare;

  /// No description provided for @journeyAlignNote.
  ///
  /// In en, this message translates to:
  /// **'Photos are lined up by your eyes. A front-facing, well-lit photo lines up best.'**
  String get journeyAlignNote;

  /// No description provided for @journeyTotalXp.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get journeyTotalXp;

  /// No description provided for @journeyBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get journeyBestStreak;

  /// No description provided for @journeyActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get journeyActiveDays;

  /// No description provided for @journeyLast4Weeks.
  ///
  /// In en, this message translates to:
  /// **'Last 4 weeks'**
  String get journeyLast4Weeks;

  /// No description provided for @journeyTrends.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get journeyTrends;

  /// No description provided for @journeyWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get journeyWeight;

  /// No description provided for @journeyXpPerDay.
  ///
  /// In en, this message translates to:
  /// **'XP per day'**
  String get journeyXpPerDay;

  /// No description provided for @journeyBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get journeyBadges;

  /// No description provided for @journeyBadgesEarned.
  ///
  /// In en, this message translates to:
  /// **'{earned} of {total} earned'**
  String journeyBadgesEarned(int earned, int total);

  /// No description provided for @journeyHowXp.
  ///
  /// In en, this message translates to:
  /// **'How XP works'**
  String get journeyHowXp;

  /// No description provided for @journeyHowXpBody.
  ///
  /// In en, this message translates to:
  /// **'XP comes from what you already log — water, meals, sleep, activity, habits, plan items, checks, snapshots and outfits. A day with 15 XP or more counts toward your streak. Missing a day never removes XP.'**
  String get journeyHowXpBody;

  /// No description provided for @questsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s quests'**
  String get questsTitle;

  /// No description provided for @questsReward.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP'**
  String questsReward(int xp);

  /// No description provided for @questsAllDone.
  ///
  /// In en, this message translates to:
  /// **'All done — +{xp} bonus XP'**
  String questsAllDone(int xp);

  /// No description provided for @questsAllBonus.
  ///
  /// In en, this message translates to:
  /// **'Finish all three for +{xp} bonus XP'**
  String questsAllBonus(int xp);

  /// No description provided for @questDrinkTarget.
  ///
  /// In en, this message translates to:
  /// **'Reach your water target'**
  String get questDrinkTarget;

  /// No description provided for @questLogMeals.
  ///
  /// In en, this message translates to:
  /// **'Log two meals'**
  String get questLogMeals;

  /// No description provided for @questPostureCheck.
  ///
  /// In en, this message translates to:
  /// **'Do a posture check'**
  String get questPostureCheck;

  /// No description provided for @questCompletePlan.
  ///
  /// In en, this message translates to:
  /// **'Complete three plan items'**
  String get questCompletePlan;

  /// No description provided for @questAllHabits.
  ///
  /// In en, this message translates to:
  /// **'Finish today\'s habits'**
  String get questAllHabits;

  /// No description provided for @questLogSleep.
  ///
  /// In en, this message translates to:
  /// **'Log last night\'s sleep'**
  String get questLogSleep;

  /// No description provided for @questWorkout.
  ///
  /// In en, this message translates to:
  /// **'Log a workout or activity'**
  String get questWorkout;

  /// No description provided for @questWearOutfit.
  ///
  /// In en, this message translates to:
  /// **'Wear a saved outfit'**
  String get questWearOutfit;

  /// No description provided for @questSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Take this week\'s face snapshot'**
  String get questSnapshot;

  /// No description provided for @questLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log your weight'**
  String get questLogWeight;

  /// No description provided for @badgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Badge unlocked'**
  String get badgeUnlocked;

  /// No description provided for @badgesUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{count} badges unlocked'**
  String badgesUnlocked(int count);

  /// No description provided for @badgeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get badgeContinue;

  /// No description provided for @badgeProgress.
  ///
  /// In en, this message translates to:
  /// **'{progress} / {target}'**
  String badgeProgress(int progress, int target);

  /// No description provided for @badgeFirstSteps.
  ///
  /// In en, this message translates to:
  /// **'First steps'**
  String get badgeFirstSteps;

  /// No description provided for @badgeFirstStepsInfo.
  ///
  /// In en, this message translates to:
  /// **'Log anything for the first time.'**
  String get badgeFirstStepsInfo;

  /// No description provided for @badgeStreak7.
  ///
  /// In en, this message translates to:
  /// **'One steady week'**
  String get badgeStreak7;

  /// No description provided for @badgeStreak7Info.
  ///
  /// In en, this message translates to:
  /// **'Reach a 7-day streak.'**
  String get badgeStreak7Info;

  /// No description provided for @badgeStreak30.
  ///
  /// In en, this message translates to:
  /// **'Thirty strong'**
  String get badgeStreak30;

  /// No description provided for @badgeStreak30Info.
  ///
  /// In en, this message translates to:
  /// **'Reach a 30-day streak.'**
  String get badgeStreak30Info;

  /// No description provided for @badgeHydration.
  ///
  /// In en, this message translates to:
  /// **'Well hydrated'**
  String get badgeHydration;

  /// No description provided for @badgeHydrationInfo.
  ///
  /// In en, this message translates to:
  /// **'Meet your water target on 7 days.'**
  String get badgeHydrationInfo;

  /// No description provided for @badgePosture.
  ///
  /// In en, this message translates to:
  /// **'Posture regular'**
  String get badgePosture;

  /// No description provided for @badgePostureInfo.
  ///
  /// In en, this message translates to:
  /// **'Complete 5 posture checks.'**
  String get badgePostureInfo;

  /// No description provided for @badgeFace.
  ///
  /// In en, this message translates to:
  /// **'Face explorer'**
  String get badgeFace;

  /// No description provided for @badgeFaceInfo.
  ///
  /// In en, this message translates to:
  /// **'Complete a face analysis.'**
  String get badgeFaceInfo;

  /// No description provided for @badgeJourney.
  ///
  /// In en, this message translates to:
  /// **'Journey keeper'**
  String get badgeJourney;

  /// No description provided for @badgeJourneyInfo.
  ///
  /// In en, this message translates to:
  /// **'Save 4 progress snapshots.'**
  String get badgeJourneyInfo;

  /// No description provided for @badgePlanner.
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get badgePlanner;

  /// No description provided for @badgePlannerInfo.
  ///
  /// In en, this message translates to:
  /// **'Complete 20 plan items.'**
  String get badgePlannerInfo;

  /// No description provided for @badgeHabits.
  ///
  /// In en, this message translates to:
  /// **'Habit builder'**
  String get badgeHabits;

  /// No description provided for @badgeHabitsInfo.
  ///
  /// In en, this message translates to:
  /// **'Complete habits 30 times.'**
  String get badgeHabitsInfo;

  /// No description provided for @badgeStylist.
  ///
  /// In en, this message translates to:
  /// **'Stylist'**
  String get badgeStylist;

  /// No description provided for @badgeStylistInfo.
  ///
  /// In en, this message translates to:
  /// **'Save 5 outfits.'**
  String get badgeStylistInfo;

  /// No description provided for @badgeLevel5.
  ///
  /// In en, this message translates to:
  /// **'Level 5'**
  String get badgeLevel5;

  /// No description provided for @badgeLevel5Info.
  ///
  /// In en, this message translates to:
  /// **'Reach level 5.'**
  String get badgeLevel5Info;

  /// No description provided for @badgeLevel10.
  ///
  /// In en, this message translates to:
  /// **'Level 10'**
  String get badgeLevel10;

  /// No description provided for @badgeLevel10Info.
  ///
  /// In en, this message translates to:
  /// **'Reach level 10.'**
  String get badgeLevel10Info;

  /// No description provided for @forYouTitle.
  ///
  /// In en, this message translates to:
  /// **'For you today'**
  String get forYouTitle;

  /// No description provided for @forYouSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Weekly snapshot'**
  String get forYouSnapshot;

  /// No description provided for @forYouSnapshotInfo.
  ///
  /// In en, this message translates to:
  /// **'Add a frame to your time-lapse'**
  String get forYouSnapshotInfo;

  /// No description provided for @forYouTryOn.
  ///
  /// In en, this message translates to:
  /// **'Try a new look'**
  String get forYouTryOn;

  /// No description provided for @forYouTryOnInfo.
  ///
  /// In en, this message translates to:
  /// **'Glasses and beards, live on you'**
  String get forYouTryOnInfo;

  /// No description provided for @forYouPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture check'**
  String get forYouPosture;

  /// No description provided for @forYouPostureInfo.
  ///
  /// In en, this message translates to:
  /// **'Two minutes, tips for you'**
  String get forYouPostureInfo;

  /// No description provided for @forYouColours.
  ///
  /// In en, this message translates to:
  /// **'Find your colours'**
  String get forYouColours;

  /// No description provided for @forYouColoursInfo.
  ///
  /// In en, this message translates to:
  /// **'A short quiz for your palette'**
  String get forYouColoursInfo;

  /// No description provided for @forYouOutfit.
  ///
  /// In en, this message translates to:
  /// **'Today\'s outfit'**
  String get forYouOutfit;

  /// No description provided for @forYouOutfitInfo.
  ///
  /// In en, this message translates to:
  /// **'Ideas from your wardrobe'**
  String get forYouOutfitInfo;

  /// No description provided for @forYouFace.
  ///
  /// In en, this message translates to:
  /// **'Face shape'**
  String get forYouFace;

  /// No description provided for @forYouFaceInfo.
  ///
  /// In en, this message translates to:
  /// **'Styles that suit you'**
  String get forYouFaceInfo;

  /// No description provided for @forYouExercise.
  ///
  /// In en, this message translates to:
  /// **'Move a little'**
  String get forYouExercise;

  /// No description provided for @forYouExerciseInfo.
  ///
  /// In en, this message translates to:
  /// **'Guided reps, counted live'**
  String get forYouExerciseInfo;

  /// No description provided for @forYouHairstyles.
  ///
  /// In en, this message translates to:
  /// **'Hairstyle ideas'**
  String get forYouHairstyles;

  /// No description provided for @forYouHairstylesInfo.
  ///
  /// In en, this message translates to:
  /// **'Picked for your face shape'**
  String get forYouHairstylesInfo;

  /// No description provided for @goalFinderTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your focus'**
  String get goalFinderTitle;

  /// No description provided for @goalFinderStep1.
  ///
  /// In en, this message translates to:
  /// **'What would you like to work on?'**
  String get goalFinderStep1;

  /// No description provided for @goalFinderStep1Hint.
  ///
  /// In en, this message translates to:
  /// **'Tap every image that speaks to you.'**
  String get goalFinderStep1Hint;

  /// No description provided for @goalFinderStep2.
  ///
  /// In en, this message translates to:
  /// **'Which looks feel like you?'**
  String get goalFinderStep2;

  /// No description provided for @goalFinderStep2Hint.
  ///
  /// In en, this message translates to:
  /// **'Pick as many as you like — this shapes your outfit ideas.'**
  String get goalFinderStep2Hint;

  /// No description provided for @goalFinderNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get goalFinderNext;

  /// No description provided for @goalFinderBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get goalFinderBack;

  /// No description provided for @goalFinderSave.
  ///
  /// In en, this message translates to:
  /// **'Save my focus'**
  String get goalFinderSave;

  /// No description provided for @goalFinderSaved.
  ///
  /// In en, this message translates to:
  /// **'Your focus is saved. Quests and suggestions now follow it.'**
  String get goalFinderSaved;

  /// No description provided for @goalFinderSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String goalFinderSelected(int count);

  /// No description provided for @forYouGoals.
  ///
  /// In en, this message translates to:
  /// **'What do you want?'**
  String get forYouGoals;

  /// No description provided for @forYouGoalsInfo.
  ///
  /// In en, this message translates to:
  /// **'Pick images that inspire you'**
  String get forYouGoalsInfo;

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @profileGenderHelp.
  ///
  /// In en, this message translates to:
  /// **'Used only for calorie estimates and to show relevant style examples.'**
  String get profileGenderHelp;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get genderNonBinary;

  /// No description provided for @genderPreferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNot;

  /// No description provided for @profileDiet.
  ///
  /// In en, this message translates to:
  /// **'Food preference'**
  String get profileDiet;

  /// No description provided for @dietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietVegetarian;

  /// No description provided for @dietEggetarian.
  ///
  /// In en, this message translates to:
  /// **'Eggetarian'**
  String get dietEggetarian;

  /// No description provided for @dietNonVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Non-vegetarian'**
  String get dietNonVegetarian;

  /// No description provided for @dietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @profileStyleFit.
  ///
  /// In en, this message translates to:
  /// **'Show style examples for'**
  String get profileStyleFit;

  /// No description provided for @styleFitAuto.
  ///
  /// In en, this message translates to:
  /// **'Match my gender'**
  String get styleFitAuto;

  /// No description provided for @styleFitMenswear.
  ///
  /// In en, this message translates to:
  /// **'Menswear'**
  String get styleFitMenswear;

  /// No description provided for @styleFitWomenswear.
  ///
  /// In en, this message translates to:
  /// **'Womenswear'**
  String get styleFitWomenswear;

  /// No description provided for @styleFitAll.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get styleFitAll;

  /// No description provided for @onboardingAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get onboardingAboutTitle;

  /// No description provided for @onboardingAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Everything here is optional and stays on this phone. It personalises your plans, quests and style suggestions.'**
  String get onboardingAboutBody;

  /// No description provided for @onboardingHeightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get onboardingHeightCm;

  /// No description provided for @onboardingHeightFt.
  ///
  /// In en, this message translates to:
  /// **'Height (ft)'**
  String get onboardingHeightFt;

  /// No description provided for @onboardingHeightIn.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get onboardingHeightIn;

  /// No description provided for @onboardingWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get onboardingWeightKg;

  /// No description provided for @onboardingWeightLb.
  ///
  /// In en, this message translates to:
  /// **'Weight (lb)'**
  String get onboardingWeightLb;

  /// No description provided for @onboardingInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check this value'**
  String get onboardingInvalid;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingNamed.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingNamed(String greeting, String name);

  /// No description provided for @homeCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Personalise your app'**
  String get homeCompleteProfile;

  /// No description provided for @homeCompleteProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Add your gender, height and weight for accurate plans and relevant styles.'**
  String get homeCompleteProfileInfo;

  /// No description provided for @forYouBodyPlan.
  ///
  /// In en, this message translates to:
  /// **'Your diet plan'**
  String get forYouBodyPlan;

  /// No description provided for @forYouBodyPlanInfo.
  ///
  /// In en, this message translates to:
  /// **'Meals and training for your goal'**
  String get forYouBodyPlanInfo;

  /// No description provided for @featureBodyPlan.
  ///
  /// In en, this message translates to:
  /// **'Diet & body plan'**
  String get featureBodyPlan;

  /// No description provided for @bodyPlanIntro.
  ///
  /// In en, this message translates to:
  /// **'Calorie and protein targets, daily meals and a simple training week, built from your height, weight and goal.'**
  String get bodyPlanIntro;

  /// No description provided for @bodyPlanNeedData.
  ///
  /// In en, this message translates to:
  /// **'Add your height and weight to create a plan.'**
  String get bodyPlanNeedData;

  /// No description provided for @bodyPlanImprove.
  ///
  /// In en, this message translates to:
  /// **'Add your gender, age range and activity level in Profile for a better estimate.'**
  String get bodyPlanImprove;

  /// No description provided for @bodyPlanOpenProfile.
  ///
  /// In en, this message translates to:
  /// **'Open profile'**
  String get bodyPlanOpenProfile;

  /// No description provided for @bodyPlanGoal.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get bodyPlanGoal;

  /// No description provided for @planLoseFat.
  ///
  /// In en, this message translates to:
  /// **'Lose fat'**
  String get planLoseFat;

  /// No description provided for @planMaintain.
  ///
  /// In en, this message translates to:
  /// **'Stay fit'**
  String get planMaintain;

  /// No description provided for @planGainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain weight'**
  String get planGainWeight;

  /// No description provided for @planBuildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build muscle'**
  String get planBuildMuscle;

  /// No description provided for @planLoseFatInfo.
  ///
  /// In en, this message translates to:
  /// **'A moderate calorie deficit with high protein'**
  String get planLoseFatInfo;

  /// No description provided for @planMaintainInfo.
  ///
  /// In en, this message translates to:
  /// **'Eat at maintenance and train regularly'**
  String get planMaintainInfo;

  /// No description provided for @planGainWeightInfo.
  ///
  /// In en, this message translates to:
  /// **'A steady surplus to gain healthy weight'**
  String get planGainWeightInfo;

  /// No description provided for @planBuildMuscleInfo.
  ///
  /// In en, this message translates to:
  /// **'A lean surplus with strength training'**
  String get planBuildMuscleInfo;

  /// No description provided for @planBlockUnderage.
  ///
  /// In en, this message translates to:
  /// **'Under 18: plan weight changes with a doctor. Maintenance guidance is available.'**
  String get planBlockUnderage;

  /// No description provided for @planBlockUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Your BMI is below 18.5, so fat loss isn\'t suggested.'**
  String get planBlockUnderweight;

  /// No description provided for @planBlockHeavy.
  ///
  /// In en, this message translates to:
  /// **'Your BMI is 25 or more. Try Build muscle instead.'**
  String get planBlockHeavy;

  /// No description provided for @bodyPlanPace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get bodyPlanPace;

  /// No description provided for @paceGentle.
  ///
  /// In en, this message translates to:
  /// **'Gentle'**
  String get paceGentle;

  /// No description provided for @paceSteady.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get paceSteady;

  /// No description provided for @paceBrisk.
  ///
  /// In en, this message translates to:
  /// **'Brisk'**
  String get paceBrisk;

  /// No description provided for @bodyPlanRate.
  ///
  /// In en, this message translates to:
  /// **'About {rate} per week'**
  String bodyPlanRate(String rate);

  /// No description provided for @bodyPlanTarget.
  ///
  /// In en, this message translates to:
  /// **'Target weight (optional)'**
  String get bodyPlanTarget;

  /// No description provided for @bodyPlanHealthyRange.
  ///
  /// In en, this message translates to:
  /// **'Healthy range for your height: {range}'**
  String bodyPlanHealthyRange(String range);

  /// No description provided for @bodyPlanCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get bodyPlanCalories;

  /// No description provided for @bodyPlanProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get bodyPlanProtein;

  /// No description provided for @bodyPlanCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get bodyPlanCarbs;

  /// No description provided for @bodyPlanFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get bodyPlanFat;

  /// No description provided for @bodyPlanWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get bodyPlanWater;

  /// No description provided for @bodyPlanKcal.
  ///
  /// In en, this message translates to:
  /// **'{value} kcal'**
  String bodyPlanKcal(int value);

  /// No description provided for @bodyPlanGrams.
  ///
  /// In en, this message translates to:
  /// **'{value} g'**
  String bodyPlanGrams(int value);

  /// No description provided for @bodyPlanMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance is about {kcal} kcal a day'**
  String bodyPlanMaintenance(int kcal);

  /// No description provided for @bodyPlanTimeline.
  ///
  /// In en, this message translates to:
  /// **'{weeks, plural, =1{About 1 week to your target} other{About {weeks} weeks to your target}}'**
  String bodyPlanTimeline(int weeks);

  /// No description provided for @bodyPlanFloorNote.
  ///
  /// In en, this message translates to:
  /// **'Kept at a safe minimum, so progress will be slower than this pace.'**
  String get bodyPlanFloorNote;

  /// No description provided for @bodyPlanStart.
  ///
  /// In en, this message translates to:
  /// **'Start my plan'**
  String get bodyPlanStart;

  /// No description provided for @bodyPlanStarted.
  ///
  /// In en, this message translates to:
  /// **'Your plan has started'**
  String get bodyPlanStarted;

  /// No description provided for @bodyPlanDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Estimates for healthy adults, not medical advice. If you have a medical condition, are pregnant or take medication, check with a doctor first.'**
  String get bodyPlanDisclaimer;

  /// No description provided for @bodyPlanSince.
  ///
  /// In en, this message translates to:
  /// **'Since {date}'**
  String bodyPlanSince(String date);

  /// No description provided for @bodyPlanToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s targets'**
  String get bodyPlanToday;

  /// No description provided for @bodyPlanEaten.
  ///
  /// In en, this message translates to:
  /// **'{eaten} of {target} kcal logged today'**
  String bodyPlanEaten(int eaten, int target);

  /// No description provided for @bodyPlanMenu.
  ///
  /// In en, this message translates to:
  /// **'Today\'s menu'**
  String get bodyPlanMenu;

  /// No description provided for @bodyPlanServings.
  ///
  /// In en, this message translates to:
  /// **'× {servings}'**
  String bodyPlanServings(String servings);

  /// No description provided for @bodyPlanProteinBoost.
  ///
  /// In en, this message translates to:
  /// **'Protein boost'**
  String get bodyPlanProteinBoost;

  /// No description provided for @bodyPlanLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get bodyPlanLog;

  /// No description provided for @bodyPlanLogged.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get bodyPlanLogged;

  /// No description provided for @bodyPlanSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get bodyPlanSwap;

  /// No description provided for @bodyPlanWeek.
  ///
  /// In en, this message translates to:
  /// **'This week\'s training'**
  String get bodyPlanWeek;

  /// No description provided for @workoutStrengthA.
  ///
  /// In en, this message translates to:
  /// **'Strength A'**
  String get workoutStrengthA;

  /// No description provided for @workoutStrengthB.
  ///
  /// In en, this message translates to:
  /// **'Strength B'**
  String get workoutStrengthB;

  /// No description provided for @workoutCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get workoutCardio;

  /// No description provided for @workoutMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get workoutMobility;

  /// No description provided for @workoutRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutRest;

  /// No description provided for @bodyPlanMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String bodyPlanMinutes(int minutes);

  /// No description provided for @bodyPlanTodayWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today: {workout}'**
  String bodyPlanTodayWorkout(String workout);

  /// No description provided for @bodyPlanAddRoutine.
  ///
  /// In en, this message translates to:
  /// **'Add workouts to my routines'**
  String get bodyPlanAddRoutine;

  /// No description provided for @bodyPlanRoutineAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to your routines'**
  String get bodyPlanRoutineAdded;

  /// No description provided for @bodyPlanRoutineName.
  ///
  /// In en, this message translates to:
  /// **'Training plan'**
  String get bodyPlanRoutineName;

  /// No description provided for @bodyPlanWorkoutItem.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get bodyPlanWorkoutItem;

  /// No description provided for @bodyPlanProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get bodyPlanProgress;

  /// No description provided for @bodyPlanWeightNow.
  ///
  /// In en, this message translates to:
  /// **'{now} now · started at {start}'**
  String bodyPlanWeightNow(String now, String start);

  /// No description provided for @bodyPlanExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected by now: {weight}'**
  String bodyPlanExpected(String weight);

  /// No description provided for @bodyPlanUpdate.
  ///
  /// In en, this message translates to:
  /// **'Your weight has changed. Update your targets?'**
  String get bodyPlanUpdate;

  /// No description provided for @bodyPlanUpdateAction.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get bodyPlanUpdateAction;

  /// No description provided for @bodyPlanEnd.
  ///
  /// In en, this message translates to:
  /// **'End plan'**
  String get bodyPlanEnd;

  /// No description provided for @bodyPlanEndConfirm.
  ///
  /// In en, this message translates to:
  /// **'End this plan? Your logged meals and workouts stay.'**
  String get bodyPlanEndConfirm;

  /// No description provided for @bodyPlanLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get bodyPlanLogWeight;

  /// No description provided for @bodyPlanChange.
  ///
  /// In en, this message translates to:
  /// **'Change plan'**
  String get bodyPlanChange;

  /// No description provided for @profileRegion.
  ///
  /// In en, this message translates to:
  /// **'Where are you based?'**
  String get profileRegion;

  /// No description provided for @profileRegionHelp.
  ///
  /// In en, this message translates to:
  /// **'Used to suggest local food, suitable exercise and climate tips.'**
  String get profileRegionHelp;

  /// No description provided for @regionIndiaNorth.
  ///
  /// In en, this message translates to:
  /// **'North India'**
  String get regionIndiaNorth;

  /// No description provided for @regionIndiaSouth.
  ///
  /// In en, this message translates to:
  /// **'South India'**
  String get regionIndiaSouth;

  /// No description provided for @regionIndiaEast.
  ///
  /// In en, this message translates to:
  /// **'East India'**
  String get regionIndiaEast;

  /// No description provided for @regionIndiaWest.
  ///
  /// In en, this message translates to:
  /// **'West India'**
  String get regionIndiaWest;

  /// No description provided for @regionSouthAsia.
  ///
  /// In en, this message translates to:
  /// **'Rest of South Asia'**
  String get regionSouthAsia;

  /// No description provided for @regionEastAsia.
  ///
  /// In en, this message translates to:
  /// **'East Asia'**
  String get regionEastAsia;

  /// No description provided for @regionSoutheastAsia.
  ///
  /// In en, this message translates to:
  /// **'Southeast Asia'**
  String get regionSoutheastAsia;

  /// No description provided for @regionMiddleEast.
  ///
  /// In en, this message translates to:
  /// **'Middle East'**
  String get regionMiddleEast;

  /// No description provided for @regionAfrica.
  ///
  /// In en, this message translates to:
  /// **'Africa'**
  String get regionAfrica;

  /// No description provided for @regionEurope.
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get regionEurope;

  /// No description provided for @regionNorthAmerica.
  ///
  /// In en, this message translates to:
  /// **'North America'**
  String get regionNorthAmerica;

  /// No description provided for @regionLatinAmerica.
  ///
  /// In en, this message translates to:
  /// **'Latin America'**
  String get regionLatinAmerica;

  /// No description provided for @regionOceania.
  ///
  /// In en, this message translates to:
  /// **'Oceania'**
  String get regionOceania;

  /// No description provided for @bodyPlanHotClimate.
  ///
  /// In en, this message translates to:
  /// **'Warm climate: train in the cooler morning or evening, and sip water through the day.'**
  String get bodyPlanHotClimate;

  /// No description provided for @bodyPlanLocalMenu.
  ///
  /// In en, this message translates to:
  /// **'Meals chosen from {region} cuisine where possible.'**
  String bodyPlanLocalMenu(String region);

  /// No description provided for @dailyPlan.
  ///
  /// In en, this message translates to:
  /// **'Daily plan'**
  String get dailyPlan;

  /// No description provided for @partMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get partMorning;

  /// No description provided for @partAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get partAfternoon;

  /// No description provided for @partEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get partEvening;

  /// No description provided for @partAnytime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get partAnytime;

  /// No description provided for @agendaWater.
  ///
  /// In en, this message translates to:
  /// **'Drink {target}'**
  String agendaWater(String target);

  /// No description provided for @agendaWorkout.
  ///
  /// In en, this message translates to:
  /// **'{workout} · {minutes} min'**
  String agendaWorkout(String workout, int minutes);

  /// No description provided for @agendaOptional.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 optional today} other{{count} optional today}}'**
  String agendaOptional(int count);

  /// No description provided for @agendaMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get agendaMissed;

  /// No description provided for @agendaReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get agendaReschedule;

  /// No description provided for @agendaSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip today'**
  String get agendaSkip;

  /// No description provided for @agendaDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get agendaDone;

  /// No description provided for @agendaUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get agendaUndo;

  /// No description provided for @agendaLookingBack.
  ///
  /// In en, this message translates to:
  /// **'Looking back at {date}'**
  String agendaLookingBack(String date);

  /// No description provided for @agendaEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned yet. Add a routine, habits or a diet plan to build your day.'**
  String get agendaEmpty;

  /// No description provided for @agendaProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String agendaProgress(int done, int total);

  /// No description provided for @dayModeTitle.
  ///
  /// In en, this message translates to:
  /// **'How\'s today?'**
  String get dayModeTitle;

  /// No description provided for @dayModeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get dayModeNormal;

  /// No description provided for @dayModeBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get dayModeBusy;

  /// No description provided for @dayModeLow.
  ///
  /// In en, this message translates to:
  /// **'Low energy'**
  String get dayModeLow;

  /// No description provided for @dayModeNormalInfo.
  ///
  /// In en, this message translates to:
  /// **'Your full plan.'**
  String get dayModeNormalInfo;

  /// No description provided for @dayModeBusyInfo.
  ///
  /// In en, this message translates to:
  /// **'Essentials only, with a 5-minute workout.'**
  String get dayModeBusyInfo;

  /// No description provided for @dayModeLowInfo.
  ///
  /// In en, this message translates to:
  /// **'Gentle mobility instead of training. Rest counts too.'**
  String get dayModeLowInfo;

  /// No description provided for @moodTitle.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get moodTitle;

  /// No description provided for @moodQuestion.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get moodQuestion;

  /// No description provided for @energyQuestion.
  ///
  /// In en, this message translates to:
  /// **'Energy level'**
  String get energyQuestion;

  /// No description provided for @mood1.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get mood1;

  /// No description provided for @mood2.
  ///
  /// In en, this message translates to:
  /// **'Meh'**
  String get mood2;

  /// No description provided for @mood3.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get mood3;

  /// No description provided for @mood4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get mood4;

  /// No description provided for @mood5.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get mood5;

  /// No description provided for @energy1.
  ///
  /// In en, this message translates to:
  /// **'Drained'**
  String get energy1;

  /// No description provided for @energy2.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get energy2;

  /// No description provided for @energy3.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get energy3;

  /// No description provided for @energy4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get energy4;

  /// No description provided for @energy5.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get energy5;

  /// No description provided for @moodSave.
  ///
  /// In en, this message translates to:
  /// **'Save check-in'**
  String get moodSave;

  /// No description provided for @moodSaved.
  ///
  /// In en, this message translates to:
  /// **'Thanks for checking in'**
  String get moodSaved;

  /// No description provided for @moodSuggestLow.
  ///
  /// In en, this message translates to:
  /// **'Energy is low today. Make it a low-energy day?'**
  String get moodSuggestLow;

  /// No description provided for @moodSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get moodSwitch;

  /// No description provided for @moodToday.
  ///
  /// In en, this message translates to:
  /// **'Today: {mood} · energy {energy}'**
  String moodToday(String mood, String energy);

  /// No description provided for @fiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Got 5 minutes?'**
  String get fiveTitle;

  /// No description provided for @fiveWater.
  ///
  /// In en, this message translates to:
  /// **'Drink a glass of water'**
  String get fiveWater;

  /// No description provided for @fiveWaterInfo.
  ///
  /// In en, this message translates to:
  /// **'You\'re a little behind on water for this time of day.'**
  String get fiveWaterInfo;

  /// No description provided for @fiveHabit.
  ///
  /// In en, this message translates to:
  /// **'Do it now: {habit}'**
  String fiveHabit(String habit);

  /// No description provided for @fiveHabitInfo.
  ///
  /// In en, this message translates to:
  /// **'One habit, ticked off in a few minutes.'**
  String get fiveHabitInfo;

  /// No description provided for @fiveMobility.
  ///
  /// In en, this message translates to:
  /// **'5-minute mobility'**
  String get fiveMobility;

  /// No description provided for @fiveMobilityInfo.
  ///
  /// In en, this message translates to:
  /// **'Neck, shoulders and posture: a quick reset.'**
  String get fiveMobilityInfo;

  /// No description provided for @fiveOutfit.
  ///
  /// In en, this message translates to:
  /// **'Plan tomorrow\'s outfit'**
  String get fiveOutfit;

  /// No description provided for @fiveOutfitInfo.
  ///
  /// In en, this message translates to:
  /// **'Choose it tonight, decide less tomorrow.'**
  String get fiveOutfitInfo;

  /// No description provided for @fivePosture.
  ///
  /// In en, this message translates to:
  /// **'Quick posture check'**
  String get fivePosture;

  /// No description provided for @fivePostureInfo.
  ///
  /// In en, this message translates to:
  /// **'Two minutes with the camera, tips for you.'**
  String get fivePostureInfo;

  /// No description provided for @fiveDo.
  ///
  /// In en, this message translates to:
  /// **'Do it'**
  String get fiveDo;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick add'**
  String get quickAdd;

  /// No description provided for @quickWater.
  ///
  /// In en, this message translates to:
  /// **'+{ml} ml water'**
  String quickWater(int ml);

  /// No description provided for @quickMeal.
  ///
  /// In en, this message translates to:
  /// **'Log a meal'**
  String get quickMeal;

  /// No description provided for @quickWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get quickWeight;

  /// No description provided for @quickSleep.
  ///
  /// In en, this message translates to:
  /// **'Log sleep'**
  String get quickSleep;

  /// No description provided for @quickMood.
  ///
  /// In en, this message translates to:
  /// **'Mood check-in'**
  String get quickMood;

  /// No description provided for @quickAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get quickAdded;

  /// No description provided for @remindersQuiet.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get remindersQuiet;

  /// No description provided for @remindersQuietInfo.
  ///
  /// In en, this message translates to:
  /// **'No reminders from {start} to {end}. Items stay in your plan.'**
  String remindersQuietInfo(String start, String end);

  /// No description provided for @remindersQuietOff.
  ///
  /// In en, this message translates to:
  /// **'Off: reminders can arrive at any time.'**
  String get remindersQuietOff;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @insightsIntro.
  ///
  /// In en, this message translates to:
  /// **'Plan versus what actually happened. Days without records show as no data, never as misses.'**
  String get insightsIntro;

  /// No description provided for @insightsHomeInfo.
  ///
  /// In en, this message translates to:
  /// **'Plan versus actual, sleep score and trends'**
  String get insightsHomeInfo;

  /// No description provided for @rangeWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get rangeWeek;

  /// No description provided for @rangeMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get rangeMonth;

  /// No description provided for @metricPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan items'**
  String get metricPlan;

  /// No description provided for @metricHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get metricHabits;

  /// No description provided for @metricWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get metricWater;

  /// No description provided for @metricSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get metricSleep;

  /// No description provided for @metricActivity.
  ///
  /// In en, this message translates to:
  /// **'Active minutes'**
  String get metricActivity;

  /// No description provided for @metricMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals logged'**
  String get metricMeals;

  /// No description provided for @metricMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get metricMood;

  /// No description provided for @insightsMet.
  ///
  /// In en, this message translates to:
  /// **'Met on {met} of {logged} logged days'**
  String insightsMet(int met, int logged);

  /// No description provided for @insightsLogged.
  ///
  /// In en, this message translates to:
  /// **'Logged on {logged} days'**
  String insightsLogged(int logged);

  /// No description provided for @insightsNoData.
  ///
  /// In en, this message translates to:
  /// **'No records in this period yet.'**
  String get insightsNoData;

  /// No description provided for @insightsAverage.
  ///
  /// In en, this message translates to:
  /// **'Average {value}'**
  String insightsAverage(String value);

  /// No description provided for @insightsUp.
  ///
  /// In en, this message translates to:
  /// **'Up {value} vs previous {period}'**
  String insightsUp(String value, String period);

  /// No description provided for @insightsDown.
  ///
  /// In en, this message translates to:
  /// **'Down {value} vs previous {period}'**
  String insightsDown(String value, String period);

  /// No description provided for @insightsSame.
  ///
  /// In en, this message translates to:
  /// **'Same as previous {period}'**
  String insightsSame(String period);

  /// No description provided for @insightsPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get insightsPeriodWeek;

  /// No description provided for @insightsPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get insightsPeriodMonth;

  /// No description provided for @legendMet.
  ///
  /// In en, this message translates to:
  /// **'Met'**
  String get legendMet;

  /// No description provided for @legendPartial.
  ///
  /// In en, this message translates to:
  /// **'Partly'**
  String get legendPartial;

  /// No description provided for @legendMissed.
  ///
  /// In en, this message translates to:
  /// **'Not met'**
  String get legendMissed;

  /// No description provided for @legendNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get legendNoData;

  /// No description provided for @sleepScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep score'**
  String get sleepScoreTitle;

  /// No description provided for @sleepScoreInfo.
  ///
  /// In en, this message translates to:
  /// **'From your logged bed and wake times over the last 7 nights: duration (70 points) and regular bedtimes (30). No sleep stages; those need a wearable.'**
  String get sleepScoreInfo;

  /// No description provided for @sleepAverage.
  ///
  /// In en, this message translates to:
  /// **'{value} a night on average'**
  String sleepAverage(String value);

  /// No description provided for @sleepSpread.
  ///
  /// In en, this message translates to:
  /// **'Bedtime varies by about {minutes} min'**
  String sleepSpread(int minutes);

  /// No description provided for @sleepNights.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 night logged} other{{count} nights logged}}'**
  String sleepNights(int count);

  /// No description provided for @sleepExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get sleepExcellent;

  /// No description provided for @sleepGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get sleepGood;

  /// No description provided for @sleepFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get sleepFair;

  /// No description provided for @sleepCare.
  ///
  /// In en, this message translates to:
  /// **'Needs care'**
  String get sleepCare;

  /// No description provided for @sleepScoreEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log a few nights of sleep to see your score.'**
  String get sleepScoreEmpty;

  /// No description provided for @evolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Evolution'**
  String get evolutionTitle;

  /// No description provided for @evolutionIntro.
  ///
  /// In en, this message translates to:
  /// **'Moments along your way, from what you\'ve done. Add your own notes too.'**
  String get evolutionIntro;

  /// No description provided for @evolutionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your milestones will appear here as you use the app.'**
  String get evolutionEmpty;

  /// No description provided for @evolutionAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get evolutionAddNote;

  /// No description provided for @evolutionNoteHint.
  ///
  /// In en, this message translates to:
  /// **'What changed, how you feel…'**
  String get evolutionNoteHint;

  /// No description provided for @evolutionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get evolutionSeeAll;

  /// No description provided for @msFirstStep.
  ///
  /// In en, this message translates to:
  /// **'First step: you logged something'**
  String get msFirstStep;

  /// No description provided for @msFirstPosture.
  ///
  /// In en, this message translates to:
  /// **'First posture check'**
  String get msFirstPosture;

  /// No description provided for @msFirstFace.
  ///
  /// In en, this message translates to:
  /// **'First face analysis'**
  String get msFirstFace;

  /// No description provided for @msFirstSnapshot.
  ///
  /// In en, this message translates to:
  /// **'First progress snapshot'**
  String get msFirstSnapshot;

  /// No description provided for @msFirstOutfit.
  ///
  /// In en, this message translates to:
  /// **'First outfit saved'**
  String get msFirstOutfit;

  /// No description provided for @msPlanStarted.
  ///
  /// In en, this message translates to:
  /// **'Started a plan: {plan}'**
  String msPlanStarted(String plan);

  /// No description provided for @msStreak7.
  ///
  /// In en, this message translates to:
  /// **'Reached a 7-day streak'**
  String get msStreak7;

  /// No description provided for @msStreak30.
  ///
  /// In en, this message translates to:
  /// **'Reached a 30-day streak'**
  String get msStreak30;

  /// No description provided for @msHabits30.
  ///
  /// In en, this message translates to:
  /// **'30 habits completed'**
  String get msHabits30;

  /// No description provided for @msWeightDown.
  ///
  /// In en, this message translates to:
  /// **'{value} down since your first weigh-in'**
  String msWeightDown(String value);

  /// No description provided for @msWeightUp.
  ///
  /// In en, this message translates to:
  /// **'{value} up since your first weigh-in'**
  String msWeightUp(String value);

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Your week'**
  String get reviewTitle;

  /// No description provided for @reviewWeekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String reviewWeekOf(String date);

  /// No description provided for @reviewActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active day} other{{count} active days}}'**
  String reviewActive(int count);

  /// No description provided for @reviewWater.
  ///
  /// In en, this message translates to:
  /// **'Water target met on {met} days'**
  String reviewWater(int met);

  /// No description provided for @reviewSleep.
  ///
  /// In en, this message translates to:
  /// **'Average sleep {value}'**
  String reviewSleep(String value);

  /// No description provided for @reviewActivity.
  ///
  /// In en, this message translates to:
  /// **'Active on {count} days'**
  String reviewActivity(int count);

  /// No description provided for @reviewBest.
  ///
  /// In en, this message translates to:
  /// **'Best day: {day}'**
  String reviewBest(String day);

  /// No description provided for @reviewTipPlan.
  ///
  /// In en, this message translates to:
  /// **'Next week: move plan items to times that suit your day better.'**
  String get reviewTipPlan;

  /// No description provided for @reviewTipHabits.
  ///
  /// In en, this message translates to:
  /// **'Next week: keep habits small. One you never miss beats three you skip.'**
  String get reviewTipHabits;

  /// No description provided for @reviewTipWater.
  ///
  /// In en, this message translates to:
  /// **'Next week: keep a bottle in sight and add a glass with each meal.'**
  String get reviewTipWater;

  /// No description provided for @reviewTipSleep.
  ///
  /// In en, this message translates to:
  /// **'Next week: aim for a regular bedtime, even on weekends.'**
  String get reviewTipSleep;

  /// No description provided for @reviewTipActivity.
  ///
  /// In en, this message translates to:
  /// **'Next week: a 10-minute walk after a meal counts.'**
  String get reviewTipActivity;

  /// No description provided for @reviewTipMeals.
  ///
  /// In en, this message translates to:
  /// **'Next week: logging meals helps your plan fit you better.'**
  String get reviewTipMeals;

  /// No description provided for @reviewTipKeep.
  ///
  /// In en, this message translates to:
  /// **'Next week: keep the rhythm you\'ve built.'**
  String get reviewTipKeep;

  /// No description provided for @reviewClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get reviewClose;

  /// No description provided for @reviewSeeInsights.
  ///
  /// In en, this message translates to:
  /// **'See insights'**
  String get reviewSeeInsights;

  /// No description provided for @postureCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get postureCompare;

  /// No description provided for @postureCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare sessions'**
  String get postureCompareTitle;

  /// No description provided for @postureCompareSetup.
  ///
  /// In en, this message translates to:
  /// **'For a fair comparison use the same setup: same spot and distance, similar light, fitted clothes and a similar time of day.'**
  String get postureCompareSetup;

  /// No description provided for @postureCompareEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get postureCompareEarlier;

  /// No description provided for @postureCompareLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get postureCompareLater;

  /// No description provided for @postureCompareChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get postureCompareChange;

  /// No description provided for @postureCompareNeedTwo.
  ///
  /// In en, this message translates to:
  /// **'Save two checks from the same view to compare them.'**
  String get postureCompareNeedTwo;

  /// No description provided for @connectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Connected data'**
  String get connectedTitle;

  /// No description provided for @connectedIntro.
  ///
  /// In en, this message translates to:
  /// **'Track steps, walks, runs and sleep from this phone\'s own sensors. Everything stays on this device: no account, no cloud, nothing uploaded.'**
  String get connectedIntro;

  /// No description provided for @connectedPhoneSensors.
  ///
  /// In en, this message translates to:
  /// **'This phone\'s sensors'**
  String get connectedPhoneSensors;

  /// No description provided for @connectedSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get connectedSteps;

  /// No description provided for @connectedStepsInfo.
  ///
  /// In en, this message translates to:
  /// **'Counted by the phone\'s step sensor, checked every 15 minutes.'**
  String get connectedStepsInfo;

  /// No description provided for @connectedActivity.
  ///
  /// In en, this message translates to:
  /// **'Walks, runs and rides'**
  String get connectedActivity;

  /// No description provided for @connectedActivityInfo.
  ///
  /// In en, this message translates to:
  /// **'Detected on the phone when you move for 10 minutes or more.'**
  String get connectedActivityInfo;

  /// No description provided for @connectedSleep.
  ///
  /// In en, this message translates to:
  /// **'Bed and wake times'**
  String get connectedSleep;

  /// No description provided for @connectedSleepInfo.
  ///
  /// In en, this message translates to:
  /// **'Estimated by the phone overnight. You can edit or delete any night.'**
  String get connectedSleepInfo;

  /// No description provided for @connectedNoSensor.
  ///
  /// In en, this message translates to:
  /// **'This phone has no step sensor.'**
  String get connectedNoSensor;

  /// No description provided for @connectedNoPlay.
  ///
  /// In en, this message translates to:
  /// **'Walk and sleep detection needs Google Play services on this phone.'**
  String get connectedNoPlay;

  /// No description provided for @connectedPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow \"Physical activity\" so the phone can count steps and movement.'**
  String get connectedPermission;

  /// No description provided for @connectedAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get connectedAllow;

  /// No description provided for @connectedHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'Health Connect'**
  String get connectedHealthConnect;

  /// No description provided for @connectedHcInfo.
  ///
  /// In en, this message translates to:
  /// **'Android\'s on-device health store is on this phone. Read steps, workouts, sleep, weight, height and water that other apps saved there, without any account.'**
  String get connectedHcInfo;

  /// No description provided for @connectedHcAbsent.
  ///
  /// In en, this message translates to:
  /// **'Health Connect isn\'t on this phone. That\'s fine: the phone\'s own sensors cover steps, walks and sleep.'**
  String get connectedHcAbsent;

  /// No description provided for @connectedHcConnect.
  ///
  /// In en, this message translates to:
  /// **'Choose what to read'**
  String get connectedHcConnect;

  /// No description provided for @connectedSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get connectedSyncNow;

  /// No description provided for @connectedLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String connectedLastSync(String time);

  /// No description provided for @connectedNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get connectedNeverSynced;

  /// No description provided for @connectedSynced.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Up to date} =1{1 item updated} other{{count} items updated}}'**
  String connectedSynced(int count);

  /// No description provided for @connectedRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove imported data'**
  String get connectedRemove;

  /// No description provided for @connectedRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove everything imported from this source? Your own entries stay.'**
  String get connectedRemoveConfirm;

  /// No description provided for @connectedRemoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item removed} other{{count} items removed}}'**
  String connectedRemoved(int count);

  /// No description provided for @connectedPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Read only and on this device. Steps from several sources never add up twice: the larger daily total is used.'**
  String get connectedPrivacy;

  /// No description provided for @sourcePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone sensor'**
  String get sourcePhone;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & export'**
  String get backupTitle;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Move to a new phone, keep a safe copy, or open your data elsewhere'**
  String get backupSubtitle;

  /// No description provided for @backupIntro.
  ///
  /// In en, this message translates to:
  /// **'There\'s no account and no cloud, so your data lives only on this phone. Make a backup file and keep it somewhere safe, or send it to your other phone.'**
  String get backupIntro;

  /// No description provided for @backupEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup'**
  String get backupEncrypted;

  /// No description provided for @backupEncryptedInfo.
  ///
  /// In en, this message translates to:
  /// **'Everything in the app, locked with a password you set. Restore it on any phone with Personality.'**
  String get backupEncryptedInfo;

  /// No description provided for @backupIncludePhotos.
  ///
  /// In en, this message translates to:
  /// **'Include progress photos'**
  String get backupIncludePhotos;

  /// No description provided for @backupIncludePhotosInfo.
  ///
  /// In en, this message translates to:
  /// **'Makes the file larger.'**
  String get backupIncludePhotosInfo;

  /// No description provided for @backupSaveFile.
  ///
  /// In en, this message translates to:
  /// **'Save to file'**
  String get backupSaveFile;

  /// No description provided for @backupShare.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get backupShare;

  /// No description provided for @backupNever.
  ///
  /// In en, this message translates to:
  /// **'No backup made on this phone yet'**
  String get backupNever;

  /// No description provided for @backupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup {time}'**
  String backupLast(String time);

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get backupSaved;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'That didn\'t work. Please try again.'**
  String get backupFailed;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore a backup'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreInfo.
  ///
  /// In en, this message translates to:
  /// **'Open a .personality file from your other phone, a drive or a chat.'**
  String get backupRestoreInfo;

  /// No description provided for @backupChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose backup file'**
  String get backupChooseFile;

  /// No description provided for @backupExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export for other apps'**
  String get backupExportTitle;

  /// No description provided for @backupExportInfo.
  ///
  /// In en, this message translates to:
  /// **'Readable copies to open in a spreadsheet or another app. Not encrypted and without photos.'**
  String get backupExportInfo;

  /// No description provided for @backupCsv.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet (CSV)'**
  String get backupCsv;

  /// No description provided for @backupCsvInfo.
  ///
  /// In en, this message translates to:
  /// **'A zip with one table per kind of record'**
  String get backupCsvInfo;

  /// No description provided for @backupJson.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get backupJson;

  /// No description provided for @backupJsonInfo.
  ///
  /// In en, this message translates to:
  /// **'Everything in one file, for developers'**
  String get backupJsonInfo;

  /// No description provided for @backupPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Files go only where you send them. Without the password a backup can\'t be read by anyone, including us, and a lost password can\'t be recovered.'**
  String get backupPrivacy;

  /// No description provided for @backupPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get backupPassphrase;

  /// No description provided for @backupPassphraseAgain.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get backupPassphraseAgain;

  /// No description provided for @backupPassphraseCreate.
  ///
  /// In en, this message translates to:
  /// **'Set a password for your data'**
  String get backupPassphraseCreate;

  /// No description provided for @backupPassphraseEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter the backup\'s password'**
  String get backupPassphraseEnter;

  /// No description provided for @backupPassphraseWarning.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need it to restore. Write it down: it can\'t be reset.'**
  String get backupPassphraseWarning;

  /// No description provided for @backupPassphraseShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get backupPassphraseShort;

  /// No description provided for @backupPassphraseMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords don\'t match'**
  String get backupPassphraseMismatch;

  /// No description provided for @backupShowPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get backupShowPassphrase;

  /// No description provided for @backupContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get backupContinue;

  /// No description provided for @backupFound.
  ///
  /// In en, this message translates to:
  /// **'Backup from {date}: {records} records, {photos} photos.'**
  String backupFound(String date, int records, int photos);

  /// No description provided for @backupMergeInfo.
  ///
  /// In en, this message translates to:
  /// **'Add: keeps what\'s on this phone and adds anything missing.'**
  String get backupMergeInfo;

  /// No description provided for @backupReplaceInfo.
  ///
  /// In en, this message translates to:
  /// **'Replace: this phone\'s data is swapped for the backup.'**
  String get backupReplaceInfo;

  /// No description provided for @backupMerge.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get backupMerge;

  /// No description provided for @backupReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get backupReplace;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Restored 1 record} other{Restored {count} records}}'**
  String backupRestored(int count);

  /// No description provided for @backupErrorNotBackup.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Personality backup file.'**
  String get backupErrorNotBackup;

  /// No description provided for @backupErrorDamaged.
  ///
  /// In en, this message translates to:
  /// **'The backup file is damaged or incomplete.'**
  String get backupErrorDamaged;

  /// No description provided for @backupErrorPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Wrong password.'**
  String get backupErrorPassphrase;

  /// No description provided for @backupErrorTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version. Update the app, then try again.'**
  String get backupErrorTooNew;

  /// No description provided for @exMartialArts.
  ///
  /// In en, this message translates to:
  /// **'Martial arts'**
  String get exMartialArts;

  /// No description provided for @exFace.
  ///
  /// In en, this message translates to:
  /// **'Face & jaw'**
  String get exFace;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @exerciseSearch.
  ///
  /// In en, this message translates to:
  /// **'Search exercises, muscles or equipment'**
  String get exerciseSearch;

  /// No description provided for @filterNoEquipment.
  ///
  /// In en, this message translates to:
  /// **'No equipment'**
  String get filterNoEquipment;

  /// No description provided for @exerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String exerciseCount(int count);

  /// No description provided for @exerciseAlsoWorks.
  ///
  /// In en, this message translates to:
  /// **'Also works: {muscles}'**
  String exerciseAlsoWorks(String muscles);

  /// No description provided for @workoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Guided workouts'**
  String get workoutsTitle;

  /// No description provided for @workoutsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow along with a timer and moving figure'**
  String get workoutsSubtitle;

  /// No description provided for @workoutsMore.
  ///
  /// In en, this message translates to:
  /// **'Get more workouts'**
  String get workoutsMore;

  /// No description provided for @workoutMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String workoutMinutes(int count);

  /// No description provided for @workoutRounds.
  ///
  /// In en, this message translates to:
  /// **'{count} rounds'**
  String workoutRounds(int count);

  /// No description provided for @workoutSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count} s'**
  String workoutSeconds(int count);

  /// No description provided for @workoutReps.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String workoutReps(int count);

  /// No description provided for @workoutEachSide.
  ///
  /// In en, this message translates to:
  /// **'each side'**
  String get workoutEachSide;

  /// No description provided for @workoutStart.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get workoutStart;

  /// No description provided for @workoutGetReady.
  ///
  /// In en, this message translates to:
  /// **'Get ready'**
  String get workoutGetReady;

  /// No description provided for @workoutRoundOf.
  ///
  /// In en, this message translates to:
  /// **'Round {round} of {total}'**
  String workoutRoundOf(int round, int total);

  /// No description provided for @workoutSide.
  ///
  /// In en, this message translates to:
  /// **'Side {side} of 2'**
  String workoutSide(int side);

  /// No description provided for @workoutUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up next: {name}'**
  String workoutUpNext(String name);

  /// No description provided for @workoutPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get workoutPrevious;

  /// No description provided for @workoutPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get workoutPause;

  /// No description provided for @workoutResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get workoutResume;

  /// No description provided for @workoutSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get workoutSkip;

  /// No description provided for @workoutDone.
  ///
  /// In en, this message translates to:
  /// **'Workout complete. Well done!'**
  String get workoutDone;

  /// No description provided for @workoutDoneMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute of movement} other{{count} minutes of movement}}'**
  String workoutDoneMinutes(int count);

  /// No description provided for @contentTitle.
  ///
  /// In en, this message translates to:
  /// **'Content packs'**
  String get contentTitle;

  /// No description provided for @contentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download more exercises, illustrations and routines'**
  String get contentSubtitle;

  /// No description provided for @contentGetMore.
  ///
  /// In en, this message translates to:
  /// **'Get more exercises'**
  String get contentGetMore;

  /// No description provided for @contentGetMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'1,500+ exercises, illustrations, yoga, martial arts and face & jaw routines. Free, download only what you need.'**
  String get contentGetMoreInfo;

  /// No description provided for @contentIntro.
  ///
  /// In en, this message translates to:
  /// **'Packs are free and optional. Download only what you need; once on your phone they work offline, and you can remove them any time.'**
  String get contentIntro;

  /// No description provided for @contentWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Download over Wi-Fi only'**
  String get contentWifiOnly;

  /// No description provided for @contentDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get contentDownload;

  /// No description provided for @contentUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get contentUpdate;

  /// No description provided for @contentRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get contentRemove;

  /// No description provided for @contentOnPhone.
  ///
  /// In en, this message translates to:
  /// **'On this phone'**
  String get contentOnPhone;

  /// No description provided for @contentInstalled.
  ///
  /// In en, this message translates to:
  /// **'Pack ready to use'**
  String get contentInstalled;

  /// No description provided for @contentRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from this phone? You can download it again later.'**
  String contentRemoveConfirm(String name);

  /// No description provided for @contentOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Connect to the internet to see packs.'**
  String get contentOffline;

  /// No description provided for @contentWifiNeeded.
  ///
  /// In en, this message translates to:
  /// **'Connect to Wi-Fi, or turn off \"Wi-Fi only\".'**
  String get contentWifiNeeded;

  /// No description provided for @contentDamaged.
  ///
  /// In en, this message translates to:
  /// **'The download didn\'t check out, so it wasn\'t used. Please try again.'**
  String get contentDamaged;

  /// No description provided for @contentFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download right now. Please try again.'**
  String get contentFailed;

  /// No description provided for @contentRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get contentRetry;

  /// No description provided for @contentPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Packs come only from Personality\'s official content library and are checked before use. Downloading never sends anything about you, and your health data never uses the internet.'**
  String get contentPrivacy;

  /// No description provided for @navGrowth.
  ///
  /// In en, this message translates to:
  /// **'My Growth'**
  String get navGrowth;

  /// No description provided for @growthSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search exercises, techniques and tips'**
  String get growthSearchHint;

  /// No description provided for @growthProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get growthProgress;

  /// No description provided for @growthCoachSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon: a private, on-device coach.'**
  String get growthCoachSoon;

  /// No description provided for @profileMenu.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get profileMenu;

  /// No description provided for @blueprintTitle.
  ///
  /// In en, this message translates to:
  /// **'Your blueprint'**
  String get blueprintTitle;

  /// No description provided for @blueprintIntro.
  ///
  /// In en, this message translates to:
  /// **'Each area on its own, with no single score. Just what\'s going well and the next small step.'**
  String get blueprintIntro;

  /// No description provided for @blueprintNextStep.
  ///
  /// In en, this message translates to:
  /// **'Your next step'**
  String get blueprintNextStep;

  /// No description provided for @blueprintGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get blueprintGo;

  /// No description provided for @blueprintFocus.
  ///
  /// In en, this message translates to:
  /// **'Your focus'**
  String get blueprintFocus;

  /// No description provided for @blueprintExplore.
  ///
  /// In en, this message translates to:
  /// **'More areas'**
  String get blueprintExplore;

  /// No description provided for @blueprintPickGoals.
  ///
  /// In en, this message translates to:
  /// **'Pick your goals to shape your blueprint'**
  String get blueprintPickGoals;

  /// No description provided for @blueprintNoData.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get blueprintNoData;

  /// No description provided for @blueprintDaysMet.
  ///
  /// In en, this message translates to:
  /// **'{count} of 7 days'**
  String blueprintDaysMet(int count);

  /// No description provided for @blueprintPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% this fortnight'**
  String blueprintPercent(int percent);

  /// No description provided for @areaBody.
  ///
  /// In en, this message translates to:
  /// **'Body & weight'**
  String get areaBody;

  /// No description provided for @areaFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get areaFitness;

  /// No description provided for @areaPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get areaPosture;

  /// No description provided for @areaSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get areaSleep;

  /// No description provided for @areaHydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get areaHydration;

  /// No description provided for @areaHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get areaHabits;

  /// No description provided for @areaStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get areaStyle;

  /// No description provided for @areaGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get areaGrooming;

  /// No description provided for @areaSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills & martial arts'**
  String get areaSkills;

  /// No description provided for @actSetBodyPlan.
  ///
  /// In en, this message translates to:
  /// **'Set up your body plan'**
  String get actSetBodyPlan;

  /// No description provided for @actLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log your weight'**
  String get actLogWeight;

  /// No description provided for @actStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start a guided workout'**
  String get actStartWorkout;

  /// No description provided for @actCheckPosture.
  ///
  /// In en, this message translates to:
  /// **'Check your posture'**
  String get actCheckPosture;

  /// No description provided for @actLogSleep.
  ///
  /// In en, this message translates to:
  /// **'Log last night\'s sleep'**
  String get actLogSleep;

  /// No description provided for @actAddWater.
  ///
  /// In en, this message translates to:
  /// **'Have a glass of water'**
  String get actAddWater;

  /// No description provided for @actDoHabits.
  ///
  /// In en, this message translates to:
  /// **'Tick off today\'s habits'**
  String get actDoHabits;

  /// No description provided for @actAddClothes.
  ///
  /// In en, this message translates to:
  /// **'Add clothes to your wardrobe'**
  String get actAddClothes;

  /// No description provided for @actBuildOutfit.
  ///
  /// In en, this message translates to:
  /// **'Put together an outfit'**
  String get actBuildOutfit;

  /// No description provided for @actTakeSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Take this week\'s snapshot'**
  String get actTakeSnapshot;

  /// No description provided for @actPractiseSkill.
  ///
  /// In en, this message translates to:
  /// **'Practise a martial art'**
  String get actPractiseSkill;

  /// No description provided for @whyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why am I seeing this?'**
  String get whyTitle;

  /// No description provided for @whyBenefit.
  ///
  /// In en, this message translates to:
  /// **'What it helps with'**
  String get whyBenefit;

  /// No description provided for @whyAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Other ways'**
  String get whyAlternatives;

  /// No description provided for @whyYourGoal.
  ///
  /// In en, this message translates to:
  /// **'You chose this as one of your goals, and there\'s nothing recorded yet. One small start is enough.'**
  String get whyYourGoal;

  /// No description provided for @whyNoRecords.
  ///
  /// In en, this message translates to:
  /// **'There\'s nothing recorded here yet, so it\'s an easy place to start if it interests you.'**
  String get whyNoRecords;

  /// No description provided for @whyOnTrack.
  ///
  /// In en, this message translates to:
  /// **'You\'re on track this week. Keep the rhythm going.'**
  String get whyOnTrack;

  /// No description provided for @whyPartly.
  ///
  /// In en, this message translates to:
  /// **'You\'re part of the way there this week.'**
  String get whyPartly;

  /// No description provided for @whyBehind.
  ///
  /// In en, this message translates to:
  /// **'This area has had less attention lately. One small step brings it back.'**
  String get whyBehind;

  /// No description provided for @benefitBody.
  ///
  /// In en, this message translates to:
  /// **'Regular weigh-ins show the real trend, so daily ups and downs stop worrying you.'**
  String get benefitBody;

  /// No description provided for @benefitFitness.
  ///
  /// In en, this message translates to:
  /// **'Moving most days lifts energy, mood and sleep.'**
  String get benefitFitness;

  /// No description provided for @benefitPosture.
  ///
  /// In en, this message translates to:
  /// **'A quick check now and then keeps neck and back strain from building up.'**
  String get benefitPosture;

  /// No description provided for @benefitSleep.
  ///
  /// In en, this message translates to:
  /// **'Steady sleep helps focus, appetite and recovery.'**
  String get benefitSleep;

  /// No description provided for @benefitHydration.
  ///
  /// In en, this message translates to:
  /// **'Enough water helps energy, skin and concentration.'**
  String get benefitHydration;

  /// No description provided for @benefitHabits.
  ///
  /// In en, this message translates to:
  /// **'Small daily habits add up to the biggest changes.'**
  String get benefitHabits;

  /// No description provided for @benefitStyle.
  ///
  /// In en, this message translates to:
  /// **'Knowing what you own makes getting ready faster and more confident.'**
  String get benefitStyle;

  /// No description provided for @benefitGrooming.
  ///
  /// In en, this message translates to:
  /// **'A weekly photo shows how routines change things over time.'**
  String get benefitGrooming;

  /// No description provided for @benefitSkills.
  ///
  /// In en, this message translates to:
  /// **'Martial arts build fitness, balance, focus and confidence together.'**
  String get benefitSkills;

  /// No description provided for @altBody.
  ///
  /// In en, this message translates to:
  /// **'Track measurements instead of weight, or follow your diet and body plan.'**
  String get altBody;

  /// No description provided for @altFitness.
  ///
  /// In en, this message translates to:
  /// **'A brisk walk, a yoga routine, or a martial arts drill all count.'**
  String get altFitness;

  /// No description provided for @altPosture.
  ///
  /// In en, this message translates to:
  /// **'Do the Desk reset workout, or set a posture reminder.'**
  String get altPosture;

  /// No description provided for @altSleep.
  ///
  /// In en, this message translates to:
  /// **'Try the Wind down workout, or set a bedtime reminder.'**
  String get altSleep;

  /// No description provided for @altHydration.
  ///
  /// In en, this message translates to:
  /// **'Set water reminders, or keep a bottle within reach.'**
  String get altHydration;

  /// No description provided for @altHabits.
  ///
  /// In en, this message translates to:
  /// **'Start with one tiny habit, or use a ready-made routine.'**
  String get altHabits;

  /// No description provided for @altStyle.
  ///
  /// In en, this message translates to:
  /// **'Find your colours, or browse looks that suit you.'**
  String get altStyle;

  /// No description provided for @altGrooming.
  ///
  /// In en, this message translates to:
  /// **'Check your face shape for hairstyle ideas.'**
  String get altGrooming;

  /// No description provided for @altSkills.
  ///
  /// In en, this message translates to:
  /// **'Start with Kalaripayattu leg swings, Kushti dand-baithak or boxing basics.'**
  String get altSkills;

  /// No description provided for @skillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills & martial arts'**
  String get skillsTitle;

  /// No description provided for @skillsIntro.
  ///
  /// In en, this message translates to:
  /// **'Yoga, Indian and world martial arts, each with its own techniques, drills and tips.'**
  String get skillsIntro;

  /// No description provided for @skillsIndian.
  ///
  /// In en, this message translates to:
  /// **'Indian martial arts'**
  String get skillsIndian;

  /// No description provided for @skillsWorld.
  ///
  /// In en, this message translates to:
  /// **'World martial arts'**
  String get skillsWorld;

  /// No description provided for @skillsSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get skillsSeeAll;

  /// No description provided for @skillsTechniques.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 technique} other{{count} techniques}}'**
  String skillsTechniques(int count);

  /// No description provided for @skillsTechniquesTitle.
  ///
  /// In en, this message translates to:
  /// **'Techniques & drills'**
  String get skillsTechniquesTitle;

  /// No description provided for @skillsGetPackShort.
  ///
  /// In en, this message translates to:
  /// **'Tips · techniques to download'**
  String get skillsGetPackShort;

  /// No description provided for @skillsGetPack.
  ///
  /// In en, this message translates to:
  /// **'Download the techniques'**
  String get skillsGetPack;

  /// No description provided for @skillsGetPackInfo.
  ///
  /// In en, this message translates to:
  /// **'Free and small. Opens Content packs.'**
  String get skillsGetPackInfo;

  /// No description provided for @skillsTrains.
  ///
  /// In en, this message translates to:
  /// **'Trains'**
  String get skillsTrains;

  /// No description provided for @skillsTips.
  ///
  /// In en, this message translates to:
  /// **'Tips & tricks'**
  String get skillsTips;

  /// No description provided for @skillsWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Guided drills'**
  String get skillsWorkouts;

  /// No description provided for @skillsSafety.
  ///
  /// In en, this message translates to:
  /// **'Solo practice only: stances, footwork, shadow drills and conditioning. Learn sparring, partner work and weapons from a qualified teacher.'**
  String get skillsSafety;

  /// No description provided for @kindStance.
  ///
  /// In en, this message translates to:
  /// **'Stances'**
  String get kindStance;

  /// No description provided for @kindTechnique.
  ///
  /// In en, this message translates to:
  /// **'Techniques'**
  String get kindTechnique;

  /// No description provided for @kindDrill.
  ///
  /// In en, this message translates to:
  /// **'Drills'**
  String get kindDrill;

  /// No description provided for @kindConditioning.
  ///
  /// In en, this message translates to:
  /// **'Conditioning'**
  String get kindConditioning;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search all exercises, martial arts techniques, tips and workouts.'**
  String get searchEmpty;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing found for \"{query}\".'**
  String searchNoResults(String query);

  /// No description provided for @searchSkills.
  ///
  /// In en, this message translates to:
  /// **'Martial arts'**
  String get searchSkills;

  /// No description provided for @searchExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises & techniques'**
  String get searchExercises;

  /// No description provided for @searchWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get searchWorkouts;

  /// No description provided for @searchTips.
  ///
  /// In en, this message translates to:
  /// **'Tips & tricks'**
  String get searchTips;

  /// No description provided for @searchMore.
  ///
  /// In en, this message translates to:
  /// **'{count} more: refine your search'**
  String searchMore(int count);

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @featureStyleDna.
  ///
  /// In en, this message translates to:
  /// **'Style DNA'**
  String get featureStyleDna;

  /// No description provided for @featureGetReady.
  ///
  /// In en, this message translates to:
  /// **'Get ready for…'**
  String get featureGetReady;

  /// No description provided for @featureOutfitCalendar.
  ///
  /// In en, this message translates to:
  /// **'Outfit calendar'**
  String get featureOutfitCalendar;

  /// No description provided for @featureWardrobeStats.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe stats'**
  String get featureWardrobeStats;

  /// No description provided for @featureGlasses.
  ///
  /// In en, this message translates to:
  /// **'Glasses finder'**
  String get featureGlasses;

  /// No description provided for @dnaSaved.
  ///
  /// In en, this message translates to:
  /// **'Style DNA saved'**
  String get dnaSaved;

  /// No description provided for @dnaYour.
  ///
  /// In en, this message translates to:
  /// **'Your Style DNA'**
  String get dnaYour;

  /// No description provided for @dnaEmpty.
  ///
  /// In en, this message translates to:
  /// **'Pick what feels like you below. Every suggestion in the app follows it.'**
  String get dnaEmpty;

  /// No description provided for @dnaPaletteDone.
  ///
  /// In en, this message translates to:
  /// **'Your colours'**
  String get dnaPaletteDone;

  /// No description provided for @dnaFindPalette.
  ///
  /// In en, this message translates to:
  /// **'Find your colours'**
  String get dnaFindPalette;

  /// No description provided for @dnaFindShape.
  ///
  /// In en, this message translates to:
  /// **'Find face shape'**
  String get dnaFindShape;

  /// No description provided for @dnaStyles.
  ///
  /// In en, this message translates to:
  /// **'Styles you like'**
  String get dnaStyles;

  /// No description provided for @dnaStylesHelp.
  ///
  /// In en, this message translates to:
  /// **'Pick as many as you like.'**
  String get dnaStylesHelp;

  /// No description provided for @dnaFits.
  ///
  /// In en, this message translates to:
  /// **'How you like clothes to fit'**
  String get dnaFits;

  /// No description provided for @dnaFitsHelp.
  ///
  /// In en, this message translates to:
  /// **'Used for outfit tips and shopping gaps.'**
  String get dnaFitsHelp;

  /// No description provided for @dnaOccasions.
  ///
  /// In en, this message translates to:
  /// **'What you dress for most'**
  String get dnaOccasions;

  /// No description provided for @dnaOccasionsHelp.
  ///
  /// In en, this message translates to:
  /// **'Shapes wardrobe gaps and the outfit calendar.'**
  String get dnaOccasionsHelp;

  /// No description provided for @dnaCultural.
  ///
  /// In en, this message translates to:
  /// **'Cultural and traditional wear'**
  String get dnaCultural;

  /// No description provided for @dnaCulturalHelp.
  ///
  /// In en, this message translates to:
  /// **'So festive and wedding ideas fit your traditions.'**
  String get dnaCulturalHelp;

  /// No description provided for @dnaModesty.
  ///
  /// In en, this message translates to:
  /// **'Coverage you prefer'**
  String get dnaModesty;

  /// No description provided for @dnaModestyHelp.
  ///
  /// In en, this message translates to:
  /// **'Every outfit idea respects this.'**
  String get dnaModestyHelp;

  /// No description provided for @dnaBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get dnaBudget;

  /// No description provided for @dnaBudgetHelp.
  ///
  /// In en, this message translates to:
  /// **'For gaps and new-buy ideas only. Never shared.'**
  String get dnaBudgetHelp;

  /// No description provided for @fitPrefSlim.
  ///
  /// In en, this message translates to:
  /// **'Slim'**
  String get fitPrefSlim;

  /// No description provided for @fitPrefRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get fitPrefRegular;

  /// No description provided for @fitPrefRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get fitPrefRelaxed;

  /// No description provided for @fitPrefOversized.
  ///
  /// In en, this message translates to:
  /// **'Oversized'**
  String get fitPrefOversized;

  /// No description provided for @fitPrefTailored.
  ///
  /// In en, this message translates to:
  /// **'Tailored'**
  String get fitPrefTailored;

  /// No description provided for @culturalIndianEthnic.
  ///
  /// In en, this message translates to:
  /// **'Indian ethnic'**
  String get culturalIndianEthnic;

  /// No description provided for @culturalModest.
  ///
  /// In en, this message translates to:
  /// **'Modest fashion'**
  String get culturalModest;

  /// No description provided for @culturalWestern.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get culturalWestern;

  /// No description provided for @culturalFusion.
  ///
  /// In en, this message translates to:
  /// **'Indo-western fusion'**
  String get culturalFusion;

  /// No description provided for @modestyRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get modestyRelaxed;

  /// No description provided for @modestyModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get modestyModerate;

  /// No description provided for @modestyCovered.
  ///
  /// In en, this message translates to:
  /// **'Fully covered'**
  String get modestyCovered;

  /// No description provided for @budgetValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get budgetValue;

  /// No description provided for @budgetMidRange.
  ///
  /// In en, this message translates to:
  /// **'Mid-range'**
  String get budgetMidRange;

  /// No description provided for @budgetPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get budgetPremium;

  /// No description provided for @readyIntro.
  ///
  /// In en, this message translates to:
  /// **'Pick what you\'re getting ready for. You\'ll get one checklist: outfit, grooming and how to carry yourself.'**
  String get readyIntro;

  /// No description provided for @readyProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} ready'**
  String readyProgress(int done, int total);

  /// No description provided for @readyOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get readyOpen;

  /// No description provided for @readyEvInterview.
  ///
  /// In en, this message translates to:
  /// **'Interview'**
  String get readyEvInterview;

  /// No description provided for @readyEvPresentation.
  ///
  /// In en, this message translates to:
  /// **'Presentation'**
  String get readyEvPresentation;

  /// No description provided for @readyEvOffice.
  ///
  /// In en, this message translates to:
  /// **'Office day'**
  String get readyEvOffice;

  /// No description provided for @readyEvDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get readyEvDate;

  /// No description provided for @readyEvWedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get readyEvWedding;

  /// No description provided for @readyEvFestival.
  ///
  /// In en, this message translates to:
  /// **'Festival'**
  String get readyEvFestival;

  /// No description provided for @readyEvParty.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get readyEvParty;

  /// No description provided for @readyEvCasual.
  ///
  /// In en, this message translates to:
  /// **'Day out'**
  String get readyEvCasual;

  /// No description provided for @readyEvGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get readyEvGym;

  /// No description provided for @readyEvTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get readyEvTravel;

  /// No description provided for @readySecOutfit.
  ///
  /// In en, this message translates to:
  /// **'Outfit'**
  String get readySecOutfit;

  /// No description provided for @readySecGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get readySecGrooming;

  /// No description provided for @readySecPresentation.
  ///
  /// In en, this message translates to:
  /// **'Posture, breath and voice'**
  String get readySecPresentation;

  /// No description provided for @readySecFinalChecks.
  ///
  /// In en, this message translates to:
  /// **'Before you leave'**
  String get readySecFinalChecks;

  /// No description provided for @readyPlanned.
  ///
  /// In en, this message translates to:
  /// **'Wear the outfit you planned for today'**
  String get readyPlanned;

  /// No description provided for @readySuggested.
  ///
  /// In en, this message translates to:
  /// **'Wear this from your wardrobe'**
  String get readySuggested;

  /// No description provided for @readyGuideInterview.
  ///
  /// In en, this message translates to:
  /// **'Smart and plain: a pressed shirt or blouse, tailored trousers or skirt, closed shoes'**
  String get readyGuideInterview;

  /// No description provided for @readyGuidePresentation.
  ///
  /// In en, this message translates to:
  /// **'A smart layer that you can move in comfortably, in one or two calm colours'**
  String get readyGuidePresentation;

  /// No description provided for @readyGuideOffice.
  ///
  /// In en, this message translates to:
  /// **'Smart casual: collar or neat top, well-fitting trousers, clean shoes'**
  String get readyGuideOffice;

  /// No description provided for @readyGuideDate.
  ///
  /// In en, this message translates to:
  /// **'Something you feel confident in, a step smarter than everyday'**
  String get readyGuideDate;

  /// No description provided for @readyGuideWedding.
  ///
  /// In en, this message translates to:
  /// **'Festive and dressy: rich colours or traditional wear, polished shoes'**
  String get readyGuideWedding;

  /// No description provided for @readyGuideFestival.
  ///
  /// In en, this message translates to:
  /// **'Bright or traditional, comfortable for a long day'**
  String get readyGuideFestival;

  /// No description provided for @readyGuideParty.
  ///
  /// In en, this message translates to:
  /// **'One statement piece with simple basics'**
  String get readyGuideParty;

  /// No description provided for @readyGuideCasual.
  ///
  /// In en, this message translates to:
  /// **'Comfortable and neat for the weather'**
  String get readyGuideCasual;

  /// No description provided for @readyGuideGym.
  ///
  /// In en, this message translates to:
  /// **'Breathable workout clothes and supportive shoes'**
  String get readyGuideGym;

  /// No description provided for @readyGuideTravel.
  ///
  /// In en, this message translates to:
  /// **'Comfortable layers and easy shoes'**
  String get readyGuideTravel;

  /// No description provided for @readyGuideEthnic.
  ///
  /// In en, this message translates to:
  /// **'Traditional wear: kurta, saree, sherwani or lehenga in festive colours'**
  String get readyGuideEthnic;

  /// No description provided for @readyModest.
  ///
  /// In en, this message translates to:
  /// **'Choose full-coverage pieces, as you prefer'**
  String get readyModest;

  /// No description provided for @readyFitSlim.
  ///
  /// In en, this message translates to:
  /// **'Go for a slim, clean fit'**
  String get readyFitSlim;

  /// No description provided for @readyFitRegular.
  ///
  /// In en, this message translates to:
  /// **'Go for a regular, comfortable fit'**
  String get readyFitRegular;

  /// No description provided for @readyFitRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Keep it relaxed, but neat at the shoulders'**
  String get readyFitRelaxed;

  /// No description provided for @readyFitOversized.
  ///
  /// In en, this message translates to:
  /// **'Balance oversized pieces with one fitted piece'**
  String get readyFitOversized;

  /// No description provided for @readyFitTailored.
  ///
  /// In en, this message translates to:
  /// **'Tailored pieces: check sleeves and hems'**
  String get readyFitTailored;

  /// No description provided for @readyColours.
  ///
  /// In en, this message translates to:
  /// **'Keep your best colours near your face'**
  String get readyColours;

  /// No description provided for @readyPress.
  ///
  /// In en, this message translates to:
  /// **'Iron or steam the outfit'**
  String get readyPress;

  /// No description provided for @readyShoes.
  ///
  /// In en, this message translates to:
  /// **'Clean or polish your shoes'**
  String get readyShoes;

  /// No description provided for @readyLayer.
  ///
  /// In en, this message translates to:
  /// **'Bring a layer for the weather'**
  String get readyLayer;

  /// No description provided for @readyHairStyle.
  ///
  /// In en, this message translates to:
  /// **'Hair: {style} suits your face shape'**
  String readyHairStyle(String style);

  /// No description provided for @readyHairTidy.
  ///
  /// In en, this message translates to:
  /// **'Style or tidy your hair'**
  String get readyHairTidy;

  /// No description provided for @readyBeardStyle.
  ///
  /// In en, this message translates to:
  /// **'Beard: shape it as {style}'**
  String readyBeardStyle(String style);

  /// No description provided for @readyBeardTidy.
  ///
  /// In en, this message translates to:
  /// **'Trim or shave; clean the neckline'**
  String get readyBeardTidy;

  /// No description provided for @readySkin.
  ///
  /// In en, this message translates to:
  /// **'Cleanse and moisturise'**
  String get readySkin;

  /// No description provided for @readySunscreen.
  ///
  /// In en, this message translates to:
  /// **'Sunscreen for time outdoors'**
  String get readySunscreen;

  /// No description provided for @readyNails.
  ///
  /// In en, this message translates to:
  /// **'Clean and trim nails'**
  String get readyNails;

  /// No description provided for @readyScentLight.
  ///
  /// In en, this message translates to:
  /// **'A light fragrance, or none'**
  String get readyScentLight;

  /// No description provided for @readyGymHair.
  ///
  /// In en, this message translates to:
  /// **'Tie hair back; bring a towel'**
  String get readyGymHair;

  /// No description provided for @readyPosture.
  ///
  /// In en, this message translates to:
  /// **'Stand tall: shoulders back and down, chin level'**
  String get readyPosture;

  /// No description provided for @readyBreath.
  ///
  /// In en, this message translates to:
  /// **'Slow breathing for a minute: in 4, out 6'**
  String get readyBreath;

  /// No description provided for @readyFaceWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm up your face and voice for two minutes'**
  String get readyFaceWarmup;

  /// No description provided for @readyVoice.
  ///
  /// In en, this message translates to:
  /// **'Speak a little slower than feels natural, and pause'**
  String get readyVoice;

  /// No description provided for @readyEyeContact.
  ///
  /// In en, this message translates to:
  /// **'Friendly eye contact, then look away briefly'**
  String get readyEyeContact;

  /// No description provided for @readyThreePoints.
  ///
  /// In en, this message translates to:
  /// **'Know your three key points by heart'**
  String get readyThreePoints;

  /// No description provided for @readyDocuments.
  ///
  /// In en, this message translates to:
  /// **'Copies of documents or slides, and a pen'**
  String get readyDocuments;

  /// No description provided for @readyTravelDocs.
  ///
  /// In en, this message translates to:
  /// **'ID, tickets, chargers and medicines'**
  String get readyTravelDocs;

  /// No description provided for @readyGymKit.
  ///
  /// In en, this message translates to:
  /// **'Water, towel, shoes and a change of clothes'**
  String get readyGymKit;

  /// No description provided for @readyGift.
  ///
  /// In en, this message translates to:
  /// **'The gift or shagun'**
  String get readyGift;

  /// No description provided for @readyWater.
  ///
  /// In en, this message translates to:
  /// **'A bottle of water'**
  String get readyWater;

  /// No description provided for @readyPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone charged, keys and wallet'**
  String get readyPhone;

  /// No description provided for @readyEarly.
  ///
  /// In en, this message translates to:
  /// **'Leave early so you arrive calm'**
  String get readyEarly;

  /// No description provided for @calendarEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get calendarEarlier;

  /// No description provided for @calendarLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get calendarLater;

  /// No description provided for @calendarNoOutfits.
  ///
  /// In en, this message translates to:
  /// **'Save a few outfits first, then plan them here.'**
  String get calendarNoOutfits;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get calendarPlan;

  /// No description provided for @calendarWorn.
  ///
  /// In en, this message translates to:
  /// **'Worn'**
  String get calendarWorn;

  /// No description provided for @calendarWoreIt.
  ///
  /// In en, this message translates to:
  /// **'Wore it'**
  String get calendarWoreIt;

  /// No description provided for @calendarRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get calendarRemove;

  /// No description provided for @calendarPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick an outfit'**
  String get calendarPickTitle;

  /// No description provided for @calendarNoneForOccasion.
  ///
  /// In en, this message translates to:
  /// **'No saved outfits for this occasion yet.'**
  String get calendarNoneForOccasion;

  /// No description provided for @statsPriceTitle.
  ///
  /// In en, this message translates to:
  /// **'What did {name} cost?'**
  String statsPriceTitle(String name);

  /// No description provided for @statsPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get statsPrice;

  /// No description provided for @statsPriceHelp.
  ///
  /// In en, this message translates to:
  /// **'Optional. Stays on this phone; leave empty to clear.'**
  String get statsPriceHelp;

  /// No description provided for @statsWears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{not worn yet} =1{worn once} other{worn {count} times}}'**
  String statsWears(int count);

  /// No description provided for @statsLastWorn.
  ///
  /// In en, this message translates to:
  /// **'last {date}'**
  String statsLastWorn(String date);

  /// No description provided for @statsAddPrice.
  ///
  /// In en, this message translates to:
  /// **'Add price'**
  String get statsAddPrice;

  /// No description provided for @statsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add clothes to your wardrobe and mark outfits as worn to see what you really wear.'**
  String get statsEmpty;

  /// No description provided for @statsItems.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get statsItems;

  /// No description provided for @statsTotalWears.
  ///
  /// In en, this message translates to:
  /// **'times worn'**
  String get statsTotalWears;

  /// No description provided for @statsNeutrals.
  ///
  /// In en, this message translates to:
  /// **'neutral basics'**
  String get statsNeutrals;

  /// No description provided for @statsGaps.
  ///
  /// In en, this message translates to:
  /// **'What\'s missing'**
  String get statsGaps;

  /// No description provided for @statsMostWorn.
  ///
  /// In en, this message translates to:
  /// **'Most worn'**
  String get statsMostWorn;

  /// No description provided for @statsBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get statsBestValue;

  /// No description provided for @statsBestValueHelp.
  ///
  /// In en, this message translates to:
  /// **'Lowest cost per wear so far.'**
  String get statsBestValueHelp;

  /// No description provided for @statsPerWear.
  ///
  /// In en, this message translates to:
  /// **'{price} a wear'**
  String statsPerWear(String price);

  /// No description provided for @statsNeverWorn.
  ///
  /// In en, this message translates to:
  /// **'Not worn yet'**
  String get statsNeverWorn;

  /// No description provided for @statsNeverWornHelp.
  ///
  /// In en, this message translates to:
  /// **'Try one of these this week, or pass it on.'**
  String get statsNeverWornHelp;

  /// No description provided for @gapBottoms.
  ///
  /// In en, this message translates to:
  /// **'Bottoms'**
  String get gapBottoms;

  /// No description provided for @gapAdviceBottoms.
  ///
  /// In en, this message translates to:
  /// **'Add trousers, jeans or a skirt so tops can become outfits.'**
  String get gapAdviceBottoms;

  /// No description provided for @gapFootwear.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get gapFootwear;

  /// No description provided for @gapAdviceFootwear.
  ///
  /// In en, this message translates to:
  /// **'One versatile pair (white sneakers or plain loafers) completes most outfits.'**
  String get gapAdviceFootwear;

  /// No description provided for @gapWorkTop.
  ///
  /// In en, this message translates to:
  /// **'A work top'**
  String get gapWorkTop;

  /// No description provided for @gapAdviceWorkTop.
  ///
  /// In en, this message translates to:
  /// **'A plain shirt or blouse in white, light blue or a soft neutral.'**
  String get gapAdviceWorkTop;

  /// No description provided for @gapFormalWear.
  ///
  /// In en, this message translates to:
  /// **'Something formal'**
  String get gapFormalWear;

  /// No description provided for @gapAdviceFormalWear.
  ///
  /// In en, this message translates to:
  /// **'A blazer, suit or formal dress for important days.'**
  String get gapAdviceFormalWear;

  /// No description provided for @gapFestiveEthnic.
  ///
  /// In en, this message translates to:
  /// **'Festive or traditional wear'**
  String get gapFestiveEthnic;

  /// No description provided for @gapAdviceFestiveEthnic.
  ///
  /// In en, this message translates to:
  /// **'One kurta, saree or ethnic set in a colour from your palette.'**
  String get gapAdviceFestiveEthnic;

  /// No description provided for @gapNeutralBasics.
  ///
  /// In en, this message translates to:
  /// **'Neutral basics'**
  String get gapNeutralBasics;

  /// No description provided for @gapAdviceNeutralBasics.
  ///
  /// In en, this message translates to:
  /// **'Add two neutral pieces (navy, beige, grey, white) so colourful ones pair easily.'**
  String get gapAdviceNeutralBasics;

  /// No description provided for @gapSportwear.
  ///
  /// In en, this message translates to:
  /// **'Workout clothes'**
  String get gapSportwear;

  /// No description provided for @gapAdviceSportwear.
  ///
  /// In en, this message translates to:
  /// **'Breathable tops and shorts or leggings for exercise.'**
  String get gapAdviceSportwear;

  /// No description provided for @gapOuterwear.
  ///
  /// In en, this message translates to:
  /// **'A jacket or layer'**
  String get gapOuterwear;

  /// No description provided for @gapAdviceOuterwear.
  ///
  /// In en, this message translates to:
  /// **'A jacket or cardigan for cooler days.'**
  String get gapAdviceOuterwear;

  /// No description provided for @glassesSizeTip.
  ///
  /// In en, this message translates to:
  /// **'Size matters as much as shape: the frame should be about as wide as your face at the temples, with your eyes near the centre of each lens.'**
  String get glassesSizeTip;

  /// No description provided for @glassesTryOn.
  ///
  /// In en, this message translates to:
  /// **'Try on live'**
  String get glassesTryOn;

  /// No description provided for @glassesNoShape.
  ///
  /// In en, this message translates to:
  /// **'Analyse your face shape for personal fits'**
  String get glassesNoShape;

  /// No description provided for @glassesForShape.
  ///
  /// In en, this message translates to:
  /// **'Ranked for your {shape} face'**
  String glassesForShape(String shape);

  /// No description provided for @glassesHonest.
  ///
  /// In en, this message translates to:
  /// **'Fit guidance from contrast rules, not a judgement of looks. Wear what you love.'**
  String get glassesHonest;

  /// No description provided for @fitGreat.
  ///
  /// In en, this message translates to:
  /// **'Great fit'**
  String get fitGreat;

  /// No description provided for @fitGood.
  ///
  /// In en, this message translates to:
  /// **'Good fit'**
  String get fitGood;

  /// No description provided for @fitLess.
  ///
  /// In en, this message translates to:
  /// **'Less balancing'**
  String get fitLess;

  /// No description provided for @fitReasonAddsAngles.
  ///
  /// In en, this message translates to:
  /// **'Angular lines add definition to softer, rounder features.'**
  String get fitReasonAddsAngles;

  /// No description provided for @fitReasonSoftensAngles.
  ///
  /// In en, this message translates to:
  /// **'Curved frames soften a strong jaw and forehead.'**
  String get fitReasonSoftensAngles;

  /// No description provided for @fitReasonAddsLength.
  ///
  /// In en, this message translates to:
  /// **'Deeper frames break up length and add width.'**
  String get fitReasonAddsLength;

  /// No description provided for @fitReasonBalancesForehead.
  ///
  /// In en, this message translates to:
  /// **'Lighter or bottom-heavy frames balance a wider forehead.'**
  String get fitReasonBalancesForehead;

  /// No description provided for @fitReasonLiftsCheekbones.
  ///
  /// In en, this message translates to:
  /// **'Upswept or oval frames highlight the cheekbones.'**
  String get fitReasonLiftsCheekbones;

  /// No description provided for @fitReasonSuitsMost.
  ///
  /// In en, this message translates to:
  /// **'Balanced proportions suit most frames; go with what you love.'**
  String get fitReasonSuitsMost;

  /// No description provided for @fitReasonEchoesShape.
  ///
  /// In en, this message translates to:
  /// **'This shape repeats your face\'s own lines, so it balances less. Still yours to choose.'**
  String get fitReasonEchoesShape;

  /// No description provided for @fitReasonUnknownShape.
  ///
  /// In en, this message translates to:
  /// **'Analyse your face to see how this frame balances your shape.'**
  String get fitReasonUnknownShape;

  /// No description provided for @whyFeedBodyPlan.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t set up a diet and body plan yet.'**
  String get whyFeedBodyPlan;

  /// No description provided for @benefitFeedBodyPlan.
  ///
  /// In en, this message translates to:
  /// **'A plan turns your goal into daily calories, meals and training that fit your region.'**
  String get benefitFeedBodyPlan;

  /// No description provided for @whyFeedGoals.
  ///
  /// In en, this message translates to:
  /// **'Your goals decide which quests, tips and areas you see first.'**
  String get whyFeedGoals;

  /// No description provided for @benefitFeedGoals.
  ///
  /// In en, this message translates to:
  /// **'Picking a focus keeps the app about what matters to you.'**
  String get benefitFeedGoals;

  /// No description provided for @whyFeedSnapshot.
  ///
  /// In en, this message translates to:
  /// **'There\'s no progress photo for this week yet.'**
  String get whyFeedSnapshot;

  /// No description provided for @benefitFeedSnapshot.
  ///
  /// In en, this message translates to:
  /// **'A weekly photo shows real change that the mirror misses.'**
  String get benefitFeedSnapshot;

  /// No description provided for @whyFeedFace.
  ///
  /// In en, this message translates to:
  /// **'Your face shape hasn\'t been analysed yet.'**
  String get whyFeedFace;

  /// No description provided for @benefitFeedFace.
  ///
  /// In en, this message translates to:
  /// **'It tailors hairstyle, beard and glasses ideas to you.'**
  String get benefitFeedFace;

  /// No description provided for @whyFeedHairstyles.
  ///
  /// In en, this message translates to:
  /// **'These follow from your face shape.'**
  String get whyFeedHairstyles;

  /// No description provided for @benefitFeedHairstyles.
  ///
  /// In en, this message translates to:
  /// **'Styles that balance your features, with reasons for each.'**
  String get benefitFeedHairstyles;

  /// No description provided for @whyFeedTryOn.
  ///
  /// In en, this message translates to:
  /// **'You can preview glasses and beards live before changing anything.'**
  String get whyFeedTryOn;

  /// No description provided for @benefitFeedTryOn.
  ///
  /// In en, this message translates to:
  /// **'See it on your own face, privately, on this phone.'**
  String get benefitFeedTryOn;

  /// No description provided for @whyFeedColours.
  ///
  /// In en, this message translates to:
  /// **'Your colour palette isn\'t set yet.'**
  String get whyFeedColours;

  /// No description provided for @benefitFeedColours.
  ///
  /// In en, this message translates to:
  /// **'Knowing your colours makes outfits and shopping easier.'**
  String get benefitFeedColours;

  /// No description provided for @whyFeedOutfit.
  ///
  /// In en, this message translates to:
  /// **'You have enough clothes for outfit ideas.'**
  String get whyFeedOutfit;

  /// No description provided for @benefitFeedOutfit.
  ///
  /// In en, this message translates to:
  /// **'Ideas from what you already own, with reasons.'**
  String get benefitFeedOutfit;

  /// No description provided for @whyFeedPosture.
  ///
  /// In en, this message translates to:
  /// **'A quick posture check is useful every week or two.'**
  String get whyFeedPosture;

  /// No description provided for @benefitFeedPosture.
  ///
  /// In en, this message translates to:
  /// **'Catch neck and back strain early, with exercises to help.'**
  String get benefitFeedPosture;

  /// No description provided for @whyFeedExercise.
  ///
  /// In en, this message translates to:
  /// **'Moving most days helps every other goal.'**
  String get whyFeedExercise;

  /// No description provided for @benefitFeedExercise.
  ///
  /// In en, this message translates to:
  /// **'Guided workouts and 1,500+ exercises, with no equipment needed for many.'**
  String get benefitFeedExercise;

  /// No description provided for @onboardingGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to work on?'**
  String get onboardingGoalsTitle;

  /// No description provided for @onboardingGoalsBody.
  ///
  /// In en, this message translates to:
  /// **'Pick any that matter to you. We\'ll only ask what these goals need, and you can change them any time.'**
  String get onboardingGoalsBody;

  /// No description provided for @onboardingAboutFocused.
  ///
  /// In en, this message translates to:
  /// **'Only what your goals need. You can add the rest later in Profile.'**
  String get onboardingAboutFocused;

  /// No description provided for @settingsTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get settingsTimeFormat;

  /// No description provided for @timeFormatDevice.
  ///
  /// In en, this message translates to:
  /// **'Same as device'**
  String get timeFormatDevice;

  /// No description provided for @timeFormat12.
  ///
  /// In en, this message translates to:
  /// **'12-hour'**
  String get timeFormat12;

  /// No description provided for @timeFormat24.
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get timeFormat24;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get lockTitle;

  /// No description provided for @lockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for a PIN or fingerprint when the app opens'**
  String get lockSubtitle;

  /// No description provided for @lockEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get lockEnterPin;

  /// No description provided for @lockSetPin.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN'**
  String get lockSetPin;

  /// No description provided for @lockConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN again'**
  String get lockConfirmPin;

  /// No description provided for @lockPinRules.
  ///
  /// In en, this message translates to:
  /// **'4 to 8 digits. If you forget it, the app can\'t be opened without clearing its data, so pick one you\'ll remember.'**
  String get lockPinRules;

  /// No description provided for @lockPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The PINs didn\'t match. Try again.'**
  String get lockPinMismatch;

  /// No description provided for @lockWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get lockWrongPin;

  /// No description provided for @lockWait.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Wait {seconds} s.'**
  String lockWait(int seconds);

  /// No description provided for @lockUseFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint'**
  String get lockUseFingerprint;

  /// No description provided for @lockBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Personality'**
  String get lockBiometricReason;

  /// No description provided for @lockForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get lockForgot;

  /// No description provided for @lockForgotInfo.
  ///
  /// In en, this message translates to:
  /// **'For your privacy the PIN can\'t be reset or recovered, not even by us. If fingerprint unlock is on, use it, then change the PIN in Settings. Otherwise, clearing the app\'s data (Android Settings → Apps) removes the lock and everything in the app; restore from a backup afterwards.'**
  String get lockForgotInfo;

  /// No description provided for @lockOn.
  ///
  /// In en, this message translates to:
  /// **'App lock is on'**
  String get lockOn;

  /// No description provided for @lockOff.
  ///
  /// In en, this message translates to:
  /// **'App lock is off'**
  String get lockOff;

  /// No description provided for @lockChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get lockChangePin;

  /// No description provided for @lockChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed'**
  String get lockChanged;

  /// No description provided for @lockDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get lockDelete;

  /// No description provided for @lockDigits.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No digits entered} =1{1 digit entered} other{{count} digits entered}}'**
  String lockDigits(int count);

  /// No description provided for @widgetNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get widgetNext;

  /// No description provided for @widgetAddGlass.
  ///
  /// In en, this message translates to:
  /// **'+ Glass'**
  String get widgetAddGlass;

  /// No description provided for @widgetLocked.
  ///
  /// In en, this message translates to:
  /// **'Unlock the app to see your next task'**
  String get widgetLocked;

  /// No description provided for @widgetNothingNext.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned right now'**
  String get widgetNothingNext;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact & support'**
  String get contactTitle;

  /// No description provided for @contactBody.
  ///
  /// In en, this message translates to:
  /// **'Questions, ideas or a problem? Write to us.'**
  String get contactBody;

  /// No description provided for @aboutMadeBy.
  ///
  /// In en, this message translates to:
  /// **'Made by {company}'**
  String aboutMadeBy(String company);

  /// No description provided for @contactEmailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email address copied'**
  String get contactEmailCopied;

  /// No description provided for @contactEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Personality app'**
  String get contactEmailSubject;

  /// No description provided for @lockMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to unlock?'**
  String get lockMethodTitle;

  /// No description provided for @lockMethodDevice.
  ///
  /// In en, this message translates to:
  /// **'Phone\'s screen lock'**
  String get lockMethodDevice;

  /// No description provided for @lockMethodDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint, face, or your phone\'s PIN, pattern or password. Nothing new to remember. Recommended.'**
  String get lockMethodDeviceInfo;

  /// No description provided for @lockMethodPin.
  ///
  /// In en, this message translates to:
  /// **'App PIN'**
  String get lockMethodPin;

  /// No description provided for @lockMethodPinInfo.
  ///
  /// In en, this message translates to:
  /// **'A separate 4–8 digit PIN just for this app.'**
  String get lockMethodPinInfo;

  /// No description provided for @lockUsesDevice.
  ///
  /// In en, this message translates to:
  /// **'Unlocks with your phone\'s screen lock'**
  String get lockUsesDevice;

  /// No description provided for @lockUsesPin.
  ///
  /// In en, this message translates to:
  /// **'Unlocks with an app PIN'**
  String get lockUsesPin;

  /// No description provided for @lockSwitchToDevice.
  ///
  /// In en, this message translates to:
  /// **'Use the phone\'s screen lock instead'**
  String get lockSwitchToDevice;

  /// No description provided for @lockSwitchToPin.
  ///
  /// In en, this message translates to:
  /// **'Use an app PIN instead'**
  String get lockSwitchToPin;

  /// No description provided for @lockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockUnlock;

  /// No description provided for @lockDeviceHint.
  ///
  /// In en, this message translates to:
  /// **'Use your fingerprint, face, or your phone\'s PIN, pattern or password.'**
  String get lockDeviceHint;

  /// No description provided for @lockDeviceFailed.
  ///
  /// In en, this message translates to:
  /// **'Not unlocked. Try again.'**
  String get lockDeviceFailed;

  /// No description provided for @lockNoDeviceLock.
  ///
  /// In en, this message translates to:
  /// **'This phone has no screen lock. Set one in Android settings, or use an app PIN.'**
  String get lockNoDeviceLock;

  /// No description provided for @lockDeviceRemoved.
  ///
  /// In en, this message translates to:
  /// **'Your phone no longer has a screen lock, so the app lock was turned off.'**
  String get lockDeviceRemoved;

  /// No description provided for @weightJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your weight journey'**
  String get weightJourneyTitle;

  /// No description provided for @weightJourneyNoGoal.
  ///
  /// In en, this message translates to:
  /// **'Set a goal to map your journey.'**
  String get weightJourneyNoGoal;

  /// No description provided for @weightJourneySetGoal.
  ///
  /// In en, this message translates to:
  /// **'Set goal'**
  String get weightJourneySetGoal;

  /// No description provided for @weightJourneyMaintain.
  ///
  /// In en, this message translates to:
  /// **'You started inside your goal range, so this journey is about staying there.'**
  String get weightJourneyMaintain;

  /// No description provided for @weightJourneyProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the way'**
  String weightJourneyProgress(int percent);

  /// No description provided for @weightJourneyReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached'**
  String get weightJourneyReached;

  /// No description provided for @weightJourneyTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a flag to see its weight.'**
  String get weightJourneyTapHint;

  /// No description provided for @weightMilestoneAt.
  ///
  /// In en, this message translates to:
  /// **'{percent}% mark: {weight}'**
  String weightMilestoneAt(int percent, String weight);

  /// No description provided for @weightJourneySemantics.
  ///
  /// In en, this message translates to:
  /// **'Weight journey: {percent}% of the way from {start} to {target}'**
  String weightJourneySemantics(int percent, String start, String target);

  /// No description provided for @weightStatWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get weightStatWeek;

  /// No description provided for @weightStatSinceStart.
  ///
  /// In en, this message translates to:
  /// **'Since start'**
  String get weightStatSinceStart;

  /// No description provided for @weightStatToGo.
  ///
  /// In en, this message translates to:
  /// **'To go'**
  String get weightStatToGo;

  /// No description provided for @weightStatStreak.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in streak'**
  String get weightStatStreak;

  /// No description provided for @weightStreakWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not yet} =1{1 week} other{{count} weeks}}'**
  String weightStreakWeeks(int count);

  /// No description provided for @weightLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Step on the scale'**
  String get weightLogTitle;

  /// No description provided for @weightLogHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the ruler, or use − and +, to set your weight.'**
  String get weightLogHint;

  /// No description provided for @weightLogSave.
  ///
  /// In en, this message translates to:
  /// **'Save weigh-in'**
  String get weightLogSave;

  /// No description provided for @weightLogSaved.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in saved'**
  String get weightLogSaved;

  /// No description provided for @weightDecrease.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get weightDecrease;

  /// No description provided for @weightIncrease.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get weightIncrease;

  /// No description provided for @weightCelebrateMilestone.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the way!'**
  String weightCelebrateMilestone(int percent);

  /// No description provided for @weightCelebrateBody.
  ///
  /// In en, this message translates to:
  /// **'Now at {weight}. Steady steps add up. Keep going at your own pace.'**
  String weightCelebrateBody(String weight);

  /// No description provided for @weightCelebrateGoal.
  ///
  /// In en, this message translates to:
  /// **'You reached your goal!'**
  String get weightCelebrateGoal;

  /// No description provided for @weightCelebrateGoalBody.
  ///
  /// In en, this message translates to:
  /// **'Now the journey is about keeping it. Your trend will show how it holds.'**
  String get weightCelebrateGoalBody;

  /// No description provided for @weightCelebrateOk.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get weightCelebrateOk;

  /// No description provided for @featureGoalReminders.
  ///
  /// In en, this message translates to:
  /// **'Goal reminders'**
  String get featureGoalReminders;

  /// No description provided for @goalRemindersIntro.
  ///
  /// In en, this message translates to:
  /// **'Gentle nudges for your goals. Each one is a routine, so quiet hours, Done and Snooze all work, and nothing leaves your phone.'**
  String get goalRemindersIntro;

  /// No description provided for @goalRemindForYou.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get goalRemindForYou;

  /// No description provided for @goalRemindWeighIn.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in'**
  String get goalRemindWeighIn;

  /// No description provided for @goalRemindWeighInItem.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in time: step on the scale'**
  String get goalRemindWeighInItem;

  /// No description provided for @goalRemindWeighInInfo.
  ///
  /// In en, this message translates to:
  /// **'Same day and time, before breakfast: the fairest way to see your trend.'**
  String get goalRemindWeighInInfo;

  /// No description provided for @goalRemindWater.
  ///
  /// In en, this message translates to:
  /// **'Drink water'**
  String get goalRemindWater;

  /// No description provided for @goalRemindWaterItem.
  ///
  /// In en, this message translates to:
  /// **'Time for a glass of water'**
  String get goalRemindWaterItem;

  /// No description provided for @goalRemindWaterInfo.
  ///
  /// In en, this message translates to:
  /// **'Spread through the day so your water target comes easily.'**
  String get goalRemindWaterInfo;

  /// No description provided for @goalRemindBedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime wind-down'**
  String get goalRemindBedtime;

  /// No description provided for @goalRemindBedtimeItem.
  ///
  /// In en, this message translates to:
  /// **'Start winding down for bed'**
  String get goalRemindBedtimeItem;

  /// No description provided for @goalRemindBedtimeInfo.
  ///
  /// In en, this message translates to:
  /// **'A nudge to dim screens and get ready for sleep at a regular time.'**
  String get goalRemindBedtimeInfo;

  /// No description provided for @goalRemindMove.
  ///
  /// In en, this message translates to:
  /// **'Move break'**
  String get goalRemindMove;

  /// No description provided for @goalRemindMoveItem.
  ///
  /// In en, this message translates to:
  /// **'Stand up and move for 5 minutes'**
  String get goalRemindMoveItem;

  /// No description provided for @goalRemindMoveInfo.
  ///
  /// In en, this message translates to:
  /// **'Short walks break up long sitting on workdays.'**
  String get goalRemindMoveInfo;

  /// No description provided for @goalRemindPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture break'**
  String get goalRemindPosture;

  /// No description provided for @goalRemindPostureItem.
  ///
  /// In en, this message translates to:
  /// **'Posture break: roll your shoulders and sit tall'**
  String get goalRemindPostureItem;

  /// No description provided for @goalRemindPostureInfo.
  ///
  /// In en, this message translates to:
  /// **'A quick reset for neck and back during the workday.'**
  String get goalRemindPostureInfo;

  /// No description provided for @goalRemindDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get goalRemindDays;

  /// No description provided for @goalRemindTimes.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get goalRemindTimes;

  /// No description provided for @goalRemindAddTime.
  ///
  /// In en, this message translates to:
  /// **'Add a time'**
  String get goalRemindAddTime;

  /// No description provided for @goalRemindRemoveTime.
  ///
  /// In en, this message translates to:
  /// **'Remove {time}'**
  String goalRemindRemoveTime(String time);

  /// No description provided for @goalRemindWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get goalRemindWeekdays;

  /// No description provided for @nowTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended for now'**
  String get nowTitle;

  /// No description provided for @nowMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning picks'**
  String get nowMorning;

  /// No description provided for @nowAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon picks'**
  String get nowAfternoon;

  /// No description provided for @nowEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening picks'**
  String get nowEvening;

  /// No description provided for @nowNight.
  ///
  /// In en, this message translates to:
  /// **'Before bed'**
  String get nowNight;

  /// No description provided for @nowAllDone.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up for now.'**
  String get nowAllDone;

  /// No description provided for @nowNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get nowNotNow;

  /// No description provided for @nowNoThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get nowNoThanks;

  /// No description provided for @nowBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Time for breakfast'**
  String get nowBreakfast;

  /// No description provided for @nowBreakfastInfo.
  ///
  /// In en, this message translates to:
  /// **'A steady start keeps your energy up until lunch.'**
  String get nowBreakfastInfo;

  /// No description provided for @nowLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch time'**
  String get nowLunch;

  /// No description provided for @nowLunchInfo.
  ///
  /// In en, this message translates to:
  /// **'Eat around 1 pm, then log it in a tap.'**
  String get nowLunchInfo;

  /// No description provided for @nowDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner time'**
  String get nowDinner;

  /// No description provided for @nowDinnerInfo.
  ///
  /// In en, this message translates to:
  /// **'A lighter, earlier dinner helps you sleep.'**
  String get nowDinnerInfo;

  /// No description provided for @nowPostureCheck.
  ///
  /// In en, this message translates to:
  /// **'Morning posture check'**
  String get nowPostureCheck;

  /// No description provided for @nowPostureCheckInfo.
  ///
  /// In en, this message translates to:
  /// **'Two minutes with the camera to start the day standing tall.'**
  String get nowPostureCheckInfo;

  /// No description provided for @nowWeighIn.
  ///
  /// In en, this message translates to:
  /// **'Weigh in'**
  String get nowWeighIn;

  /// No description provided for @nowWeighInInfo.
  ///
  /// In en, this message translates to:
  /// **'Before breakfast, for a fair trend.'**
  String get nowWeighInInfo;

  /// No description provided for @nowWakeStretch.
  ///
  /// In en, this message translates to:
  /// **'Wake-up stretch'**
  String get nowWakeStretch;

  /// No description provided for @nowWakeStretchInfo.
  ///
  /// In en, this message translates to:
  /// **'5 minutes of gentle mobility.'**
  String get nowWakeStretchInfo;

  /// No description provided for @nowWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk for 10 minutes'**
  String get nowWalk;

  /// No description provided for @nowWalkInfo.
  ///
  /// In en, this message translates to:
  /// **'A short walk after eating helps digestion.'**
  String get nowWalkInfo;

  /// No description provided for @nowWalkStarted.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your walk. Steps count automatically if activity is allowed.'**
  String get nowWalkStarted;

  /// No description provided for @nowMicroInfo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Starts small and grows as you log sets.} =1{1 set logged. It grows as you go.} other{{count} sets logged. It grows as you go.}}'**
  String nowMicroInfo(int count);

  /// No description provided for @nowPushUps.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 push-up} other{{count} push-ups}}'**
  String nowPushUps(int count);

  /// No description provided for @nowSquats.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 squat} other{{count} squats}}'**
  String nowSquats(int count);

  /// No description provided for @nowPlank.
  ///
  /// In en, this message translates to:
  /// **'{count}-second plank'**
  String nowPlank(int count);

  /// No description provided for @nowBridges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 glute bridge} other{{count} glute bridges}}'**
  String nowBridges(int count);

  /// No description provided for @nowLunges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 lunge each side} other{{count} lunges each side}}'**
  String nowLunges(int count);

  /// No description provided for @nowMicroHint.
  ///
  /// In en, this message translates to:
  /// **'Move at a steady pace and stop if anything hurts. Tap Done when you finish to log it.'**
  String get nowMicroHint;

  /// No description provided for @nowSetLogged.
  ///
  /// In en, this message translates to:
  /// **'Set logged. Next time it grows a little.'**
  String get nowSetLogged;

  /// No description provided for @nowSkill.
  ///
  /// In en, this message translates to:
  /// **'Practise {skill} for 5 min'**
  String nowSkill(String skill);

  /// No description provided for @nowSkillInfo.
  ///
  /// In en, this message translates to:
  /// **'Your chosen skill: a few minutes a day keeps it growing.'**
  String get nowSkillInfo;

  /// No description provided for @nowYoga.
  ///
  /// In en, this message translates to:
  /// **'5-minute yoga flow'**
  String get nowYoga;

  /// No description provided for @nowYogaInfo.
  ///
  /// In en, this message translates to:
  /// **'Gentle poses for flexibility.'**
  String get nowYogaInfo;

  /// No description provided for @nowFaceSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Weekly face snapshot'**
  String get nowFaceSnapshot;

  /// No description provided for @nowFaceSnapshotInfo.
  ///
  /// In en, this message translates to:
  /// **'Same light, same spot: your time-lapse grows.'**
  String get nowFaceSnapshotInfo;

  /// No description provided for @nowWindDown.
  ///
  /// In en, this message translates to:
  /// **'Wind down for bed'**
  String get nowWindDown;

  /// No description provided for @nowWindDownInfo.
  ///
  /// In en, this message translates to:
  /// **'Dim the screens and stretch gently.'**
  String get nowWindDownInfo;

  /// No description provided for @nowMealReminders.
  ///
  /// In en, this message translates to:
  /// **'Get meal-time reminders'**
  String get nowMealReminders;

  /// No description provided for @nowMealRemindersInfo.
  ///
  /// In en, this message translates to:
  /// **'Breakfast {breakfast}, lunch {lunch}, dinner {dinner}. Change the times any time.'**
  String nowMealRemindersInfo(String breakfast, String lunch, String dinner);

  /// No description provided for @nowMealRemindersOn.
  ///
  /// In en, this message translates to:
  /// **'Meal-time reminders are on'**
  String get nowMealRemindersOn;

  /// No description provided for @skillsPractiseRegularly.
  ///
  /// In en, this message translates to:
  /// **'Practise regularly'**
  String get skillsPractiseRegularly;

  /// No description provided for @skillsPractiseInfo.
  ///
  /// In en, this message translates to:
  /// **'Shown in your recommendations on Home.'**
  String get skillsPractiseInfo;

  /// No description provided for @goalRemindMeals.
  ///
  /// In en, this message translates to:
  /// **'Meal times'**
  String get goalRemindMeals;

  /// No description provided for @goalRemindMealsInfo.
  ///
  /// In en, this message translates to:
  /// **'Breakfast, lunch and dinner at regular times.'**
  String get goalRemindMealsInfo;

  /// No description provided for @mealBreakfastTime.
  ///
  /// In en, this message translates to:
  /// **'Breakfast time'**
  String get mealBreakfastTime;

  /// No description provided for @mealLunchTime.
  ///
  /// In en, this message translates to:
  /// **'Lunch time'**
  String get mealLunchTime;

  /// No description provided for @mealSnackTime.
  ///
  /// In en, this message translates to:
  /// **'Snack time'**
  String get mealSnackTime;

  /// No description provided for @mealDinnerTime.
  ///
  /// In en, this message translates to:
  /// **'Dinner time'**
  String get mealDinnerTime;

  /// No description provided for @goalRemindPostureCheck.
  ///
  /// In en, this message translates to:
  /// **'Morning posture check'**
  String get goalRemindPostureCheck;

  /// No description provided for @goalRemindPostureCheckItem.
  ///
  /// In en, this message translates to:
  /// **'Morning posture check: 2 minutes with the camera'**
  String get goalRemindPostureCheckItem;

  /// No description provided for @goalRemindPostureCheckInfo.
  ///
  /// In en, this message translates to:
  /// **'Start each day with a quick look at how you stand.'**
  String get goalRemindPostureCheckInfo;

  /// No description provided for @goalRemindFaceSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Weekly face snapshot'**
  String get goalRemindFaceSnapshot;

  /// No description provided for @goalRemindFaceSnapshotItem.
  ///
  /// In en, this message translates to:
  /// **'Take this week\'s face snapshot'**
  String get goalRemindFaceSnapshotItem;

  /// No description provided for @goalRemindFaceSnapshotInfo.
  ///
  /// In en, this message translates to:
  /// **'Same day each week, so your time-lapse shows real change.'**
  String get goalRemindFaceSnapshotInfo;

  /// No description provided for @permTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow what Personality needs'**
  String get permTitle;

  /// No description provided for @permIntro.
  ///
  /// In en, this message translates to:
  /// **'Each one is optional and everything stays on your phone. You can change them any time.'**
  String get permIntro;

  /// No description provided for @permNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permNotifications;

  /// No description provided for @permNotificationsInfo.
  ///
  /// In en, this message translates to:
  /// **'Meal times, reminders and gentle nudges.'**
  String get permNotificationsInfo;

  /// No description provided for @permCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permCamera;

  /// No description provided for @permCameraInfo.
  ///
  /// In en, this message translates to:
  /// **'Posture checks, face shape and progress photos. Frames never leave your phone.'**
  String get permCameraInfo;

  /// No description provided for @permActivity.
  ///
  /// In en, this message translates to:
  /// **'Physical activity'**
  String get permActivity;

  /// No description provided for @permActivityInfo.
  ///
  /// In en, this message translates to:
  /// **'Counts steps and walks with the phone\'s own sensors.'**
  String get permActivityInfo;

  /// No description provided for @permAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get permAllowed;

  /// No description provided for @permAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get permAllow;

  /// No description provided for @permOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get permOpenSettings;

  /// No description provided for @permAllowAll.
  ///
  /// In en, this message translates to:
  /// **'Allow all'**
  String get permAllowAll;

  /// No description provided for @permNudgeTitle.
  ///
  /// In en, this message translates to:
  /// **'A few permissions are still off'**
  String get permNudgeTitle;

  /// No description provided for @permNudgeBody.
  ///
  /// In en, this message translates to:
  /// **'Allow them so reminders, camera checks and step counts can work.'**
  String get permNudgeBody;

  /// No description provided for @permLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get permLater;

  /// No description provided for @permStartReminders.
  ///
  /// In en, this message translates to:
  /// **'Start with these reminders'**
  String get permStartReminders;

  /// No description provided for @permStartRemindersNote.
  ///
  /// In en, this message translates to:
  /// **'They need notifications. Change or turn them off any time under Goal reminders.'**
  String get permStartRemindersNote;

  /// No description provided for @settingsPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get settingsPermissions;

  /// No description provided for @nowStartTimer.
  ///
  /// In en, this message translates to:
  /// **'Start timer'**
  String get nowStartTimer;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Your Personality'**
  String get aboutTitle;

  /// No description provided for @aboutHomeInfo.
  ///
  /// In en, this message translates to:
  /// **'Your face, body, posture, style and progress in one place'**
  String get aboutHomeInfo;

  /// No description provided for @aboutIntro.
  ///
  /// In en, this message translates to:
  /// **'What your own checks have shown so far. There\'s no score: just where you are, and where you could go next.'**
  String get aboutIntro;

  /// No description provided for @aboutFace.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get aboutFace;

  /// No description provided for @aboutFaceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No face analysis yet. It estimates your face shape and suggests styles.'**
  String get aboutFaceEmpty;

  /// No description provided for @aboutAlsoClose.
  ///
  /// In en, this message translates to:
  /// **'Also close to'**
  String get aboutAlsoClose;

  /// No description provided for @aboutChecked.
  ///
  /// In en, this message translates to:
  /// **'Last checked'**
  String get aboutChecked;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get aboutBody;

  /// No description provided for @aboutBodyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add your height and weight to see your body summary.'**
  String get aboutBodyEmpty;

  /// No description provided for @aboutBmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get aboutBmi;

  /// No description provided for @aboutBmiNote.
  ///
  /// In en, this message translates to:
  /// **'BMI is a rough guide: it says nothing about muscle, shape or health on its own.'**
  String get aboutBmiNote;

  /// No description provided for @aboutPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get aboutPosture;

  /// No description provided for @aboutPostureEmpty.
  ///
  /// In en, this message translates to:
  /// **'No posture check yet. Two minutes with the camera shows your alignment.'**
  String get aboutPostureEmpty;

  /// No description provided for @aboutView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get aboutView;

  /// No description provided for @aboutStyle.
  ///
  /// In en, this message translates to:
  /// **'Style & colours'**
  String get aboutStyle;

  /// No description provided for @aboutStyleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Find your colours to see the palette that suits you.'**
  String get aboutStyleEmpty;

  /// No description provided for @aboutUndertone.
  ///
  /// In en, this message translates to:
  /// **'Undertone'**
  String get aboutUndertone;

  /// No description provided for @aboutDepth.
  ///
  /// In en, this message translates to:
  /// **'Skin depth'**
  String get aboutDepth;

  /// No description provided for @aboutProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get aboutProgress;

  /// No description provided for @aboutLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get aboutLevel;

  /// No description provided for @aboutStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get aboutStreak;

  /// No description provided for @aboutPostureChecks.
  ///
  /// In en, this message translates to:
  /// **'Posture checks'**
  String get aboutPostureChecks;

  /// No description provided for @aboutProgressPhotos.
  ///
  /// In en, this message translates to:
  /// **'Progress photos'**
  String get aboutProgressPhotos;

  /// No description provided for @aboutGrow.
  ///
  /// In en, this message translates to:
  /// **'Room to grow'**
  String get aboutGrow;

  /// No description provided for @aboutGrowEmpty.
  ///
  /// In en, this message translates to:
  /// **'Every area is on track this week.'**
  String get aboutGrowEmpty;

  /// No description provided for @aboutCheckNow.
  ///
  /// In en, this message translates to:
  /// **'Check now'**
  String get aboutCheckNow;

  /// No description provided for @aboutSeeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get aboutSeeMore;

  /// No description provided for @skillsMindBody.
  ///
  /// In en, this message translates to:
  /// **'Yoga & mind-body'**
  String get skillsMindBody;

  /// No description provided for @practiceRoutine.
  ///
  /// In en, this message translates to:
  /// **'My practice'**
  String get practiceRoutine;

  /// No description provided for @practiceItem.
  ///
  /// In en, this message translates to:
  /// **'Practise {skill} · {minutes} min'**
  String practiceItem(String skill, int minutes);

  /// No description provided for @practiceAdded.
  ///
  /// In en, this message translates to:
  /// **'{skill} is in your day, with a reminder'**
  String practiceAdded(String skill);

  /// No description provided for @practiceAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {skill} to my day'**
  String practiceAddTitle(String skill);

  /// No description provided for @practiceAddInfo.
  ///
  /// In en, this message translates to:
  /// **'A daily slot at a time you choose, with a reminder. It shows in your day plan.'**
  String get practiceAddInfo;

  /// No description provided for @practiceTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get practiceTime;

  /// No description provided for @practiceLength.
  ///
  /// In en, this message translates to:
  /// **'How long'**
  String get practiceLength;

  /// No description provided for @practiceAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add to my day'**
  String get practiceAddButton;

  /// No description provided for @goalStrength.
  ///
  /// In en, this message translates to:
  /// **'Build strength'**
  String get goalStrength;

  /// No description provided for @goalMindfulness.
  ///
  /// In en, this message translates to:
  /// **'Calm & mindfulness'**
  String get goalMindfulness;

  /// No description provided for @goalEnergy.
  ///
  /// In en, this message translates to:
  /// **'More energy'**
  String get goalEnergy;

  /// No description provided for @goalNutrition.
  ///
  /// In en, this message translates to:
  /// **'Eat well'**
  String get goalNutrition;

  /// No description provided for @goalSkinCare.
  ///
  /// In en, this message translates to:
  /// **'Skin care'**
  String get goalSkinCare;

  /// No description provided for @goalConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get goalConfidence;

  /// No description provided for @ideasTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit ideas'**
  String get ideasTitle;

  /// No description provided for @ideasIntro.
  ///
  /// In en, this message translates to:
  /// **'Common habits people find helpful. Pick one, then change the name or days before adding it.'**
  String get ideasIntro;

  /// No description provided for @ideasBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse habit ideas'**
  String get ideasBrowse;

  /// No description provided for @ideaGroupFood.
  ///
  /// In en, this message translates to:
  /// **'Food & drink'**
  String get ideaGroupFood;

  /// No description provided for @ideaGroupBody.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get ideaGroupBody;

  /// No description provided for @ideaGroupMind.
  ///
  /// In en, this message translates to:
  /// **'Mind'**
  String get ideaGroupMind;

  /// No description provided for @ideaGroupSleep.
  ///
  /// In en, this message translates to:
  /// **'Evening & sleep'**
  String get ideaGroupSleep;

  /// No description provided for @ideaWaterOnWaking.
  ///
  /// In en, this message translates to:
  /// **'A glass of water after waking'**
  String get ideaWaterOnWaking;

  /// No description provided for @ideaFruitDaily.
  ///
  /// In en, this message translates to:
  /// **'Eat a fruit'**
  String get ideaFruitDaily;

  /// No description provided for @ideaVegEveryMeal.
  ///
  /// In en, this message translates to:
  /// **'Vegetables with lunch and dinner'**
  String get ideaVegEveryMeal;

  /// No description provided for @ideaHomeCooked.
  ///
  /// In en, this message translates to:
  /// **'Eat a home-cooked meal'**
  String get ideaHomeCooked;

  /// No description provided for @ideaNoSugaryDrinks.
  ///
  /// In en, this message translates to:
  /// **'No sugary drinks'**
  String get ideaNoSugaryDrinks;

  /// No description provided for @ideaWalkAfterMeals.
  ///
  /// In en, this message translates to:
  /// **'10-minute walk after a meal'**
  String get ideaWalkAfterMeals;

  /// No description provided for @ideaStretchMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning stretch'**
  String get ideaStretchMorning;

  /// No description provided for @ideaStairs.
  ///
  /// In en, this message translates to:
  /// **'Take the stairs'**
  String get ideaStairs;

  /// No description provided for @ideaRead10.
  ///
  /// In en, this message translates to:
  /// **'Read for 10 minutes'**
  String get ideaRead10;

  /// No description provided for @ideaBreathe.
  ///
  /// In en, this message translates to:
  /// **'2 minutes of slow breathing'**
  String get ideaBreathe;

  /// No description provided for @ideaGratitude.
  ///
  /// In en, this message translates to:
  /// **'Note one good thing from today'**
  String get ideaGratitude;

  /// No description provided for @ideaNoScreensBed.
  ///
  /// In en, this message translates to:
  /// **'No screens 30 min before bed'**
  String get ideaNoScreensBed;

  /// No description provided for @ideaSameBedtime.
  ///
  /// In en, this message translates to:
  /// **'Go to bed at the same time'**
  String get ideaSameBedtime;

  /// No description provided for @ideaSkincareNight.
  ///
  /// In en, this message translates to:
  /// **'Evening skin care'**
  String get ideaSkincareNight;

  /// No description provided for @mealIdeasFor.
  ///
  /// In en, this message translates to:
  /// **'Ideas for {meal}'**
  String mealIdeasFor(String meal);

  /// No description provided for @mealIdeasInfo.
  ///
  /// In en, this message translates to:
  /// **'Matched to your diet and local cuisine. Tap + to log one.'**
  String get mealIdeasInfo;

  /// No description provided for @mealIdeaNutrition.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal · {protein} g protein'**
  String mealIdeaNutrition(int kcal, int protein);

  /// No description provided for @mealIdeaLog.
  ///
  /// In en, this message translates to:
  /// **'Log this'**
  String get mealIdeaLog;

  /// No description provided for @mealIdeaLogged.
  ///
  /// In en, this message translates to:
  /// **'Logged: {dish}'**
  String mealIdeaLogged(String dish);

  /// No description provided for @sampleDayTitle.
  ///
  /// In en, this message translates to:
  /// **'A sample day'**
  String get sampleDayTitle;

  /// No description provided for @sampleDayAnother.
  ///
  /// In en, this message translates to:
  /// **'Another'**
  String get sampleDayAnother;

  /// No description provided for @sampleDayTotals.
  ///
  /// In en, this message translates to:
  /// **'About {kcal} kcal and {protein} g protein in all'**
  String sampleDayTotals(int kcal, int protein);

  /// No description provided for @sampleDayNote.
  ///
  /// In en, this message translates to:
  /// **'Sized to your plan, or to your estimated needs from height and weight. A guide, not a prescription.'**
  String get sampleDayNote;

  /// No description provided for @skillsPopular.
  ///
  /// In en, this message translates to:
  /// **'Most popular first'**
  String get skillsPopular;

  /// No description provided for @contentWifiOnlyInfo.
  ///
  /// In en, this message translates to:
  /// **'Small packs (under 2 MB) still download on mobile data.'**
  String get contentWifiOnlyInfo;

  /// No description provided for @contentMobileTitle.
  ///
  /// In en, this message translates to:
  /// **'Use mobile data?'**
  String get contentMobileTitle;

  /// No description provided for @contentMobileBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re not on Wi-Fi. Download {pack} ({size}) using mobile data now?'**
  String contentMobileBody(String pack, String size);

  /// No description provided for @contentMobileUse.
  ///
  /// In en, this message translates to:
  /// **'Download now'**
  String get contentMobileUse;

  /// No description provided for @contentMobileWait.
  ///
  /// In en, this message translates to:
  /// **'Wait for Wi-Fi'**
  String get contentMobileWait;

  /// No description provided for @notifSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications & sounds'**
  String get notifSettingsTitle;

  /// No description provided for @notifSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder sound, vibration, pop-ups and snooze'**
  String get notifSettingsSubtitle;

  /// No description provided for @notifSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get notifSound;

  /// No description provided for @soundSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone default'**
  String get soundSystem;

  /// No description provided for @soundSilent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get soundSilent;

  /// No description provided for @soundChime.
  ///
  /// In en, this message translates to:
  /// **'Chime'**
  String get soundChime;

  /// No description provided for @soundBell.
  ///
  /// In en, this message translates to:
  /// **'Bell'**
  String get soundBell;

  /// No description provided for @soundMarimba.
  ///
  /// In en, this message translates to:
  /// **'Marimba'**
  String get soundMarimba;

  /// No description provided for @soundKalimba.
  ///
  /// In en, this message translates to:
  /// **'Kalimba'**
  String get soundKalimba;

  /// No description provided for @soundZenBowl.
  ///
  /// In en, this message translates to:
  /// **'Singing bowl'**
  String get soundZenBowl;

  /// No description provided for @soundDroplet.
  ///
  /// In en, this message translates to:
  /// **'Water drop'**
  String get soundDroplet;

  /// No description provided for @soundPop.
  ///
  /// In en, this message translates to:
  /// **'Soft pop'**
  String get soundPop;

  /// No description provided for @soundRise.
  ///
  /// In en, this message translates to:
  /// **'Rising notes'**
  String get soundRise;

  /// No description provided for @soundHarp.
  ///
  /// In en, this message translates to:
  /// **'Harp'**
  String get soundHarp;

  /// No description provided for @soundSparkle.
  ///
  /// In en, this message translates to:
  /// **'Sparkle'**
  String get soundSparkle;

  /// No description provided for @soundPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get soundPulse;

  /// No description provided for @soundBirdsong.
  ///
  /// In en, this message translates to:
  /// **'Birdsong'**
  String get soundBirdsong;

  /// No description provided for @soundPreview.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get soundPreview;

  /// No description provided for @notifVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get notifVibration;

  /// No description provided for @vibrationOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get vibrationOff;

  /// No description provided for @vibrationGentle.
  ///
  /// In en, this message translates to:
  /// **'Gentle'**
  String get vibrationGentle;

  /// No description provided for @vibrationStandard.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get vibrationStandard;

  /// No description provided for @vibrationStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get vibrationStrong;

  /// No description provided for @notifBehaviour.
  ///
  /// In en, this message translates to:
  /// **'How reminders appear'**
  String get notifBehaviour;

  /// No description provided for @notifPopUp.
  ///
  /// In en, this message translates to:
  /// **'Pop up on screen'**
  String get notifPopUp;

  /// No description provided for @notifPopUpInfo.
  ///
  /// In en, this message translates to:
  /// **'Show reminders briefly over other apps'**
  String get notifPopUpInfo;

  /// No description provided for @notifHideLock.
  ///
  /// In en, this message translates to:
  /// **'Hide details on lock screen'**
  String get notifHideLock;

  /// No description provided for @notifHideLockInfo.
  ///
  /// In en, this message translates to:
  /// **'The lock screen only shows that you have a reminder'**
  String get notifHideLockInfo;

  /// No description provided for @notifSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze for'**
  String get notifSnooze;

  /// No description provided for @notifSchedule.
  ///
  /// In en, this message translates to:
  /// **'Reminder times & quiet hours'**
  String get notifSchedule;

  /// No description provided for @notifScheduleInfo.
  ///
  /// In en, this message translates to:
  /// **'Turn reminders on or off and choose when they stay quiet'**
  String get notifScheduleInfo;

  /// No description provided for @notifTest.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get notifTest;

  /// No description provided for @notifTestTitle.
  ///
  /// In en, this message translates to:
  /// **'This is how reminders will look'**
  String get notifTestTitle;

  /// No description provided for @notifTestBody.
  ///
  /// In en, this message translates to:
  /// **'Sound: {sound}'**
  String notifTestBody(String sound);

  /// No description provided for @notifTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get notifTestSent;

  /// No description provided for @notifPhoneNote.
  ///
  /// In en, this message translates to:
  /// **'Your phone’s Do Not Disturb and volume settings still apply.'**
  String get notifPhoneNote;

  /// No description provided for @settingsAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent colour'**
  String get settingsAccent;

  /// No description provided for @accentTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get accentTeal;

  /// No description provided for @accentOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean blue'**
  String get accentOcean;

  /// No description provided for @accentIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get accentIndigo;

  /// No description provided for @accentPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get accentPurple;

  /// No description provided for @accentRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get accentRose;

  /// No description provided for @accentCoral.
  ///
  /// In en, this message translates to:
  /// **'Coral'**
  String get accentCoral;

  /// No description provided for @accentAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get accentAmber;

  /// No description provided for @accentForest.
  ///
  /// In en, this message translates to:
  /// **'Forest green'**
  String get accentForest;

  /// No description provided for @settingsTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get settingsTextSize;

  /// No description provided for @textSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get textSizeSmall;

  /// No description provided for @textSizeDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get textSizeDefault;

  /// No description provided for @textSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get textSizeLarge;

  /// No description provided for @textSizeLarger.
  ///
  /// In en, this message translates to:
  /// **'Larger'**
  String get textSizeLarger;

  /// No description provided for @settingsReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce animations'**
  String get settingsReduceMotion;

  /// No description provided for @settingsReduceMotionInfo.
  ///
  /// In en, this message translates to:
  /// **'Fewer moving effects across the app'**
  String get settingsReduceMotionInfo;

  /// No description provided for @reminderActionSnoozeFor.
  ///
  /// In en, this message translates to:
  /// **'Snooze {minutes} min'**
  String reminderActionSnoozeFor(int minutes);

  /// No description provided for @snapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Your snapshot'**
  String get snapshotTitle;

  /// No description provided for @snapshotInfo.
  ///
  /// In en, this message translates to:
  /// **'Ratings for each area come from your own checks and logs this week. They\'re a guide, not a judgement.'**
  String get snapshotInfo;

  /// No description provided for @snapshotEmpty.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet. Weigh in, run a posture check or log a few days, and your ratings and suggested exercises will appear here.'**
  String get snapshotEmpty;

  /// No description provided for @snapshotActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get snapshotActivity;

  /// No description provided for @snapshotHydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get snapshotHydration;

  /// No description provided for @snapshotConsistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get snapshotConsistency;

  /// No description provided for @ratingGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get ratingGreat;

  /// No description provided for @ratingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @ratingFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get ratingFair;

  /// No description provided for @ratingNeedsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs work'**
  String get ratingNeedsWork;

  /// No description provided for @snapshotBmi.
  ///
  /// In en, this message translates to:
  /// **'BMI {value}'**
  String snapshotBmi(String value);

  /// No description provided for @snapshotMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} active min a day'**
  String snapshotMinutes(int minutes);

  /// No description provided for @snapshotHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h a night'**
  String snapshotHours(String hours);

  /// No description provided for @snapshotOnTarget.
  ///
  /// In en, this message translates to:
  /// **'On target {percent}% of logged days'**
  String snapshotOnTarget(int percent);

  /// No description provided for @snapshotImprove.
  ///
  /// In en, this message translates to:
  /// **'Key areas to improve'**
  String get snapshotImprove;

  /// No description provided for @improveBody.
  ///
  /// In en, this message translates to:
  /// **'Aim for steady, gentle change: daily walks, balanced meals and enough protein.'**
  String get improveBody;

  /// No description provided for @improvePosture.
  ///
  /// In en, this message translates to:
  /// **'Short posture breaks every hour and the stretches below help most.'**
  String get improvePosture;

  /// No description provided for @improveActivity.
  ///
  /// In en, this message translates to:
  /// **'Start with a 10-minute walk after a meal, then build up.'**
  String get improveActivity;

  /// No description provided for @improveSleep.
  ///
  /// In en, this message translates to:
  /// **'Keep the same bedtime and put screens away 30 minutes before.'**
  String get improveSleep;

  /// No description provided for @improveHydration.
  ///
  /// In en, this message translates to:
  /// **'Keep a bottle nearby and drink a glass with each meal.'**
  String get improveHydration;

  /// No description provided for @improveConsistency.
  ///
  /// In en, this message translates to:
  /// **'Do one small thing every day — even 2 minutes keeps your streak going.'**
  String get improveConsistency;

  /// No description provided for @snapshotSuggested.
  ///
  /// In en, this message translates to:
  /// **'Exercises suggested for you'**
  String get snapshotSuggested;

  /// No description provided for @reasonPosture.
  ///
  /// In en, this message translates to:
  /// **'Helps with: {issue}'**
  String reasonPosture(String issue);

  /// No description provided for @reasonGain.
  ///
  /// In en, this message translates to:
  /// **'Builds strength for a healthy weight'**
  String get reasonGain;

  /// No description provided for @reasonMove.
  ///
  /// In en, this message translates to:
  /// **'Burns energy and is easy on the joints'**
  String get reasonMove;

  /// No description provided for @reasonActivity.
  ///
  /// In en, this message translates to:
  /// **'Gets you moving more each day'**
  String get reasonActivity;

  /// No description provided for @reasonSleep.
  ///
  /// In en, this message translates to:
  /// **'Calms body and mind before bed'**
  String get reasonSleep;

  /// No description provided for @reasonDaily.
  ///
  /// In en, this message translates to:
  /// **'Quick and easy to do every day'**
  String get reasonDaily;

  /// No description provided for @reasonStart.
  ///
  /// In en, this message translates to:
  /// **'A good place to start'**
  String get reasonStart;

  /// No description provided for @reasonGoal.
  ///
  /// In en, this message translates to:
  /// **'For your goal: {goal}'**
  String reasonGoal(String goal);

  /// No description provided for @snapshotNote.
  ///
  /// In en, this message translates to:
  /// **'General wellness guidance, not medical advice. Stop any exercise that hurts.'**
  String get snapshotNote;

  /// No description provided for @widgetGrowthTitle.
  ///
  /// In en, this message translates to:
  /// **'My growth'**
  String get widgetGrowthTitle;

  /// No description provided for @widgetLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String widgetLevel(int level);

  /// No description provided for @widgetXpToNext.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to level {level}'**
  String widgetXpToNext(int xp, int level);

  /// No description provided for @widgetPlanWeek.
  ///
  /// In en, this message translates to:
  /// **'Plan done, last 7 days'**
  String get widgetPlanWeek;

  /// No description provided for @widgetMinutesOf.
  ///
  /// In en, this message translates to:
  /// **'{done} / {target} min'**
  String widgetMinutesOf(int done, int target);

  /// No description provided for @widgetWeekMinutes.
  ///
  /// In en, this message translates to:
  /// **'This week: {minutes} min'**
  String widgetWeekMinutes(int minutes);

  /// No description provided for @widgetStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get widgetStart;

  /// No description provided for @widgetSinceStart.
  ///
  /// In en, this message translates to:
  /// **'{change} since start'**
  String widgetSinceStart(String change);

  /// No description provided for @widgetLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log your weight to see a trend'**
  String get widgetLogWeight;

  /// No description provided for @widgetPercentOfGoal.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of today\'s goal'**
  String widgetPercentOfGoal(int percent);

  /// No description provided for @widgetSleepGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal {hours} h a night'**
  String widgetSleepGoal(String hours);

  /// No description provided for @widgetFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Your focus'**
  String get widgetFocusTitle;

  /// No description provided for @widgetFocusAllGood.
  ///
  /// In en, this message translates to:
  /// **'Looking good'**
  String get widgetFocusAllGood;

  /// No description provided for @widgetFocusKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep logging and checking in to see what to work on next.'**
  String get widgetFocusKeepGoing;

  /// No description provided for @widgetTryToday.
  ///
  /// In en, this message translates to:
  /// **'Try today'**
  String get widgetTryToday;

  /// No description provided for @widgetHabitsDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String widgetHabitsDone(int done, int total);

  /// No description provided for @widgetHabitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No habits due today. Add one in the app.'**
  String get widgetHabitsEmpty;

  /// No description provided for @faceBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance & proportions'**
  String get faceBalanceTitle;

  /// No description provided for @faceBalanceInfo.
  ///
  /// In en, this message translates to:
  /// **'How evenly each feature sits either side of your face\'s midline. No face is perfectly symmetric — most people measure 90–98%. It\'s for interest, not a score.'**
  String get faceBalanceInfo;

  /// No description provided for @faceBalanceEyes.
  ///
  /// In en, this message translates to:
  /// **'Eyes'**
  String get faceBalanceEyes;

  /// No description provided for @faceBalanceCheeks.
  ///
  /// In en, this message translates to:
  /// **'Cheeks'**
  String get faceBalanceCheeks;

  /// No description provided for @faceBalanceJaw.
  ///
  /// In en, this message translates to:
  /// **'Jaw'**
  String get faceBalanceJaw;

  /// No description provided for @faceBalanceMouth.
  ///
  /// In en, this message translates to:
  /// **'Mouth'**
  String get faceBalanceMouth;

  /// No description provided for @faceBalancePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% even'**
  String faceBalancePercent(int percent);

  /// No description provided for @faceProportionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Proportions'**
  String get faceProportionsTitle;

  /// No description provided for @faceEyeSpacing.
  ///
  /// In en, this message translates to:
  /// **'Eye spacing'**
  String get faceEyeSpacing;

  /// No description provided for @faceEyeSpacingValue.
  ///
  /// In en, this message translates to:
  /// **'{value} · {kind}'**
  String faceEyeSpacingValue(String value, String kind);

  /// No description provided for @faceCloseSet.
  ///
  /// In en, this message translates to:
  /// **'closer-set'**
  String get faceCloseSet;

  /// No description provided for @faceWideSet.
  ///
  /// In en, this message translates to:
  /// **'wide-set'**
  String get faceWideSet;

  /// No description provided for @faceAverageSet.
  ///
  /// In en, this message translates to:
  /// **'average'**
  String get faceAverageSet;

  /// No description provided for @faceMouthWidth.
  ///
  /// In en, this message translates to:
  /// **'Mouth width to eye spacing'**
  String get faceMouthWidth;

  /// No description provided for @makeupTitle.
  ///
  /// In en, this message translates to:
  /// **'Makeup guide'**
  String get makeupTitle;

  /// No description provided for @makeupIntro.
  ///
  /// In en, this message translates to:
  /// **'Where to place blush, contour and highlight for your face shape, and shades that suit your undertone. All optional — wear what you enjoy.'**
  String get makeupIntro;

  /// No description provided for @makeupNoShape.
  ///
  /// In en, this message translates to:
  /// **'Find your face shape'**
  String get makeupNoShape;

  /// No description provided for @makeupNoUndertone.
  ///
  /// In en, this message translates to:
  /// **'Find your undertone'**
  String get makeupNoUndertone;

  /// No description provided for @makeupPlacementFor.
  ///
  /// In en, this message translates to:
  /// **'Placement for {shape} faces'**
  String makeupPlacementFor(String shape);

  /// No description provided for @makeupBlush.
  ///
  /// In en, this message translates to:
  /// **'Blush'**
  String get makeupBlush;

  /// No description provided for @makeupContour.
  ///
  /// In en, this message translates to:
  /// **'Contour'**
  String get makeupContour;

  /// No description provided for @makeupHighlight.
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get makeupHighlight;

  /// No description provided for @makeupLips.
  ///
  /// In en, this message translates to:
  /// **'Lips'**
  String get makeupLips;

  /// No description provided for @makeupEyes.
  ///
  /// In en, this message translates to:
  /// **'Eyes'**
  String get makeupEyes;

  /// No description provided for @makeupShadesFor.
  ///
  /// In en, this message translates to:
  /// **'Shades for your {undertone}'**
  String makeupShadesFor(String undertone);

  /// No description provided for @makeupShadesAll.
  ///
  /// In en, this message translates to:
  /// **'Shades to explore'**
  String get makeupShadesAll;

  /// No description provided for @makeupTryOn.
  ///
  /// In en, this message translates to:
  /// **'Try on with the camera'**
  String get makeupTryOn;

  /// No description provided for @makeupBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get makeupBasics;

  /// No description provided for @makeupNote.
  ///
  /// In en, this message translates to:
  /// **'General tips, not medical advice. Check ingredients if you have sensitive skin.'**
  String get makeupNote;

  /// No description provided for @makeupOpen.
  ///
  /// In en, this message translates to:
  /// **'Makeup guide'**
  String get makeupOpen;

  /// No description provided for @qaTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask about style'**
  String get qaTitle;

  /// No description provided for @qaSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search, e.g. frizz, foundation, beard'**
  String get qaSearchHint;

  /// No description provided for @qaAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get qaAll;

  /// No description provided for @qaSkin.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get qaSkin;

  /// No description provided for @qaStyle.
  ///
  /// In en, this message translates to:
  /// **'Clothes & style'**
  String get qaStyle;

  /// No description provided for @qaColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get qaColour;

  /// No description provided for @qaNone.
  ///
  /// In en, this message translates to:
  /// **'No answers match yet. Try another word or topic.'**
  String get qaNone;

  /// No description provided for @qaNote.
  ///
  /// In en, this message translates to:
  /// **'Answers are built into the app and work offline. Your searches never leave your phone. General guidance, not medical advice.'**
  String get qaNote;

  /// No description provided for @trendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Style trends'**
  String get trendsTitle;

  /// No description provided for @trendsInfo.
  ///
  /// In en, this message translates to:
  /// **'What\'s popular right now — take what suits you and skip the rest. Download the trends pack in Content packs for updates.'**
  String get trendsInfo;

  /// No description provided for @trendAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get trendAccessories;

  /// No description provided for @lookbookTitle.
  ///
  /// In en, this message translates to:
  /// **'My lookbook'**
  String get lookbookTitle;

  /// No description provided for @lookbookInfo.
  ///
  /// In en, this message translates to:
  /// **'Everything you saved with ♡, in one place. Tap a style to try it on.'**
  String get lookbookInfo;

  /// No description provided for @lookbookEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet. Tap ♡ on hairstyles, beards, glasses, makeup shades or clothes and they\'ll gather here.'**
  String get lookbookEmpty;

  /// No description provided for @lookbookFindStyles.
  ///
  /// In en, this message translates to:
  /// **'Find styles for my face'**
  String get lookbookFindStyles;

  /// No description provided for @lookbookColours.
  ///
  /// In en, this message translates to:
  /// **'My best colours'**
  String get lookbookColours;

  /// No description provided for @lookbookClothes.
  ///
  /// In en, this message translates to:
  /// **'Favourite clothes'**
  String get lookbookClothes;

  /// No description provided for @lookbookOutfits.
  ///
  /// In en, this message translates to:
  /// **'Saved outfits'**
  String get lookbookOutfits;

  /// No description provided for @featureLookbook.
  ///
  /// In en, this message translates to:
  /// **'My lookbook'**
  String get featureLookbook;

  /// No description provided for @featureMakeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup guide'**
  String get featureMakeup;

  /// No description provided for @featureStyleQa.
  ///
  /// In en, this message translates to:
  /// **'Ask about style'**
  String get featureStyleQa;

  /// No description provided for @featureTrends.
  ///
  /// In en, this message translates to:
  /// **'Style trends'**
  String get featureTrends;

  /// No description provided for @coachTitle.
  ///
  /// In en, this message translates to:
  /// **'AI coach'**
  String get coachTitle;

  /// No description provided for @coachHint.
  ///
  /// In en, this message translates to:
  /// **'Ask your coach…'**
  String get coachHint;

  /// No description provided for @coachSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get coachSend;

  /// No description provided for @coachStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get coachStop;

  /// No description provided for @coachClear.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get coachClear;

  /// No description provided for @coachOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get coachOpen;

  /// No description provided for @coachNothing.
  ///
  /// In en, this message translates to:
  /// **'I couldn\'t find anything on that in the app yet. Try other words, or ask about fitness, food, sleep, posture or style.'**
  String get coachNothing;

  /// No description provided for @coachFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'From the app\'s guides'**
  String get coachFromLibrary;

  /// No description provided for @coachNote.
  ///
  /// In en, this message translates to:
  /// **'Runs on your phone; your questions never leave it. General wellness guidance, not medical advice.'**
  String get coachNote;

  /// No description provided for @coachSearchMode.
  ///
  /// In en, this message translates to:
  /// **'Smart search mode'**
  String get coachSearchMode;

  /// No description provided for @coachSearchModeInfo.
  ///
  /// In en, this message translates to:
  /// **'This phone is best suited to quick answers from the app\'s guides, shown with pictures and links. The writing model needs a phone with more memory.'**
  String get coachSearchModeInfo;

  /// No description provided for @coachReady.
  ///
  /// In en, this message translates to:
  /// **'Offline AI is ready'**
  String get coachReady;

  /// No description provided for @coachReadyInfo.
  ///
  /// In en, this message translates to:
  /// **'Answers are written on your phone from the app\'s guides and your data.'**
  String get coachReadyInfo;

  /// No description provided for @coachGetModel.
  ///
  /// In en, this message translates to:
  /// **'Add the offline AI (optional)'**
  String get coachGetModel;

  /// No description provided for @coachGetModelInfo.
  ///
  /// In en, this message translates to:
  /// **'Download a small language model once ({size}) and your coach writes full answers, offline. Until then it shows the best matches from the app\'s guides.'**
  String coachGetModelInfo(String size);

  /// No description provided for @coachDownload.
  ///
  /// In en, this message translates to:
  /// **'Download ({size})'**
  String coachDownload(String size);

  /// No description provided for @coachRemoveModel.
  ///
  /// In en, this message translates to:
  /// **'Remove offline AI'**
  String get coachRemoveModel;

  /// No description provided for @coachNoSpace.
  ///
  /// In en, this message translates to:
  /// **'Not enough free space on this phone.'**
  String get coachNoSpace;

  /// No description provided for @coachKindWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get coachKindWorkout;

  /// No description provided for @coachKindSection.
  ///
  /// In en, this message translates to:
  /// **'In the app'**
  String get coachKindSection;

  /// No description provided for @coachPromptFocus.
  ///
  /// In en, this message translates to:
  /// **'What should I work on first?'**
  String get coachPromptFocus;

  /// No description provided for @coachPromptPosture.
  ///
  /// In en, this message translates to:
  /// **'Exercises for my posture'**
  String get coachPromptPosture;

  /// No description provided for @coachPromptDinner.
  ///
  /// In en, this message translates to:
  /// **'A high-protein dinner idea'**
  String get coachPromptDinner;

  /// No description provided for @coachPromptHair.
  ///
  /// In en, this message translates to:
  /// **'Which hairstyle suits my face?'**
  String get coachPromptHair;

  /// No description provided for @coachPromptSleep.
  ///
  /// In en, this message translates to:
  /// **'How can I sleep better?'**
  String get coachPromptSleep;

  /// No description provided for @coachPromptYoga.
  ///
  /// In en, this message translates to:
  /// **'Easy yoga for back stiffness'**
  String get coachPromptYoga;

  /// No description provided for @coachHomeCard.
  ///
  /// In en, this message translates to:
  /// **'Ask your AI coach'**
  String get coachHomeCard;

  /// No description provided for @coachHomeCardInfo.
  ///
  /// In en, this message translates to:
  /// **'Fitness, food, posture and style answers, with pictures — on your phone.'**
  String get coachHomeCardInfo;

  /// No description provided for @letsTry.
  ///
  /// In en, this message translates to:
  /// **'Let\'s try {name}'**
  String letsTry(String name);

  /// No description provided for @letsTryYourFavourite.
  ///
  /// In en, this message translates to:
  /// **'Your go-to workout'**
  String get letsTryYourFavourite;

  /// No description provided for @letsTryPopular.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get letsTryPopular;

  /// No description provided for @workoutsLog.
  ///
  /// In en, this message translates to:
  /// **'Exercise log'**
  String get workoutsLog;

  /// No description provided for @featureExerciseHub.
  ///
  /// In en, this message translates to:
  /// **'Exercise & workouts'**
  String get featureExerciseHub;

  /// No description provided for @sessionFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get sessionFullBody;

  /// No description provided for @sessionUpper.
  ///
  /// In en, this message translates to:
  /// **'Upper body'**
  String get sessionUpper;

  /// No description provided for @sessionLower.
  ///
  /// In en, this message translates to:
  /// **'Lower body & glutes'**
  String get sessionLower;

  /// No description provided for @sessionCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get sessionCore;

  /// No description provided for @sessionCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get sessionCardio;

  /// No description provided for @sessionMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get sessionMobility;

  /// No description provided for @sessionYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get sessionYoga;

  /// No description provided for @sessionPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get sessionPosture;

  /// No description provided for @sessionRest.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get sessionRest;

  /// No description provided for @planSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'{type} session'**
  String planSessionTitle(String type);

  /// No description provided for @doseReps.
  ///
  /// In en, this message translates to:
  /// **'{count} reps'**
  String doseReps(int count);

  /// No description provided for @doseSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String doseSeconds(int seconds);

  /// No description provided for @doseMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String doseMinutes(int minutes);

  /// No description provided for @trainingTitle.
  ///
  /// In en, this message translates to:
  /// **'My training plan'**
  String get trainingTitle;

  /// No description provided for @trainingEntryInfo.
  ///
  /// In en, this message translates to:
  /// **'A day-by-day plan with sets and reps that grows with you'**
  String get trainingEntryInfo;

  /// No description provided for @trainingSettings.
  ///
  /// In en, this message translates to:
  /// **'Training settings'**
  String get trainingSettings;

  /// No description provided for @trainingSummary.
  ///
  /// In en, this message translates to:
  /// **'{level} · {days} days a week · {minutes} min'**
  String trainingSummary(String level, int days, int minutes);

  /// No description provided for @planDayInfo.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises · about {minutes} min'**
  String planDayInfo(int count, int minutes);

  /// No description provided for @planRestInfo.
  ///
  /// In en, this message translates to:
  /// **'Recover today: an easy walk or a gentle stretch is plenty.'**
  String get planRestInfo;

  /// No description provided for @planProgressInfo.
  ///
  /// In en, this message translates to:
  /// **'After each session, tell us how it felt. Too easy, or just right twice in a row, adds reps or a set; too hard eases off. As you get stronger, your level goes up and the plan adjusts by itself.'**
  String get planProgressInfo;

  /// No description provided for @trainingLevel.
  ///
  /// In en, this message translates to:
  /// **'Fitness level'**
  String get trainingLevel;

  /// No description provided for @trainingDays.
  ///
  /// In en, this message translates to:
  /// **'Days a week'**
  String get trainingDays;

  /// No description provided for @trainingDaysValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String trainingDaysValue(int days);

  /// No description provided for @trainingMinutes.
  ///
  /// In en, this message translates to:
  /// **'Time per session'**
  String get trainingMinutes;

  /// No description provided for @trainingEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get trainingEquipment;

  /// No description provided for @equipmentNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get equipmentNone;

  /// No description provided for @equipmentHome.
  ///
  /// In en, this message translates to:
  /// **'Chair & backpack'**
  String get equipmentHome;

  /// No description provided for @trainingFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus area'**
  String get trainingFocus;

  /// No description provided for @focusBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get focusBalanced;

  /// No description provided for @focusUpper.
  ///
  /// In en, this message translates to:
  /// **'Upper body'**
  String get focusUpper;

  /// No description provided for @focusLower.
  ///
  /// In en, this message translates to:
  /// **'Lower body & glutes'**
  String get focusLower;

  /// No description provided for @todaysWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get todaysWorkout;

  /// No description provided for @feelQuestion.
  ///
  /// In en, this message translates to:
  /// **'How did that feel?'**
  String get feelQuestion;

  /// No description provided for @feelTooEasy.
  ///
  /// In en, this message translates to:
  /// **'Too easy'**
  String get feelTooEasy;

  /// No description provided for @feelJustRight.
  ///
  /// In en, this message translates to:
  /// **'Just right'**
  String get feelJustRight;

  /// No description provided for @feelTooHard.
  ///
  /// In en, this message translates to:
  /// **'Too hard'**
  String get feelTooHard;

  /// No description provided for @feelNoteHarder.
  ///
  /// In en, this message translates to:
  /// **'Next time you\'ll get a few more reps.'**
  String get feelNoteHarder;

  /// No description provided for @feelNoteSteady.
  ///
  /// In en, this message translates to:
  /// **'Great — one more like this and it steps up.'**
  String get feelNoteSteady;

  /// No description provided for @feelNoteEasier.
  ///
  /// In en, this message translates to:
  /// **'No problem — next time is a little easier.'**
  String get feelNoteEasier;

  /// No description provided for @feelLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Level up! Your plan is now {level}.'**
  String feelLevelUp(String level);

  /// No description provided for @welcomePrivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get welcomePrivateTitle;

  /// No description provided for @welcomePrivateBody.
  ///
  /// In en, this message translates to:
  /// **'No account, no ads. Your data stays on your phone.'**
  String get welcomePrivateBody;

  /// No description provided for @welcomePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'A plan made for you'**
  String get welcomePlanTitle;

  /// No description provided for @welcomePlanBody.
  ///
  /// In en, this message translates to:
  /// **'Daily workouts, meals and habits from your goals — adjusting as you progress.'**
  String get welcomePlanBody;

  /// No description provided for @welcomeAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All in one place'**
  String get welcomeAllTitle;

  /// No description provided for @welcomeAllBody.
  ///
  /// In en, this message translates to:
  /// **'Health, posture, style, skills and an offline AI coach.'**
  String get welcomeAllBody;

  /// No description provided for @onboardingTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your training'**
  String get onboardingTrainingTitle;

  /// No description provided for @onboardingTrainingBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll build a day-by-day plan with sets and reps from your goals. It starts where you are and steps up as you get stronger.'**
  String get onboardingTrainingBody;

  /// No description provided for @onboardingYourWeek.
  ///
  /// In en, this message translates to:
  /// **'Your week'**
  String get onboardingYourWeek;

  /// No description provided for @onboardingWeekNote.
  ///
  /// In en, this message translates to:
  /// **'{days} sessions a week, {count} exercises each, rest days in between.'**
  String onboardingWeekNote(int days, int count);

  /// No description provided for @onboardingTrainingLater.
  ///
  /// In en, this message translates to:
  /// **'You can change all of this later in My training plan.'**
  String get onboardingTrainingLater;

  /// No description provided for @agendaFullDay.
  ///
  /// In en, this message translates to:
  /// **'Show the full day ({count})'**
  String agendaFullDay(int count);

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search or ask anything'**
  String get homeSearchHint;

  /// No description provided for @homeSearchAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask the coach: \"{query}\"'**
  String homeSearchAsk(String query);

  /// No description provided for @homeSearchNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing found. Try another word, or ask the coach.'**
  String get homeSearchNone;

  /// No description provided for @homeSearchTip.
  ///
  /// In en, this message translates to:
  /// **'Find exercises, workouts, meals, hairstyles, answers or any screen — for example \"neck\", \"breakfast\", \"water\" or \"backup\".'**
  String get homeSearchTip;

  /// No description provided for @homeMore.
  ///
  /// In en, this message translates to:
  /// **'More for you'**
  String get homeMore;

  /// No description provided for @homeLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get homeLess;

  /// No description provided for @voiceCuesOn.
  ///
  /// In en, this message translates to:
  /// **'Voice cues on'**
  String get voiceCuesOn;

  /// No description provided for @voiceCuesOff.
  ///
  /// In en, this message translates to:
  /// **'Voice cues off'**
  String get voiceCuesOff;

  /// No description provided for @voiceGetReady.
  ///
  /// In en, this message translates to:
  /// **'Get ready. First: {name}'**
  String voiceGetReady(String name);

  /// No description provided for @voiceWorkReps.
  ///
  /// In en, this message translates to:
  /// **'{name}. {count} reps'**
  String voiceWorkReps(String name, int count);

  /// No description provided for @voiceWorkSeconds.
  ///
  /// In en, this message translates to:
  /// **'{name}. {count} seconds'**
  String voiceWorkSeconds(String name, int count);

  /// No description provided for @voiceOtherSide.
  ///
  /// In en, this message translates to:
  /// **'Other side'**
  String get voiceOtherSide;

  /// No description provided for @voiceSwitchSides.
  ///
  /// In en, this message translates to:
  /// **'Switch sides'**
  String get voiceSwitchSides;

  /// No description provided for @voiceRestNext.
  ///
  /// In en, this message translates to:
  /// **'Rest. Next: {name}'**
  String voiceRestNext(String name);

  /// No description provided for @builderTitle.
  ///
  /// In en, this message translates to:
  /// **'Build your own workout'**
  String get builderTitle;

  /// No description provided for @builderEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit workout'**
  String get builderEditTitle;

  /// No description provided for @builderEntry.
  ///
  /// In en, this message translates to:
  /// **'Build your own'**
  String get builderEntry;

  /// No description provided for @builderEntryInfo.
  ///
  /// In en, this message translates to:
  /// **'Pick exercises, reps or time, and rest'**
  String get builderEntryInfo;

  /// No description provided for @builderName.
  ///
  /// In en, this message translates to:
  /// **'Workout name'**
  String get builderName;

  /// No description provided for @builderRoundsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get builderRoundsLabel;

  /// No description provided for @builderAdd.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get builderAdd;

  /// No description provided for @builderEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add the exercises you want, in the order you\'ll do them.'**
  String get builderEmpty;

  /// No description provided for @builderReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get builderReps;

  /// No description provided for @builderTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get builderTime;

  /// No description provided for @builderRest.
  ///
  /// In en, this message translates to:
  /// **'Rest {count} s'**
  String builderRest(int count);

  /// No description provided for @builderEachSide.
  ///
  /// In en, this message translates to:
  /// **'Each side'**
  String get builderEachSide;

  /// No description provided for @builderSearch.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get builderSearch;

  /// No description provided for @builderDeleteAsk.
  ///
  /// In en, this message translates to:
  /// **'Delete this workout?'**
  String get builderDeleteAsk;

  /// No description provided for @builderSaved.
  ///
  /// In en, this message translates to:
  /// **'Workout saved'**
  String get builderSaved;

  /// No description provided for @builderHint.
  ///
  /// In en, this message translates to:
  /// **'Give it a name and add at least one exercise.'**
  String get builderHint;

  /// No description provided for @builderMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get builderMoveUp;

  /// No description provided for @builderMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get builderMoveDown;

  /// No description provided for @builderRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get builderRemove;

  /// No description provided for @myWorkoutBadge.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get myWorkoutBadge;

  /// No description provided for @myWorkoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Your own workout'**
  String get myWorkoutSummary;

  /// No description provided for @backupNudgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a backup'**
  String get backupNudgeTitle;

  /// No description provided for @backupNudgeBody.
  ///
  /// In en, this message translates to:
  /// **'Your last backup was {count} days ago. Save an encrypted copy so nothing is lost if this phone is.'**
  String backupNudgeBody(int count);

  /// No description provided for @backupNudgeNever.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t backed up yet. Save an encrypted copy so nothing is lost if this phone is.'**
  String get backupNudgeNever;

  /// No description provided for @backupNudgeLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get backupNudgeLater;

  /// No description provided for @backupNudgeNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNudgeNow;

  /// No description provided for @backupWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly backup reminder'**
  String get backupWeekly;

  /// No description provided for @backupWeeklyInfo.
  ///
  /// In en, this message translates to:
  /// **'Home reminds you when a week has passed without a backup. Your password is never stored, so the backup itself is one tap.'**
  String get backupWeeklyInfo;

  /// No description provided for @whatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get whatsNewTitle;

  /// No description provided for @whatsNewCard.
  ///
  /// In en, this message translates to:
  /// **'See what this update brings'**
  String get whatsNewCard;

  /// No description provided for @whatsNewIntro.
  ///
  /// In en, this message translates to:
  /// **'New in this version. Tap any item to try it.'**
  String get whatsNewIntro;

  /// No description provided for @newTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'A training plan that grows with you'**
  String get newTrainingTitle;

  /// No description provided for @newTrainingBody.
  ///
  /// In en, this message translates to:
  /// **'Day-by-day sessions with sets and reps. Tell it how each session felt and it adjusts, then levels you up.'**
  String get newTrainingBody;

  /// No description provided for @newBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'Build your own workout'**
  String get newBuilderTitle;

  /// No description provided for @newBuilderBody.
  ///
  /// In en, this message translates to:
  /// **'Pick exercises, reps or time, rest and rounds. It plays like any guided workout.'**
  String get newBuilderBody;

  /// No description provided for @newVoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice cues'**
  String get newVoiceTitle;

  /// No description provided for @newVoiceBody.
  ///
  /// In en, this message translates to:
  /// **'The workout player says what\'s next, counts down and tells you when to switch sides. Works offline.'**
  String get newVoiceBody;

  /// No description provided for @newSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search everything'**
  String get newSearchTitle;

  /// No description provided for @newSearchBody.
  ///
  /// In en, this message translates to:
  /// **'One search on Home for exercises, workouts, meals, styles and every screen.'**
  String get newSearchBody;

  /// No description provided for @newSwipeTitle.
  ///
  /// In en, this message translates to:
  /// **'A shorter Home, with swipes'**
  String get newSwipeTitle;

  /// No description provided for @newSwipeBody.
  ///
  /// In en, this message translates to:
  /// **'Home shows what\'s next first. Swipe a timeline item right for done, left to skip.'**
  String get newSwipeBody;

  /// No description provided for @newBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly backup reminder'**
  String get newBackupTitle;

  /// No description provided for @newBackupBody.
  ///
  /// In en, this message translates to:
  /// **'A gentle nudge on Home when it\'s been a week since your last encrypted backup.'**
  String get newBackupBody;

  /// No description provided for @agendaUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get agendaUpNext;

  /// No description provided for @agendaShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get agendaShowLess;

  /// No description provided for @dayCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Day complete!'**
  String get dayCompleteTitle;

  /// No description provided for @dayCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Everything on today\'s plan is done. Well done.'**
  String get dayCompleteBody;

  /// No description provided for @greetingNight.
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get greetingNight;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'hi',
    'id',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
