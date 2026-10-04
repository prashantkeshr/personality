import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('en'),
    Locale('hi'),
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
  /// **'Recommendations come from transparent rules. The optional AI Coach can explain them.'**
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
  /// **'Health Connect'**
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
