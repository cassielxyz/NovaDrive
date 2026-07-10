import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../../core/providers/backend_coordinator_provider.dart';
import '../../core/providers/developer_log_provider.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../shared/widgets/nova_glass_card.dart';
import '../../shared/widgets/nova_fluid_sweep.dart';
import 'providers/github_issues_provider.dart';
import 'providers/github_user_provider.dart';
import 'widgets/nova_badge_display.dart';
import '../../core/utils/safe_url_launcher.dart';

const String githubRepoUrl = "https://github.com/cassielxyz/NovaDrive";
const String telegramCommunityUrl = "https://t.me/+z1r5cUq-2lY0ODQ1";
const String buyMeCoffeeUrl = "Coming soon";

class DeveloperScreen extends ConsumerWidget {
  const DeveloperScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String urlString, {List<String> allowedHosts = const []}) async {
    await SafeUrlLauncher.launchExternal(context, urlString, allowedHosts: allowedHosts);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Dev Hub', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHero(context, ref),
                _buildActionButtons(context),
                const SizedBox(height: AppSpacing.xl),
                _buildCommunityIssues(context, ref),
                const SizedBox(height: AppSpacing.xl),
                _buildFAQSection(context),
                const SizedBox(height: AppSpacing.xl),
                _buildBadgesSection(context, ref),
                const SizedBox(height: AppSpacing.xl),
                _buildTransparencyCard(context),
                const SizedBox(height: 100), // padding for bottom nav
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, WidgetRef ref) {
    final username = ref.watch(githubUsernameProvider);
    final count = ref.watch(githubContributionProvider).value?.mergedPrs ?? 0;
    final earned = NovaBadgeLevel.allLevels.where((l) => count >= l.threshold).toList();

    final primary = Theme.of(context).colorScheme.primary;
    final hsl = HSLColor.fromColor(primary);
    final darkColor = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
    final lightColor = hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    final adjacentColor = hsl.withHue((hsl.hue + 30) % 360).toColor();
    final themeColors = [darkColor, lightColor, adjacentColor, primary, darkColor];

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        // Fluid Nova Drive Text
        FluidSweepText(
          text: 'Nova Drive',
          colors: themeColors,
          isStroke: true,
          strokeWidth: 1.0,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            fontFamily: 'Outfit',
            shadows: [],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        
        // Pinned Badges or Add Badge Button
        if (username == null || earned.isEmpty) ...[
          ActionChip(
            avatar: const Icon(Icons.add, size: 16),
            label: const Text('Add Badges', style: TextStyle(fontSize: 12)),
            onPressed: () => _showLinkGitHubDialog(context, ref),
          ),
        ] else ...[
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: earned.map((badge) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badge.icon, color: badge.color, size: 16),
                const SizedBox(width: 4),
                Text(
                  badge.name,
                  style: TextStyle(color: badge.color, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            )).toList(),
          ),
        ],

        const SizedBox(height: AppSpacing.md),
        Text(
          'Developer Hub',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Repo Links
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _buildLinkChip(context, Icons.bug_report, 'Report Issue', () => _launchUrl(context, '$githubRepoUrl/issues/new', allowedHosts: ['github.com'])),
            _buildLinkChip(context, Icons.lightbulb, 'Request Feature', () => _launchUrl(context, '$githubRepoUrl/issues/new?labels=feature-request', allowedHosts: ['github.com'])),
            _buildLinkChip(context, Icons.new_releases, 'Release Notes', () => _launchUrl(context, '$githubRepoUrl/releases', allowedHosts: ['github.com'])),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildLinkChip(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onTap,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final githubColors = [
      Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, 
      Colors.grey, Colors.black
    ];
    final coffeeColors = [Colors.orange[800]!, Colors.yellow[600]!, Colors.orange];
    final tgColors = [const Color(0xFF0088cc), const Color(0xFF00BFFF), const Color(0xFF005599)];

    return Column(
      children: [
        _AnimatedBrandButton(
          icon: Icons.code,
          label: 'GitHub Repo',
          colors: githubColors,
          brand: 'github',
          onTap: () => _launchUrl(context, githubRepoUrl, allowedHosts: ['github.com']),
        ),
        const SizedBox(height: AppSpacing.md),
        _AnimatedBrandButton(
          icon: Icons.local_cafe,
          label: 'Buy me a Coffee',
          colors: coffeeColors,
          brand: 'coffee',
          onTap: () => _launchUrl(context, buyMeCoffeeUrl),
        ),
        const SizedBox(height: AppSpacing.md),
        _AnimatedBrandButton(
          icon: Icons.telegram,
          label: 'Join Telegram Community',
          colors: tgColors,
          brand: 'telegram',
          onTap: () => _launchUrl(context, telegramCommunityUrl, allowedHosts: ['t.me']),
        ),
      ],
    );
  }

  Widget _buildBadgesSection(BuildContext context, WidgetRef ref) {
    final username = ref.watch(githubUsernameProvider);
    final count = ref.watch(githubContributionProvider).value?.mergedPrs ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Contributor Badges',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (username != null)
              TextButton.icon(
                onPressed: () => ref.read(githubUsernameProvider.notifier).clearUsername(),
                icon: const Icon(Icons.logout, size: 16),
                label: Text('Unlink $username', overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (username == null) ...[
          Text(
            'Link your GitHub to unlock your contribution badges.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: () => _showLinkGitHubDialog(context, ref),
            icon: const Icon(Icons.link),
            label: const Text('Link GitHub Profile'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        NovaBadgeGallery(contributions: username != null ? count : 0),
      ],
    );
  }

  void _showLinkGitHubDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Link GitHub Profile'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter GitHub username',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final username = controller.text.trim();
                if (username.isNotEmpty) {
                  ref.read(githubUsernameProvider.notifier).setUsername(username);
                }
                Navigator.pop(context);
              },
              child: const Text('Link'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommunityIssues(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(githubIssuesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Repo Issues & Solutions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => _launchUrl(context, '$githubRepoUrl/issues', allowedHosts: ['github.com']),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        issuesAsync.when(
          data: (issues) {
            if (issues.isEmpty) {
              return NovaGlassCard(
      disableBlur: true,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: const Text('No open issues found.'),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: issues.length > 5 ? 5 : issues.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final issue = issues[index];
                return NovaGlassCard(
      disableBlur: true,
                  onTap: () => _launchUrl(context, issue.htmlUrl, allowedHosts: ['github.com']),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            issue.state == 'open' ? Icons.adjust : Icons.check_circle_outline,
                            color: issue.state == 'open' ? Colors.green : Colors.purple,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              issue.safeTitle,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: Text(
                          '#${issue.number} opened by ${issue.safeAuthor}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                      if (issue.safeLabels.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: issue.safeLabels.map((l) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                              ),
                              child: Text(l, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary)),
                            )).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: CircularProgressIndicator())),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text('Could not load issues. Check connection or rate limits.', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {'q': 'What is Nova Drive?', 'a': 'A private cloud storage client built on top of the Telegram API.'},
      {'q': 'Where are my files stored?', 'a': 'Your files are stored securely in your own Telegram Saved Messages or a private channel.'},
      {'q': 'Is Nova Drive a messenger?', 'a': 'No, Nova Drive only uses Telegram\'s storage infrastructure, it does not provide chatting capabilities.'},
      {'q': 'Why do I need Telegram API ID and API Hash?', 'a': 'To connect directly and securely as your own Telegram client without a middleman.'},
      {'q': 'Can I create folders?', 'a': 'Yes, Nova Drive uses virtual folders.'},
      {'q': 'Why are folders virtual?', 'a': 'Because Telegram doesn\'t natively support a folder structure; Nova Drive maps files to virtual paths locally.'},
      {'q': 'What is #novadrive?', 'a': 'It is a hashtag added to messages so Nova Drive can index its own files.'},
      {'q': 'Are my old Saved Messages shown?', 'a': 'Only files tagged with #novadrive or specifically uploaded through the app are indexed.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FAQ', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        NovaGlassCard(
          disableBlur: true,
          child: Column(
            children: faqs.map((faq) => ExpansionTile(
                  title: Text(faq['q']!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(faq['a']!, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTransparencyCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Privacy & Transparency', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        NovaGlassCard(
          disableBlur: true,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTransparencyItem(context, 'No Chat UI: Messages and contacts are never accessed.'),
              _buildTransparencyItem(context, 'No Tracking: No analytics or telemetry included.'),
              _buildTransparencyItem(context, 'Local Index: Your virtual folders are mapped securely on your device.'),
              _buildTransparencyItem(context, 'Direct Connection: Connects straight to Telegram with zero middlemen.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransparencyItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }


  void _showLogsDialog(BuildContext context, List<DeveloperLogEntry> logs, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Developer Logs'),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(developerLogProvider.notifier).clearLogs();
                  Navigator.pop(context);
                },
              )
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '[${log.tag}] ${log.message}',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedBrandButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;
  final String brand; 
  
  const _AnimatedBrandButton({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
    required this.brand,
  });

  @override
  State<_AnimatedBrandButton> createState() => _AnimatedBrandButtonState();
}

class _AnimatedBrandButtonState extends State<_AnimatedBrandButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isTapped = false;
  String _currentLabel = '';
  
  @override
  void initState() {
    super.initState();
    _currentLabel = widget.label;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() { _isTapped = false; _currentLabel = widget.label; });
            _controller.reverse();
            widget.onTap();
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    if (_isTapped) return;
    setState(() { _isTapped = true; });
    
    if (widget.brand == 'github') {
      _startHackerText();
    }
    
    _controller.forward(from: 0.0);
  }
  
  void _startHackerText() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final random = math.Random();
    final target = widget.label;
    for (int i = 0; i < 15; i++) {
      if (!mounted || !_isTapped) return;
      String current = '';
      for (int j = 0; j < target.length; j++) {
        current += chars[random.nextInt(chars.length)];
      }
      setState(() => _currentLabel = current);
      await Future.delayed(const Duration(milliseconds: 30));
    }
    setState(() => _currentLabel = 'ACCESS GRANTED');
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedIcon = Icon(widget.icon, color: widget.colors.first);
    
    if (widget.brand == 'coffee') {
      animatedIcon = AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
           final scale = 1.0 + math.sin(_controller.value * math.pi) * 0.5;
           final rotation = math.sin(_controller.value * math.pi * 4) * 0.2;
           return Transform(
             alignment: Alignment.center,
             transform: Matrix4.identity()..scale(scale)..rotateZ(rotation),
             child: Icon(
               _controller.value > 0.5 ? Icons.emoji_food_beverage : widget.icon, 
               color: widget.colors.first
             ),
           );
        },
      );
    } else if (widget.brand == 'telegram') {
      animatedIcon = AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
           final slide = _controller.value * 50.0;
           final fade = 1.0 - _controller.value;
           return Transform.translate(
             offset: Offset(slide, -slide),
             child: Opacity(
               opacity: fade.clamp(0.0, 1.0),
               child: Icon(widget.icon, color: widget.colors.first),
             ),
           );
        },
      );
    }
    
    return InkWell(
      onTap: _handleTap,
      borderRadius: AppRadius.radiusLg,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.radiusLg,
          border: Border.all(color: widget.colors.first.withValues(alpha: 0.8), width: 1.5),
        ),
        child: NovaGlassCard(
          disableBlur: true,
          borderRadius: AppRadius.radiusLg,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              animatedIcon,
              const SizedBox(width: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: Text(
                  _currentLabel,
                  key: ValueKey(_currentLabel),
                  style: TextStyle(
                    color: widget.colors.first,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

