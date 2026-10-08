import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/features/journey/goal_finder_screen.dart';

void main() {
  test('every goal and look photo is bundled and credited', () {
    final paths = {
      ...goalImages.values,
      for (final l in styleImages.values) ...l,
      ...photoCredits.keys,
    };
    expect(paths.length, 24);
    for (final p in paths) {
      expect(File(p).existsSync(), isTrue, reason: p);
      expect(photoCredits[p], isNotNull, reason: 'credit for $p');
      final dir = File(p).parent.path;
      final credits = File('$dir/CREDITS.md').readAsStringSync();
      expect(credits, contains(p.split('/').last), reason: p);
    }
  });
}
