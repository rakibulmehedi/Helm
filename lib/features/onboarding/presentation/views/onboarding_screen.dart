import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/themes/colors.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';

import '../../../../core/local_storage/shared_pref_service.dart';
import '../../../../core/widgets/progress_bar/linear_progress_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  /// Marks onboarding as complete in SharedPreferences,
  /// then navigates to the dashboard via GoRouter.
  Future<void> _completeOnboarding() async {
    await SharedPrefServices.setOnboardingCompleted(true);
    if (mounted) context.go(RouteNames.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = SharedPrefServices.getIsDarkMode();
    final List<String> onboardingTexts = [
      "Track your expenses",
      "Set your budget",
      "Achieve financial freedom",
    ];
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      bottomNavigationBar: _buildBottomAppBar(isDark, onboardingTexts, context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            OnboardingHeader(title: '', isDark: isDark, totalSteps: 4),
            Expanded(child: _buildPageView(onboardingTexts, isDark)),

            buildDotIndicator(onboardingTexts),
          ],
        ),
      ),
    );
  }

  Row buildDotIndicator(List<String> onboardingTexts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingTexts.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 20 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  PageView _buildPageView(List<String> onboardingTexts, bool isDark) {
    return PageView.builder(
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            onboardingTexts[index],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
        );
      },
      controller: _pageController,
      itemCount: onboardingTexts.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  BottomAppBar _buildBottomAppBar(
    bool isDark,
    List<String> onboardingTexts,
    BuildContext context,
  ) {
    return BottomAppBar(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      elevation: 4,
      shadowColor: isDark ? AppColors.textLight : AppColors.textDark,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: AppButton(
                label: 'Back',
                onPressed: () {
                  if (_currentPage > 0) {
                    setState(() {
                      _currentPage--;
                    });
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                type: AppButtonType.secondary,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: AppButton(
                label:
                    _currentPage == onboardingTexts.length - 1
                        ? "Get Started"
                        : "Next",
                onPressed: () {
                  if (_currentPage < onboardingTexts.length - 1) {
                    setState(() {
                      _currentPage++;
                    });
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _completeOnboarding();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
