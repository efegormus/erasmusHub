import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/posts_data.dart';
import '../profile/profile_store.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/exchange_experience.dart';
import '../../models/post.dart';
import '../../shared/widgets/app_text_field.dart';
import 'widgets/confirmation_dialog.dart';
import 'widgets/form_widgets.dart';
import 'widgets/rating_row.dart';

/// New post form (screen 09). UI only: a valid post goes to the placeholder list.
class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key, this.universityId});

  /// Preselects the host university when opened from a University page.
  final String? universityId;

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courses = TextEditingController();
  final _tips = TextEditingController();
  late String? _universityId = hostUniversityById(widget.universityId)?.id;
  String? _term;
  ExchangeProgram _program = ExchangeProgram.erasmus;
  final Map<RatingCategory, int> _ratings = {};

  @override
  void dispose() {
    _courses.dispose();
    _tips.dispose();
    super.dispose();
  }

  List<String> _parseCourses() => _courses.text
      .split(',')
      .map((course) => course.trim())
      .where((course) => course.isNotEmpty)
      .toList();

  String? _validateCourses(String? value) =>
      _parseCourses().isEmpty ? 'Add at least one course.' : null;

  /// The form has no title field, so the title comes from the tip.
  String _titleFor(String universityName, String tip) {
    if (tip.isEmpty) return 'My experience at $universityName';
    final firstSentence = tip.split(RegExp(r'[.!?\n]')).first.trim();
    final title = firstSentence.isEmpty ? tip : firstSentence;
    return title.length > 60 ? '${title.substring(0, 57)}...' : title;
  }

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate()) return;
    final university = hostUniversityById(_universityId)!;
    final tip = _tips.text.trim();
    final post = Post(
      id: 'post${DateTime.now().microsecondsSinceEpoch}',
      universityId: university.id,
      universityName: university.name,
      title: _titleFor(university.name, tip),
      author: profileStore.value.name,
      authorId: profileStore.value.id,
      term: _term!,
      major: profileStore.value.major,
      program: _program,
      courses: _parseCourses(),
      ratings: Map.of(_ratings),
      tip: tip,
    );
    placeholderPosts.insert(0, post);
    await showConfirmationDialog(
      context,
      title: 'Post published',
      message: 'Your experience is now visible on the ${university.name} page.',
    );
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.university(university.id));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('New post')),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabeledField(
                    label: 'Host university',
                    child: DropdownButtonFormField<String>(
                      initialValue: _universityId,
                      isExpanded: true,
                      decoration: dropdownDecoration(
                        context,
                        'Select university',
                      ),
                      items: [
                        for (final university in kHostUniversities)
                          DropdownMenuItem(
                            value: university.id,
                            child: Text(
                              university.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) => _universityId = value,
                      validator: (value) =>
                          value == null ? 'Please select a university.' : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LabeledField(
                    label: 'Term',
                    child: DropdownButtonFormField<String>(
                      initialValue: _term,
                      isExpanded: true,
                      decoration: dropdownDecoration(context, 'e.g. Fall 2025'),
                      items: [
                        for (final term in kTerms)
                          DropdownMenuItem(value: term, child: Text(term)),
                      ],
                      onChanged: (value) => _term = value,
                      validator: (value) =>
                          value == null ? 'Please select a term.' : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Courses taken',
                    controller: _courses,
                    hintText: 'Add courses',
                    textInputAction: TextInputAction.next,
                    validator: _validateCourses,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Separate courses with commas.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LabeledField(
                    label: 'Program',
                    child: SegmentedButton<ExchangeProgram>(
                      segments: [
                        for (final program in ExchangeProgram.values)
                          ButtonSegment(
                            value: program,
                            label: Text(program.label),
                          ),
                      ],
                      selected: {_program},
                      onSelectionChanged: (selection) =>
                          setState(() => _program = selection.first),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Ratings', style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.xs),
                  for (final category in RatingCategory.values)
                    FormField<int>(
                      initialValue: _ratings[category] ?? 0,
                      validator: (value) =>
                          value == null || value < 1 || value > 5
                          ? 'Give 1 to 5 stars.'
                          : null,
                      builder: (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingRow(
                            label: category.label,
                            value: field.value ?? 0,
                            onChanged: (value) {
                              _ratings[category] = value;
                              field.didChange(value);
                            },
                          ),
                          if (field.hasError) FieldError(field.errorText!),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Tips',
                    controller: _tips,
                    hintText: 'Share advice for future students…',
                    maxLines: 4,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: _publish,
                    child: const Text('Publish'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
