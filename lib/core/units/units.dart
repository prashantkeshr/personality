/// Unit system (spec §56).
///
/// Values are always stored in canonical metric units (cm, kg, ml, km).
/// Conversion happens only at the display/input boundary.
library;

enum UnitSystem {
  metric,
  imperial;

  static UnitSystem fromName(String? name) => UnitSystem.values
      .firstWhere((u) => u.name == name, orElse: () => UnitSystem.metric);
}

abstract final class UnitConversions {
  static const cmPerInch = 2.54;
  static const inchesPerFoot = 12;
  static const kgPerPound = 0.45359237;
  static const mlPerFluidOunce = 29.5735295625; // US fluid ounce
  static const kmPerMile = 1.609344;

  static double cmToInches(double cm) => cm / cmPerInch;
  static double inchesToCm(double inches) => inches * cmPerInch;
  static double kgToPounds(double kg) => kg / kgPerPound;
  static double poundsToKg(double lb) => lb * kgPerPound;
  static double mlToFluidOunces(double ml) => ml / mlPerFluidOunce;
  static double fluidOuncesToMl(double oz) => oz * mlPerFluidOunce;
  static double kmToMiles(double km) => km / kmPerMile;
  static double milesToKm(double mi) => mi * kmPerMile;

  /// Splits centimetres into whole feet and rounded inches, e.g. 172 → (5, 8).
  static ({int feet, int inches}) cmToFeetInches(double cm) {
    var totalInches = cmToInches(cm).round();
    final feet = totalInches ~/ inchesPerFoot;
    totalInches -= feet * inchesPerFoot;
    return (feet: feet, inches: totalInches);
  }

  static double feetInchesToCm(int feet, double inches) =>
      inchesToCm(feet * inchesPerFoot + inches);
}
