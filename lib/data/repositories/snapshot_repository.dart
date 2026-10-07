import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import 'body_record_repository.dart';

enum SnapshotKind { face, bodyFront, bodySide }

class Snapshot {
  const Snapshot({
    required this.id,
    required this.kind,
    required this.takenAt,
    required this.jpeg,
    required this.width,
    required this.height,
  });

  final String id;
  final SnapshotKind kind;
  final DateTime takenAt;
  final Uint8List jpeg;
  final int width;
  final int height;
}

/// Upright, size-limited JPEG: orientation baked in, longest side ≤ 1080.
/// Runs off the UI thread.
class PreparedPhoto {
  const PreparedPhoto(this.jpeg, this.width, this.height);
  final Uint8List jpeg;
  final int width;
  final int height;
}

PreparedPhoto? preparePhoto(Uint8List raw) {
  img.Image? decoded;
  try {
    decoded = img.decodeImage(raw);
  } catch (_) {
    return null; // corrupt or unsupported bytes
  }
  if (decoded == null) return null;
  var im = img.bakeOrientation(decoded);
  const maxSide = 1080;
  if (im.width > maxSide || im.height > maxSide) {
    im = im.width >= im.height
        ? img.copyResize(im, width: maxSide)
        : img.copyResize(im, height: maxSide);
  }
  return PreparedPhoto(
      Uint8List.fromList(img.encodeJpg(im, quality: 82)), im.width, im.height);
}

/// Progress snapshots, stored inside the encrypted database.
class SnapshotRepository {
  SnapshotRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  /// Prepares and stores [raw] camera bytes. Returns the new id, or null if
  /// the photo could not be decoded.
  Future<String?> add(SnapshotKind kind, Uint8List raw) async {
    final photo = await compute(preparePhoto, raw);
    if (photo == null) return null;
    final id = _uuid.v4();
    final now = _clock().toUtc().millisecondsSinceEpoch;
    await _db.into(_db.snapshots).insert(SnapshotsCompanion.insert(
          id: id,
          kind: kind.name,
          takenAt: now,
          jpeg: photo.jpeg,
          width: photo.width,
          height: photo.height,
          createdAt: now,
        ));
    return id;
  }

  /// Newest first.
  Stream<List<Snapshot>> watch(SnapshotKind kind) {
    final q = _db.select(_db.snapshots)
      ..where((t) => t.kind.equals(kind.name))
      ..orderBy([(t) => OrderingTerm.desc(t.takenAt)]);
    return q.watch().map((rows) => [
          for (final r in rows)
            Snapshot(
              id: r.id,
              kind: kind,
              takenAt:
                  DateTime.fromMillisecondsSinceEpoch(r.takenAt, isUtc: true),
              jpeg: r.jpeg,
              width: r.width,
              height: r.height,
            ),
        ]);
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.snapshots)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAll() => _db.delete(_db.snapshots).go();
}
