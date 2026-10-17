import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Who makes the app and how to reach them.
const companyName = 'dhurta.Inc';
const supportEmail = 'support@dhurta.org';

/// Settings → About: the app's logo and maker, and a support email row that
/// opens the user's own mail app (nothing is sent by the app itself).
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _device = MethodChannel('personality/device');

  Future<void> _email(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;
    try {
      opened = await _device.invokeMethod<bool>('email', {
            'to': supportEmail,
            'subject': l10n.contactEmailSubject,
          }) ??
          false;
    } on PlatformException {
      opened = false;
    } on MissingPluginException {
      opened = false;
    }
    // No mail app: copy the address so it can be pasted anywhere.
    if (!opened) await _copy(messenger, l10n);
  }

  static Future<void> _copy(
      ScaffoldMessengerState messenger, AppLocalizations l10n) async {
    await Clipboard.setData(const ClipboardData(text: supportEmail));
    messenger.showSnackBar(SnackBar(content: Text(l10n.contactEmailCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset('assets/images/brand/app_icon.png',
                    width: 56, height: 56, excludeFromSemantics: true),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personality', style: theme.textTheme.titleMedium),
                    Text(
                      l10n.aboutMadeBy(companyName),
                      key: const Key('about-company'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          key: const Key('contact-email'),
          leading: const Icon(Icons.mail_outline),
          title: Text(l10n.contactTitle),
          subtitle: Text('${l10n.contactBody}\n$supportEmail'),
          isThreeLine: true,
          onTap: () => _email(context),
          onLongPress: () =>
              _copy(ScaffoldMessenger.of(context), AppLocalizations.of(context)),
        ),
      ],
    );
  }
}
