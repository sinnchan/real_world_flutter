import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_world_flutter/presentation/ui/common/molecules/loading_overlay.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/sign_up_state_notifer.dart';
import 'package:real_world_flutter/presentation/ui/profile/organisms/sign_up_view_model.dart';

class SignUp extends HookConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(SignUpStateNotifier.provider);
    final notifier = ref.watch(SignUpStateNotifier.provider.notifier);

    _ifNeedShowDialog(context, vm, notifier);

    return LoadingOverlay(
      isLoading: vm.isLoading,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _title(),
              _haveAccount(notifier),
              _forms(vm, notifier),
              _signInButton(context, vm, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Container _signInButton(
    BuildContext context,
    SignUpViewModel vm,
    SignUpStateNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: vm.isEnableSignUpButton
            ? () {
                FocusScope.of(context).unfocus();
                notifier.onTapSignUp();
              }
            : null,
        child: const Text('Sign up'),
      ),
    );
  }

  void _ifNeedShowDialog(
    BuildContext context,
    SignUpViewModel vm,
    SignUpStateNotifier notifier,
  ) {
    final error = vm.errorMessage;
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
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

  Widget _haveAccount(SignUpStateNotifier notifier) {
    return TextButton(
      onPressed: notifier.onTapHaveAccount,
      child: const Text('Have an account?'),
    );
  }

  Widget _title() {
    return const Text(
      'Sign up',
      style: TextStyle(fontSize: 32),
    );
  }

  Widget _forms(SignUpViewModel vm, SignUpStateNotifier notifier) {
    return FocusTraversalGroup(
      child: Form(
        child: Column(
          children: [
            TextFormField(
              initialValue: vm.email,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Username'),
              onChanged: notifier.onUpdateUsername,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: vm.email,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email'),
              onChanged: notifier.onUpdateEmail,
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: vm.password,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
              onChanged: notifier.onUpdatePassword,
            ),
          ],
        ),
      ),
    );
  }
}
