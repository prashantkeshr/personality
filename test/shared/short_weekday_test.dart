import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personality/shared/format/clock_format.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  // 2024-01-07 is a Sunday; take the whole week.
  final week = [for (var d = 7; d < 14; d++) DateTime(2024, 1, d)];

  test('English keeps two-letter abbreviations', () {
    expect(week.map((d) => shortWeekday('en', d)),
        ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']);
  });

  test('Arabic days are told apart, not all "ال"', () {
    final labels = week.map((d) => shortWeekday('ar', d)).toList();
    expect(labels.toSet(), hasLength(7));
    expect(labels, isNot(contains('ال')));
  });
}
