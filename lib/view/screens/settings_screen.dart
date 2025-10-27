import 'dart:math' as math;
import 'dart:ui';

import 'package:factor/view/components/neumorphic_card.dart';
import 'package:factor/view_model/exchange_rate_calculator.dart';
import 'package:factor/view_model/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ExchangeRateCalculator _calculator = ExchangeRateCalculator();
  late bool _hapticsEnabled;
  late bool _soundEnabled;
  late Future<PackageInfo> _packageInfoFuture;
  final LayerLink _themeMenuLink = LayerLink();
  bool _isThemeMenuOpen = false;

  static final Uri _iosStoreUri = Uri.parse(
    'https://apps.apple.com/us/app/factor-exchange/id000000000',
  );
  static final Uri _feedbackMailUri = Uri(
    scheme: 'mailto',
    path: 'immadotdev@gmail.com',
    queryParameters: {'subject': 'Factor Feedback'},
  );
  static final Uri _termsUri = Uri.parse(
    'https://chum-bucket.vercel.app/license',
  );
  static final Uri _privacyUri = Uri.parse(
    'https://chum-bucket.vercel.app/privacy',
  );
  static final Uri _clevaLabsUri = Uri.parse('https://x.com/ClevaLabs');

  @override
  void initState() {
    super.initState();
    _hapticsEnabled = _calculator.hapticsEnabled;
    _soundEnabled = _calculator.audioClickEnabled;
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = context.watch<ThemeController>();
    final currentThemeMode = themeController.themeMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    children: [
                      const _SectionHeading(label: 'Appearance'),
                      const SizedBox(height: 12),
                      NeumorphicCard(
                        borderRadius: 24,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              PhosphorIconsRegular.palette,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Theme',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_themeLabel(currentThemeMode)} mode',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.bodyMedium?.color
                                          ?.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            CompositedTransformTarget(
                              link: _themeMenuLink,
                              child: _ThemeMenuButton(
                                isOpen: _isThemeMenuOpen,
                                onTap: _toggleThemeMenu,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _SectionHeading(label: 'Feedback'),
                      const SizedBox(height: 12),
                      NeumorphicCard(
                        borderRadius: 24,
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            SwitchListTile.adaptive(
                              secondary: Icon(
                                PhosphorIconsRegular.vibrate,
                                color: theme.colorScheme.primary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              title: const Text('Haptic feedback'),
                              subtitle: const Text(
                                'Vibrate softly when you press keypad buttons.',
                              ),
                              value: _hapticsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _hapticsEnabled = value;
                                  _calculator.hapticsEnabled = value;
                                });
                              },
                            ),
                            const Divider(height: 1),
                            SwitchListTile.adaptive(
                              secondary: Icon(
                                PhosphorIconsRegular.waveform,
                                color: theme.colorScheme.primary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              title: const Text('Button sounds'),
                              subtitle: const Text(
                                'Play a gentle click on each keypad tap.',
                              ),
                              value: _soundEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _soundEnabled = value;
                                  _calculator.audioClickEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _SectionHeading(label: 'Rate Factor'),
                      const SizedBox(height: 12),
                      NeumorphicCard(
                        borderRadius: 24,
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _LinkTile(
                              title: 'Rate on the App Store',
                              subtitle:
                                  'Leave a review for fellow Factor traders.',
                              icon: PhosphorIconsRegular.storefront,
                              onTap: () => _launchUri(_iosStoreUri),
                            ),
                            // const Divider(height: 1),
                            // _LinkTile(
                            //   title: 'Rate on Solana dApp Store',
                            //   subtitle: 'Help others discover Factor on Solana.',
                            //   icon: PhosphorIconsRegular.compass,
                            //   onTap: () => _launchUri(_solanaDappStoreUri),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _SectionHeading(label: 'Stay in touch'),
                      const SizedBox(height: 12),
                      NeumorphicCard(
                        borderRadius: 24,
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _LinkTile(
                              title: 'Share feedback',
                              subtitle: 'immadotdev@gmail.com',
                              icon: PhosphorIconsRegular.envelope,
                              onTap: () => _launchUri(_feedbackMailUri),
                            ),
                            const Divider(height: 1),
                            _LinkTile(
                              title: 'About the developers',
                              subtitle:
                                  'ClevaLabs builds polished web3 experiences. Let’s ship yours.',
                              icon: PhosphorIconsRegular.usersThree,
                              onTap: () => _launchUri(_clevaLabsUri),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<PackageInfo>(
                        future: _packageInfoFuture,
                        builder: (context, snapshot) {
                          final version = snapshot.data?.version;
                          final build = snapshot.data?.buildNumber;
                          final versionLabel = version == null
                              ? ''
                              : build == null || build.isEmpty
                              ? 'v$version'
                              : 'v$version+$build';
                          return Center(
                            child: Text(
                              'Factor ${versionLabel.isEmpty ? '' : versionLabel}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _BottomLink(
                            label: 'Terms of Service',
                            onTap: () => _launchUri(_termsUri),
                            icon: PhosphorIconsRegular.scroll,
                          ),
                          _BottomLink(
                            label: 'Privacy Policy',
                            onTap: () => _launchUri(_privacyUri),
                            icon: PhosphorIconsRegular.shieldCheck,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isThemeMenuOpen)
              Positioned.fill(
                child: Stack(
                  children: [
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _closeThemeMenu,
                    ),
                    CompositedTransformFollower(
                      link: _themeMenuLink,
                      targetAnchor: Alignment.center,
                      followerAnchor: Alignment.center,
                      child: _ThemeRadialMenu(
                        selected: currentThemeMode,
                        onSelect: _selectTheme,
                        onClose: _closeThemeMenu,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleThemeMenu() {
    setState(() {
      _isThemeMenuOpen = !_isThemeMenuOpen;
    });
  }

  void _closeThemeMenu() {
    if (_isThemeMenuOpen) {
      setState(() {
        _isThemeMenuOpen = false;
      });
    }
  }

  void _selectTheme(ThemeMode mode) {
    context.read<ThemeController>().setTheme(mode);
    _closeThemeMenu();
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  static Future<void> _launchUri(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _ThemeMenuButton extends StatelessWidget {
  const _ThemeMenuButton({required this.isOpen, required this.onTap});

  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Icon(
              isOpen
                  ? PhosphorIconsRegular.xCircle
                  : PhosphorIconsRegular.caretDown,
              key: ValueKey<bool>(isOpen),
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeRadialMenu extends StatelessWidget {
  const _ThemeRadialMenu({
    required this.selected,
    required this.onSelect,
    required this.onClose,
  });

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onSelect;
  final VoidCallback onClose;

  static const double _menuSize = 240;
  static const double _radius = 120;
  static const double _optionSize = 72;
  static const Offset _origin = Offset(_menuSize / 2, _menuSize / 2);
  static const List<double> _angles = [math.pi / 2, 3 * math.pi / 4, math.pi];
  static const List<_ThemeOption> _options = [
    _ThemeOption(
      mode: ThemeMode.system,
      label: 'System',
      icon: PhosphorIconsRegular.deviceMobile,
    ),
    _ThemeOption(
      mode: ThemeMode.light,
      label: 'Light',
      icon: PhosphorIconsRegular.sun,
    ),
    _ThemeOption(
      mode: ThemeMode.dark,
      label: 'Dark',
      icon: PhosphorIconsRegular.moonStars,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.85, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: SizedBox(
        width: _menuSize,
        height: _menuSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Center(
                child: NeumorphicCard(
                  onTap: onClose,
                  padding: const EdgeInsets.all(16),
                  borderRadius: _menuSize / 20,
                  child: Icon(
                    PhosphorIconsRegular.x,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                ),
              ),
            ),
            for (var i = 0; i < _options.length; i++)
              Positioned(
                left:
                    _origin.dx +
                    _radius * math.cos(_angles[i]) -
                    _optionSize / 2,
                top:
                    _origin.dy +
                    _radius * math.sin(_angles[i]) -
                    _optionSize / 2,
                child: _ThemeOptionButton(
                  option: _options[i],
                  selected: selected == _options[i].mode,
                  size: _optionSize,
                  onSelect: onSelect,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionButton extends StatelessWidget {
  const _ThemeOptionButton({
    required this.option,
    required this.selected,
    required this.size,
    required this.onSelect,
  });

  final _ThemeOption option;
  final bool selected;
  final double size;
  final ValueChanged<ThemeMode> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: NeumorphicCard(
        onTap: () => onSelect(option.mode),
        padding: const EdgeInsets.all(18),
        borderRadius: size / 3.5,
        isActive: selected,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          scale: selected ? 1.05 : 1,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: selected ? 1 : 0.82,
            child: Icon(
              option.icon,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withValues(alpha: 0.75),
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeOption {
  const _ThemeOption({
    required this.mode,
    required this.label,
    required this.icon,
  });

  final ThemeMode mode;
  final String label;
  final IconData icon;
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(
        PhosphorIconsRegular.arrowUpRight,
        color: theme.colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}

class _BottomLink extends StatelessWidget {
  const _BottomLink({
    required this.label,
    required this.onTap,
    required this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
