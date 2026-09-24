import 'package:flutter/material.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/units/units.dart';
import '../../../domain/entities/body.dart';
import '../../../domain/entities/provenance.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/format/body_format.dart';

enum RecordKind { height, weight, measurement }

/// Validated user input, in canonical units.
class RecordDraft {
  const RecordDraft({
    required this.measurement,
    this.notes,
    this.type,
    this.customLabel,
  });

  final Measurement measurement;
  final String? notes;
  final BodyMeasurementType? type;
  final String? customLabel;
}

Future<void> showAddRecordSheet(
  BuildContext context, {
  required RecordKind kind,
  required UnitSystem units,
  required Future<void> Function(RecordDraft draft) onSave,
  BodyMeasurementType? presetType,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => AddRecordSheet(
      kind: kind,
      units: units,
      onSave: onSave,
      presetType: presetType,
    ),
  );
}

class AddRecordSheet extends StatefulWidget {
  const AddRecordSheet({
    super.key,
    required this.kind,
    required this.units,
    required this.onSave,
    this.presetType,
    this.clock = DateTime.now,
  });

  final RecordKind kind;
  final UnitSystem units;
  final Future<void> Function(RecordDraft draft) onSave;
  final BodyMeasurementType? presetType;
  final DateTime Function() clock;

  @override
  State<AddRecordSheet> createState() => _AddRecordSheetState();
}

class _AddRecordSheetState extends State<AddRecordSheet> {
  final _form = GlobalKey<FormState>();
  final _value = TextEditingController();
  final _inches = TextEditingController();
  final _notes = TextEditingController();
  final _label = TextEditingController();
  late BodyMeasurementType _type =
      widget.presetType ?? BodyMeasurementType.chest;
  late MeasurementMethod _method = _methods.first;
  late DateTime _date = widget.clock();
  bool _saving = false;

  bool get _feetInches =>
      widget.kind == RecordKind.height && widget.units == UnitSystem.imperial;

  List<MeasurementMethod> get _methods => switch (widget.kind) {
        RecordKind.weight => const [
            MeasurementMethod.scale,
            MeasurementMethod.professional,
            MeasurementMethod.estimated,
          ],
        _ => const [
            MeasurementMethod.selfMeasured,
            MeasurementMethod.measuredByOther,
            MeasurementMethod.professional,
          ],
      };

  (double, double) get _limits => switch (widget.kind) {
        RecordKind.height => (BodyLimits.minHeightCm, BodyLimits.maxHeightCm),
        RecordKind.weight => (BodyLimits.minWeightKg, BodyLimits.maxWeightKg),
        RecordKind.measurement => (
            BodyLimits.minMeasurementCm,
            BodyLimits.maxMeasurementCm
          ),
      };

  @override
  void dispose() {
    _value.dispose();
    _inches.dispose();
    _notes.dispose();
    _label.dispose();
    super.dispose();
  }

  static double? _parse(String s) =>
      double.tryParse(s.trim().replaceAll(',', '.'));

  /// Converts the entered value to canonical units, or null if invalid.
  double? _canonical() {
    final v = _parse(_value.text);
    if (v == null) return null;
    final metric = widget.units == UnitSystem.metric;
    return switch (widget.kind) {
      RecordKind.height when !metric => UnitConversions.inchesToCm(
          v * UnitConversions.inchesPerFoot + (_parse(_inches.text) ?? 0)),
      RecordKind.weight when !metric => UnitConversions.poundsToKg(v),
      RecordKind.measurement when !metric => UnitConversions.inchesToCm(v),
      _ => v,
    };
  }

  String? _validateValue(String? _) {
    final l10n = AppLocalizations.of(context);
    final format = BodyFormat.of(context, widget.units);
    final v = _canonical();
    if (v == null) return l10n.validationRequired;
    final (min, max) = _limits;
    if (v < min || v > max) {
      final show = switch (widget.kind) {
        RecordKind.height => format.height,
        RecordKind.weight => format.weight,
        RecordKind.measurement => format.length,
      };
      return l10n.validationRange(show(min), show(max));
    }
    return null;
  }

  Future<void> _pickDate() async {
    final now = widget.clock();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final now = widget.clock();
    final isToday = DateUtils.isSameDay(_date, now);
    final recordedAt =
        isToday ? now : DateTime(_date.year, _date.month, _date.day, 12);
    final isMass = widget.kind == RecordKind.weight;

    final draft = RecordDraft(
      measurement: Measurement(
        value: _canonical()!,
        unit: isMass ? CanonicalUnits.mass : CanonicalUnits.length,
        source: DataSource.userEntered,
        method: _method.wireName,
        recordedAt: recordedAt.toUtc(),
      ),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      type: widget.kind == RecordKind.measurement ? _type : null,
      customLabel:
          _type == BodyMeasurementType.custom ? _label.text.trim() : null,
    );

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      await widget.onSave(draft);
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('record.save', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = BodyFormat.of(context, widget.units);
    final metric = widget.units == UnitSystem.metric;
    final title = switch (widget.kind) {
      RecordKind.height => l10n.heightAdd,
      RecordKind.weight => l10n.weightAdd,
      RecordKind.measurement => l10n.measurementAdd,
    };
    final unitSuffix = switch (widget.kind) {
      RecordKind.height => metric ? l10n.unitCmShort : l10n.unitFtShort,
      RecordKind.weight => metric ? l10n.unitKgShort : l10n.unitLbShort,
      RecordKind.measurement => metric ? l10n.unitCmShort : l10n.unitInShort,
    };
    final help = widget.kind == RecordKind.measurement
        ? l10n.measurementHelp(_type)
        : null;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              if (widget.kind == RecordKind.measurement &&
                  widget.presetType == null) ...[
                DropdownButtonFormField<BodyMeasurementType>(
                  initialValue: _type,
                  decoration: InputDecoration(labelText: l10n.measurementType),
                  items: [
                    for (final t in BodyMeasurementType.values)
                      DropdownMenuItem(
                          value: t, child: Text(l10n.measurementName(t))),
                  ],
                  onChanged: (t) => setState(() => _type = t!),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (widget.kind == RecordKind.measurement &&
                  _type == BodyMeasurementType.custom) ...[
                TextFormField(
                  controller: _label,
                  decoration:
                      InputDecoration(labelText: l10n.measurementCustomLabel),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.validationRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (help != null) ...[
                Text(help, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.md),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('record-value'),
                      controller: _value,
                      autofocus: true,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(suffixText: unitSuffix),
                      validator: _validateValue,
                    ),
                  ),
                  if (_feetInches) ...[
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        key: const Key('record-inches'),
                        controller: _inches,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            InputDecoration(suffixText: l10n.unitInShort),
                        validator: (v) {
                          final i = _parse(v ?? '');
                          if (v != null && v.isNotEmpty &&
                              (i == null || i < 0 || i >= 12)) {
                            return l10n.validationRange('0', '11');
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<MeasurementMethod>(
                initialValue: _method,
                decoration: InputDecoration(labelText: l10n.fieldMethod),
                items: [
                  for (final m in _methods)
                    DropdownMenuItem(value: m, child: Text(l10n.methodLabel(m))),
                ],
                onChanged: (m) => setState(() => _method = m!),
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: Text(l10n.fieldDate),
                subtitle: Text(format.date(_date)),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: _notes,
                decoration: InputDecoration(labelText: l10n.fieldNotes),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(l10n.actionSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirmation before a permanent delete.
Future<bool> confirmDelete(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.deleteRecordTitle),
      content: Text(l10n.deleteRecordBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.actionDelete),
        ),
      ],
    ),
  );
  return ok ?? false;
}
