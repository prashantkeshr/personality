import '../entities/body.dart';
import '../entities/provenance.dart';

/// Chooses the height used across the app (spec §11).
///
/// Order: the record the user pinned as primary, then the latest
/// user-entered record, then the latest imported/health-platform record.
/// Camera estimates are never chosen automatically.
BodyRecord? selectPrimaryHeight(List<BodyRecord> records, {String? pinnedId}) {
  if (records.isEmpty) return null;

  if (pinnedId != null) {
    for (final r in records) {
      if (r.id == pinnedId) return r;
    }
  }

  BodyRecord? latestOf(Set<DataSource> sources) {
    BodyRecord? best;
    for (final r in records) {
      if (!sources.contains(r.source)) continue;
      if (best == null || r.recordedAt.isAfter(best.recordedAt)) best = r;
    }
    return best;
  }

  return latestOf({DataSource.userEntered}) ??
      latestOf({DataSource.imported, DataSource.healthPlatform});
}

/// Everyday height varies by roughly 1–2 cm (posture, time of day,
/// measuring technique). Differences inside this band are shown as normal
/// variation, never as growth or shrinkage (spec §39).
const heightVariationToleranceCm = 2.0;

bool isWithinNormalVariation(double aCm, double bCm) =>
    (aCm - bCm).abs() <= heightVariationToleranceCm;
