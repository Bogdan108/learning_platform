import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_platform/src/core/navigation/app_router.dart';
import 'package:learning_platform/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc.dart';
import 'package:learning_platform/src/feature/profile/bloc/profile_bloc_state.dart';
import 'package:provider/provider.dart';

class AppNavigation extends StatefulWidget {
  final Widget child;

  const AppNavigation({required this.child, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final routingConfig = ValueNotifier<RoutingConfig>(AppRouter.router);
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final profileBloc = DependenciesScope.of(context).profileBloc;

    return BlocListener<ProfileBloc, ProfileBlocState>(
      bloc: profileBloc,
      listener: (context, state) {
        // TODO(b.lukyanchuk): Update config after `Admin` feature implementation.
      },
      child: Provider.value(
        value: GoRouter.routingConfig(
          routingConfig: routingConfig,
          navigatorKey: _rootNavigatorKey,
        ),
        child: widget.child,
      ),
    );
  }
}
