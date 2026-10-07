import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// One card in a [StyleCarousel].
class StyleCardData {
  const StyleCardData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.art,
    required this.details,
    this.favorite = false,
    this.onFavorite,
    this.onTryOn,
    this.credit,
  });

  final String id;
  final String title;
  final String subtitle;

  /// Front visual: a photo or vector art.
  final Widget art;

  /// Back of the card: description and "Why this?".
  final String details;
  final bool favorite;
  final VoidCallback? onFavorite;

  /// Shown on the back when a live try-on exists for this item.
  final VoidCallback? onTryOn;

  /// Photo credit (licence requires attribution where applicable).
  final String? credit;
}

/// Swipeable cards; the centred card is larger, tapping flips it in 3D.
class StyleCarousel extends StatefulWidget {
  const StyleCarousel({
    super.key,
    required this.cards,
    required this.flipHint,
    required this.tryOnLabel,
    required this.favoriteLabel,
    this.height = 300,
  });

  final List<StyleCardData> cards;
  final String flipHint;
  final String tryOnLabel;
  final String favoriteLabel;
  final double height;

  @override
  State<StyleCarousel> createState() => _StyleCarouselState();
}

class _StyleCarouselState extends State<StyleCarousel> {
  final _controller = PageController(viewportFraction: 0.78);
  final _flipped = <String>{};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.cards.length,
        itemBuilder: (context, i) => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Scale and dim cards as they move away from the centre.
            final page = _controller.hasClients &&
                    _controller.position.haveDimensions
                ? _controller.page ?? 0
                : 0.0;
            final d = (page - i).abs().clamp(0.0, 1.0);
            return Transform.scale(
              scale: 1 - 0.08 * d,
              child: Opacity(opacity: 1 - 0.35 * d, child: child),
            );
          },
          child: _FlipCard(
            data: widget.cards[i],
            flipped: _flipped.contains(widget.cards[i].id),
            reduceMotion: reduce,
            flipHint: widget.flipHint,
            tryOnLabel: widget.tryOnLabel,
            favoriteLabel: widget.favoriteLabel,
            onTap: () => setState(() {
              final id = widget.cards[i].id;
              _flipped.contains(id) ? _flipped.remove(id) : _flipped.add(id);
            }),
          ),
        ),
      ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  const _FlipCard({
    required this.data,
    required this.flipped,
    required this.reduceMotion,
    required this.flipHint,
    required this.tryOnLabel,
    required this.favoriteLabel,
    required this.onTap,
  });

  final StyleCardData data;
  final bool flipped;
  final bool reduceMotion;
  final String flipHint;
  final String tryOnLabel;
  final String favoriteLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Semantics(
        button: true,
        hint: flipHint,
        child: GestureDetector(
          onTap: onTap,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: flipped ? 1 : 0),
            duration:
                reduceMotion ? Duration.zero : const Duration(milliseconds: 520),
            curve: Curves.easeInOutCubic,
            builder: (context, t, _) {
              final angle = t * math.pi;
              final showBack = t > 0.5;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateY(angle),
                child: showBack
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: _back(context),
                      )
                    : _front(context),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _shell(BuildContext context, Widget child) => Material(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppRadius.card + 4),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: child,
      );

  Widget _front(BuildContext context) {
    final theme = Theme.of(context);
    return _shell(
      context,
      Stack(
        fit: StackFit.expand,
        children: [
          data.art,
          // Legibility gradient under the title.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC000000)],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                Text(data.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: _FavoriteButton(
                on: data.favorite, label: favoriteLabel, onTap: data.onFavorite),
          ),
          if (data.credit != null)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Text(data.credit!,
                  style: const TextStyle(color: Colors.white70, fontSize: 9)),
            ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    final theme = Theme.of(context);
    return _shell(
      context,
      Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                  child: Text(data.title, style: theme.textTheme.titleMedium)),
              _FavoriteButton(
                  on: data.favorite,
                  label: favoriteLabel,
                  onTap: data.onFavorite,
                  dark: false),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: SingleChildScrollView(
                child: Text(data.details, style: theme.textTheme.bodyMedium),
              ),
            ),
            if (data.onTryOn != null)
              FilledButton.icon(
                onPressed: data.onTryOn,
                icon: const Icon(Icons.face_retouching_natural),
                label: Text(tryOnLabel),
              ),
          ],
        ),
      ),
    );
  }
}

/// Heart that pops when toggled.
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.on,
    required this.label,
    required this.onTap,
    this.dark = true,
  });

  final bool on;
  final String label;
  final VoidCallback? onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = on
        ? Theme.of(context).colorScheme.primary
        : (dark ? Colors.white : Theme.of(context).colorScheme.onSurface);
    return IconButton(
      tooltip: label,
      onPressed: onTap,
      style: dark
          ? IconButton.styleFrom(backgroundColor: Colors.black38)
          : null,
      icon: AnimatedSwitcher(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 260),
        transitionBuilder: (c, a) => ScaleTransition(
            scale: Tween(begin: 0.4, end: 1.0)
                .animate(CurvedAnimation(parent: a, curve: Curves.elasticOut)),
            child: c),
        child: Icon(on ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(on), color: color),
      ),
    );
  }
}
