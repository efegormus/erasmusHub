import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

import '../../features/posts/post_detail_screen.dart';
import '../../features/posts/new_post_screen.dart';
import '../../features/posts/add_exchange_screen.dart';
import '../../models/exchange_experience.dart';

import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/auth/sign_up_account_screen.dart';
import '../../features/auth/sign_up_profile_screen.dart';
import '../../shared/screens/placeholder_screen.dart';
import '../../shared/widgets/app_shell.dart';
import 'app_routes.dart';

/// New instances isolate navigation stacks in tests and future app sessions.
GoRouter createAppRouter({String initialLocation = AppRoutes.login}) =>
    GoRouter(
      initialLocation: initialLocation,
      errorBuilder: (context, state) => const PlaceholderScreen(
        title: 'Page not found',
        detail: 'This link is not available.',
        fallback: AppRoutes.login,
        links: {'Back to login': AppRoutes.login},
      ),
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) => const PlaceholderScreen(
            title: 'Forgot password',
            fallback: AppRoutes.login,
          ),
        ),
        GoRoute(
          path: AppRoutes.signUpAccount,
          name: 'signUpAccount',
          builder: (context, state) => const SignUpAccountScreen(),
        ),
        GoRoute(
          path: AppRoutes.signUpProfile,
          name: 'signUpProfile',
          builder: (context, state) => const SignUpProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.verifyEmail,
          name: 'verifyEmail',
          builder: (context, state) => const PlaceholderScreen(
            title: 'Verify your email',
            fallback: AppRoutes.signUpAccount,
          ),
        ),
        GoRoute(
          path: AppRoutes.addUniversity,
          name: 'addUniversity',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Add university'),
        ),
        // Forms and Post detail cover the shell, as in the PDF mockups.
        GoRoute(
          path: '/posts/new',
          name: 'newPost',
          builder: (context, state) => NewPostScreen(
            key: ValueKey(state.uri.toString()),
            universityId: state.uri.queryParameters['universityId'],
          ),
        ),
        GoRoute(
          path: '/posts/:id',
          name: 'postDetail',
          builder: (context, state) => PostDetailScreen(
            key: ValueKey(state.pathParameters['id']),
            postId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: AppRoutes.addPlace,
          name: 'addPlace',
          builder: (context, state) => const PlaceholderScreen(
            title: 'Add place',
            fallback: AppRoutes.places,
          ),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          name: 'editProfile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.addExchange,
          name: 'addExchange',
          builder: (context, state) => AddExchangeScreen(
            initialExperience: state.extra is ExchangeExperience
                ? state.extra as ExchangeExperience
                : null,
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => AppShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  name: 'home',
                  builder: (context, state) => const HomeScreen(),
                  routes: [
                    GoRoute(
                      path: 'universities/:id',
                      name: 'universityDetail',
                      builder: (context, state) => PlaceholderScreen(
                        title: 'University detail',
                        detail: state.pathParameters['id'],
                        links: {
                          'Post detail': AppRoutes.post('post1'),
                          'Write post': AppRoutes.newPost(
                            state.pathParameters['id']!,
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.places,
                  name: 'places',
                  builder: (context, state) => const PlaceholderScreen(
                    title: 'Places',
                    showBack: false,
                    links: {'Add place': AppRoutes.addPlace},
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.matches,
                  name: 'matches',
                  builder: (context, state) => const PlaceholderScreen(
                    title: 'Matches',
                    showBack: false,
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  name: 'profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );

final appRouter = createAppRouter();
