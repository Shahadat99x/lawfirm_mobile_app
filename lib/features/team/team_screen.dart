import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'data/lawyer_repo.dart';
import 'domain/lawyer.dart';
import '../../shared/config/contact_config.dart';
import '../../shared/theme/app_colors.dart';
import 'package:lexnova/l10n/app_localizations.dart';
import 'widgets/team_member_sheet.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.contactCopied)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lawyersAsync = ref.watch(lawyersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.ourFirmTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(lawyersProvider);
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100), // Spacing for nav bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Team Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.teamOurTeam,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              lawyersAsync.when(
                data: (lawyers) {
                  if (lawyers.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(AppLocalizations.of(context)!.teamEmpty),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lawyers.length,
                    itemBuilder: (context, index) {
                      final lawyer = lawyers[index];
                      return _LawyerCard(lawyer: lawyer);
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.teamError),
                        ElevatedButton(
                          onPressed: () => ref.refresh(lawyersProvider),
                          child: Text(AppLocalizations.of(context)!.teamRetry),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(height: 32),

              // Contact & Office Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.contactTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      icon: Icons.location_on_outlined,
                      title: AppLocalizations.of(context)!.contactAddress,
                      content: ContactConfig.address,
                      action: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            onPressed: () =>
                                _launchUrl(ContactConfig.googleMapsUrl),
                            icon: const Icon(Icons.map, size: 16),
                            label: Text(
                              AppLocalizations.of(context)!.contactOpenMaps,
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              minimumSize: Size.zero,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _copyToClipboard(
                              context,
                              ContactConfig.address,
                            ),
                            icon: const Icon(Icons.copy, size: 16),
                            tooltip: AppLocalizations.of(
                              context,
                            )!.contactCopyAddress,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            style: IconButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      icon: Icons.language,
                      title: 'Website',
                      content: ContactConfig.website,
                      onTap: () => _launchUrl(ContactConfig.website),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      icon: Icons.email_outlined,
                      title: AppLocalizations.of(context)!.contactEmail,
                      content: ContactConfig.email,
                      onTap: () => _launchUrl('mailto:${ContactConfig.email}'),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Social Profiles',
                      content: ContactConfig.officeHours,
                      action: Wrap(
                        spacing: 0,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.code), // GitHub
                            tooltip: 'GitHub',
                            onPressed: () => _launchUrl(ContactConfig.github),
                          ),
                          IconButton(
                            icon: const Icon(Icons.work_outline), // LinkedIn
                            tooltip: 'LinkedIn',
                            onPressed: () => _launchUrl(ContactConfig.linkedin),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close), // X
                            tooltip: 'X (Twitter)',
                            onPressed: () => _launchUrl(ContactConfig.x),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                            ), // Instagram
                            tooltip: 'Instagram',
                            onPressed: () =>
                                _launchUrl(ContactConfig.instagram),
                          ),
                          IconButton(
                            icon: const Icon(Icons.facebook), // Facebook
                            tooltip: 'Facebook',
                            onPressed: () => _launchUrl(ContactConfig.facebook),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.smart_display_outlined,
                            ), // YouTube
                            tooltip: 'YouTube',
                            onPressed: () => _launchUrl(ContactConfig.youtube),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    Widget? action,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest, // was grey.shade50
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (action != null) ...[const SizedBox(height: 8), action],
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class _LawyerCard extends StatelessWidget {
  final Lawyer lawyer;
  const _LawyerCard({required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias, // Ensure splash is clipped
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor:
                Colors.transparent, // Let sheet handle its own bg/radius
            builder: (context) => TeamMemberSheet(lawyer: lawyer),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                backgroundImage: lawyer.photoUrl != null
                    ? NetworkImage(lawyer.photoUrl!)
                    : null,
                child: lawyer.photoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 28,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lawyer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      lawyer.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
