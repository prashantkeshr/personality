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
  String get featureHealthIntegration => 'Connected data';

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

  @override
  String get pmHeadTilt => 'Head tilt';

  @override
  String get pmShoulderLevel => 'Shoulder level';

  @override
  String get pmHipLevel => 'Hip level';

  @override
  String get pmTorsoLean => 'Torso lean';

  @override
  String get pmKneeAlignment => 'Knee alignment';

  @override
  String get pmHeadForward => 'Head position';

  @override
  String get bandAligned => 'Within typical range';

  @override
  String get bandSlight => 'Slight';

  @override
  String get bandNoticeable => 'Noticeable';

  @override
  String get dirNone => 'Centered';

  @override
  String get dirLeftHigher => 'Left side higher';

  @override
  String get dirRightHigher => 'Right side higher';

  @override
  String get dirTiltLeft => 'Tilted toward your left';

  @override
  String get dirTiltRight => 'Tilted toward your right';

  @override
  String get dirKneeLeft => 'Larger on the left knee';

  @override
  String get dirKneeRight => 'Larger on the right knee';

  @override
  String get dirLeanLeft => 'Leaning toward your left';

  @override
  String get dirLeanRight => 'Leaning toward your right';

  @override
  String get dirHeadAhead => 'Head ahead of the shoulders';

  @override
  String get dirLeanForward => 'Leaning forward';

  @override
  String get dirLeanBack => 'Leaning back';

  @override
  String get viewFront => 'Front view';

  @override
  String get viewSide => 'Side view';

  @override
  String get poseTooFar => 'Move a little closer to the phone.';

  @override
  String get poseTooClose => 'Step back so your whole body fits in the guide.';

  @override
  String get poseUnclearView =>
      'Face the camera directly, or turn fully sideways.';

  @override
  String get poseLowVisibility =>
      'Your body isn\'t clearly visible. Fitted clothes and a plain background help.';

  @override
  String postureReady(String view) {
    return 'Ready — $view detected. Stand naturally and tap Analyze.';
  }

  @override
  String get postureAnalyze => 'Analyze';

  @override
  String get postureCapturing =>
      'Hold still while several frames are analyzed…';

  @override
  String get postureHistory => 'Posture history';

  @override
  String get postureHistoryEmpty => 'Complete your first posture check.';

  @override
  String get postureIntro =>
      'Get an estimated alignment of your head, shoulders, hips and knees. Analysis runs on this phone; frames are discarded.';

  @override
  String get postureTipPhone => 'Prop the phone upright at about waist height.';

  @override
  String get postureTipDistance =>
      'Stand 2–3 metres away so your whole body fits.';

  @override
  String get postureTipLight =>
      'Use even lighting; avoid a bright window behind you.';

  @override
  String get postureTipClothes =>
      'Fitted clothing makes landmarks easier to see.';

  @override
  String get postureTipViews =>
      'Face the camera for a front view, or stand sideways for head position.';

  @override
  String get lensFront => 'Front camera';

  @override
  String get lensBack => 'Back camera';

  @override
  String get postureDisclaimer =>
      'Estimated alignment from the camera for personal awareness — not a medical or spinal assessment. For pain or concerns, consult a qualified professional.';

  @override
  String get postureNotReliable => 'Posture could not be reliably measured.';

  @override
  String postureResultTitle(String view) {
    return 'Estimated alignment · $view';
  }

  @override
  String postureFramesUsed(int count) {
    return '$count frames';
  }

  @override
  String get postureSaved => 'Posture check saved';

  @override
  String get postureSavedShort => 'Saved';

  @override
  String get postureRetake => 'Retake';

  @override
  String get postureSuggestions => 'Suggested for you';

  @override
  String get postureLowConfidenceNote =>
      'Results were uncertain, so no suggestions are shown. Try again with better light and your whole body in the guide.';

  @override
  String postureChange(String change) {
    return '$change since last check';
  }

  @override
  String postureFlaggedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count to look at',
      one: '1 to look at',
      zero: 'All within typical range',
    );
    return '$_temp0';
  }

  @override
  String valueDegrees(String value) {
    return '$value°';
  }

  @override
  String get exerciseSafetyNote =>
      'These are general mobility ideas, not treatment. Stop if anything hurts.';

  @override
  String get whyThis => 'Why this?';

  @override
  String whyObserved(String metric, String degrees, String band) {
    return '$metric measured $degrees° ($band) in this check.';
  }

  @override
  String get whyRepeated => 'Your previous check showed this too.';

  @override
  String get whyGoal => 'Posture is one of your goals.';

  @override
  String get whyMaintenance =>
      'All estimated alignments were within the typical range; regular breaks help keep it that way.';

  @override
  String alternativeLabel(String name) {
    return 'Alternative: $name';
  }

  @override
  String get poseAnalysisFailed =>
      'On-device analysis could not run on this frame. If this keeps happening, restart the camera.';

  @override
  String get postureStepBack =>
      'Step back into the guide — capture starts at zero.';

  @override
  String postureCountdown(int seconds) {
    return 'Starting in $seconds';
  }

  @override
  String get exerciseLibrary => 'Exercise library';

  @override
  String get filterAll => 'All';

  @override
  String get filterCameraTracked => 'Camera-tracked';

  @override
  String get cameraTracked => 'Camera-tracked';

  @override
  String get howTo => 'How to do it';

  @override
  String get trackWithCamera => 'Track with camera';

  @override
  String get logAsDone => 'Log as done';

  @override
  String get savedToLog => 'Saved to your exercise log';

  @override
  String repsValue(int count) {
    return '$count reps';
  }

  @override
  String get trackingSetupFront =>
      'Prop the phone upright at waist height, step back 2–3 m and face the camera so your whole body is visible.';

  @override
  String get trackingSetupSide =>
      'Place the phone at floor or waist height to your side, so it sees your whole body from the side.';

  @override
  String trackingTargetReps(int count) {
    return 'Goal: $count reps';
  }

  @override
  String trackingTargetHold(int seconds) {
    return 'Goal: hold for $seconds seconds';
  }

  @override
  String get trackingReady =>
      'Ready — tap Start, then get into position during the countdown.';

  @override
  String get trackingStart => 'Start';

  @override
  String get trackingFinish => 'Finish';

  @override
  String trackingOfReps(int count) {
    return 'of $count reps';
  }

  @override
  String trackingOfSeconds(int seconds) {
    return 'of ${seconds}s';
  }

  @override
  String holdSecondsValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get trackingSummaryTitle => 'Session summary';

  @override
  String get trackingRepsDone => 'Reps counted';

  @override
  String get trackingHoldTime => 'Time in position';

  @override
  String get trackingTargetReached => 'Goal reached — well done.';

  @override
  String get trackingCountNote =>
      'Counted by the camera on this phone. It can occasionally miss or add a rep.';

  @override
  String get saveToLog => 'Save to log';

  @override
  String get trackingDone => 'Done';

  @override
  String get cueStepIntoView => 'Step into view so your whole body is visible.';

  @override
  String get cueGoLower => 'Go a little lower if it feels comfortable.';

  @override
  String get cueKneesOverToes => 'Keep your knees in line with your toes.';

  @override
  String get cueChestUp => 'Keep your chest up.';

  @override
  String get cueRaiseHigher => 'Raise your arms a little higher.';

  @override
  String get cueRaiseEvenly => 'Raise both arms evenly.';

  @override
  String get cueLiftKneeHigher => 'Lift your knee a little higher.';

  @override
  String get cueKeepBodyStraight =>
      'Keep a straight line from shoulders to ankles.';

  @override
  String get cueGetIntoPosition => 'Get into position.';

  @override
  String get cueGoodForm => 'Good — keep going.';

  @override
  String get cueKeepGoing => 'Keep going at a steady pace.';

  @override
  String get faceHistory => 'Face history';

  @override
  String get faceHistoryEmpty =>
      'Complete a face check to see style suggestions here.';

  @override
  String get faceIntro =>
      'Estimate your face shape from its proportions and get hairstyle, beard, glasses and grooming ideas.';

  @override
  String get facePrivacy =>
      'Your face is analyzed on this phone. No photo is taken or stored; only proportions are saved, and only if you tap Save.';

  @override
  String get faceTipLight =>
      'Face a window or lamp so light falls evenly on your face.';

  @override
  String get faceTipHair => 'Keep hair away from your forehead and jawline.';

  @override
  String get faceTipStraight =>
      'Look straight at the camera with a neutral expression; keep your head level.';

  @override
  String get faceDisclaimer =>
      'Face shape is an estimate from the camera, used only for style ideas. It says nothing about attractiveness, and every face suits many styles.';

  @override
  String get faceNone => 'No face detected. Look at the camera.';

  @override
  String get faceMultiple =>
      'More than one face is visible. Make sure only you are in view.';

  @override
  String get faceModelRequired =>
      'Face analysis isn\'t available on this device.';

  @override
  String get faceReady => 'Face detected — tap Analyze and hold still.';

  @override
  String get faceTooFar => 'Bring the phone a little closer to your face.';

  @override
  String get faceTooClose => 'Move the phone a little further away.';

  @override
  String get faceInGuide => 'Keep your whole face inside the oval.';

  @override
  String get faceCapturing => 'Hold still while a few frames are measured…';

  @override
  String get faceNotReliable => 'Face shape could not be reliably estimated.';

  @override
  String get faceSaved => 'Face check saved';

  @override
  String get faceResultTitle => 'Estimated face shape';

  @override
  String faceShapeBetween(String first, String second) {
    return '$first / $second';
  }

  @override
  String get faceLowConfidenceNote =>
      'The estimate was uncertain, so no style suggestions are shown. Try again with even light and your head level.';

  @override
  String get shapeOval => 'Oval';

  @override
  String get shapeRound => 'Round';

  @override
  String get shapeSquare => 'Square';

  @override
  String get shapeOblong => 'Oblong';

  @override
  String get shapeHeart => 'Heart';

  @override
  String get shapeDiamond => 'Diamond';

  @override
  String get ratioLengthWidth => 'Length ÷ cheekbone width';

  @override
  String get ratioForeheadCheek => 'Forehead ÷ cheekbone width';

  @override
  String get ratioJawCheek => 'Jaw ÷ cheekbone width';

  @override
  String get styleHair => 'Hairstyles';

  @override
  String get styleBeard => 'Beard styles';

  @override
  String get styleBeardNote => 'If you have or want facial hair.';

  @override
  String get styleGlasses => 'Glasses frames';

  @override
  String get favoriteAdd => 'Add to favourites';

  @override
  String get favoriteRemove => 'Remove from favourites';

  @override
  String get groomingTitle => 'Simple grooming routine';

  @override
  String get groomingAddRoutine => 'Add to my routines';

  @override
  String get groomingRoutineName => 'Grooming';

  @override
  String get groomingRoutineAdded => 'Grooming routine added to your routines';

  @override
  String faceBetweenNote(String shape) {
    return 'Your proportions are also close to $shape, so ideas for both are shown:';
  }

  @override
  String get cardFlipHint => 'Tap to see details';

  @override
  String get tryOn => 'Try on';

  @override
  String get tryOnOpen => 'Try on glasses & beard styles';

  @override
  String get faceArtLegend =>
      'Grey: reference shape · Colour: your proportions';

  @override
  String get tryOnHint => 'Press and hold the preview to compare without.';

  @override
  String get tryOnComparing => 'Showing without the style';

  @override
  String get tryOnNone => 'None';

  @override
  String get tryOnNote =>
      'Live preview drawn on this phone; nothing is recorded. Beard previews are approximate shading, not a photo-real render.';

  @override
  String get featureProgressSnapshots => 'Progress snapshots';

  @override
  String get snapFace => 'Face';

  @override
  String get snapBodyFront => 'Body · front';

  @override
  String get snapBodySide => 'Body · side';

  @override
  String get snapTake => 'Take snapshot';

  @override
  String get snapCompare => 'Compare before / after';

  @override
  String get snapEmpty =>
      'Take your first snapshot. Repeat it regularly in the same place and light to see changes over time.';

  @override
  String get snapPrivacyShort =>
      'Stored only on this phone, inside the encrypted database. Never uploaded or added to your gallery.';

  @override
  String get snapLongPressDelete => 'Long-press a snapshot to delete it.';

  @override
  String get snapWeeklyReminder => 'Remind me weekly (Sunday 9:00)';

  @override
  String get snapDeleteAll => 'Delete all snapshots';

  @override
  String get snapReminderRoutine => 'Progress snapshot';

  @override
  String get snapReminderItem => 'Take a progress snapshot';

  @override
  String get snapReminderAdded =>
      'Weekly snapshot reminder added to your routines';

  @override
  String get snapConsentTitle => 'Track changes with private photos';

  @override
  String get snapConsentStored =>
      'Photos are saved only when you tap Save, inside this app\'s encrypted database.';

  @override
  String get snapConsentNeverUploaded =>
      'They never leave this phone and are not added to your gallery.';

  @override
  String get snapConsentOptIn =>
      'This is optional; every other feature works without photos.';

  @override
  String get snapConsentDelete =>
      'You can delete any snapshot, or all of them, at any time.';

  @override
  String get snapConsentAccept => 'I understand — turn on snapshots';

  @override
  String get snapGhost => 'Show previous snapshot as a guide';

  @override
  String get snapGhostHelp =>
      'Line yourself up with the faint image so snapshots are comparable.';

  @override
  String get snapTipFace =>
      'Same place and light each time; face the camera with a neutral expression.';

  @override
  String get snapTipBody =>
      'Prop the phone at waist height, step back so your whole body fits, and wear similar clothing each time.';

  @override
  String get snapCapture => 'Capture (3-second timer)';

  @override
  String get snapSaveEncrypted => 'Save privately';

  @override
  String get snapSaved => 'Snapshot saved privately';

  @override
  String get snapBefore => 'Before';

  @override
  String get snapAfter => 'After';

  @override
  String get snapCompareHelp =>
      'Drag across the image to compare. Choose any two snapshots below.';

  @override
  String get colourTitle => 'Colour & style';

  @override
  String get colourYourPalette => 'Your palette';

  @override
  String get colourDisclaimer =>
      'Palettes are colour-theory suggestions, not rules — wear what you enjoy.';

  @override
  String get quizVeinQ => 'What colour do the veins on your inner wrist look?';

  @override
  String get quizVeinHelp => 'Look in daylight, without filters.';

  @override
  String get quizVeinBlue => 'Blue or purple';

  @override
  String get quizVeinGreen => 'Greenish';

  @override
  String get quizVeinBoth => 'Hard to tell / both';

  @override
  String get quizJewelQ => 'Which jewellery looks better on your skin?';

  @override
  String get quizJewelHelp => 'Think of rings or a watch against your hand.';

  @override
  String get quizJewelSilver => 'Silver';

  @override
  String get quizJewelGold => 'Gold';

  @override
  String get quizJewelBoth => 'Both look good';

  @override
  String get quizSunQ => 'How does your skin usually react to the sun?';

  @override
  String get quizSunHelp => 'Without sunscreen, after a short time outdoors.';

  @override
  String get quizSunBurns => 'Burns or turns pink';

  @override
  String get quizSunTans => 'Tans easily';

  @override
  String get quizSunBoth => 'A bit of both';

  @override
  String get quizDepthQ => 'Which is closest to your skin depth?';

  @override
  String get quizDepthHelp => 'This sets how much contrast your palette has.';

  @override
  String get quizSeePalette => 'See my palette';

  @override
  String get quizRetake => 'Retake colour quiz';

  @override
  String get undertoneWarm => 'Warm undertone';

  @override
  String get undertoneCool => 'Cool undertone';

  @override
  String get undertoneNeutral => 'Neutral undertone';

  @override
  String get undertoneWarmExplain =>
      'Earthy, golden and olive shades tend to harmonise with your skin.';

  @override
  String get undertoneCoolExplain =>
      'Jewel tones, blues and rosy shades tend to harmonise with your skin.';

  @override
  String get undertoneNeutralExplain =>
      'Most balanced shades suit you; avoid only very extreme colours near the face.';

  @override
  String get depthLight => 'Light';

  @override
  String get depthMedium => 'Medium';

  @override
  String get depthDeep => 'Deep';

  @override
  String get paletteBest => 'Best colours';

  @override
  String get paletteBestNote =>
      'Wear these near your face — tops, shirts, scarves. Tap one to try it on.';

  @override
  String get paletteNeutrals => 'Your neutrals';

  @override
  String get paletteNeutralsNote =>
      'Foundation colours for trousers, outerwear and shoes.';

  @override
  String get paletteSparingly => 'Use sparingly';

  @override
  String get paletteSparinglyNote =>
      'Fine away from the face or as small accents.';

  @override
  String get drapeOpen => 'Try colours on live';

  @override
  String get drapeTitle => 'Colour drape';

  @override
  String get drapeHint => 'Tap colours below and compare';

  @override
  String get drapeNote =>
      'A colour drape shows how a shade looks next to your face. Live preview only; nothing is recorded. Room lighting affects how colours appear.';

  @override
  String get stylePrefsTitle => 'Styles you like';

  @override
  String get prefClassic => 'Classic';

  @override
  String get prefMinimal => 'Minimal';

  @override
  String get prefSmartCasual => 'Smart casual';

  @override
  String get prefStreet => 'Streetwear';

  @override
  String get prefTraditional => 'Traditional / ethnic';

  @override
  String get prefSporty => 'Sporty';

  @override
  String get wardrobeAdd => 'Add clothing';

  @override
  String get wardrobeEmpty =>
      'Add a few pieces you wear often — tops, bottoms and shoes — and get outfit ideas from your own clothes.';

  @override
  String get wardrobePrivacy =>
      'Clothing photos stay on this phone inside the encrypted database.';

  @override
  String get outfitIdeas => 'Outfit ideas';

  @override
  String get outfitIdeasTab => 'Ideas';

  @override
  String get outfitSavedTab => 'Saved';

  @override
  String get outfitNone =>
      'No combinations for this occasion yet. Add tops, bottoms and shoes, or mark items for this occasion.';

  @override
  String get outfitPaletteHint =>
      'Tip: complete the colour quiz to rank outfits by your palette.';

  @override
  String get outfitSave => 'Save outfit';

  @override
  String get outfitSavedEmpty =>
      'Saved outfits appear here, ready for busy mornings.';

  @override
  String get outfitWoreToday => 'Wore it today';

  @override
  String get garmentName => 'Name (e.g. white oxford shirt)';

  @override
  String get garmentPhoto => 'Add photo (optional)';

  @override
  String get garmentRetakePhoto => 'Retake photo';

  @override
  String get garmentPhotoTip =>
      'Lay the item flat or hang it in good light, filling the frame. Its colour is read from the centre.';

  @override
  String get garmentCategory => 'Type';

  @override
  String get garmentColour => 'Colour';

  @override
  String get garmentColourFromPhoto =>
      'Colour (read from photo — adjust if needed)';

  @override
  String get garmentPattern => 'Pattern';

  @override
  String get garmentFormality => 'Formality';

  @override
  String get garmentOccasions => 'Occasions';

  @override
  String get garmentOccasionsHelp => 'Leave empty to allow any occasion.';

  @override
  String get catTop => 'Top / shirt';

  @override
  String get catBottom => 'Bottom';

  @override
  String get catOnePiece => 'Dress / one-piece';

  @override
  String get catOuterwear => 'Outerwear';

  @override
  String get catFootwear => 'Footwear';

  @override
  String get catEthnicTop => 'Kurta / ethnic top';

  @override
  String get catEthnicBottom => 'Ethnic bottom';

  @override
  String get catAccessory => 'Accessory';

  @override
  String get patSolid => 'Solid';

  @override
  String get patStripes => 'Stripes';

  @override
  String get patChecks => 'Checks';

  @override
  String get patPrint => 'Print';

  @override
  String get occCasual => 'Casual';

  @override
  String get occWork => 'Work';

  @override
  String get occFormal => 'Formal';

  @override
  String get occFestive => 'Festive';

  @override
  String get occSport => 'Sport';

  @override
  String get form1 => 'Very relaxed';

  @override
  String get form2 => 'Relaxed';

  @override
  String get form3 => 'Smart';

  @override
  String get form4 => 'Dressy';

  @override
  String get form5 => 'Formal';

  @override
  String get reasonAllNeutral => 'All neutral colours — easy and polished.';

  @override
  String get reasonOneAccent => 'One accent colour against neutrals.';

  @override
  String get reasonTonal => 'Tonal colours from the same family.';

  @override
  String get reasonAnalogous => 'Neighbouring colours that blend smoothly.';

  @override
  String get reasonComplementary =>
      'Opposite colours for a confident contrast.';

  @override
  String get reasonInPalette => 'The colour near your face is in your palette.';

  @override
  String get reasonOnePattern => 'A single pattern, balanced by solids.';

  @override
  String get reasonMatchedFormality => 'Every piece suits the occasion.';

  @override
  String get reasonFavourite => 'Includes a favourite piece.';

  @override
  String get reasonNotWorn => 'None of these were worn this week.';

  @override
  String outfitWornCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Worn $count times',
      one: 'Worn once',
      zero: 'Not worn yet',
    );
    return '$_temp0';
  }

  @override
  String get journeyTitle => 'Your journey';

  @override
  String journeyLevel(int level) {
    return 'Level $level';
  }

  @override
  String journeyXpToNext(int xp, int level) {
    return '$xp XP to level $level';
  }

  @override
  String journeyTodayXp(int xp) {
    return '+$xp XP today';
  }

  @override
  String journeyStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-day streak',
      one: '1-day streak',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String journeyRestDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rest days banked',
      one: '1 rest day banked',
      zero: 'No rest days banked',
    );
    return '$_temp0';
  }

  @override
  String get journeyRestDaysHelp =>
      'Every 7 active days earns a rest day. A missed day uses one, so your streak continues.';

  @override
  String get journeyStartTimelapse =>
      'Take a face snapshot to start your time-lapse';

  @override
  String get journeyOneSnapshot =>
      'Add another snapshot next week to see your change';

  @override
  String journeySnapshotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count snapshots',
      one: '1 snapshot',
    );
    return '$_temp0';
  }

  @override
  String get journeyFirst => 'First';

  @override
  String get journeyLatest => 'Latest';

  @override
  String get journeyPlay => 'Play time-lapse';

  @override
  String get journeyPause => 'Pause';

  @override
  String get journeyCompare => 'Compare side by side';

  @override
  String get journeyAlignNote =>
      'Photos are lined up by your eyes. A front-facing, well-lit photo lines up best.';

  @override
  String get journeyTotalXp => 'Total XP';

  @override
  String get journeyBestStreak => 'Best streak';

  @override
  String get journeyActiveDays => 'Active days';

  @override
  String get journeyLast4Weeks => 'Last 4 weeks';

  @override
  String get journeyTrends => 'Trends';

  @override
  String get journeyWeight => 'Weight';

  @override
  String get journeyXpPerDay => 'XP per day';

  @override
  String get journeyBadges => 'Badges';

  @override
  String journeyBadgesEarned(int earned, int total) {
    return '$earned of $total earned';
  }

  @override
  String get journeyHowXp => 'How XP works';

  @override
  String get journeyHowXpBody =>
      'XP comes from what you already log — water, meals, sleep, activity, habits, plan items, checks, snapshots and outfits. A day with 15 XP or more counts toward your streak. Missing a day never removes XP.';

  @override
  String get questsTitle => 'Today\'s quests';

  @override
  String questsReward(int xp) {
    return '+$xp XP';
  }

  @override
  String questsAllDone(int xp) {
    return 'All done — +$xp bonus XP';
  }

  @override
  String questsAllBonus(int xp) {
    return 'Finish all three for +$xp bonus XP';
  }

  @override
  String get questDrinkTarget => 'Reach your water target';

  @override
  String get questLogMeals => 'Log two meals';

  @override
  String get questPostureCheck => 'Do a posture check';

  @override
  String get questCompletePlan => 'Complete three plan items';

  @override
  String get questAllHabits => 'Finish today\'s habits';

  @override
  String get questLogSleep => 'Log last night\'s sleep';

  @override
  String get questWorkout => 'Log a workout or activity';

  @override
  String get questWearOutfit => 'Wear a saved outfit';

  @override
  String get questSnapshot => 'Take this week\'s face snapshot';

  @override
  String get questLogWeight => 'Log your weight';

  @override
  String get badgeUnlocked => 'Badge unlocked';

  @override
  String badgesUnlocked(int count) {
    return '$count badges unlocked';
  }

  @override
  String get badgeContinue => 'Continue';

  @override
  String badgeProgress(int progress, int target) {
    return '$progress / $target';
  }

  @override
  String get badgeFirstSteps => 'First steps';

  @override
  String get badgeFirstStepsInfo => 'Log anything for the first time.';

  @override
  String get badgeStreak7 => 'One steady week';

  @override
  String get badgeStreak7Info => 'Reach a 7-day streak.';

  @override
  String get badgeStreak30 => 'Thirty strong';

  @override
  String get badgeStreak30Info => 'Reach a 30-day streak.';

  @override
  String get badgeHydration => 'Well hydrated';

  @override
  String get badgeHydrationInfo => 'Meet your water target on 7 days.';

  @override
  String get badgePosture => 'Posture regular';

  @override
  String get badgePostureInfo => 'Complete 5 posture checks.';

  @override
  String get badgeFace => 'Face explorer';

  @override
  String get badgeFaceInfo => 'Complete a face analysis.';

  @override
  String get badgeJourney => 'Journey keeper';

  @override
  String get badgeJourneyInfo => 'Save 4 progress snapshots.';

  @override
  String get badgePlanner => 'Planner';

  @override
  String get badgePlannerInfo => 'Complete 20 plan items.';

  @override
  String get badgeHabits => 'Habit builder';

  @override
  String get badgeHabitsInfo => 'Complete habits 30 times.';

  @override
  String get badgeStylist => 'Stylist';

  @override
  String get badgeStylistInfo => 'Save 5 outfits.';

  @override
  String get badgeLevel5 => 'Level 5';

  @override
  String get badgeLevel5Info => 'Reach level 5.';

  @override
  String get badgeLevel10 => 'Level 10';

  @override
  String get badgeLevel10Info => 'Reach level 10.';

  @override
  String get forYouTitle => 'For you today';

  @override
  String get forYouSnapshot => 'Weekly snapshot';

  @override
  String get forYouSnapshotInfo => 'Add a frame to your time-lapse';

  @override
  String get forYouTryOn => 'Try a new look';

  @override
  String get forYouTryOnInfo => 'Glasses and beards, live on you';

  @override
  String get forYouPosture => 'Posture check';

  @override
  String get forYouPostureInfo => 'Two minutes, tips for you';

  @override
  String get forYouColours => 'Find your colours';

  @override
  String get forYouColoursInfo => 'A short quiz for your palette';

  @override
  String get forYouOutfit => 'Today\'s outfit';

  @override
  String get forYouOutfitInfo => 'Ideas from your wardrobe';

  @override
  String get forYouFace => 'Face shape';

  @override
  String get forYouFaceInfo => 'Styles that suit you';

  @override
  String get forYouExercise => 'Move a little';

  @override
  String get forYouExerciseInfo => 'Guided reps, counted live';

  @override
  String get forYouHairstyles => 'Hairstyle ideas';

  @override
  String get forYouHairstylesInfo => 'Picked for your face shape';

  @override
  String get goalFinderTitle => 'Find your focus';

  @override
  String get goalFinderStep1 => 'What would you like to work on?';

  @override
  String get goalFinderStep1Hint => 'Tap every image that speaks to you.';

  @override
  String get goalFinderStep2 => 'Which looks feel like you?';

  @override
  String get goalFinderStep2Hint =>
      'Pick as many as you like — this shapes your outfit ideas.';

  @override
  String get goalFinderNext => 'Next';

  @override
  String get goalFinderBack => 'Back';

  @override
  String get goalFinderSave => 'Save my focus';

  @override
  String get goalFinderSaved =>
      'Your focus is saved. Quests and suggestions now follow it.';

  @override
  String goalFinderSelected(int count) {
    return '$count selected';
  }

  @override
  String get forYouGoals => 'What do you want?';

  @override
  String get forYouGoalsInfo => 'Pick images that inspire you';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileGenderHelp =>
      'Used only for calorie estimates and to show relevant style examples.';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderNonBinary => 'Non-binary';

  @override
  String get genderPreferNot => 'Prefer not to say';

  @override
  String get profileDiet => 'Food preference';

  @override
  String get dietVegetarian => 'Vegetarian';

  @override
  String get dietEggetarian => 'Eggetarian';

  @override
  String get dietNonVegetarian => 'Non-vegetarian';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get profileStyleFit => 'Show style examples for';

  @override
  String get styleFitAuto => 'Match my gender';

  @override
  String get styleFitMenswear => 'Menswear';

  @override
  String get styleFitWomenswear => 'Womenswear';

  @override
  String get styleFitAll => 'Everyone';

  @override
  String get onboardingAboutTitle => 'About you';

  @override
  String get onboardingAboutBody =>
      'Everything here is optional and stays on this phone. It personalises your plans, quests and style suggestions.';

  @override
  String get onboardingHeightCm => 'Height (cm)';

  @override
  String get onboardingHeightFt => 'Height (ft)';

  @override
  String get onboardingHeightIn => 'in';

  @override
  String get onboardingWeightKg => 'Weight (kg)';

  @override
  String get onboardingWeightLb => 'Weight (lb)';

  @override
  String get onboardingInvalid => 'Check this value';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String greetingNamed(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeCompleteProfile => 'Personalise your app';

  @override
  String get homeCompleteProfileInfo =>
      'Add your gender, height and weight for accurate plans and relevant styles.';

  @override
  String get forYouBodyPlan => 'Your diet plan';

  @override
  String get forYouBodyPlanInfo => 'Meals and training for your goal';

  @override
  String get featureBodyPlan => 'Diet & body plan';

  @override
  String get bodyPlanIntro =>
      'Calorie and protein targets, daily meals and a simple training week, built from your height, weight and goal.';

  @override
  String get bodyPlanNeedData => 'Add your height and weight to create a plan.';

  @override
  String get bodyPlanImprove =>
      'Add your gender, age range and activity level in Profile for a better estimate.';

  @override
  String get bodyPlanOpenProfile => 'Open profile';

  @override
  String get bodyPlanGoal => 'Your goal';

  @override
  String get planLoseFat => 'Lose fat';

  @override
  String get planMaintain => 'Stay fit';

  @override
  String get planGainWeight => 'Gain weight';

  @override
  String get planBuildMuscle => 'Build muscle';

  @override
  String get planLoseFatInfo => 'A moderate calorie deficit with high protein';

  @override
  String get planMaintainInfo => 'Eat at maintenance and train regularly';

  @override
  String get planGainWeightInfo => 'A steady surplus to gain healthy weight';

  @override
  String get planBuildMuscleInfo => 'A lean surplus with strength training';

  @override
  String get planBlockUnderage =>
      'Under 18: plan weight changes with a doctor. Maintenance guidance is available.';

  @override
  String get planBlockUnderweight =>
      'Your BMI is below 18.5, so fat loss isn\'t suggested.';

  @override
  String get planBlockHeavy =>
      'Your BMI is 25 or more. Try Build muscle instead.';

  @override
  String get bodyPlanPace => 'Pace';

  @override
  String get paceGentle => 'Gentle';

  @override
  String get paceSteady => 'Steady';

  @override
  String get paceBrisk => 'Brisk';

  @override
  String bodyPlanRate(String rate) {
    return 'About $rate per week';
  }

  @override
  String get bodyPlanTarget => 'Target weight (optional)';

  @override
  String bodyPlanHealthyRange(String range) {
    return 'Healthy range for your height: $range';
  }

  @override
  String get bodyPlanCalories => 'Calories';

  @override
  String get bodyPlanProtein => 'Protein';

  @override
  String get bodyPlanCarbs => 'Carbs';

  @override
  String get bodyPlanFat => 'Fat';

  @override
  String get bodyPlanWater => 'Water';

  @override
  String bodyPlanKcal(int value) {
    return '$value kcal';
  }

  @override
  String bodyPlanGrams(int value) {
    return '$value g';
  }

  @override
  String bodyPlanMaintenance(int kcal) {
    return 'Maintenance is about $kcal kcal a day';
  }

  @override
  String bodyPlanTimeline(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'About $weeks weeks to your target',
      one: 'About 1 week to your target',
    );
    return '$_temp0';
  }

  @override
  String get bodyPlanFloorNote =>
      'Kept at a safe minimum, so progress will be slower than this pace.';

  @override
  String get bodyPlanStart => 'Start my plan';

  @override
  String get bodyPlanStarted => 'Your plan has started';

  @override
  String get bodyPlanDisclaimer =>
      'Estimates for healthy adults, not medical advice. If you have a medical condition, are pregnant or take medication, check with a doctor first.';

  @override
  String bodyPlanSince(String date) {
    return 'Since $date';
  }

  @override
  String get bodyPlanToday => 'Today\'s targets';

  @override
  String bodyPlanEaten(int eaten, int target) {
    return '$eaten of $target kcal logged today';
  }

  @override
  String get bodyPlanMenu => 'Today\'s menu';

  @override
  String bodyPlanServings(String servings) {
    return '× $servings';
  }

  @override
  String get bodyPlanProteinBoost => 'Protein boost';

  @override
  String get bodyPlanLog => 'Log';

  @override
  String get bodyPlanLogged => 'Logged';

  @override
  String get bodyPlanSwap => 'Swap';

  @override
  String get bodyPlanWeek => 'This week\'s training';

  @override
  String get workoutStrengthA => 'Strength A';

  @override
  String get workoutStrengthB => 'Strength B';

  @override
  String get workoutCardio => 'Cardio';

  @override
  String get workoutMobility => 'Mobility';

  @override
  String get workoutRest => 'Rest';

  @override
  String bodyPlanMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String bodyPlanTodayWorkout(String workout) {
    return 'Today: $workout';
  }

  @override
  String get bodyPlanAddRoutine => 'Add workouts to my routines';

  @override
  String get bodyPlanRoutineAdded => 'Added to your routines';

  @override
  String get bodyPlanRoutineName => 'Training plan';

  @override
  String get bodyPlanWorkoutItem => 'Workout';

  @override
  String get bodyPlanProgress => 'Progress';

  @override
  String bodyPlanWeightNow(String now, String start) {
    return '$now now · started at $start';
  }

  @override
  String bodyPlanExpected(String weight) {
    return 'Expected by now: $weight';
  }

  @override
  String get bodyPlanUpdate => 'Your weight has changed. Update your targets?';

  @override
  String get bodyPlanUpdateAction => 'Update';

  @override
  String get bodyPlanEnd => 'End plan';

  @override
  String get bodyPlanEndConfirm =>
      'End this plan? Your logged meals and workouts stay.';

  @override
  String get bodyPlanLogWeight => 'Log weight';

  @override
  String get bodyPlanChange => 'Change plan';

  @override
  String get profileRegion => 'Where are you based?';

  @override
  String get profileRegionHelp =>
      'Used to suggest local food, suitable exercise and climate tips.';

  @override
  String get regionIndiaNorth => 'North India';

  @override
  String get regionIndiaSouth => 'South India';

  @override
  String get regionIndiaEast => 'East India';

  @override
  String get regionIndiaWest => 'West India';

  @override
  String get regionSouthAsia => 'Rest of South Asia';

  @override
  String get regionEastAsia => 'East Asia';

  @override
  String get regionSoutheastAsia => 'Southeast Asia';

  @override
  String get regionMiddleEast => 'Middle East';

  @override
  String get regionAfrica => 'Africa';

  @override
  String get regionEurope => 'Europe';

  @override
  String get regionNorthAmerica => 'North America';

  @override
  String get regionLatinAmerica => 'Latin America';

  @override
  String get regionOceania => 'Oceania';

  @override
  String get bodyPlanHotClimate =>
      'Warm climate: train in the cooler morning or evening, and sip water through the day.';

  @override
  String bodyPlanLocalMenu(String region) {
    return 'Meals chosen from $region cuisine where possible.';
  }

  @override
  String get dailyPlan => 'Daily plan';

  @override
  String get partMorning => 'Morning';

  @override
  String get partAfternoon => 'Afternoon';

  @override
  String get partEvening => 'Evening';

  @override
  String get partAnytime => 'Any time';

  @override
  String agendaWater(String target) {
    return 'Drink $target';
  }

  @override
  String agendaWorkout(String workout, int minutes) {
    return '$workout · $minutes min';
  }

  @override
  String agendaOptional(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count optional today',
      one: '1 optional today',
    );
    return '$_temp0';
  }

  @override
  String get agendaMissed => 'Missed';

  @override
  String get agendaReschedule => 'Reschedule';

  @override
  String get agendaSkip => 'Skip today';

  @override
  String get agendaDone => 'Mark done';

  @override
  String get agendaUndo => 'Undo';

  @override
  String agendaLookingBack(String date) {
    return 'Looking back at $date';
  }

  @override
  String get agendaEmpty =>
      'Nothing planned yet. Add a routine, habits or a diet plan to build your day.';

  @override
  String agendaProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get dayModeTitle => 'How\'s today?';

  @override
  String get dayModeNormal => 'Normal';

  @override
  String get dayModeBusy => 'Busy';

  @override
  String get dayModeLow => 'Low energy';

  @override
  String get dayModeNormalInfo => 'Your full plan.';

  @override
  String get dayModeBusyInfo => 'Essentials only, with a 5-minute workout.';

  @override
  String get dayModeLowInfo =>
      'Gentle mobility instead of training. Rest counts too.';

  @override
  String get moodTitle => 'Check in';

  @override
  String get moodQuestion => 'How are you feeling?';

  @override
  String get energyQuestion => 'Energy level';

  @override
  String get mood1 => 'Low';

  @override
  String get mood2 => 'Meh';

  @override
  String get mood3 => 'Okay';

  @override
  String get mood4 => 'Good';

  @override
  String get mood5 => 'Great';

  @override
  String get energy1 => 'Drained';

  @override
  String get energy2 => 'Low';

  @override
  String get energy3 => 'Steady';

  @override
  String get energy4 => 'Good';

  @override
  String get energy5 => 'High';

  @override
  String get moodSave => 'Save check-in';

  @override
  String get moodSaved => 'Thanks for checking in';

  @override
  String get moodSuggestLow => 'Energy is low today. Make it a low-energy day?';

  @override
  String get moodSwitch => 'Switch';

  @override
  String moodToday(String mood, String energy) {
    return 'Today: $mood · energy $energy';
  }

  @override
  String get fiveTitle => 'Got 5 minutes?';

  @override
  String get fiveWater => 'Drink a glass of water';

  @override
  String get fiveWaterInfo =>
      'You\'re a little behind on water for this time of day.';

  @override
  String fiveHabit(String habit) {
    return 'Do it now: $habit';
  }

  @override
  String get fiveHabitInfo => 'One habit, ticked off in a few minutes.';

  @override
  String get fiveMobility => '5-minute mobility';

  @override
  String get fiveMobilityInfo => 'Neck, shoulders and posture: a quick reset.';

  @override
  String get fiveOutfit => 'Plan tomorrow\'s outfit';

  @override
  String get fiveOutfitInfo => 'Choose it tonight, decide less tomorrow.';

  @override
  String get fivePosture => 'Quick posture check';

  @override
  String get fivePostureInfo => 'Two minutes with the camera, tips for you.';

  @override
  String get fiveDo => 'Do it';

  @override
  String get quickAdd => 'Quick add';

  @override
  String quickWater(int ml) {
    return '+$ml ml water';
  }

  @override
  String get quickMeal => 'Log a meal';

  @override
  String get quickWeight => 'Log weight';

  @override
  String get quickSleep => 'Log sleep';

  @override
  String get quickMood => 'Mood check-in';

  @override
  String get quickAdded => 'Added';

  @override
  String get remindersQuiet => 'Quiet hours';

  @override
  String remindersQuietInfo(String start, String end) {
    return 'No reminders from $start to $end. Items stay in your plan.';
  }

  @override
  String get remindersQuietOff => 'Off: reminders can arrive at any time.';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsIntro =>
      'Plan versus what actually happened. Days without records show as no data, never as misses.';

  @override
  String get insightsHomeInfo => 'Plan versus actual, sleep score and trends';

  @override
  String get rangeWeek => 'Week';

  @override
  String get rangeMonth => 'Month';

  @override
  String get metricPlan => 'Plan items';

  @override
  String get metricHabits => 'Habits';

  @override
  String get metricWater => 'Water';

  @override
  String get metricSleep => 'Sleep';

  @override
  String get metricActivity => 'Active minutes';

  @override
  String get metricMeals => 'Meals logged';

  @override
  String get metricMood => 'Mood';

  @override
  String insightsMet(int met, int logged) {
    return 'Met on $met of $logged logged days';
  }

  @override
  String insightsLogged(int logged) {
    return 'Logged on $logged days';
  }

  @override
  String get insightsNoData => 'No records in this period yet.';

  @override
  String insightsAverage(String value) {
    return 'Average $value';
  }

  @override
  String insightsUp(String value, String period) {
    return 'Up $value vs previous $period';
  }

  @override
  String insightsDown(String value, String period) {
    return 'Down $value vs previous $period';
  }

  @override
  String insightsSame(String period) {
    return 'Same as previous $period';
  }

  @override
  String get insightsPeriodWeek => 'week';

  @override
  String get insightsPeriodMonth => 'month';

  @override
  String get legendMet => 'Met';

  @override
  String get legendPartial => 'Partly';

  @override
  String get legendMissed => 'Not met';

  @override
  String get legendNoData => 'No data';

  @override
  String get sleepScoreTitle => 'Sleep score';

  @override
  String get sleepScoreInfo =>
      'From your logged bed and wake times over the last 7 nights: duration (70 points) and regular bedtimes (30). No sleep stages; those need a wearable.';

  @override
  String sleepAverage(String value) {
    return '$value a night on average';
  }

  @override
  String sleepSpread(int minutes) {
    return 'Bedtime varies by about $minutes min';
  }

  @override
  String sleepNights(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights logged',
      one: '1 night logged',
    );
    return '$_temp0';
  }

  @override
  String get sleepExcellent => 'Excellent';

  @override
  String get sleepGood => 'Good';

  @override
  String get sleepFair => 'Fair';

  @override
  String get sleepCare => 'Needs care';

  @override
  String get sleepScoreEmpty => 'Log a few nights of sleep to see your score.';

  @override
  String get evolutionTitle => 'Evolution';

  @override
  String get evolutionIntro =>
      'Moments along your way, from what you\'ve done. Add your own notes too.';

  @override
  String get evolutionEmpty =>
      'Your milestones will appear here as you use the app.';

  @override
  String get evolutionAddNote => 'Add a note';

  @override
  String get evolutionNoteHint => 'What changed, how you feel…';

  @override
  String get evolutionSeeAll => 'See all';

  @override
  String get msFirstStep => 'First step: you logged something';

  @override
  String get msFirstPosture => 'First posture check';

  @override
  String get msFirstFace => 'First face analysis';

  @override
  String get msFirstSnapshot => 'First progress snapshot';

  @override
  String get msFirstOutfit => 'First outfit saved';

  @override
  String msPlanStarted(String plan) {
    return 'Started a plan: $plan';
  }

  @override
  String get msStreak7 => 'Reached a 7-day streak';

  @override
  String get msStreak30 => 'Reached a 30-day streak';

  @override
  String get msHabits30 => '30 habits completed';

  @override
  String msWeightDown(String value) {
    return '$value down since your first weigh-in';
  }

  @override
  String msWeightUp(String value) {
    return '$value up since your first weigh-in';
  }

  @override
  String get reviewTitle => 'Your week';

  @override
  String reviewWeekOf(String date) {
    return 'Week of $date';
  }

  @override
  String reviewActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active days',
      one: '1 active day',
    );
    return '$_temp0';
  }

  @override
  String reviewWater(int met) {
    return 'Water target met on $met days';
  }

  @override
  String reviewSleep(String value) {
    return 'Average sleep $value';
  }

  @override
  String reviewActivity(int count) {
    return 'Active on $count days';
  }

  @override
  String reviewBest(String day) {
    return 'Best day: $day';
  }

  @override
  String get reviewTipPlan =>
      'Next week: move plan items to times that suit your day better.';

  @override
  String get reviewTipHabits =>
      'Next week: keep habits small. One you never miss beats three you skip.';

  @override
  String get reviewTipWater =>
      'Next week: keep a bottle in sight and add a glass with each meal.';

  @override
  String get reviewTipSleep =>
      'Next week: aim for a regular bedtime, even on weekends.';

  @override
  String get reviewTipActivity =>
      'Next week: a 10-minute walk after a meal counts.';

  @override
  String get reviewTipMeals =>
      'Next week: logging meals helps your plan fit you better.';

  @override
  String get reviewTipKeep => 'Next week: keep the rhythm you\'ve built.';

  @override
  String get reviewClose => 'Close';

  @override
  String get reviewSeeInsights => 'See insights';

  @override
  String get postureCompare => 'Compare';

  @override
  String get postureCompareTitle => 'Compare sessions';

  @override
  String get postureCompareSetup =>
      'For a fair comparison use the same setup: same spot and distance, similar light, fitted clothes and a similar time of day.';

  @override
  String get postureCompareEarlier => 'Earlier';

  @override
  String get postureCompareLater => 'Later';

  @override
  String get postureCompareChange => 'Change';

  @override
  String get postureCompareNeedTwo =>
      'Save two checks from the same view to compare them.';

  @override
  String get connectedTitle => 'Connected data';

  @override
  String get connectedIntro =>
      'Track steps, walks, runs and sleep from this phone\'s own sensors. Everything stays on this device: no account, no cloud, nothing uploaded.';

  @override
  String get connectedPhoneSensors => 'This phone\'s sensors';

  @override
  String get connectedSteps => 'Steps';

  @override
  String get connectedStepsInfo =>
      'Counted by the phone\'s step sensor, checked every 15 minutes.';

  @override
  String get connectedActivity => 'Walks, runs and rides';

  @override
  String get connectedActivityInfo =>
      'Detected on the phone when you move for 10 minutes or more.';

  @override
  String get connectedSleep => 'Bed and wake times';

  @override
  String get connectedSleepInfo =>
      'Estimated by the phone overnight. You can edit or delete any night.';

  @override
  String get connectedNoSensor => 'This phone has no step sensor.';

  @override
  String get connectedNoPlay =>
      'Walk and sleep detection needs Google Play services on this phone.';

  @override
  String get connectedPermission =>
      'Allow \"Physical activity\" so the phone can count steps and movement.';

  @override
  String get connectedAllow => 'Allow';

  @override
  String get connectedHealthConnect => 'Health Connect';

  @override
  String get connectedHcInfo =>
      'Android\'s on-device health store is on this phone. Read steps, workouts, sleep, weight, height and water that other apps saved there, without any account.';

  @override
  String get connectedHcAbsent =>
      'Health Connect isn\'t on this phone. That\'s fine: the phone\'s own sensors cover steps, walks and sleep.';

  @override
  String get connectedHcConnect => 'Choose what to read';

  @override
  String get connectedSyncNow => 'Sync now';

  @override
  String connectedLastSync(String time) {
    return 'Last synced $time';
  }

  @override
  String get connectedNeverSynced => 'Not synced yet';

  @override
  String connectedSynced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items updated',
      one: '1 item updated',
      zero: 'Up to date',
    );
    return '$_temp0';
  }

  @override
  String get connectedRemove => 'Remove imported data';

  @override
  String get connectedRemoveConfirm =>
      'Remove everything imported from this source? Your own entries stay.';

  @override
  String connectedRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items removed',
      one: '1 item removed',
    );
    return '$_temp0';
  }

  @override
  String get connectedPrivacy =>
      'Read only and on this device. Steps from several sources never add up twice: the larger daily total is used.';

  @override
  String get sourcePhone => 'Phone sensor';

  @override
  String get backupTitle => 'Backup & export';

  @override
  String get backupSubtitle =>
      'Move to a new phone, keep a safe copy, or open your data elsewhere';

  @override
  String get backupIntro =>
      'There\'s no account and no cloud, so your data lives only on this phone. Make a backup file and keep it somewhere safe, or send it to your other phone.';

  @override
  String get backupEncrypted => 'Encrypted backup';

  @override
  String get backupEncryptedInfo =>
      'Everything in the app, locked with a passphrase you choose. Restore it on any phone with Personality.';

  @override
  String get backupIncludePhotos => 'Include progress photos';

  @override
  String get backupIncludePhotosInfo => 'Makes the file larger.';

  @override
  String get backupSaveFile => 'Save to file';

  @override
  String get backupShare => 'Send';

  @override
  String get backupNever => 'No backup made on this phone yet';

  @override
  String backupLast(String time) {
    return 'Last backup $time';
  }

  @override
  String get backupSaved => 'Saved';

  @override
  String get backupFailed => 'That didn\'t work. Please try again.';

  @override
  String get backupRestoreTitle => 'Restore a backup';

  @override
  String get backupRestoreInfo =>
      'Open a .personality file from your other phone, a drive or a chat.';

  @override
  String get backupChooseFile => 'Choose backup file';

  @override
  String get backupExportTitle => 'Export for other apps';

  @override
  String get backupExportInfo =>
      'Readable copies to open in a spreadsheet or another app. Not encrypted and without photos.';

  @override
  String get backupCsv => 'Spreadsheet (CSV)';

  @override
  String get backupCsvInfo => 'A zip with one table per kind of record';

  @override
  String get backupJson => 'JSON';

  @override
  String get backupJsonInfo => 'Everything in one file, for developers';

  @override
  String get backupPrivacy =>
      'Files go only where you send them. Without the passphrase a backup can\'t be read by anyone, including us, and a lost passphrase can\'t be recovered.';

  @override
  String get backupPassphrase => 'Passphrase';

  @override
  String get backupPassphraseAgain => 'Repeat passphrase';

  @override
  String get backupPassphraseCreate => 'Choose a passphrase';

  @override
  String get backupPassphraseEnter => 'Enter the backup\'s passphrase';

  @override
  String get backupPassphraseWarning =>
      'You\'ll need it to restore. Write it down: it can\'t be reset.';

  @override
  String get backupPassphraseShort => 'Use at least 8 characters';

  @override
  String get backupPassphraseMismatch => 'The passphrases don\'t match';

  @override
  String get backupShowPassphrase => 'Show passphrase';

  @override
  String get backupContinue => 'Continue';

  @override
  String backupFound(String date, int records, int photos) {
    return 'Backup from $date: $records records, $photos photos.';
  }

  @override
  String get backupMergeInfo =>
      'Add: keeps what\'s on this phone and adds anything missing.';

  @override
  String get backupReplaceInfo =>
      'Replace: this phone\'s data is swapped for the backup.';

  @override
  String get backupMerge => 'Add';

  @override
  String get backupReplace => 'Replace';

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restored $count records',
      one: 'Restored 1 record',
    );
    return '$_temp0';
  }

  @override
  String get backupErrorNotBackup => 'That isn\'t a Personality backup file.';

  @override
  String get backupErrorDamaged => 'The backup file is damaged or incomplete.';

  @override
  String get backupErrorPassphrase => 'Wrong passphrase.';

  @override
  String get backupErrorTooNew =>
      'This backup is from a newer version. Update the app, then try again.';
}
