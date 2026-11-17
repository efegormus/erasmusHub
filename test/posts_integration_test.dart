import 'package:erasmus_hub/app.dart';
import 'package:erasmus_hub/core/data/posts_data.dart';
import 'package:erasmus_hub/core/data/profile_data.dart';
import 'package:erasmus_hub/core/router/app_router.dart';
import 'package:erasmus_hub/features/posts/add_exchange_screen.dart';
import 'package:erasmus_hub/features/posts/new_post_screen.dart';
import 'package:erasmus_hub/features/posts/post_detail_screen.dart';
import 'package:erasmus_hub/features/profile/profile_store.dart';
import 'package:erasmus_hub/models/exchange_experience.dart';
import 'package:erasmus_hub/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<GoRouter> open(WidgetTester tester, String path) async {
  final router = createAppRouter(initialLocation: path);
  addTearDown(router.dispose);
  await tester.pumpWidget(ErasmusHubApp(router: router));
  await tester.pumpAndSettle();
  return router;
}

Future<void> tapText(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).last);
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> choose(WidgetTester tester, int index, String value) async {
  final field = find.byType(DropdownButtonFormField<String>).at(index);
  await tester.ensureVisible(field);
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text(value).last);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => profileStore.update(kCurrentUser));
  testWidgets(
    'Real detail route receives ID; missing post recovers; new is not an ID',
    (tester) async {
      final router = await open(tester, '/posts/post1');
      expect(find.byType(PostDetailScreen), findsOneWidget);
      expect(find.text('Great courses, hard housing'), findsOneWidget);
      router.go('/posts/no-such-post');
      await tester.pumpAndSettle();
      expect(find.text('This post is not available.'), findsOneWidget);
      router.go('/posts/new?universityId=tu-delft');
      await tester.pumpAndSettle();
      expect(find.byType(NewPostScreen), findsOneWidget);
      expect(find.text('TU Delft'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    },
  );
  testWidgets(
    'Comments reject whitespace and report dialog fits a narrow phone',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final post = postById('post1')!;
      final original = [...post.comments];
      addTearDown(() {
        post.comments
          ..clear()
          ..addAll(original);
      });
      await open(tester, '/posts/post1');
      await tester.enterText(find.byType(TextField), '   ');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      expect(post.comments.length, original.length);
      await tester.enterText(find.byType(TextField), 'Useful information');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pumpAndSettle();
      expect(post.comments.last.text, 'Useful information');
      await tester.tap(find.byTooltip('More options'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Report');
      expect(find.text('Report this post?'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tapText(tester, 'Spam');
      await tapText(tester, 'Report');
      expect(
        find.text('Thanks. Moderators will review this post.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Adding then editing exchange updates profile once and preserves status',
    (tester) async {
      final originalCount = profileStore.value.experiences.length;
      final router = await open(tester, '/profile/edit');
      await tapText(tester, 'Add exchange');
      expect(find.byType(AddExchangeScreen), findsOneWidget);
      await tapText(tester, 'Save exchange');
      expect(find.text('Please select a university.'), findsOneWidget);
      expect(find.text('Choose Going or Returned.'), findsOneWidget);
      expect(profileStore.value.experiences.length, originalCount);
      await choose(tester, 0, 'Lund University');
      await choose(tester, 1, 'Spring 2027');
      await tapText(tester, 'Going');
      await tapText(tester, 'Save exchange');
      await tapText(tester, 'OK');
      expect(router.state.uri.path, '/profile/edit');
      expect(profileStore.value.experiences.length, originalCount + 1);
      final added = profileStore.value.experiences.last;
      expect(added.status, ExchangeStatus.planning);
      expect(find.text('Lund University · Spring 2027'), findsOneWidget);
      final edit = find.byTooltip('Edit experience').last;
      await tester.ensureVisible(edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      expect(find.text('Edit exchange'), findsOneWidget);
      await tapText(tester, 'Returned');
      await tapText(tester, 'Save exchange');
      await tapText(tester, 'OK');
      expect(profileStore.value.experiences.length, originalCount + 1);
      expect(profileStore.value.experiences.last.id, added.id);
      expect(
        profileStore.value.experiences.last.status,
        ExchangeStatus.returned,
      );
    },
  );
  testWidgets('Direct exchange URL saves data and returns to Edit profile', (
    tester,
  ) async {
    final count = profileStore.value.experiences.length;
    final router = await open(tester, '/profile/exchanges/new');
    await choose(tester, 0, 'TU Delft');
    await choose(tester, 1, 'Fall 2026');
    await tapText(tester, 'Going');
    await tapText(tester, 'Save exchange');
    await tapText(tester, 'OK');
    expect(router.state.uri.path, '/profile/edit');
    expect(profileStore.value.experiences.length, count + 1);
    await tapText(tester, 'Save changes');
    await tapText(tester, 'OK');
    expect(router.state.uri.path, '/profile');
    expect(tester.takeException(), isNull);
  });
  testWidgets('New post requires all ratings, publishes and opens its detail', (
    tester,
  ) async {
    final original = List<Post>.of(placeholderPosts);
    addTearDown(() {
      placeholderPosts
        ..clear()
        ..addAll(original);
    });
    final router = await open(tester, '/posts/new?universityId=tu-delft');
    await tapText(tester, 'Publish');
    expect(find.text('Give 1 to 5 stars.'), findsNWidgets(6));
    expect(placeholderPosts.length, original.length);
    await choose(tester, 1, 'Fall 2025');
    final courses = find.byType(TextFormField).first;
    await tester.ensureVisible(courses);
    await tester.enterText(courses, 'Algorithms, Databases');
    for (var i = 0; i < 6; i++) {
      final star = find.byTooltip('Rate 4 of 5 stars').at(i);
      await tester.ensureVisible(star);
      await tester.tap(star);
      await tester.pump();
    }
    await tapText(tester, 'Publish');
    expect(find.text('Post published'), findsOneWidget);
    await tapText(tester, 'OK');
    expect(router.state.uri.path, '/universities/tu-delft');
    expect(placeholderPosts.length, original.length + 1);
    router.go('/posts/${placeholderPosts.first.id}');
    await tester.pumpAndSettle();
    expect(find.text('Courses: Algorithms, Databases'), findsOneWidget);
  });
}
