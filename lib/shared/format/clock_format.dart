import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Whether times show as 24-hour (the app setting, applied through
/// MediaQuery in PersonalityApp, else the device's own setting).
bool use24h(BuildContext context) =>
    MediaQuery.maybeAlwaysUse24HourFormatOf(context) ?? false;

/// "7:30 PM" or "19:30", following the user's choice.
DateFormat clockFormat(BuildContext context) {
  final tag = Localizations.localeOf(context).toLanguageTag();
  return use24h(context) ? DateFormat.Hm(tag) : DateFormat.jm(tag);
}

/// A date pattern followed by the time in the user's clock style.
DateFormat withClock(BuildContext context, DateFormat date) =>
    use24h(context) ? date.add_Hm() : date.add_jm();

/// A weekday label short enough for a day chip: "Mo", "मंग", "ن".
///
/// Two characters of the abbreviation works for most languages, but every
/// Arabic weekday starts with the article "ال", so Arabic uses CLDR's
/// one-letter narrow form instead.
String shortWeekday(String locale, DateTime day) {
  if (locale.split(RegExp('[-_]')).first == 'ar') {
    return DateFormat.EEEEE(locale).format(day);
  }
  return DateFormat.E(locale).format(day).characters.take(2).toString();
}
