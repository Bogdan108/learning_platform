import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/navigation/app_router.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/model/user_role.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatefulWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context).profileBloc;
    final userRole = deps.state.profileInfo.role;
    final initialLocation = userRole == UserRole.student
        ? '/'
        : userRole == UserRole.admin
            ? '/admin_courses'
            : '/teacher_courses';
    router = AppRouter().initRouter(initialLocation);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        key: MaterialContext._globalKey,
        data: mediaQueryData.copyWith(
          textScaler: TextScaler.linear(
            mediaQueryData.textScaler.scale(1).clamp(0.5, 2),
          ),
        ),
        child: child!,
      ),
    );
  }
}
