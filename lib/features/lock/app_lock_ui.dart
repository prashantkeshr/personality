import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/security/app_lock.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Dots and a numeric keypad. Calls [onDone] with 4–8 digits.
class PinPad extends StatefulWidget {
  const PinPad({
    super.key,
    required this.title,
    required this.onDone,
    this.error,
    this.busy = false,
    this.extra,
  });

  final String title;
  final Future<void> Function(String pin) onDone;
  final String? error;
  final bool busy;

  /// Optional button beside 0 (fingerprint).
  final Widget? extra;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  var _pin = '';

  void _tap(String d) {
    if (widget.busy || _pin.length >= 8) return;
    HapticFeedback.selectionClick();
    setState(() => _pin += d);
  }

  Future<void> _submit() async {
    if (!PinVault.validPin(_pin) || widget.busy) return;
    final pin = _pin;
    setState(() => _pin = '');
    await widget.onDone(pin);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    Widget key(String d) => SizedBox.square(
      dimension: 72,
      child: TextButton(
        key: Key('pin-$d'),
        style: TextButton.styleFrom(shape: const CircleBorder()),
        onPressed: () => _tap(d),
        child: Text(d, style: theme.textTheme.headlineSmall),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          label: l.lockDigits(_pin.length),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < (_pin.length < 4 ? 4 : _pin.length); i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _pin.length ? scheme.primary : null,
                    border: Border.all(color: scheme.primary, width: 2),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: Center(
            child: widget.busy
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.error ?? '',
                    style: TextStyle(color: scheme.error),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(
            mainAxisSize: MainAxisSize.min,
            // Keypads read 1-2-3 left to right in every language.
            textDirection: TextDirection.ltr,
            children: [for (final d in row) key(d)],
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: [
            SizedBox.square(
              dimension: 72,
              child: widget.extra ?? const SizedBox(),
            ),
            key('0'),
            SizedBox.square(
              dimension: 72,
              child: IconButton(
                key: const Key('pin-back'),
                tooltip: l.lockDelete,
                onPressed: _pin.isEmpty
                    ? null
                    : () => setState(
                        () => _pin = _pin.substring(0, _pin.length - 1),
                      ),
                icon: const Icon(Icons.backspace_outlined),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        FilledButton(
          key: const Key('pin-ok'),
          onPressed: PinVault.validPin(_pin) && !widget.busy ? _submit : null,
          child: Text(l.backupContinue),
        ),
      ],
    );
  }
}

/// Covers the app while it's locked, and blanks it while it's in the
/// background so the recent-apps preview shows nothing private.
class LockGate extends ConsumerStatefulWidget {
  const LockGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> {
  late final AppLifecycleListener _life;
  DateTime? _leftAt;
  bool _covered = false;
  bool _prompted = false;
  bool _busy = false;
  String? _error;
  Timer? _tick;
  final _overlayKey = GlobalKey<OverlayState>();

  // One entry, rebuilt with the gate so the keypad always shows current state.
  bool _showing(AppLockState lock) => lock.enabled && (lock.locked || _covered);

  late final OverlayEntry _entry = OverlayEntry(
    builder: (_) {
      final lock = ref.read(appLockProvider);
      if (!_showing(lock)) return const SizedBox.shrink();
      return _LockCover(
        showPad: lock.enabled && lock.locked && !_covered,
        busy: _busy,
        error: _error,
        onPin: _pin,
        onBiometric: lock.biometric ? _biometric : null,
      );
    },
  );

  @override
  void initState() {
    super.initState();
    _life = AppLifecycleListener(
      onInactive: () => setState(() => _covered = true),
      onHide: () => _leftAt ??= DateTime.now(),
      onResume: () {
        final away = _leftAt == null
            ? Duration.zero
            : DateTime.now().difference(_leftAt!);
        _leftAt = null;
        setState(() => _covered = false);
        ref.read(appLockProvider.notifier).onResume(away);
      },
    );
  }

  @override
  void dispose() {
    _life.dispose();
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _biometric() async {
    final l = AppLocalizations.of(context);
    await ref
        .read(appLockProvider.notifier)
        .unlockWithBiometrics(l.lockBiometricReason);
  }

  Future<void> _pin(String pin) async {
    final l = AppLocalizations.of(context);
    final c = ref.read(appLockProvider.notifier);
    setState(() => _busy = true);
    final ok = await c.unlockWithPin(pin);
    if (!mounted) return;
    setState(() {
      _busy = false;
      final wait = c.waitSeconds();
      _error = ok ? null : (wait > 0 ? l.lockWait(wait) : l.lockWrongPin);
    });
    if (!ok && c.waitSeconds() > 0) {
      _tick?.cancel();
      _tick = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return t.cancel();
        final w = c.waitSeconds();
        setState(() => _error = w > 0 ? l.lockWait(w) : null);
        if (w == 0) t.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(appLockProvider);
    final locked = lock.enabled && lock.locked;
    if (!locked) _prompted = false;
    if (locked && lock.biometric && !_prompted && !_covered) {
      _prompted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _biometric());
    }
    if (_entry.mounted) _entry.markNeedsBuild();
    final hidden = _showing(lock);
    return Stack(
      children: [
        // While covered, screen readers and keyboards can't reach the app
        // behind the lock; it stays mounted so nothing loses its state.
        ExcludeSemantics(
          excluding: hidden,
          child: ExcludeFocus(excluding: hidden, child: widget.child),
        ),
        // Above the app's navigator, so it brings its own overlay for tooltips
        // and dialogs. Always mounted; empty and click-through when unlocked.
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !hidden,
            child: Overlay(key: _overlayKey, initialEntries: [_entry]),
          ),
        ),
      ],
    );
  }
}

class _LockCover extends StatelessWidget {
  const _LockCover({
    required this.showPad,
    required this.busy,
    required this.error,
    required this.onPin,
    this.onBiometric,
  });

  final bool showPad;
  final bool busy;
  final String? error;
  final Future<void> Function(String) onPin;
  final VoidCallback? onBiometric;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 40, color: scheme.primary),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l.appTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (showPad) ...[
                  PinPad(
                    key: const Key('unlock-pad'),
                    title: l.lockEnterPin,
                    error: error,
                    busy: busy,
                    onDone: onPin,
                    extra: onBiometric == null
                        ? null
                        : IconButton(
                            key: const Key('unlock-biometric'),
                            tooltip: l.lockUseFingerprint,
                            onPressed: onBiometric,
                            icon: const Icon(Icons.fingerprint, size: 32),
                          ),
                  ),
                  TextButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (c) => AlertDialog(
                        content: Text(l.lockForgotInfo),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(c),
                            child: Text(l.actionOk),
                          ),
                        ],
                      ),
                    ),
                    child: Text(l.lockForgot),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Settings: turn the lock on with a new PIN, change it, use fingerprint,
/// or turn it off (needs the current PIN).
class AppLockSettings extends ConsumerWidget {
  const AppLockSettings({super.key});

  Future<String?> _askPin(BuildContext context, {required bool confirm}) =>
      Navigator.of(context).push<String>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => _PinEntryScreen(confirm: confirm),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lock = ref.watch(appLockProvider);
    final c = ref.read(appLockProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    return Column(
      children: [
        SwitchListTile(
          key: const Key('app-lock'),
          secondary: const Icon(Icons.lock_outline),
          title: Text(l.lockTitle),
          subtitle: Text(l.lockSubtitle),
          value: lock.enabled,
          onChanged: !lock.ready
              ? null
              : (on) async {
                  if (on) {
                    final pin = await _askPin(context, confirm: true);
                    if (pin == null) return;
                    await c.enable(pin);
                    messenger.showSnackBar(SnackBar(content: Text(l.lockOn)));
                  } else {
                    final pin = await _askPin(context, confirm: false);
                    if (pin == null) return;
                    if (await ref.read(pinVaultProvider).verify(pin)) {
                      await c.disable();
                      messenger.showSnackBar(
                        SnackBar(content: Text(l.lockOff)),
                      );
                    } else {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l.lockWrongPin)),
                      );
                    }
                  }
                },
        ),
        if (lock.enabled) ...[
          FutureBuilder<bool>(
            future: ref.read(biometricsProvider).available(),
            builder: (_, snap) => snap.data != true
                ? const SizedBox.shrink()
                : SwitchListTile(
                    key: const Key('app-lock-biometric'),
                    secondary: const Icon(Icons.fingerprint),
                    title: Text(l.lockUseFingerprint),
                    value: lock.biometric,
                    onChanged: (on) => c.setBiometric(on),
                  ),
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: Text(l.lockChangePin),
            onTap: () async {
              final old = await _askPin(context, confirm: false);
              if (old == null || !context.mounted) return;
              if (!await ref.read(pinVaultProvider).verify(old)) {
                messenger.showSnackBar(SnackBar(content: Text(l.lockWrongPin)));
                return;
              }
              if (!context.mounted) return;
              final pin = await _askPin(context, confirm: true);
              if (pin == null) return;
              await c.enable(pin);
              messenger.showSnackBar(SnackBar(content: Text(l.lockChanged)));
            },
          ),
        ],
      ],
    );
  }
}

/// Full-screen PIN entry; with [confirm] the PIN is asked twice.
class _PinEntryScreen extends StatefulWidget {
  const _PinEntryScreen({required this.confirm});
  final bool confirm;

  @override
  State<_PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<_PinEntryScreen> {
  String? _first;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final title = !widget.confirm
        ? l.lockEnterPin
        : (_first == null ? l.lockSetPin : l.lockConfirmPin);
    return Scaffold(
      appBar: AppBar(title: Text(l.lockTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.confirm && _first == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Text(l.lockPinRules, textAlign: TextAlign.center),
                ),
              PinPad(
                key: ValueKey(title),
                title: title,
                error: _error,
                onDone: (pin) async {
                  if (!widget.confirm || pin == _first) {
                    return Navigator.pop(context, pin);
                  }
                  if (_first == null) {
                    setState(() {
                      _first = pin;
                      _error = null;
                    });
                    return;
                  }
                  setState(() {
                    _first = null;
                    _error = l.lockPinMismatch;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
