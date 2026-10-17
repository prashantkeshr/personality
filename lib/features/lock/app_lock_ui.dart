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

  /// Shown briefly after the lock turned itself off (phone lock removed).
  String? _notice;
  Timer? _tick;
  final _overlayKey = GlobalKey<OverlayState>();

  // One entry, rebuilt with the gate so the keypad always shows current state.
  bool _showing(AppLockState lock) => lock.enabled && (lock.locked || _covered);

  late final OverlayEntry _entry = OverlayEntry(
    builder: (_) {
      final lock = ref.read(appLockProvider);
      if (!_showing(lock)) {
        return _notice == null ? const SizedBox.shrink() : _Notice(_notice!);
      }
      return _LockCover(
        showPad: lock.enabled && lock.locked && !_covered,
        busy: _busy,
        error: _error,
        onPin: _pin,
        onBiometric: lock.biometric ? _biometric : null,
        onDevice: lock.device ? _device : null,
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

  Future<void> _device() async {
    if (_busy) return;
    final l = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final r = await ref
        .read(appLockProvider.notifier)
        .unlockWithDevice(l.lockBiometricReason);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = r == DeviceAuth.failed ? l.lockDeviceFailed : null;
      if (r == DeviceAuth.noLock) _notice = l.lockDeviceRemoved;
    });
    if (r == DeviceAuth.noLock) {
      Timer(const Duration(seconds: 5), () {
        if (mounted) setState(() => _notice = null);
      });
    }
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
    if (locked && (lock.device || lock.biometric) && !_prompted && !_covered) {
      _prompted = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => lock.device ? _device() : _biometric(),
      );
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
    this.onDevice,
  });

  final bool showPad;
  final bool busy;
  final String? error;
  final Future<void> Function(String) onPin;
  final VoidCallback? onBiometric;

  /// Set when the phone's screen lock unlocks the app: no keypad, just the
  /// system prompt.
  final VoidCallback? onDevice;

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
                if (showPad && onDevice != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Column(
                      children: [
                        Text(
                          l.lockDeviceHint,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 40,
                          child: Center(
                            child: busy
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    error ?? '',
                                    style: TextStyle(color: scheme.error),
                                  ),
                          ),
                        ),
                        FilledButton.icon(
                          key: const Key('unlock-device'),
                          onPressed: busy ? null : onDevice,
                          icon: const Icon(Icons.fingerprint),
                          label: Text(l.lockUnlock),
                        ),
                      ],
                    ),
                  )
                else if (showPad) ...[
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

enum _Method { device, pin }

/// Settings: turn the lock on with the phone's screen lock or an app PIN,
/// switch between them, use fingerprint with the PIN, or turn it off. Every
/// change first asks for the current lock.
class AppLockSettings extends ConsumerWidget {
  const AppLockSettings({super.key});

  Future<String?> _askPin(BuildContext context, {required bool confirm}) =>
      Navigator.of(context).push<String>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => _PinEntryScreen(confirm: confirm),
        ),
      );

  Future<_Method?> _chooseMethod(BuildContext context) {
    final l = AppLocalizations.of(context);
    return showModalBottomSheet<_Method>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                l.lockMethodTitle,
                style: Theme.of(c).textTheme.titleLarge,
              ),
            ),
            ListTile(
              key: const Key('lock-method-device'),
              leading: const Icon(Icons.phonelink_lock),
              title: Text(l.lockMethodDevice),
              subtitle: Text(l.lockMethodDeviceInfo),
              onTap: () => Navigator.pop(c, _Method.device),
            ),
            ListTile(
              key: const Key('lock-method-pin'),
              leading: const Icon(Icons.pin_outlined),
              title: Text(l.lockMethodPin),
              subtitle: Text(l.lockMethodPinInfo),
              onTap: () => Navigator.pop(c, _Method.pin),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  /// Asks for whatever currently unlocks the app.
  Future<bool> _confirmCurrent(
    BuildContext context,
    WidgetRef ref,
    AppLockState lock,
  ) async {
    final l = AppLocalizations.of(context);
    if (lock.device) {
      return ref
          .read(appLockProvider.notifier)
          .confirmDevice(l.lockBiometricReason);
    }
    final pin = await _askPin(context, confirm: false);
    if (pin == null) return false;
    return ref.read(pinVaultProvider).verify(pin);
  }

  Future<void> _useDevice(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final r = await ref
        .read(appLockProvider.notifier)
        .enableDevice(l.lockBiometricReason);
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (r) {
          DeviceAuth.success => l.lockOn,
          DeviceAuth.noLock => l.lockNoDeviceLock,
          DeviceAuth.failed => l.lockDeviceFailed,
        }),
      ),
    );
  }

  Future<void> _usePin(BuildContext context, WidgetRef ref, String done) async {
    final messenger = ScaffoldMessenger.of(context);
    final pin = await _askPin(context, confirm: true);
    if (pin == null) return;
    await ref.read(appLockProvider.notifier).enable(pin);
    messenger.showSnackBar(SnackBar(content: Text(done)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lock = ref.watch(appLockProvider);
    final c = ref.read(appLockProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final deviceLock = ref.read(biometricsProvider).deviceLockAvailable();

    Future<void> wrong() async => messenger.showSnackBar(
      SnackBar(
        content: Text(lock.device ? l.lockDeviceFailed : l.lockWrongPin),
      ),
    );

    return Column(
      children: [
        SwitchListTile(
          key: const Key('app-lock'),
          secondary: const Icon(Icons.lock_outline),
          title: Text(l.lockTitle),
          subtitle: Text(
            !lock.enabled
                ? l.lockSubtitle
                : (lock.device ? l.lockUsesDevice : l.lockUsesPin),
          ),
          value: lock.enabled,
          onChanged: !lock.ready
              ? null
              : (on) async {
                  if (on) {
                    final hasDeviceLock = await deviceLock;
                    if (!context.mounted) return;
                    final method = hasDeviceLock
                        ? await _chooseMethod(context)
                        : _Method.pin;
                    if (method == null || !context.mounted) return;
                    if (method == _Method.device) {
                      await _useDevice(context, ref);
                    } else {
                      await _usePin(context, ref, l.lockOn);
                    }
                  } else {
                    if (await _confirmCurrent(context, ref, lock)) {
                      await c.disable();
                      messenger.showSnackBar(
                        SnackBar(content: Text(l.lockOff)),
                      );
                    } else {
                      await wrong();
                    }
                  }
                },
        ),
        if (lock.enabled && !lock.device) ...[
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
              if (!await _confirmCurrent(context, ref, lock)) return wrong();
              if (!context.mounted) return;
              await _usePin(context, ref, l.lockChanged);
            },
          ),
          FutureBuilder<bool>(
            future: deviceLock,
            builder: (_, snap) => snap.data != true
                ? const SizedBox.shrink()
                : ListTile(
                    key: const Key('lock-switch-device'),
                    leading: const Icon(Icons.phonelink_lock),
                    title: Text(l.lockSwitchToDevice),
                    onTap: () async {
                      if (!await _confirmCurrent(context, ref, lock)) {
                        return wrong();
                      }
                      if (!context.mounted) return;
                      await _useDevice(context, ref);
                    },
                  ),
          ),
        ],
        if (lock.enabled && lock.device)
          ListTile(
            key: const Key('lock-switch-pin'),
            leading: const Icon(Icons.pin_outlined),
            title: Text(l.lockSwitchToPin),
            onTap: () async {
              if (!await _confirmCurrent(context, ref, lock)) return wrong();
              if (!context.mounted) return;
              await _usePin(context, ref, l.lockOn);
            },
          ),
      ],
    );
  }
}

/// A short message at the bottom of the screen, above the app.
class _Notice extends StatelessWidget {
  const _Notice(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.inverseSurface,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
          ),
        ),
      ),
    ),
  );
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
