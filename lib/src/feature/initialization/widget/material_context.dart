import 'package:flutter/material.dart';
import 'package:learning_platform/src/core/constant/localization/localization.dart';
import 'package:learning_platform/src/core/navigation/app_router.dart';
import 'package:learning_platform/src/feature/settings/model/app_theme.dart';
import 'package:learning_platform/src/feature/settings/widget/settings_scope.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatelessWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.settingsOf(context);
    final mediaQueryData = MediaQuery.of(context);
    final theme = settings.appTheme ?? AppTheme.defaultTheme;
    final lightTheme = theme.buildThemeData(Brightness.light);
    final darkTheme = theme.buildThemeData(Brightness.dark);
    final themeMode = theme.themeMode;

    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: settings.locale,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      routerConfig: AppRouter.router,
      builder: (context, child) => MediaQuery(
        key: _globalKey,
        data: mediaQueryData.copyWith(
          textScaler: TextScaler.linear(
            mediaQueryData.textScaler
                .scale(settings.textScale ?? 1)
                .clamp(0.5, 2),
          ),
        ),
        child: child!,
      ),
    );
  }
}
