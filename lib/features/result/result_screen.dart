import 'package:flutter/material.dart';
import 'package:ncs_vita/features/game/game_screen.dart';
import 'package:ncs_vita/features/game/models/game_config.dart';
import 'package:ncs_vita/features/game/models/game_result.dart';
import 'package:ncs_vita/features/home/home_screen.dart';
import 'package:ncs_vita/theme/font.dart';

class Result extends StatelessWidget {
  final GameResult result;

  const Result({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final modeLabel = result.config.type.label;
    final totalQuestions = result.config.count;
    final textScaler = TextScaler.linear(context.effectiveTextScale);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(compact ? 18 : 24),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(compact ? 20 : 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '게임 종료',
                          style: TextStyle(
                            fontSize: context
                                .scaleText(compact ? 24.0 : 28.0)
                                .clamp(22.0, 30.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          modeLabel,
                          style: TextStyle(
                            fontSize: context
                                .scaleText(compact ? 14.0 : 16.0)
                                .clamp(12.0, 18.0),
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _ScoreBox(
                                title: '맞힌 수',
                                value: '${result.correctCnt}',
                                compact: compact,
                                textScaler: textScaler,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ScoreBox(
                                title: '틀린 수',
                                value: '${result.wrongCnt}',
                                compact: compact,
                                textScaler: textScaler,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: compact ? 14 : 18,
                            vertical: compact ? 10 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '정답률',
                                style: TextStyle(
                                  fontSize: context
                                      .scaleText(compact ? 12.0 : 14.0)
                                      .clamp(11.0, 15.0),
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                result.accuracyStr,
                                style: TextStyle(
                                  fontSize: context
                                      .scaleText(compact ? 24.0 : 30.0)
                                      .clamp(22.0, 32.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        Text(
                          '총 ${totalQuestions}문제 중 ${result.currentIdx}문제 진행',
                          style: TextStyle(
                            fontSize: context
                                .scaleText(compact ? 12.5 : 14.0)
                                .clamp(11.5, 15.0),
                            color: Colors.grey[700],
                          ),
                        ),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Game(config: result.config),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: compact ? 14 : 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '다시 도전',
                              style: TextStyle(
                                fontSize: context
                                    .scaleText(compact ? 16.0 : 18.0)
                                    .clamp(15.0, 20.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const Home()),
                                (route) => false,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: compact ? 14 : 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '홈으로',
                              style: TextStyle(
                                fontSize: context
                                    .scaleText(compact ? 16.0 : 18.0)
                                    .clamp(15.0, 20.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String title;
  final String value;
  final bool compact;
  final TextScaler textScaler;

  const _ScoreBox({
    required this.title,
    required this.value,
    this.compact = false,
    required this.textScaler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: compact ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: textScaler
                  .scale(compact ? 12.0 : 14.0)
                  .clamp(11.0, 15.0),
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: context
                  .scaleText(compact ? 22.0 : 28.0)
                  .clamp(20.0, 30.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
