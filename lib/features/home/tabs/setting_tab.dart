import 'package:flutter/material.dart';
import 'package:ncs_vita/main.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, child) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final textScale = MediaQuery.textScalerOf(context);

        return Container(
          color: theme.scaffoldBackgroundColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('설정', style: theme.textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  '앱 사용 환경을 내 학습 방식에 맞춰보세요.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 28),
                _SettingsSection(
                  title: '화면 및 테마',
                  child: Column(
                    children: [
                      _SettingsRow(
                        icon: Icons.dark_mode_outlined,
                        title: '다크 모드',
                        subtitle: settings.isDarkMode ? '사용 중' : '사용 안 함',
                        trailing: Switch(
                          value: settings.isDarkMode,
                          onChanged: settings.setDarkMode,
                        ),
                      ),
                      Divider(color: theme.dividerColor, height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.format_size_rounded,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '글자 크기',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${(settings.fontScale * 100).round()}%',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        value: settings.fontScale,
                        min: 0.8,
                        max: 1.2,
                        divisions: 4,
                        label: '${(settings.fontScale * 100).round()}%',
                        onChanged: settings.setFontScale,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('작게', style: theme.textTheme.bodySmall),
                            Text('표준', style: theme.textTheme.bodySmall),
                            Text('크게', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SettingsSection(
                  title: '학습 환경',
                  child: Column(
                    children: [
                      _SettingsRow(
                        icon: Icons.volume_up_outlined,
                        title: '효과음',
                        subtitle: '문제 풀이 효과음 설정',
                        enabled: false,
                      ),
                      Divider(color: theme.dividerColor, height: 1),
                      _SettingsRow(
                        icon: Icons.timer_outlined,
                        title: '문제 전환',
                        subtitle: '정답 후 다음 문제로 넘어가는 시간',
                        enabled: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SettingsSection(
                  title: '알림',
                  child: _SettingsRow(
                    icon: Icons.notifications_none_rounded,
                    title: '학습 알림',
                    subtitle: '매일 학습 시간을 알려드려요',
                    enabled: false,
                  ),
                ),
                const SizedBox(height: 24),
                _SettingsSection(
                  title: '데이터',
                  child: Column(
                    children: [
                      _SettingsRow(
                        icon: Icons.cloud_sync_outlined,
                        title: '학습 기록 백업',
                        subtitle: '기기 변경 시 기록을 이어갈 수 있어요',
                        enabled: false,
                      ),
                      Divider(color: theme.dividerColor, height: 1),
                      _SettingsRow(
                        icon: Icons.delete_outline_rounded,
                        title: '학습 기록 초기화',
                        subtitle: '저장된 기록을 삭제합니다',
                        enabled: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SettingsSection(
                  title: '앱 정보',
                  child: _SettingsRow(
                    icon: Icons.info_outline_rounded,
                    title: 'NCS Vita',
                    subtitle: '버전 1.0.0',
                    enabled: false,
                  ),
                ),
                SizedBox(height: textScale.scale(16)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool enabled;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final iconColor = enabled
        ? colors.primary
        : colors.onSurface.withValues(alpha: 0.45);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: enabled
                        ? null
                        : colors.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(
                      alpha: enabled ? 0.6 : 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
