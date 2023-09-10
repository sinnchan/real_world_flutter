import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/edit/article_edit_notifier.dart';
import 'package:real_world_flutter/presentation/ui/articles/organisms/edit/article_edit_view_model.dart';
import 'package:real_world_flutter/presentation/ui/common/molecules/loading_overlay.dart';

class ArticleEdit extends HookConsumerWidget {
  const ArticleEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(ArticleEditNotifier.provider);
    final notifier = ref.watch(ArticleEditNotifier.provider.notifier);

    _ifNeedShowDialog(context, vm, notifier);

    return LoadingOverlay(
      isLoading: vm.isLoading,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _forms(vm, notifier),
              _publishButton(context, vm, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forms(
    ArticleEditViewModel vm,
    ArticleEditNotifier notifier,
  ) {
    return FocusTraversalGroup(
      child: Form(
        child: Column(
          children: [
            TextFormField(
              initialValue: vm.title,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Article Title',
              ),
              onChanged: (v) => notifier.updateTitle(v),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: vm.description,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'What\'s this article about?',
              ),
              onChanged: (v) => notifier.updateDescription(v),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: vm.body,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Write your article',
              ),
              onChanged: (v) => notifier.updateBody(v),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: vm.tags.join(' '),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Enter tags',
              ),
              onChanged: (v) => notifier.updateTags(v),
            ),
          ],
        ),
      ),
    );
  }

  Container _publishButton(
    BuildContext context,
    ArticleEditViewModel vm,
    ArticleEditNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: vm.isEnableButton
            ? () {
                FocusScope.of(context).unfocus();
                notifier.publish();
              }
            : null,
        child: const Text('Sign in'),
      ),
    );
  }

  void _ifNeedShowDialog(
    BuildContext context,
    ArticleEditViewModel vm,
    ArticleEditNotifier notifier,
  ) {
    final error = vm.errorMessage;
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(error),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    notifier.onTapErrorDialogOk();
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }
}
