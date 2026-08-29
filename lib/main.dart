import 'package:flutter/material.dart';
import 'package:ncs_vita/models/settings.dart';
import 'features/home/home_screen.dart';
import 'package:ncs_vita/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final Settings settings = Settings();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appUuid = await AppIdService().getOrCreate();
  debugPrint('App UUID: $appUuid');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      child: const Home(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NCS Vita 1.0',
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.light(settings.fontScale),
          darkTheme: AppTheme.dark(settings.fontScale),
          home: child,
        );
      },
    );
  }
}

class AppIdService {
  static const _key = 'app_uuid';

  Future<String> getOrCreate() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    if (existing != null) return existing;

    final uuid = const Uuid().v4();
    await prefs.setString(_key, uuid);
    return uuid;
  }
}
