import 'package:flutter/material.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/core/widgets/app_toast.dart';
import 'package:nuropulse/core/widgets/main_app_bar.dart';
import 'package:nuropulse/features/measure/presentation/widgets/measure_countdown_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  Future<void> _testSupabaseConnection(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.getUser('debug-connectivity-check');
      if (context.mounted) {
        showAppToast(
          context,
          message: 'Supabase terhubung (server menjawab)',
          tone: AppToastTone.success,
        );
      }
    } on AuthException catch (error) {
      if (context.mounted) {
        showAppToast(
          context,
          message: 'Supabase terhubung (${error.message})',
          tone: AppToastTone.success,
        );
      }
    } catch (error) {
      if (context.mounted) {
        showAppToast(
          context,
          message: 'Gagal terhubung ke Supabase: $error',
          tone: AppToastTone.danger,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Column(
        children: [
          Expanded(child: MeasureCountdownView(secondsLeft: 2)),
          Padding(
            padding: const EdgeInsets.all(24),
            child: AppButton(
              label: 'Test Supabase',
              icon: Icons.cloud_outlined,
              onPressed: () => _testSupabaseConnection(context),
            ),
          ),
        ],
      ),
    );
  }
}
