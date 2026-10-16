import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_alert.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/app_text_field.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nuropulse/features/connection/presentation/connection_failure_message.dart';
import 'package:nuropulse/features/connection/presentation/cubit/connection_cubit.dart';
import 'package:nuropulse/features/connection/presentation/cubit/connection_state.dart';

/// Prompted right after register/login when the patient has no connected
/// doctor yet. Dismissable, since connecting isn't required to use the app.
class ConnectDoctorPage extends StatefulWidget {
  const ConnectDoctorPage({super.key});

  @override
  State<ConnectDoctorPage> createState() => _ConnectDoctorPageState();
}

class _ConnectDoctorPageState extends State<ConnectDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<ConnectionCubit>().connect(_code.text.trim());
    if (!mounted || !ok) return;
    await context.read<AuthCubit>().refreshProfile();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(label: 'Hubungkan Dokter'),
      body: BlocBuilder<ConnectionCubit, DoctorConnectionState>(
        builder: (context, state) {
          final isLoading = state is DoctorConnectionConnecting;
          final failure = state is DoctorConnectionFailure
              ? state.failure
              : null;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan kode koneksi dari dokter Anda',
                    style: FontTheme.heading.copyWith(color: BaseColors.ink),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dokter Anda bisa memberikan kode ini setelah pemeriksaan. '
                    'Anda juga bisa melakukannya nanti dari halaman Profil.',
                    style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
                  ),
                  const SizedBox(height: 24),
                  if (failure != null) ...[
                    AppAlert(
                      tone: AppAlertTone.danger,
                      message: connectionFailureMessage(failure),
                    ),
                    const SizedBox(height: 16),
                  ],
                  AppTextField(
                    label: 'Kode koneksi dokter',
                    controller: _code,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kode koneksi wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  AppButton(
                    label: 'Hubungkan',
                    isLoading: isLoading,
                    onPressed: _submit,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Nanti',
                    variant: AppButtonVariant.text,
                    onPressed: () => context.go('/'),
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
