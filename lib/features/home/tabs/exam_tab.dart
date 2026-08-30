import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/game_screen.dart';
import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/theme/components/card.dart';

class ExamTab extends StatelessWidget {
  const ExamTab({super.key});

  void _startExam(BuildContext context) {
    final config = GameConfig.examPreset(count: 10, timer: 15, level: 2);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Game(config: config)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(compact ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              '검정 모드',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '실전 시험 형태로 문제를 풀어보세요.',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.6),
                fontSize: MediaQuery.textScalerOf(
                  context,
                ).scale(12.5).clamp(11.0, 14.0),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(compact ? 18 : 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF111111), Color(0xFF2A2A2A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.timer_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '오늘의 검정',
                        style: TextStyle(
                          fontSize: MediaQuery.textScalerOf(
                            context,
                          ).scale(17).clamp(15.0, 20.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '분수·곱셈·덧셈 유형을 섞어 10문제를 제한시간 안에 풀어보세요.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: MediaQuery.textScalerOf(
                        context,
                      ).scale(12.5).clamp(11.0, 14.0),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      const CardLabel(
                        icon: Icons.quiz_rounded,
                        label: '10문제',
                        iconColor: Colors.white70,
                        textColor: Colors.white,
                        backgroundColor: Color(0x1FFFFFFF),
                      ),
                      const CardLabel(
                        icon: Icons.access_time_rounded,
                        label: '15초',
                        iconColor: Colors.white70,
                        textColor: Colors.white,
                        backgroundColor: Color(0x1FFFFFFF),
                      ),
                      const CardLabel(
                        icon: Icons.trending_up_rounded,
                        label: 'Lv.2',
                        iconColor: Colors.white70,
                        textColor: Colors.white,
                        backgroundColor: Color(0x1FFFFFFF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: compact ? 1.42 : 1.35,
              children: const [
                StatCard(title: '문항수', value: '10개'),
                StatCard(title: '시간', value: '15초'),
                StatCard(title: '난이도', value: 'Lv.2'),
                StatCard(title: '유형', value: '혼합형'),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _startExam(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('검정 시작'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
