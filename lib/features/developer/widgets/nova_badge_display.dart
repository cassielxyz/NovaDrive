
import 'package:flutter/material.dart';


class NovaBadgeLevel {
  final int level;
  final String name;
  final Color color;
  final bool hasGlow;
  final int threshold;
  final IconData icon;

  const NovaBadgeLevel({
    required this.level,
    required this.name,
    required this.color,
    required this.threshold,
    required this.icon,
    this.hasGlow = false,
  });

  static const List<NovaBadgeLevel> allLevels = [
    NovaBadgeLevel(level: 0, name: 'Visitor', color: Color(0xFFA0A0A0), threshold: 0, icon: Icons.visibility, hasGlow: true),
    NovaBadgeLevel(level: 1, name: 'Supporter', color: Color(0xFFE0E0E0), threshold: 1, icon: Icons.favorite_border, hasGlow: true),
    NovaBadgeLevel(level: 2, name: 'Contributor', color: Color(0xFFFFFF33), threshold: 5, icon: Icons.star, hasGlow: true),
    NovaBadgeLevel(level: 3, name: 'Innovator', color: Color(0xFF00FFFF), threshold: 10, icon: Icons.diamond, hasGlow: true),
    NovaBadgeLevel(level: 4, name: 'Hacker', color: Color(0xFFBF00FF), threshold: 20, icon: Icons.terminal, hasGlow: true),
    NovaBadgeLevel(level: 5, name: 'Champion', color: Color(0xFFFF003F), threshold: 50, icon: Icons.local_fire_department, hasGlow: true),
    NovaBadgeLevel(level: 6, name: 'Architect', color: Color(0xFFFF2020), threshold: 100, icon: Icons.account_balance, hasGlow: true),
  ];
}

class NovaBadgeGallery extends StatelessWidget {
  final int contributions;

  const NovaBadgeGallery({super.key, required this.contributions});

  @override
  Widget build(BuildContext context) {
    final earned = NovaBadgeLevel.allLevels.where((l) => contributions >= l.threshold).toList();
    final locked = NovaBadgeLevel.allLevels.where((l) => contributions < l.threshold).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (earned.isNotEmpty) ...[
          Text('Earned Badges', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: earned.map((level) => _NovaBadgeItem(level: level, isUnlocked: true)).toList(),
          ),
          const SizedBox(height: 24),
        ],
        if (locked.isNotEmpty) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Locked Badges', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
          ),
          const SizedBox(height: 12),
          _buildLockedBadgeScrollRow(locked),
        ],
      ],
    );
  }

  Widget _buildLockedBadgeScrollRow(List<NovaBadgeLevel> badges) {
    return SizedBox(
      height: 120, // Reduced height for smaller badges
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
            stops: [0.0, 0.05, 0.95, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: badges.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            return _NovaBadgeItem(level: badges[index], isUnlocked: false);
          },
        ),
      ),
    );
  }
}

class _NovaBadgeItem extends StatelessWidget {
  final NovaBadgeLevel level;
  final bool isUnlocked;

  const _NovaBadgeItem({required this.level, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    final displayColor = isUnlocked ? level.color : level.color.withValues(alpha: 0.4);

    Widget badgeCircle = Container(
      width: 50, // Small size
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent, // No fill
        border: Border.all(color: displayColor, width: 1.5),
        boxShadow: (isUnlocked && level.hasGlow)
            ? [BoxShadow(color: displayColor.withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 1)]
            : null,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(level.icon, color: displayColor, size: 24), // Small icon
            if (!isUnlocked)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.lock, color: Colors.white, size: 10),
                ),
              ),
          ],
        ),
      ),
    );

    final textColor = Theme.of(context).brightness == Brightness.light ? Colors.black : displayColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        badgeCircle,
        const SizedBox(height: 8),
        Text(
          level.name,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: (isUnlocked && level.hasGlow && Theme.of(context).brightness == Brightness.dark)
                ? [Shadow(color: level.color, blurRadius: 8)]
                : null,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${level.threshold}+ PRs',
          style: TextStyle(
            color: textColor.withValues(alpha: 0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
