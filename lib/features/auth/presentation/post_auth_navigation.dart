import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_state.dart';

/// Where to go right after a successful register/login: the connect-doctor
/// prompt if the patient has no doctor yet, home otherwise. Shared by the
/// login and register screens so this decision is made in one place.
void navigateAfterAuth(BuildContext context) {
  final state = context.read<AuthCubit>().state;
  final hasNoDoctor =
      state is AuthAuthenticated && state.profile.doctorId == null;
  context.go(hasNoDoctor ? '/connect' : '/');
}
