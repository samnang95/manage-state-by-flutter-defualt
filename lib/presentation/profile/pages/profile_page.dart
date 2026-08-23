import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/profile/controllers/profile_controller.dart';
import 'package:manage_state/presentation/profile/widgets/profile_header.dart';
import 'package:manage_state/presentation/profile/widgets/profile_info_section.dart';
import 'package:manage_state/presentation/profile/widgets/profile_action_buttons.dart';
import 'package:manage_state/presentation/profile/widgets/profile_tab_bar.dart';
import 'package:manage_state/presentation/profile/widgets/personal_details_section.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController _controller = DependencyInjector.instance.getProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading || _controller.userProfile == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final profile = _controller.userProfile!;

            return RefreshIndicator(
              onRefresh: _controller.refreshData,
              color: AppColors.primary,
              child: CustomScrollView(
                slivers: [
                  // Profile content
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cover photo + avatar
                        ProfileHeader(profile: profile),
                        const SizedBox(height: 60),
                        // User info
                        const ProfileInfoSection(),
                        const SizedBox(height: 24),
                        // Action buttons
                        const ProfileActionButtons(),
                        const SizedBox(height: 16),
                        const SizedBox(height: 4),
                        // Tab bar
                        ProfileTabBar(
                          selectedIndex: _controller.selectedTabIndex,
                          onTabChanged: _controller.changeTab,
                        ),
                        const SizedBox(height: 16),
                        // Personal details
                        PersonalDetailsSection(profile: profile),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
