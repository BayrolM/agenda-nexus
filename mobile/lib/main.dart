import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
    await initializeDateFormatting('es');

    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      publishableKey: AppConstants.supabaseAnonKey,
    );

    await NotificationService.init();
    await NotificationService.requestPermission();
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error de inicialización:\n$e\n\nPor favor, verifica el archivo .env y la conexión.',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));
    return;
  }

  runApp(
    const ProviderScope(
      child: AgendaNexusApp(),
    ),
  );
}

class AgendaNexusApp extends ConsumerWidget {
  const AgendaNexusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
