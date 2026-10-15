import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/whatsapp.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/app_toast.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/features/auth/domain/entity/profile.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:nuropulse/features/connection/presentation/cubit/connection_cubit.dart';
import 'package:nuropulse/features/connection/presentation/cubit/connection_state.dart';
import 'package:url_launcher/url_launcher.dart';

/// Profil tab. Shows Masuk/Daftar when signed out; a profile summary plus
/// connected-doctor status otherwise. Editing isn't built yet.
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
            const _Badge(icon: Icons.person_outline),
            const SizedBox(height: 20),
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
            const SizedBox(height: 28),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                _Avatar(fullName: profile.fullName),
                const SizedBox(height: 16),
                Text(
                  profile.fullName,
                  textAlign: TextAlign.center,
                  style: FontTheme.title.copyWith(color: BaseColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  textAlign: TextAlign.center,
                  style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Dokter',
            style: FontTheme.label.copyWith(color: BaseColors.inkMuted),
          ),
          const SizedBox(height: 8),
          profile.doctorId == null
              ? const _NotConnectedCard()
              : const _ConnectedDoctorCard(),
          const SizedBox(height: 32),
          AppButton(
            label: 'Keluar',
            variant: AppButtonVariant.outline,
            icon: Icons.logout,
            onPressed: () => context.read<AuthCubit>().logout(),
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

/// Soft-circle icon badge reused for both the signed-out state and the
/// account icon fallback, matching the onboarding/empty-state visual
/// language used elsewhere in the app.
class _Badge extends StatelessWidget {
  const _Badge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: BaseColors.primarySoft,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 32, color: BaseColors.primary),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.fullName});

  final String fullName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(
        color: BaseColors.primarySoft,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(fullName),
        style: FontTheme.display.copyWith(
          color: BaseColors.primary,
          fontSize: 32,
        ),
      ),
    );
  }

  static String _initials(String fullName) {
    final words = fullName.trim().split(RegExp(r'\s+'));
    final first = words.isNotEmpty && words.first.isNotEmpty
        ? words.first[0]
        : '';
    final last = words.length > 1 && words.last.isNotEmpty ? words.last[0] : '';
    return (first + last).toUpperCase();
  }
}

class _NotConnectedCard extends StatelessWidget {
  const _NotConnectedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.surfaceRaised,
        border: Border.all(color: BaseColors.line),
        borderRadius: BorderRadius.circular(20), // radius-lg
      ),
      child: Column(
        children: [
          Icon(Icons.link_off, size: 32, color: BaseColors.inkMuted),
          const SizedBox(height: 12),
          Text(
            'Anda belum terhubung dengan dokter.',
            textAlign: TextAlign.center,
            style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Hubungkan dengan Dokter',
            icon: Icons.link,
            onPressed: () => context.push('/connect'),
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _ConnectedDoctorCard extends StatelessWidget {
  const _ConnectedDoctorCard();

  Future<void> _contactDoctor(BuildContext context, String phone) async {
    final launched = await launchUrl(
      whatsappUri(phone),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      showAppToast(
        context,
        message: 'Tidak dapat membuka WhatsApp.',
        tone: AppToastTone.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.surfaceRaised,
        border: Border.all(color: BaseColors.line),
        borderRadius: BorderRadius.circular(20), // radius-lg
      ),
      child: BlocBuilder<ConnectionCubit, DoctorConnectionState>(
        builder: (context, state) {
          return switch (state) {
            DoctorConnectionConnected(:final doctor) => Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: BaseColors.secondarySoft,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: BaseColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terhubung dengan',
                            style: FontTheme.caption.copyWith(
                              color: BaseColors.inkMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
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
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Hubungi Dokter',
                  variant: AppButtonVariant.secondary,
                  icon: Icons.chat_outlined,
                  onPressed: () => _contactDoctor(context, doctor.phone),
                  fullWidth: true,
                ),
              ],
            ),
            DoctorConnectionFailure() => Text(
              'Gagal memuat info dokter.',
              textAlign: TextAlign.center,
              style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
            ),
            _ => const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          };
        },
      ),
    );
  }
}
