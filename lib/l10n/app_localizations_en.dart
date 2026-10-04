// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Personality';

  @override
  String get navHome => 'Home';

  @override
  String get navHealth => 'Health';

  @override
  String get navAnalyze => 'Analyze';

  @override
  String get navCoach => 'Coach';

  @override
  String get navStyle => 'Style';

  @override
  String get todayTitle => 'Today';

  @override
  String get homeEmptyTitle => 'Your day starts here';

  @override
  String get homeEmptyBody =>
      'Your daily plan and progress will appear here as tracking features become available.';

  @override
  String get sectionFeatures => 'Features';

  @override
  String get healthIntro =>
      'Track your body, nutrition, sleep and daily activity.';

  @override
  String get analyzeIntro =>
      'On-device camera analysis. Frames are processed on your phone and discarded.';

  @override
  String get coachIntro =>
      'Recommendations come from transparent rules. The optional AI Coach can explain them.';

  @override
  String get styleIntro =>
      'Clothing, color and outfits based on your measurements and preferences.';

  @override
  String get featureStateAvailable => 'Available';

  @override
  String get featureStateBeta => 'Beta';

  @override
  String get featureStateComingSoon => 'Coming soon';

  @override
  String get featureStateDeviceRequired => 'Not supported on this device';

  @override
  String get featureStateModelRequired => 'Model required';

  @override
  String get featureStateOnlineRequired => 'Internet required';

  @override
  String get featureStatePremium => 'Premium';

  @override
  String get featureProfile => 'Profile';

  @override
  String get featureHeight => 'Height';

  @override
  String get featureBodyMeasurements => 'Body measurements';

  @override
  String get featureWeight => 'Weight';

  @override
  String get featureWater => 'Water';

  @override
  String get featureMeals => 'Meals';

  @override
  String get featureSleep => 'Sleep';

  @override
  String get featureActivity => 'Activity';

  @override
  String get featureExercise => 'Exercise';

  @override
  String get featureHabits => 'Habits';

  @override
  String get featureRoutines => 'Routines';

  @override
  String get featureReminders => 'Reminders';

  @override
  String get featureProgress => 'Progress';

  @override
  String get featureCameraHeight => 'Camera height estimate';

  @override
  String get featurePosture => 'Posture analysis';

  @override
  String get featureExerciseTracking => 'Exercise tracking';

  @override
  String get featureFace => 'Face analysis';

  @override
  String get featureStyle => 'Style recommendations';

  @override
  String get featureWardrobe => 'Wardrobe';

  @override
  String get featureAiCoach => 'AI Coach';

  @override
  String get featureHealthIntegration => 'Health Connect';

  @override
  String get featureBackup => 'Encrypted backup';

  @override
  String get featureCommerce => 'Shopping';

  @override
  String get onboardingWelcomeTitle => 'A private space for your wellbeing';

  @override
  String get onboardingWelcomeBody =>
      'Track your body, health, habits and style in one place. Everything works offline.';

  @override
  String get onboardingPrivacyTitle => 'Your data stays on this device';

  @override
  String get onboardingPrivacyEncrypted =>
      'Records are stored in an encrypted database on this phone.';

  @override
  String get onboardingPrivacyCamera =>
      'Camera analysis runs on the device. Frames are not saved unless you choose to save them.';

  @override
  String get onboardingPrivacyAccount => 'No account is required.';

  @override
  String get onboardingPrivacyAi =>
      'AI is optional. The app works fully without it.';

  @override
  String get onboardingPrefsTitle => 'Set your preferences';

  @override
  String get onboardingPrefsBody =>
      'You can change these at any time in Settings.';

  @override
  String onboardingStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get actionNext => 'Next';

  @override
  String get actionBack => 'Back';

  @override
  String get actionGetStarted => 'Get started';

  @override
  String get actionRetry => 'Retry';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsUnits => 'Units';

  @override
  String get unitsMetric => 'Metric (cm, kg, L)';

  @override
  String get unitsImperial => 'Imperial (ft/in, lb, oz)';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get privacyStorageSummary =>
      'Your data is stored only on this device, in an encrypted database.';

  @override
  String get settingsAbout => 'About';

  @override
  String get wellnessDisclaimer =>
      'Personality supports wellness and lifestyle habits. It does not provide medical advice or diagnosis.';

  @override
  String get settingsSaveError =>
      'The setting could not be saved. Please try again.';

  @override
  String get startupErrorTitle => 'Unable to open your data';

  @override
  String get startupErrorBody =>
      'Personality could not open its secure storage. Your data has not been changed.';

  @override
  String get featureBodyProportions => 'Body proportions';

  @override
  String get sourceUserEntered => 'Manual';

  @override
  String get sourceCameraDerived => 'Camera estimate';

  @override
  String get sourceDeviceDerived => 'Device';

  @override
  String get sourceHealthPlatform => 'Health platform';

  @override
  String get sourceCalculated => 'Calculated';

  @override
  String get sourceImported => 'Imported';

  @override
  String get sourceAiGenerated => 'AI generated';

  @override
  String get confidenceLow => 'Low confidence';

  @override
  String get confidenceMedium => 'Medium confidence';

  @override
  String get confidenceHigh => 'High confidence';

  @override
  String valueCm(String value) {
    return '$value cm';
  }

  @override
  String valueKg(String value) {
    return '$value kg';
  }

  @override
  String valueLb(String value) {
    return '$value lb';
  }

  @override
  String valueIn(String value) {
    return '$value in';
  }

  @override
  String valueFtIn(String feet, String inches) {
    return '$feet ft $inches in';
  }

  @override
  String get unitCmShort => 'cm';

  @override
  String get unitKgShort => 'kg';

  @override
  String get unitLbShort => 'lb';

  @override
  String get unitInShort => 'in';

  @override
  String get unitFtShort => 'ft';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get deleteRecordTitle => 'Delete this record?';

  @override
  String get deleteRecordBody =>
      'This permanently removes the record from this device.';

  @override
  String get recordSaveError => 'Could not save. Please try again.';

  @override
  String get loadErrorTitle => 'Unable to load';

  @override
  String get loadErrorBody =>
      'This information could not be loaded. Your data has not been changed.';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldNotes => 'Notes (optional)';

  @override
  String get fieldMethod => 'How was it measured?';

  @override
  String get methodSelfMeasured => 'Measured myself';

  @override
  String get methodMeasuredByOther => 'Measured by another person';

  @override
  String get methodProfessional => 'Professional measurement';

  @override
  String get methodScale => 'Scale';

  @override
  String get methodEstimated => 'My estimate';

  @override
  String get validationRequired => 'Enter a value';

  @override
  String validationRange(String min, String max) {
    return 'Enter a value between $min and $max';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileIntro =>
      'Everything here is optional and stays on this device.';

  @override
  String get profileName => 'Name (optional)';

  @override
  String get profileAgeRange => 'Age range';

  @override
  String get profileActivityLevel => 'Activity level';

  @override
  String get profileGoals => 'Goals';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get ageUnder18 => 'Under 18';

  @override
  String get age18to24 => '18–24';

  @override
  String get age25to34 => '25–34';

  @override
  String get age35to44 => '35–44';

  @override
  String get age45to54 => '45–54';

  @override
  String get age55to64 => '55–64';

  @override
  String get age65plus => '65+';

  @override
  String get activitySedentary => 'Mostly sitting';

  @override
  String get activityLight => 'Lightly active';

  @override
  String get activityModerate => 'Moderately active';

  @override
  String get activityActive => 'Active';

  @override
  String get activityVeryActive => 'Very active';

  @override
  String get goalPosture => 'Posture';

  @override
  String get goalWeightManagement => 'Weight management';

  @override
  String get goalFitness => 'Fitness';

  @override
  String get goalFlexibility => 'Flexibility and mobility';

  @override
  String get goalHydration => 'Hydration';

  @override
  String get goalSleep => 'Sleep';

  @override
  String get goalHabits => 'Habits and routines';

  @override
  String get goalStyle => 'Style';

  @override
  String get goalGrooming => 'Grooming';

  @override
  String get heightTitle => 'Height';

  @override
  String get heightEmpty =>
      'Add your height to improve body-proportion and clothing recommendations.';

  @override
  String get heightAdd => 'Add height';

  @override
  String get heightPrimary => 'Primary height';

  @override
  String get heightPinnedNote =>
      'You chose this record as your primary height.';

  @override
  String get heightLatestManualNote =>
      'Using your most recent manual measurement.';

  @override
  String get heightVariationNote =>
      'Height naturally varies by about 1–2 cm during the day. Small differences between records are normal and are not treated as growth.';

  @override
  String get heightSetPrimary => 'Use as primary';

  @override
  String get weightTitle => 'Weight';

  @override
  String get weightEmpty =>
      'Add your first weight entry to start seeing trends.';

  @override
  String get weightAdd => 'Add weight';

  @override
  String get weightLatest => 'Latest';

  @override
  String get weightGoalRange => 'Goal range';

  @override
  String get weightGoalNotSet => 'No goal range set';

  @override
  String get weightSetGoal => 'Set';

  @override
  String get weightGoalMin => 'From';

  @override
  String get weightGoalMax => 'To';

  @override
  String get weightGoalInvalid =>
      'The second value must be higher than the first.';

  @override
  String get weightClearGoal => 'Clear';

  @override
  String get goalBelow => 'Below your goal range';

  @override
  String get goalWithin => 'Within your goal range';

  @override
  String get goalAbove => 'Above your goal range';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodQuarter => '3 months';

  @override
  String weightTrendChange(String change) {
    return 'Change in 7-day average over this period: $change';
  }

  @override
  String get weightTrendInsufficient =>
      'Add at least two entries in this period to see a trend.';

  @override
  String weightChartLabel(int count) {
    return 'Weight chart with $count entries';
  }

  @override
  String get weightAverageLegend => '7-day average';

  @override
  String get weightEntriesLegend => 'Entries';

  @override
  String get measurementsTitle => 'Body measurements';

  @override
  String get measurementsIntro =>
      'Optional. Used for body proportions and clothing fit. Measure over light clothing with a soft tape.';

  @override
  String get measurementNotRecorded => 'Not recorded';

  @override
  String get measurementAdd => 'Add measurement';

  @override
  String get measurementCustom => 'Custom measurement';

  @override
  String get measurementCustomLabel => 'Measurement name';

  @override
  String get measurementType => 'Measurement';

  @override
  String get mShoulderWidth => 'Shoulder width';

  @override
  String get mChest => 'Chest';

  @override
  String get mWaist => 'Waist';

  @override
  String get mHip => 'Hip';

  @override
  String get mNeck => 'Neck';

  @override
  String get mArmLength => 'Arm length';

  @override
  String get mLegLength => 'Leg length';

  @override
  String get mTorsoLength => 'Torso length';

  @override
  String get mInseam => 'Inseam';

  @override
  String get mShoulderWidthHelp =>
      'Straight across the back, from shoulder point to shoulder point.';

  @override
  String get mChestHelp =>
      'Around the fullest part of the chest, keeping the tape level.';

  @override
  String get mWaistHelp => 'Around the natural waist, just above the navel.';

  @override
  String get mHipHelp => 'Around the fullest part of the hips.';

  @override
  String get mNeckHelp => 'Around the base of the neck.';

  @override
  String get mArmLengthHelp =>
      'From the shoulder point to the wrist, with the arm relaxed.';

  @override
  String get mLegLengthHelp =>
      'From the hip bone to the floor, along the outside of the leg.';

  @override
  String get mTorsoLengthHelp =>
      'From the top of the shoulder to the natural waist.';

  @override
  String get mInseamHelp =>
      'From the crotch to the floor, along the inside of the leg.';

  @override
  String get proportionsTitle => 'Body proportions';

  @override
  String get proportionsIntro =>
      'Neutral descriptions used for clothing fit and silhouette suggestions.';

  @override
  String get proportionsDisclaimer =>
      'These are not assessments of health or appearance, and there is no ideal shape.';

  @override
  String get proportionsEmpty =>
      'Add your height and a few measurements to see your proportions.';

  @override
  String proportionsMissing(String items, String metric) {
    return 'Add $items to see $metric.';
  }

  @override
  String proportionsBasedOn(String inputs) {
    return 'Based on: $inputs';
  }

  @override
  String get proportionsAddMeasurements => 'Measurements';

  @override
  String get metricLegLine => 'Leg line';

  @override
  String get metricShoulderBreadth => 'Shoulder breadth';

  @override
  String get metricUpperTaper => 'Chest-to-waist difference';

  @override
  String get metricHipBalance => 'Hip-to-chest balance';

  @override
  String get descShorterLegLine => 'Shorter leg line relative to height';

  @override
  String get descBalancedLegLine => 'Balanced leg line';

  @override
  String get descLongerLegLine => 'Longer leg line relative to height';

  @override
  String get descNarrowerShoulders => 'Narrower shoulders relative to height';

  @override
  String get descAverageShoulders =>
      'Shoulder width in the middle range for your height';

  @override
  String get descBroaderShoulders => 'Broader shoulders relative to height';

  @override
  String get descStraightTaper => 'Straighter line through the torso';

  @override
  String get descModerateTaper => 'Moderate taper from chest to waist';

  @override
  String get descPronouncedTaper => 'Pronounced taper from chest to waist';

  @override
  String get descChestFuller => 'Chest measures fuller than hips';

  @override
  String get descBalancedChestHip => 'Chest and hips measure similarly';

  @override
  String get descHipsFuller => 'Hips measure fuller than chest';

  @override
  String valueFlOz(String value) {
    return '$value fl oz';
  }

  @override
  String valueLitres(String value) {
    return '$value L';
  }

  @override
  String valueMl(String value) {
    return '$value ml';
  }

  @override
  String durationHm(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String valueMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String valueSteps(String value) {
    return '$value steps';
  }

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMiles(String value) {
    return '$value mi';
  }

  @override
  String valueKcal(int value) {
    return '$value kcal';
  }

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealSnack => 'Snack';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealCustom => 'Other';

  @override
  String get activityWalking => 'Walking';

  @override
  String get activityRunning => 'Running';

  @override
  String get activityCycling => 'Cycling';

  @override
  String get activitySwimming => 'Swimming';

  @override
  String get activitySports => 'Sports';

  @override
  String get activityOther => 'Other activity';

  @override
  String get exNeck => 'Neck';

  @override
  String get exShoulder => 'Shoulder';

  @override
  String get exUpperBack => 'Upper back';

  @override
  String get exLowerBack => 'Lower back';

  @override
  String get exCore => 'Core';

  @override
  String get exMobility => 'Mobility';

  @override
  String get exYoga => 'Yoga';

  @override
  String get exStretching => 'Stretching';

  @override
  String get exPosture => 'Posture';

  @override
  String get exGeneralFitness => 'General fitness';

  @override
  String get exStrength => 'Strength';

  @override
  String get exCardio => 'Cardio';

  @override
  String get targetOutOfRange => 'This value is outside the supported range.';

  @override
  String get targetsTitle => 'Daily targets';

  @override
  String get targetsIntro =>
      'These are starting points you can change at any time. They are not medical recommendations.';

  @override
  String get unitLitreShort => 'L';

  @override
  String get unitFlOzShort => 'fl oz';

  @override
  String get unitHoursShort => 'h';

  @override
  String get unitMinutesShort => 'min';

  @override
  String get unitMlShort => 'ml';

  @override
  String get unitKmShort => 'km';

  @override
  String get unitMiShort => 'mi';

  @override
  String get stepsLabel => 'Steps';

  @override
  String get activeMinutesLabel => 'Active minutes';

  @override
  String get waterCustom => 'Custom amount';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionEdit => 'Edit';

  @override
  String ofTarget(String value) {
    return 'Target: $value';
  }

  @override
  String get lastSevenDays => 'Last 7 days';

  @override
  String weekChartLabel(String metric) {
    return '$metric for the last 7 days';
  }

  @override
  String get todayEntries => 'Today\'s entries';

  @override
  String get waterEmpty => 'No water logged today.';

  @override
  String get mealAdd => 'Log meal';

  @override
  String get mealsEmpty =>
      'Log what you eat, in your own words. Calories are optional.';

  @override
  String get mealType => 'Meal';

  @override
  String get mealCustomName => 'Name (optional)';

  @override
  String get mealFood => 'What did you eat?';

  @override
  String get mealQuantity => 'Quantity (optional)';

  @override
  String get mealCalories => 'Calories (optional)';

  @override
  String get mealCaloriesHelp => 'Only if you want to track them.';

  @override
  String get fieldTime => 'Time';

  @override
  String get sleepAdd => 'Log sleep';

  @override
  String get sleepLastNight => 'Last night';

  @override
  String get sleepConsistencyInsufficient =>
      'Log at least two nights this week to see how consistent your bedtime is.';

  @override
  String sleepConsistency(int minutes) {
    return 'Your bedtime varied by about $minutes min this week.';
  }

  @override
  String get sleepDisclaimer =>
      'Sleep tracking here is for personal awareness and does not assess sleep disorders.';

  @override
  String get sleepEmpty => 'No sleep logged yet.';

  @override
  String get sleepWakeBeforeBed => 'Wake time must be after bedtime.';

  @override
  String get sleepTooLong => 'A sleep entry cannot be longer than 24 hours.';

  @override
  String get sleepBedtime => 'Bedtime';

  @override
  String get sleepWakeTime => 'Wake time';

  @override
  String sleepDurationPreview(String duration) {
    return 'Duration: $duration';
  }

  @override
  String get activityAdd => 'Log activity';

  @override
  String get activeMinutesNote =>
      'Active minutes include activities and exercise sessions.';

  @override
  String get activityEmpty =>
      'No activity logged yet. Automatic step import from Health Connect comes later.';

  @override
  String get activityNeedsValue => 'Enter steps, a duration or a distance.';

  @override
  String get activityKindLabel => 'Activity';

  @override
  String get durationLabel => 'Duration';

  @override
  String get distanceLabel => 'Distance (optional)';

  @override
  String get exerciseAdd => 'Log exercise';

  @override
  String get exerciseEmpty =>
      'Log exercise you have done. A guided exercise library comes in a later update.';

  @override
  String get exerciseThisWeek => 'This week';

  @override
  String setsReps(int sets, int reps) {
    return '$sets × $reps';
  }

  @override
  String get exerciseName => 'Exercise';

  @override
  String get exerciseCategory => 'Category';

  @override
  String get setsLabel => 'Sets (optional)';

  @override
  String get repsLabel => 'Reps (optional)';

  @override
  String get habitAdd => 'Add habit';

  @override
  String get habitEdit => 'Edit habit';

  @override
  String get habitsEmpty =>
      'Add a small habit you want to repeat, and choose the days it applies.';

  @override
  String habitsTodaySummary(int done, int total) {
    return 'You completed $done of $total habits today.';
  }

  @override
  String get habitsNotToday => 'Not scheduled today';

  @override
  String habitWeekAdherence(int done, int total) {
    return '$done of $total this week';
  }

  @override
  String get habitSkippedToday => 'Skipped today';

  @override
  String get habitSkip => 'Skip';

  @override
  String get habitUndo => 'Undo';

  @override
  String get habitArchive => 'Archive';

  @override
  String get habitName => 'Habit';

  @override
  String get habitDays => 'Days';

  @override
  String get habitDaysRequired => 'Choose at least one day.';

  @override
  String get habitsNoneToday => 'None today';

  @override
  String get homeBodyTitle => 'Body';

  @override
  String mealsLogged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meals',
      one: '1 meal',
      zero: 'None logged',
    );
    return '$_temp0';
  }

  @override
  String get planTitle => 'Today\'s plan';

  @override
  String get routineNew => 'New routine';

  @override
  String get routinesEmpty =>
      'Build a daily routine with times for water, meals, movement and rest. Reminders are optional.';

  @override
  String get routineFromExample => 'Start from an example';

  @override
  String get templateRoutineName => 'My daily routine';

  @override
  String get newRoutineName => 'New routine';

  @override
  String routineItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get everyDay => 'Every day';

  @override
  String get routineNotFound => 'This routine no longer exists.';

  @override
  String get actionDuplicate => 'Duplicate';

  @override
  String routineCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String get routineAddItem => 'Add item';

  @override
  String get routinePaused => 'Paused — not part of today\'s plan.';

  @override
  String get routineNoItems =>
      'No items yet. Add times for the things you want to do.';

  @override
  String get reminderOn => 'Remind me';

  @override
  String get reminderOff => 'No reminder';

  @override
  String get routineName => 'Routine name';

  @override
  String get routineItemTitle => 'What';

  @override
  String get routineItemKind => 'Type';

  @override
  String get kindWake => 'Wake';

  @override
  String get kindMeal => 'Meal';

  @override
  String get kindWindDown => 'Wind down';

  @override
  String get kindCustom => 'Other';

  @override
  String get templatePostureBreak => 'Posture break';

  @override
  String get remindersChannelName => 'Routine reminders';

  @override
  String get remindersChannelDescription =>
      'Reminders for items in your routines';

  @override
  String get reminderActionDone => 'Done';

  @override
  String get reminderActionSnooze => 'Snooze 10 min';

  @override
  String reminderBody(String time) {
    return 'Planned for $time';
  }

  @override
  String get planEmpty =>
      'Nothing is planned for today. Create a routine to see your plan here.';

  @override
  String planSummary(int done, int total) {
    return 'Completed $done of $total planned';
  }

  @override
  String planBreakdown(int skipped, int missed, int moved, int open) {
    return 'Skipped $skipped · Missed $missed · Moved $moved · Remaining $open';
  }

  @override
  String get planWeekAdherence => 'Plan completed, last 7 days (%)';

  @override
  String get planAdherenceNote =>
      'This shows how much of your plan happened. It is separate from health results such as water or steps.';

  @override
  String get planUpcoming => 'Upcoming';

  @override
  String get planDue => 'Now';

  @override
  String get planDone => 'Done';

  @override
  String get planSkipped => 'Skipped';

  @override
  String get planMissed => 'Missed';

  @override
  String planMovedFrom(String time) {
    return 'moved from $time';
  }

  @override
  String get planReschedule => 'Move to another time';

  @override
  String get planHomeEmpty => 'No plan for today yet';

  @override
  String get planAllDone => 'Nothing left for today';

  @override
  String planNext(String title, String time) {
    return 'Next: $title — $time';
  }

  @override
  String get suggestionTitle => 'Suggestion';

  @override
  String suggestionMissed(String title, String time, int count, int total) {
    return '$title at $time was missed on $count of the last $total scheduled days.';
  }

  @override
  String suggestionLate(String title, String time, int count, int total) {
    return '$title at $time was usually done later — on $count of the last $total scheduled days.';
  }

  @override
  String suggestionRescheduled(String title, String time, int count) {
    return 'You moved $title from $time $count times recently.';
  }

  @override
  String suggestionQuestion(String time) {
    return 'Move it to $time?';
  }

  @override
  String suggestionAccept(String time) {
    return 'Move to $time';
  }

  @override
  String get suggestionDismiss => 'Keep current time';

  @override
  String get notificationsBlocked =>
      'Notifications are off for this app. Your plan still works here; enable notifications in Android settings to get reminders.';

  @override
  String get remindersEnable => 'Routine reminders';

  @override
  String get remindersOnNote =>
      'You\'ll be reminded of routine items that have reminders turned on.';

  @override
  String get remindersOffNote =>
      'Off. Your plan is still available in the app.';

  @override
  String get remindersAdaptive => 'Timing suggestions';

  @override
  String get remindersAdaptiveNote =>
      'Suggest a better time when an item is often missed or done late. Nothing changes unless you accept.';

  @override
  String get remindersTimingNote =>
      'To save battery, Android may deliver reminders a few minutes late.';

  @override
  String get remindersNext => 'Next reminders';

  @override
  String get remindersNoneUpcoming => 'No reminders in the next two days.';

  @override
  String get featureCameraCheck => 'Camera check';

  @override
  String get cameraSwitch => 'Switch camera';

  @override
  String get cameraUnavailable =>
      'Camera access is unavailable. Manual tracking remains available.';

  @override
  String get cameraPermissionDenied =>
      'Camera access was not allowed. Manual tracking remains available. To use the camera, allow it for Personality in Android settings.';

  @override
  String get cameraFailed =>
      'The camera could not be started. Close other apps using the camera and try again.';

  @override
  String get cameraIntro =>
      'Check your camera setup and lighting. Frames are analyzed on this phone and discarded — nothing is saved or uploaded.';

  @override
  String get cameraStart => 'Start camera';

  @override
  String get cameraStop => 'Stop camera';

  @override
  String get cameraPrivacyNote =>
      'Camera frames stay in memory only while being analyzed and are then discarded. The camera stops when you leave this screen or switch apps.';

  @override
  String get cameraProcessingOnDevice => 'Processing on device';

  @override
  String get cameraWaiting => 'Waiting for frames…';

  @override
  String get cameraLighting => 'Lighting';

  @override
  String get cameraAnalysisRate => 'Analysis';

  @override
  String cameraFramesStats(int fps, int frames) {
    return '$fps frames per second · $frames analyzed';
  }

  @override
  String get poseModelRequired =>
      'Posture analysis needs the pose model, which arrives in a later update. Lighting and camera checks work now.';

  @override
  String get poseNoPerson => 'No person detected. Step into the frame.';

  @override
  String get posePersonDetected => 'Person detected';

  @override
  String get poseReposition =>
      'Move into the guide so your whole body is visible.';

  @override
  String get poseHoldStill => 'Hold still for a moment.';

  @override
  String get cameraPowerMode => 'Camera power mode';

  @override
  String get powerLow => 'Low power';

  @override
  String get powerStandard => 'Standard';

  @override
  String get powerHigh => 'High accuracy';

  @override
  String get powerLowNote =>
      'Lower resolution, 5 analyses per second. Saves battery; results may be less stable.';

  @override
  String get powerStandardNote =>
      'Balanced resolution, 10 analyses per second. Recommended for most phones.';

  @override
  String get powerHighNote =>
      'Higher resolution, 15 analyses per second. Most stable results; uses more battery and may warm the phone.';

  @override
  String get lightingGood => 'Good light';

  @override
  String get lightingDim => 'Dim';

  @override
  String get lightingTooDark => 'Too dark';

  @override
  String get lightingTooBright => 'Too bright';

  @override
  String get lightingLowContrast => 'Lens covered?';

  @override
  String get lightingGoodAdvice => 'Lighting is good for analysis.';

  @override
  String get lightingDimAdvice =>
      'Usable, but more light will give steadier results.';

  @override
  String get lightingTooDarkAdvice =>
      'Please improve the lighting — turn on a light or face a window.';

  @override
  String get lightingTooBrightAdvice =>
      'Too much light — avoid standing in front of a bright window.';

  @override
  String get lightingLowContrastAdvice =>
      'The image is almost uniform. Check that the lens is not covered.';

  @override
  String get deviceInfoTitle => 'This device';

  @override
  String get deviceInfoSubtitle => 'Hardware and processing quality';

  @override
  String get deviceInfoIntro =>
      'Personality adjusts camera and analysis quality to this phone\'s hardware. Only hardware facts are read; no identifiers are collected.';

  @override
  String get deviceUnknownNote =>
      'Hardware details could not be read, so the most conservative settings are used.';

  @override
  String get deviceTier => 'Performance level';

  @override
  String get tierHigh => 'High';

  @override
  String get tierMedium => 'Medium';

  @override
  String get tierLow => 'Basic';

  @override
  String get deviceRam => 'Memory';

  @override
  String get deviceCores => 'Processor cores';

  @override
  String get deviceAndroid => 'Android version';

  @override
  String get deviceStorage => 'Free storage';

  @override
  String get deviceCamera => 'Camera';

  @override
  String get deviceProcessing => 'Processing';

  @override
  String get deviceAnalysisRate => 'Default analysis rate';

  @override
  String get deviceCameraResolution => 'Default camera resolution';

  @override
  String get deviceLocalAi => 'Optional local AI supported';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get unknownValue => 'Unknown';

  @override
  String valueGb(String value) {
    return '$value GB';
  }

  @override
  String valueFps(int fps) {
    return '$fps per second';
  }

  @override
  String get privacyCameraSummary =>
      'Camera analysis runs on this phone. Frames are never saved or uploaded unless you explicitly choose to save a photo.';
}
