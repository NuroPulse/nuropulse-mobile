import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/date_format.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/app_toast.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_log_entry.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_log_status.dart';
import 'package:nuropulse/features/medication/domain/entity/medication_schedule.dart';
import 'package:nuropulse/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:nuropulse/features/medication/presentation/cubit/medication_state.dart';

/// Obat tab: the signed-in patient's doctor-prescribed schedule, with a way
/// to mark each one taken or skipped. Not a dose history: `medication_logs`
/// holds at most one row per schedule, so this shows the latest logged
/// status per medicine, not every past dose. Signed out shows a login
/// prompt instead, since every query here is scoped to the signed-in
/// patient.
class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(showLogo: true, label: 'Obat'),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const _SignedOutPrompt();
          }
          return const _MedicationContent();
        },
      ),
    );
  }
}

class _SignedOutPrompt extends StatelessWidget {
  const _SignedOutPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 56,
              color: BaseColors.inkMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum masuk',
              textAlign: TextAlign.center,
              style: FontTheme.heading.copyWith(color: BaseColors.ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Masuk untuk melihat jadwal obat dan mencatat dosis Anda.',
              textAlign: TextAlign.center,
              style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Masuk',
              onPressed: () => context.push('/login'),
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationContent extends StatefulWidget {
  const _MedicationContent();

  @override
  State<_MedicationContent> createState() => _MedicationContentState();
}

class _MedicationContentState extends State<_MedicationContent> {
  @override
  void initState() {
    super.initState();
    context.read<MedicationCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationCubit, MedicationState>(
      builder: (context, state) {
        return switch (state) {
          MedicationLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          MedicationFailureState() => Padding(
            padding: const EdgeInsets.all(24),
            child: AppAlert(
              tone: AppAlertTone.danger,
              message: 'Terjadi kesalahan. Silakan coba lagi.',
              action: TextButton(
                onPressed: () => context.read<MedicationCubit>().load(),
                child: const Text('Muat ulang'),
              ),
            ),
          ),
          MedicationLoaded(:final schedules, :final logs) => RefreshIndicator(
            onRefresh: () => context.read<MedicationCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Jadwal obat',
                  style: FontTheme.heading.copyWith(color: BaseColors.ink),
                ),
                const SizedBox(height: 12),
                if (schedules.isEmpty)
                  Text(
                    'Belum ada jadwal obat dari dokter Anda.',
                    style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
                  )
                else
                  for (final schedule in schedules) ...[
                    _ScheduleCard(schedule: schedule),
                    const SizedBox(height: 12),
                  ],
                const SizedBox(height: 28),
                Text(
                  'Status Terkini',
                  style: FontTheme.heading.copyWith(color: BaseColors.ink),
                ),
                const SizedBox(height: 12),
                if (logs.isEmpty)
                  Text(
                    'Belum ada dosis yang dicatat.',
                    style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
                  )
                else
                  for (final log in logs) ...[
                    _LogTile(log: log),
                    const SizedBox(height: 8),
                  ],
              ],
            ),
          ),
        };
      },
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.schedule});

  final MedicationSchedule schedule;

  Future<void> _log(BuildContext context, MedicationLogStatus status) async {
    final ok = await context.read<MedicationCubit>().logDose(
      scheduleId: schedule.id,
      scheduledAt: DateTime.now(),
      status: status,
    );
    if (ok && context.mounted) {
      showAppToast(
        context,
        message: status == MedicationLogStatus.taken
            ? 'Dosis dicatat sebagai diminum.'
            : 'Dosis dicatat sebagai dilewati.',
        tone: AppToastTone.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BaseColors.surfaceRaised,
        border: Border.all(color: BaseColors.line),
        borderRadius: BorderRadius.circular(12), // radius-md
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.medicineName,
            style: FontTheme.bodyLg.copyWith(
              color: BaseColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            schedule.dose,
            style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
          ),
          if (schedule.scheduleTimes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final time in schedule.scheduleTimes) _TimeChip(time),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Sudah Diminum',
                  icon: Icons.check,
                  onPressed: () => _log(context, MedicationLogStatus.taken),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'Lewati',
                  variant: AppButtonVariant.outline,
                  onPressed: () => _log(context, MedicationLogStatus.skipped),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip(this.time);

  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: BaseColors.primarySoft,
        borderRadius: BorderRadius.circular(999), // radius-full
      ),
      child: Text(
        time,
        style: FontTheme.caption.copyWith(
          color: BaseColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.log});

  final MedicationLogEntry log;

  @override
  Widget build(BuildContext context) {
    final taken = log.status == MedicationLogStatus.taken;
    final color = taken ? BaseColors.success : BaseColors.warning;
    final softColor = taken ? BaseColors.successSoft : BaseColors.warningSoft;
    final icon = taken
        ? Icons.check_circle_outline
        : Icons.remove_circle_outline;
    final label = taken ? 'Diminum' : 'Dilewati';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BaseColors.surfaceRaised,
        border: Border.all(color: BaseColors.line),
        borderRadius: BorderRadius.circular(12), // radius-md
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: softColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: FontTheme.body.copyWith(
                    color: BaseColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Terakhir dicatat: ${formatDateTime(log.loggedAt)}',
                  style: FontTheme.caption.copyWith(color: BaseColors.inkMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
