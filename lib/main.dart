import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hd_images/core/di/injection_container.dart' as di;
import 'package:hd_images/core/navigation/app_router.dart';
import 'package:hd_images/core/responsive_screen/responsive_screen.dart';
import 'package:hd_images/core/theme/theme_cubit.dart';
import 'package:hd_images/core/theme/themes.dart';
import 'package:hd_images/core/utils/app_text.dart';
import 'package:hd_images/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await di.initDependencies();
  
  // AppText yerelleştirme (Easy Localization) init
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: AppText.appName.tr(),
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              ResponsiveScreen.init(context);
              return child!;
            },
          );
        },
      ),
    );
  }
}
