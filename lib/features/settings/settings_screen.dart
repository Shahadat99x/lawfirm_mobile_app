import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexnova/l10n/app_localizations.dart';
import '../../shared/providers/locale_provider.dart';
import '../../shared/theme/theme_mode_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../shared/cache/simple_cache.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              onChanged: (ThemeMode? newMode) {
                if (newMode != null) {
                  ref.read(themeModeProvider.notifier).setTheme(newMode);
                }
              },
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.settingsLanguage),
            subtitle: Text(_getLanguageName(context, ref.watch(localeProvider))),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguagePicker(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: Text(AppLocalizations.of(context)!.settingsAdmin),
            onTap: () {
              context.push('/admin');
            },
          ),
          const Divider(),
          _SettingsSectionHeader(title: 'LEGAL & COMPLIANCE'),
          ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About this Demo'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/settings/demo'),
          ),
          ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/settings/privacy'),
          ),
          ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/settings/terms'),
          ),
          ListTile(
              leading: const Icon(Icons.cookie_outlined),
              title: const Text('GDPR & Data Use'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.go('/settings/gdpr'),
          ),
           const Divider(),
          _SettingsSectionHeader(title: 'DATA'),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear Cache'),
            onTap: () async {
              await SimpleCache().clearAll([
                'practice_areas_cache',
                'blog_posts_cache',
                'lawyers_cache'
              ]);
             if (context.mounted) {
               ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared (Demo)')),
                );
             }
            },
          ),
           const Divider(),
          ListTile(
            title: const Text('App Version'),
            subtitle: Text(_version),
          ),
        ],
      ),
    );
  }


  String _getLanguageName(BuildContext context, Locale? locale) {
    if (locale == null) return AppLocalizations.of(context)!.languageSystem;
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizations.of(context)!.languageEn;
      case 'lt':
        return AppLocalizations.of(context)!.languageLt;
      case 'ro':
        return AppLocalizations.of(context)!.languageRo;
      case 'es':
        return AppLocalizations.of(context)!.languageEs;
      default:
        return locale.languageCode;
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.settingsLanguage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _buildLanguageOption(ctx, ref, l10n.languageSystem, null, currentLocale),
              _buildLanguageOption(ctx, ref, l10n.languageEn, const Locale('en'), currentLocale),
              _buildLanguageOption(ctx, ref, l10n.languageLt, const Locale('lt'), currentLocale),
              _buildLanguageOption(ctx, ref, l10n.languageRo, const Locale('ro'), currentLocale),
              _buildLanguageOption(ctx, ref, l10n.languageEs, const Locale('es'), currentLocale),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String label,
    Locale? value,
    Locale? groupValue,
  ) {
    final isSelected = value == groupValue;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(value);
        Navigator.pop(context);
      },
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final String title;
  const _SettingsSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
