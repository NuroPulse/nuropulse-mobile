import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/widgets/app_button.dart';
import 'package:nuropulse/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:nuropulse/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.image,
    required this.title,
    required this.body,
  });

  final String image;
  final String title;
  final String body;
}

const _slides = [
  _OnboardingSlide(
    image: 'assets/images/welcome.png',
    title: 'Selamat datang di NuroPulse',
    body:
        'Pendamping untuk penderita Parkinson dan siapa pun yang ingin '
        'memeriksa tremor tangan.',
  ),
  _OnboardingSlide(
    image: 'assets/images/result-none.png',
    title: 'Deteksi tremor dalam hitungan detik',
    body:
        'Letakkan ponsel di punggung tangan, rilekskan tangan, dan biarkan '
        'sensor ponsel merekam gerakan selama beberapa detik.',
  ),
  _OnboardingSlide(
    image: 'assets/images/result-tremor.png',
    title: 'Catat jadwal obat Anda',
    body:
        'Dokter mengatur jadwal obat dari dashboard, dan Anda cukup '
        'mencatat setiap dosis yang diminum langsung dari aplikasi.',
  ),
];

/// First-open walkthrough. Always shown again on the next cold start unless
/// the user ticks "Jangan tampilkan lagi" on the last slide — the router
/// (`services/router_service.dart`) reads [OnboardingRepository] to decide
/// whether this is the initial route at all.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OnboardingCubit(context.read<OnboardingRepository>()),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final _controller = PageController();
  int _page = 0;
  bool _dontShowAgain = false;

  bool get _isLastSlide => _page == _slides.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _skipToEnd() {
    _controller.animateToPage(
      _slides.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish() async {
    await context.read<OnboardingCubit>().finish(dontShowAgain: _dontShowAgain);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: _isLastSlide
                  ? null
                  : Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _skipToEnd,
                        child: Text(
                          'Lewati',
                          style: FontTheme.body.copyWith(
                            color: BaseColors.inkMuted,
                          ),
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) =>
                    _SlideView(slide: _slides[index]),
              ),
            ),
            _PageDots(count: _slides.length, index: _page),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (_isLastSlide)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 72),
                      child: InkWell(
                        onTap: () =>
                            setState(() => _dontShowAgain = !_dontShowAgain),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _dontShowAgain,
                              activeColor: BaseColors.primary,
                              onChanged: (value) => setState(
                                () => _dontShowAgain = value ?? false,
                              ),
                            ),
                            Text(
                              'Jangan tampilkan lagi',
                              style: FontTheme.body.copyWith(
                                color: BaseColors.focus,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!_isLastSlide)
                    Padding(padding: const EdgeInsets.only(bottom: 120.0)),
                  AppButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    iconPosition: AppButtonIconPosition.trailing,
                    variant: AppButtonVariant.secondary,
                    label: _isLastSlide ? 'Mulai' : 'Lanjut',
                    onPressed: _isLastSlide ? _finish : _next,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              slide.image,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
              errorBuilder: (context, error, stackTrace) => Align(
                alignment: Alignment.bottomCenter,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: BaseColors.surfaceSunken,
                    borderRadius: BorderRadius.circular(20), // radius-lg
                  ),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: BaseColors.inkMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 0),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: FontTheme.title.copyWith(color: BaseColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index ? BaseColors.primary : BaseColors.line,
              borderRadius: BorderRadius.circular(999), // radius-full
            ),
          ),
      ],
    );
  }
}
