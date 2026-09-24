import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/units/units.dart';

void main() {
  test('height conversions', () {
    expect(UnitConversions.cmToFeetInches(172), (feet: 5, inches: 8));
    expect(UnitConversions.cmToFeetInches(182.88), (feet: 6, inches: 0));
    // 5 ft 11.6 in rounds to 6 ft 0 in, not 5 ft 12 in.
    expect(UnitConversions.cmToFeetInches(181.9), (feet: 6, inches: 0));
    expect(UnitConversions.feetInchesToCm(5, 8), closeTo(172.72, 1e-9));
  });

  test('weight, volume and distance round-trip', () {
    expect(UnitConversions.kgToPounds(70), closeTo(154.32, 0.01));
    expect(UnitConversions.poundsToKg(UnitConversions.kgToPounds(70)),
        closeTo(70, 1e-9));
    expect(UnitConversions.mlToFluidOunces(250), closeTo(8.45, 0.01));
    expect(UnitConversions.kmToMiles(10), closeTo(6.214, 0.001));
  });

  test('unit system parsing defaults to metric', () {
    expect(UnitSystem.fromName('imperial'), UnitSystem.imperial);
    expect(UnitSystem.fromName(null), UnitSystem.metric);
    expect(UnitSystem.fromName('bogus'), UnitSystem.metric);
  });
}
