import 'package:flutter/material.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/profile/controllers/profile_controller.dart';
import 'package:manage_state/presentation/profile/intents/profile_intent.dart';
import 'package:manage_state/presentation/profile/states/profile_state.dart';
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
        child: ValueListenableBuilder<ProfileState>(
          valueListenable: _controller,
          builder: (context, state, _) {
            if (state.isLoading || state.userProfile == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final profile = state.userProfile!;

            return RefreshIndicator(
              onRefresh: () async {
                _controller.onIntent(const RefreshProfileIntent());
              },
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
                          selectedIndex: state.selectedTabIndex,
                          onTabChanged: (index) {
                            _controller.onIntent(ChangeProfileTabIntent(index));
                          },
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
