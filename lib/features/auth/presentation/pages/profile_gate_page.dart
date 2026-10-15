import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/features/auth/domain/entity/profile.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:nuropulse/features/connection/presentation/cubit/connection_cubit.dart';
import 'package:nuropulse/features/connection/presentation/cubit/connection_state.dart';

/// Profil tab. Shows Masuk/Daftar when signed out; a signed-in summary plus
/// connected-doctor status otherwise. The full profile view (editing)
/// isn't built yet.
class ProfileGatePage extends StatelessWidget {
  const ProfileGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(label: 'Profil'),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return switch (state) {
            AuthAuthenticated(:final profile) => _SignedIn(profile: profile),
            _ => const _SignedOut(),
          };
        },
      ),
    );
  }
}

class _SignedOut extends StatelessWidget {
  const _SignedOut();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 56, color: BaseColors.inkMuted),
            const SizedBox(height: 16),
            Text(
              'Belum masuk',
              textAlign: TextAlign.center,
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Masuk atau daftar untuk terhubung dengan dokter Anda.',
              textAlign: TextAlign.center,
              style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Masuk',
              onPressed: () => context.push('/login'),
              fullWidth: true,
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Daftar',
              variant: AppButtonVariant.outline,
              onPressed: () => context.push('/register'),
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SignedIn extends StatefulWidget {
  const _SignedIn({required this.profile});

  final Profile profile;

  @override
  State<_SignedIn> createState() => _SignedInState();
}

class _SignedInState extends State<_SignedIn> {
  @override
  void initState() {
    super.initState();
    _loadDoctorIfNeeded(null);
  }

  @override
  void didUpdateWidget(covariant _SignedIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadDoctorIfNeeded(oldWidget.profile.doctorId);
  }

  // Covers both the first build (previousDoctorId null, meaning "unknown")
  // and connecting to a doctor later, which updates profile.doctorId
  // without this widget being recreated.
  void _loadDoctorIfNeeded(String? previousDoctorId) {
    final doctorId = widget.profile.doctorId;
    if (doctorId != null && doctorId != previousDoctorId) {
      context.read<ConnectionCubit>().loadConnectedDoctor(doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 56,
              color: BaseColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Halo, ${profile.fullName}',
              textAlign: TextAlign.center,
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 24),
            if (profile.doctorId == null)
              _NotConnected()
            else
              const _ConnectedDoctorInfo(),
            const SizedBox(height: 24),
            AppButton(
              label: 'Keluar',
              variant: AppButtonVariant.outline,
              onPressed: () => context.read<AuthCubit>().logout(),
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotConnected extends StatelessWidget {
  const _NotConnected();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Anda belum terhubung dengan dokter.',
          textAlign: TextAlign.center,
          style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Hubungkan dengan Dokter',
          icon: Icons.link,
          onPressed: () => context.push('/connect'),
          fullWidth: true,
        ),
      ],
    );
  }
}

class _ConnectedDoctorInfo extends StatelessWidget {
  const _ConnectedDoctorInfo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, DoctorConnectionState>(
      builder: (context, state) {
        return switch (state) {
          DoctorConnectionConnected(:final doctor) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BaseColors.surfaceRaised,
              border: Border.all(color: BaseColors.line),
              borderRadius: BorderRadius.circular(12), // radius-md
            ),
            child: Column(
              children: [
                Text(
                  'Dokter yang terhubung',
                  style: FontTheme.label.copyWith(color: BaseColors.inkMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.fullName,
                  style: FontTheme.bodyLg.copyWith(
                    color: BaseColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          DoctorConnectionFailure() => Text(
            'Gagal memuat info dokter.',
            textAlign: TextAlign.center,
            style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
          ),
          _ => const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        };
      },
    );
  }
}
