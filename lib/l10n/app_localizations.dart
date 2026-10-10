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
