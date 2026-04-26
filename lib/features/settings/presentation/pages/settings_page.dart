import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hd_images/core/responsive_screen/responsive_screen.dart';
import 'package:hd_images/core/theme/theme_cubit.dart';
import 'package:hd_images/core/utils/app_text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.settings.tr()),
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveScreen.w(24)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(ResponsiveScreen.w(16)),
              ),
              child: ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: Text(AppText.darkMode.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Switch(
                  value: isDark,
                  onChanged: themeCubit.setDarkMode,
                ),
              ),
            ),
            SizedBox(height: ResponsiveScreen.h(16)),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(ResponsiveScreen.w(16)),
              ),
              child: ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(AppText.language.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: DropdownButton<Locale>(
                  value: context.locale,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  items: const [
                    DropdownMenuItem(value: Locale('en'), child: Text('English')),
                    DropdownMenuItem(value: Locale('tr'), child: Text('Türkçe')),
                  ],
                  onChanged: (newLocale) {
                    if (newLocale != null) {
                      context.setLocale(newLocale);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
